const std = @import("std");
const upaya = @import("upaya");
usingnamespace upaya.imgui;

// .
// Animation
// .
pub const frame_dt: f32 = 0.016; // roughly 16ms per frame

pub const ButtonState = enum {
    none = 0,
    hovered,
    pressed,
    released,
};

pub const ButtonAnim = struct {
    ticker_ms: u32 = 0,
    prevState: ButtonState = .none,
    currentState: ButtonState = .none,
    hover_duration: i32 = 200,
    press_duration: i32 = 100,
    release_duration: i32 = 100,
    current_color: ImVec4 = ImVec4{},
};

pub const EditAnim = struct {
    visible: bool = false,
    visible_prev: bool = false,
    current_size: ImVec2 = ImVec2{},
    ticker_ms: u32 = 0,
    fadein_duration: i32 = 200,
    fadeout_duration: i32 = 200,
};

pub fn animateVec2(from: ImVec2, to: ImVec2, duration_ms: i32, ticker_ms: u32) ImVec2 {
    if (ticker_ms >= duration_ms) {
        return to;
    }
    if (ticker_ms <= 1) {
        return from;
    }

    var ret = from;
    var fduration_ms = @intToFloat(f32, duration_ms);
    var fticker_ms = @intToFloat(f32, ticker_ms);
    ret.x += (to.x - from.x) / fduration_ms * fticker_ms;
    ret.y += (to.y - from.y) / fduration_ms * fticker_ms;
    return ret;
}

pub fn animatedEditor(anim: *EditAnim, size: ImVec2, content_window_size: ImVec2, internal_render_size: ImVec2) void {
    var fromSize = ImVec2{};
    var toSize = ImVec2{};
    var anim_duration: i32 = 0;
    var show: bool = true;

    // only animate when transitioning
    if (anim.visible != anim.visible_prev) {
        if (anim.visible) {
            // fading in
            fromSize = ImVec2{};
            toSize = size;
            anim_duration = anim.fadein_duration;
        } else {
            fromSize = size;
            toSize = ImVec2{};
            anim_duration = anim.fadeout_duration;
        }
        anim.current_size = animateVec2(fromSize, toSize, anim_duration, anim.ticker_ms);
        anim.ticker_ms += @floatToInt(u32, frame_dt * 1000);
        if (anim.ticker_ms >= anim_duration) {
            anim.visible_prev = anim.visible;
        }
    } else {
        anim.ticker_ms = 0;
        if (!anim.visible) {
            show = false;
        }
    }

    if (show) {
        _ = igButton("", trxy(anim.current_size, content_window_size, internal_render_size));
    }
}

fn trxy(pos: ImVec2, content_window_size: ImVec2, internal_render_size: ImVec2) ImVec2 {
    return ImVec2{ .x = pos.x * content_window_size.x / internal_render_size.x, .y = pos.y * content_window_size.y / internal_render_size.y };
}

pub fn animateColor(from: ImVec4, to: ImVec4, duration_ms: i32, ticker_ms: u32) ImVec4 {
    if (ticker_ms >= duration_ms) {
        return to;
    }
    if (ticker_ms <= 1) {
        return from;
    }

    var ret = from;
    var fduration_ms = @intToFloat(f32, duration_ms);
    var fticker_ms = @intToFloat(f32, ticker_ms);
    ret.x += (to.x - from.x) / fduration_ms * fticker_ms;
    ret.y += (to.y - from.y) / fduration_ms * fticker_ms;
    ret.z += (to.z - from.z) / fduration_ms * fticker_ms;
    ret.w += (to.w - from.w) / fduration_ms * fticker_ms;
    return ret;
}

pub fn doButton(label: [*c]const u8, size: ImVec2) ButtonState {
    var released = igButton(label, size);

    if (released) return .released;
    if (igIsItemActive() and igIsItemHovered(ImGuiHoveredFlags_RectOnly)) return .pressed;
    if (igIsItemHovered(ImGuiHoveredFlags_RectOnly)) return .hovered;
    return .none;
}

pub fn animatedButton(label: [*c]const u8, size: ImVec2, anim: *ButtonAnim) ButtonState {
    var fromColor = ImVec4{};
    var toColor = ImVec4{};
    switch (anim.prevState) {
        .none => fromColor = igGetStyleColorVec4(ImGuiCol_Button).*,
        .hovered => fromColor = igGetStyleColorVec4(ImGuiCol_ButtonHovered).*,
        .pressed => fromColor = igGetStyleColorVec4(ImGuiCol_ButtonActive).*,
        .released => fromColor = igGetStyleColorVec4(ImGuiCol_ButtonActive).*,
    }

    switch (anim.currentState) {
        .none => toColor = igGetStyleColorVec4(ImGuiCol_Button).*,
        .hovered => toColor = igGetStyleColorVec4(ImGuiCol_ButtonHovered).*,
        .pressed => toColor = igGetStyleColorVec4(ImGuiCol_ButtonActive).*,
        .released => toColor = igGetStyleColorVec4(ImGuiCol_ButtonActive).*,
    }

    var anim_duration: i32 = 0;
    switch (anim.currentState) {
        .hovered => anim_duration = anim.hover_duration,
        .pressed => anim_duration = anim.press_duration,
        .released => anim_duration = anim.release_duration,
        else => anim_duration = anim.hover_duration,
    }
    if (anim.prevState == .released) anim_duration = anim.release_duration;

    var currentColor = animateColor(fromColor, toColor, anim_duration, anim.ticker_ms);
    igPushStyleColorVec4(ImGuiCol_Button, currentColor);
    igPushStyleColorVec4(ImGuiCol_ButtonHovered, currentColor);
    igPushStyleColorVec4(ImGuiCol_ButtonActive, currentColor);
    var state = doButton(label, size);
    igPopStyleColor(3);

    anim.ticker_ms += @floatToInt(u32, frame_dt * 1000);
    if (state != anim.currentState) {
        anim.prevState = anim.currentState;
        anim.currentState = state;
        anim.ticker_ms = 0;
    }
    anim.current_color = currentColor;
    return state;
}
