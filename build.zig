const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_options = b.addOptions();

    const module = b.addModule("mach_extras", .{
        .root_source_file = b.path("src/mach_extras.zig"),
        .optimize = optimize,
        .target = target,
    });
    module.addImport("build-options", build_options.createModule());

    // Unit tests
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/mach_extras.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.root_module.addImport("mach_extras", module);

    const test_step = b.step("test", "Run unit tests");  
    test_step.dependOn(&b.addRunArtifact(unit_tests).step);

    // Documentation
    const docs_obj = b.addObject(.{
        .name = "mach",
        .target = target,
        .optimize = .Debug,
        .root_source_file = b.path("src/mach_extras.zig"),
    });
    //docs_obj.root_module.addOptions("build_options", build_options);
    const docs = docs_obj.getEmittedDocs();
    const install_docs = b.addInstallDirectory(.{
        .source_dir = docs,
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    const docs_step = b.step("docs", "Generate docs");
    docs_step.dependOn(&install_docs.step);    
}