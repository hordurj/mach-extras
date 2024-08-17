//! Modules and utilities for mach
//! 

pub const Physics = @import("Physics.zig");

const version_str = "0.1.0";
/// Return the version number.
pub fn version() []const u8 {
    return version_str;
}

test {
    _ = version;
}