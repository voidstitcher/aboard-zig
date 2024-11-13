const This = @This();

pub usingnamespace @cImport({
    @cInclude("SDL2/SDL.h");
});

// types
pub const window = This.SDL_Window;
pub const surface = This.SDL_Surface;
pub const event = This.SDL_Event;

// constants
pub const INIT_VIDEO = This.SDL_INIT_VIDEO;
pub const WINDOWPOS_UNDEFINED = This.SDL_WINDOWPOS_UNDEFINED;
pub const WINDOW_SHOWN = This.SDL_WINDOW_SHOWN;
pub const QUIT = This.SDL_QUIT;

// functions
pub const init = &This.SDL_Init;
pub const createWindow = &This.SDL_CreateWindow;
pub const getError = &This.SDL_GetError;
pub const getWindowSurface = &This.SDL_GetWindowSurface;
pub const fillRect = &This.SDL_FillRect;
pub const updateWindowSurface = &This.SDL_UpdateWindowSurface;
pub const mapRgb = &This.SDL_MapRGB;
pub const pollEvent = &This.SDL_PollEvent;
pub const destroyWindow = &This.SDL_DestroyWindow;
pub const quit = &This.SDL_Quit;
