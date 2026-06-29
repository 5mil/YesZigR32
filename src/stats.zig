//! Hashrate and share accounting for YesZigR32.
//! Uses std.posix.clock_gettime(.MONOTONIC) directly —
//! std.time.nanoTimestamp / std.time.Instant were removed in Zig 0.16.
const std = @import("std");

fn nanoNow() i128 {
    const ts = std.posix.clock_gettime(.MONOTONIC) catch return 0;
    return (@as(i128, ts.sec) * 1_000_000_000) + ts.nsec;
}

pub const Stats = struct {
    accepted: u64 = 0,
    rejected: u64 = 0,
    total_hashes: u64 = 0,
    start_ns: i128 = 0,

    pub fn init() Stats {
        return .{ .start_ns = nanoNow() };
    }

    pub fn hashrate(self: *const Stats) f64 {
        const elapsed_ns = nanoNow() - self.start_ns;
        if (elapsed_ns <= 0) return 0;
        const elapsed_s = @as(f64, @floatFromInt(elapsed_ns)) / 1e9;
        return @as(f64, @floatFromInt(self.total_hashes)) / elapsed_s;
    }

    pub fn print(self: *const Stats) void {
        std.debug.print("[stats] accepted={d} rejected={d} hashrate={d:.2} H/s\n", .{
            self.accepted, self.rejected, self.hashrate(),
        });
    }
};

test "stats hashrate non-negative" {
    const s = Stats.init();
    try std.testing.expect(s.hashrate() >= 0);
}
