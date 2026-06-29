//! Hashrate and share accounting for YesZigR32.
const std = @import("std");

pub const Stats = struct {
    accepted: u64 = 0,
    rejected: u64 = 0,
    total_hashes: u64 = 0,
    start_ns: i128 = 0,

    pub fn init() Stats {
        return .{ .start_ns = std.time.nanoTimestamp() };
    }

    pub fn hashrate(self: *const Stats) f64 {
        const now = std.time.nanoTimestamp();
        const elapsed_s = @as(f64, @floatFromInt(now - self.start_ns)) / 1e9;
        if (elapsed_s <= 0) return 0;
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
