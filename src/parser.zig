const std = @import("std");
const mem = std.mem;

// TODO: @push and @pop:
//       @bg "background.png"
//       @fontSize 16
//       @push "default slide"
//       ...
//       @pop "default slide"
//       @text .....

const slides = @import("slides.zig");
usingnamespace slides;

//pub fn constructSlidesFromFile(input: []const u8, slides: *SlideList, allocator: *mem.Allocator) !void {
pub fn constructSlidesFromFile(input: []const u8, allocator: *mem.Allocator) !void {
    var start: usize = if (mem.startsWith(u8, input, "\xEF\xBB\xBF")) 3 else 0;
    var it = mem.tokenize(input[start..], "\n\r");
    var i: usize = 0;
    while (it.next()) |line| {
        i += 1;
        //        std.log.info("{d}: {s}", .{ i + 1, line });
        if (mem.startsWith(u8, line, "#")) {
            std.log.debug("{d}: ignored comment {s}", .{ i, line });
            continue;
        }
    }
    return;
}

pub fn main() !void {
    try constructSlidesFromFile(@embedFile("test.sld"), std.heap.page_allocator);
}
