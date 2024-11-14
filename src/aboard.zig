const std = @import("std");
const sdl = @import("sdl.zig");
const sleep = std.time.sleep;

pub const screen_width = 512;
pub const screen_height = 512;

const stderr = std.io.getStdErr().writer();

const Game = struct {
    const This = @This();
    window_name: [*:0]const u8,
    window: ?*sdl.window,
    window_surface: *sdl.surface,
    bullshit_pointer: *const fn (*Game) void,
    components: *Components,

    fn init(comptime window_name: [*:0]const u8) This {
        const window = sdl.createWindow(
            window_name,
            sdl.WINDOWPOS_UNDEFINED,
            sdl.WINDOWPOS_UNDEFINED,
            screen_width,
            screen_height,
            sdl.WINDOW_SHOWN,
        );
        return This{
            .window_name = window_name,
            .window = window,
            .window_surface = sdl.getWindowSurface(window),
            .bullshit_pointer = &bullshit,
        };
    }
};

const Components = struct {
    position_component: []PositionComponent,
};

const PositionComponent = struct {
    x: u32,
    y: u32,
};

fn err(comptime fmt: []const u8) void {
    stderr.print(fmt ++ "\n", .{}) catch {};
}

fn sdlRun(game: *Game) void {
    if (sdl.init(sdl.INIT_VIDEO) < 0) {
        err("sdl didnt init :(");
    } else {
        if (game.window == null) {
            err("window could not be created!");
        } else {
            _ = sdl.fillRect(game.window_surface, null, sdl.mapRgb(game.window_surface.format, 0xff, 0xff, 0xff));
            _ = sdl.updateWindowSurface(game.window);

            var e: sdl.event = undefined;
            mainloop: while (true) {
                while (sdl.pollEvent(&e) != 0) {
                    switch (e.type) {
                        sdl.QUIT => break :mainloop,
                        else => {},
                    }
                }
                game.bullshit_pointer(game);
                // limits framerate to ~60 per second
                sleep(std.math.floor((1.0 / 60.0) * 1_000_000_000));
            }
            sdl.destroyWindow(game.window);
            sdl.quit();
        }
    }
}

fn bullshit(game: *Game) void {
    game.bullshit_pointer = &bullshit2;
    err("FUCK");
}
fn bullshit2(game: *Game) void {
    game.bullshit_pointer = &bullshit;
    err("SHIT");
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const ally = gpa.allocator();

    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) {
            err("deinit leaked D:");
        }
    }

    var args = try std.process.argsWithAllocator(ally);
    defer args.deinit();

    var game: Game = Game.init("Aboard");
    sdlRun(&game);
}
