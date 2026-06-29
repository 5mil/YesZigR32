//! Stratum V1 TCP client for YesZigR32.
//! Handles: mining.subscribe, mining.authorize, mining.notify, mining.submit
const std = @import("std");

pub const Job = struct {
    job_id: [64]u8 = [_]u8{0} ** 64,
    prevhash: [64]u8 = [_]u8{0} ** 64,
    coinb1: []const u8 = "",
    coinb2: []const u8 = "",
    nbits: u32 = 0,
    ntime: u32 = 0,
    clean: bool = false,
};

pub const Client = struct {
    host: []const u8,
    port: u16,
    user: []const u8,
    pass: []const u8,
    stream: ?std.net.Stream = null,

    pub fn connect(self: *Client) !void {
        const addr = try std.net.Address.resolveIp(self.host, self.port);
        self.stream = try std.net.tcpConnectToAddress(addr);
    }

    pub fn subscribe(self: *Client, allocator: std.mem.Allocator) !void {
        _ = allocator;
        const msg =
            \{"id":1,"method":"mining.subscribe","params":["YesZigR32/0.1.0"]}
            ++ "\n";
        try self.stream.?.writer().writeAll(msg);
    }

    pub fn authorize(self: *Client) !void {
        var buf: [256]u8 = undefined;
        const msg = try std.fmt.bufPrint(&buf,
            \{{"id":2,"method":"mining.authorize","params":["{s}","{s}"]}}
            ++ "\n",
            .{ self.user, self.pass },
        );
        try self.stream.?.writer().writeAll(msg);
    }

    pub fn submit(self: *Client, job_id: []const u8, nonce: u32, ntime: u32) !void {
        var buf: [256]u8 = undefined;
        const msg = try std.fmt.bufPrint(&buf,
            \{{"id":4,"method":"mining.submit","params":["{s}","{s}","{x:0>8}","{x:0>8}"]}}
            ++ "\n",
            .{ self.user, job_id, ntime, nonce },
        );
        try self.stream.?.writer().writeAll(msg);
    }

    pub fn close(self: *Client) void {
        if (self.stream) |s| s.close();
        self.stream = null;
    }
};

test "job defaults" {
    const j = Job{};
    try std.testing.expectEqual(false, j.clean);
    try std.testing.expectEqual(@as(u32, 0), j.nbits);
}
