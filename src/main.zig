const std = @import("std");
const worker = @import("worker.zig");
const stratum = @import("stratum.zig");
const stats = @import("stats.zig");

pub const Config = struct {
    host: []const u8 = "localhost",
    port: u16 = 3032,
    user: []const u8 = "wallet.worker",
    pass: []const u8 = "x",
    threads: u32 = 1,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    _ = allocator;

    const cfg = Config{};
    std.debug.print("YesZigR32 starting — {s}:{d} user={s}\n", .{
        cfg.host, cfg.port, cfg.user,
    });

    // TODO: spawn stratum client thread
    // TODO: spawn worker threads (cfg.threads)
    // TODO: stats display loop
}

test "config defaults" {
    const cfg = Config{};
    try std.testing.expectEqual(@as(u16, 3032), cfg.port);
    try std.testing.expectEqualStrings("wallet.worker", cfg.user);
}
