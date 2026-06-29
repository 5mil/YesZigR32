const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Redirect cache to a WSL-safe path when building from /mnt/c/
    // Override with: zig build --cache-dir /tmp/yeszigr32-cache
    const cflags = &.{ "-O2", "-std=c99", "-Wall", "-Wno-unused-function" };
    const csources = &.{
        "ccore/yescrypt.c",
        "ccore/sha256.c",
    };

    // --- shared module factory ---
    const mk = struct {
        fn mod(bb: *std.Build, t: std.Build.ResolvedTarget, o: std.builtin.OptimizeMode,
               cf: []const []const u8, cs: []const []const u8) *std.Build.Module {
            const m = bb.createModule(.{
                .root_source_file = bb.path("src/main.zig"),
                .target = t,
                .optimize = o,
            });
            m.addCSourceFiles(.{ .files = cs, .flags = cf });
            m.addIncludePath(bb.path("ccore"));
            m.link_libc = true;
            return m;
        }
    };

    // --- tests ---
    const unit_tests = b.addTest(.{
        .name = "yeszigr32-tests",
        .root_module = mk.mod(b, target, optimize, cflags, csources),
    });
    const run_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    // --- exe ---
    const exe = b.addExecutable(.{
        .name = "yeszigr32",
        .root_module = mk.mod(b, target, optimize, cflags, csources),
    });
    exe.step.dependOn(&run_tests.step);
    b.installArtifact(exe);

    // --- run ---
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run YesZigR32");
    run_step.dependOn(&run_cmd.step);
}
