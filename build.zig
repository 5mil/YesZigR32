const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "yeszigr32",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Compile yescrypt C core and link it in
    exe.addCSourceFile(.{
        .file = b.path("ccore/yescrypt.c"),
        .flags = &.{ "-O2", "-std=c99", "-Wall" },
    });
    exe.addIncludePath(b.path("ccore"));
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("run", "Run YesZigR32");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.addCSourceFile(.{
        .file = b.path("ccore/yescrypt.c"),
        .flags = &.{ "-O2", "-std=c99", "-Wall" },
    });
    unit_tests.addIncludePath(b.path("ccore"));
    unit_tests.linkLibC();
    test_step.dependOn(&b.addRunArtifact(unit_tests).step);
}
