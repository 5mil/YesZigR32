//! Per-thread mining worker. Iterates nonces and calls job.hashHeader.
const std = @import("std");
const job = @import("job.zig");
const stats = @import("stats.zig");

pub const WorkerCtx = struct {
    thread_id: u32,
    header: [80]u8,
    start_nonce: u32,
    end_nonce: u32,
    diff_zeros: u8,
    found: ?job.Share = null,
    hashes: u64 = 0,
};

pub fn run(ctx: *WorkerCtx) void {
    var nonce = ctx.start_nonce;
    while (nonce <= ctx.end_nonce) : (nonce +%= 1) {
        var h = ctx.header;
        // Write nonce into header bytes 76..80 (little-endian)
        std.mem.writeInt(u32, h[76..80], nonce, .little);
        var hash: [32]u8 = undefined;
        job.hashHeader(&h, &hash);
        ctx.hashes += 1;
        if (job.meetsDifficulty(&hash, ctx.diff_zeros)) {
            ctx.found = job.Share{
                .job_id = "unknown",
                .nonce = nonce,
                .ntime = 0,
                .hash = hash,
            };
            return;
        }
    }
}

test "worker nonce range" {
    var ctx = WorkerCtx{
        .thread_id = 0,
        .header = [_]u8{0} ** 80,
        .start_nonce = 0,
        .end_nonce = 0,
        .diff_zeros = 32, // impossible to find
    };
    run(&ctx);
    try std.testing.expectEqual(@as(u64, 1), ctx.hashes);
    try std.testing.expect(ctx.found == null);
}
