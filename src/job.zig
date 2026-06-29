//! Job engine: nonce iteration and share target check.
const std = @import("std");
const c = @cImport(@cInclude("yescrypt.h"));

pub const Share = struct {
    job_id: []const u8,
    nonce: u32,
    ntime: u32,
    hash: [32]u8,
};

/// Hash a block header with YescryptR32 via C core.
/// `header` must be exactly 80 bytes.
pub fn hashHeader(header: *const [80]u8, out: *[32]u8) void {
    c.yescrypt_hash(header.ptr, 80, out.ptr);
}

/// Check if hash meets target (simple leading-zero check for now).
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
