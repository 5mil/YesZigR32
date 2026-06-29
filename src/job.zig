//! Job engine: nonce iteration and share target check.
//! Calls yescrypt_hash from ccore/yescrypt.c (LuckyPepeChain vendored core).
//! Signature: yescrypt_hash(passwd, passwdlen, salt, saltlen, buf, buflen) -> c_int
const std = @import("std");

const c = @cImport(@cInclude("yescrypt.h"));

pub const Share = struct {
    job_id: []const u8,
    nonce: u32,
    ntime: u32,
    hash: [32]u8,
};

/// Hash an 80-byte block header with YescryptR32.
/// header is used as both passwd and salt (PoW convention).
/// Returns false if allocation failed inside the C core.
pub fn hashHeader(header: *const [80]u8, out: *[32]u8) bool {
    const ret = c.yescrypt_hash(
        header.ptr, 80,
        header.ptr, 80,
        out.ptr, 32,
    );
    return ret == 0;
}

/// Check if hash meets target (leading-zero byte check).
pub fn meetsDifficulty(hash: *const [32]u8, diff_leading_zeros: u8) bool {
    var i: u8 = 0;
    while (i < diff_leading_zeros and i < 32) : (i += 1) {
        if (hash[i] != 0) return false;
    }
    return true;
}

test "meetsDifficulty zero hash always passes" {
    const hash = [_]u8{0} ** 32;
    try std.testing.expect(meetsDifficulty(&hash, 4));
}

test "meetsDifficulty non-zero fails" {
    var hash = [_]u8{0} ** 32;
    hash[0] = 1;
    try std.testing.expect(!meetsDifficulty(&hash, 1));
}

test "hashHeader returns true and non-zero output on zero header" {
    const header = [_]u8{0} ** 80;
    var out: [32]u8 = undefined;
    const ok = hashHeader(&header, &out);
    try std.testing.expect(ok);
    var all_zero = true;
    for (out) |byte| { if (byte != 0) { all_zero = false; break; } }
    try std.testing.expect(!all_zero);
}
