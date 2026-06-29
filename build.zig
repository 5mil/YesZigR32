const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Shared C compilation step reused by both exe and tests
    const cflags = &.{ "-O2", "-std=c99", "-Wall", "-Wno-unused-function" };
    const csources = &.{
        "ccore/yescrypt.c",
        "ccore/sha256.c",
    };

    // --- tests ---
    const unit_tests = b.addTest(.{
        .name = "yeszigr32-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    unit_tests.addCSourceFiles(.{ .files = csources, .flags = cflags });
    unit_tests.addIncludePath(b.path("ccore"));
    unit_tests.linkLibC();

    const run_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    // --- exe ---
    const exe = b.addExecutable(.{
        .name = "yeszigr32",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.addCSourceFiles(.{ .files = csources, .flags = cflags });
    exe.addIncludePath(b.path("ccore"));
    exe.linkLibC();

    // Tests must pass before the binary is installed
    exe.step.dependOn(&run_tests.step);
    b.installArtifact(exe);

    // --- run ---
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run YesZigR32");
    run_step.dependOn(&run_cmd.step);
}
