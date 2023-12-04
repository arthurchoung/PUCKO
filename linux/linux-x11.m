/*

 HOT DOG Linux

 Copyright (c) 2020 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of HOT DOG Linux.

 HOT DOG Linux is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */

#import "HOTDOG.h"

// linker flags -lX11 -lXext

#include <fcntl.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <signal.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/keysym.h>
#include <X11/cursorfont.h>
#include <X11/extensions/shape.h>

static XImage *CreateTrueColorImage(Display *display, Visual *visual, unsigned char *image, int width, int height, int depth)
{
    unsigned char *image32=(unsigned char *)malloc(width*height*4);
    memcpy(image32, image, width*height*4);
    return XCreateImage(display, visual, depth, ZPixmap, 0, image32, width, height, 32, 0);
}

@implementation Definitions(fjdklsjfkldsjklfjs)

+ (id)currentWindow
{
    id windowManager = [@"windowManager" valueForKey];
    id focusDict = [windowManager valueForKey:@"focusDict"];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (focusDict == menuBar) {
        return nil;
    }
    return focusDict;
}
+ (void)x11FixupEvent:(id)eventDict forBitmapObject:(id)object
{
    if ([object respondsToSelector:@selector(bitmapWidth)]) {
        if ([object respondsToSelector:@selector(bitmapHeight)]) {
            int bitmapWidth = [object bitmapWidth]; 
            int bitmapHeight = [object bitmapHeight];
            if (bitmapWidth && bitmapHeight) {
                int viewWidth = [eventDict intValueForKey:@"viewWidth"];
                int viewHeight = [eventDict intValueForKey:@"viewHeight"];
                int mouseX = [eventDict intValueForKey:@"mouseX"];
                int mouseY = [eventDict intValueForKey:@"mouseY"];
                int adjustedX = (double)mouseX / ((double)viewWidth/(double)bitmapWidth);
                int adjustedY = (double)mouseY / ((double)viewHeight/(double)bitmapHeight);
                [eventDict setValue:nsfmt(@"%d", adjustedX) forKey:@"mouseX"];
                [eventDict setValue:nsfmt(@"%d", adjustedY) forKey:@"mouseY"];
                [eventDict setValue:nsfmt(@"%d", bitmapWidth) forKey:@"viewWidth"];
                [eventDict setValue:nsfmt(@"%d", bitmapHeight) forKey:@"viewHeight"];
            }
        }
    }
}
+ (void)x11FixupEventForPixelScaling:(id)eventDict x11dict:(id)x11dict
{
    int scaling = [x11dict intValueForKey:@"pixelScaling"];
    if (scaling < 2) {
        return;
    }
    id object = [x11dict valueForKey:@"object"];
    if ([object respondsToSelector:@selector(bitmapWidth)]) {
        return;
    }

    int viewWidth = [eventDict intValueForKey:@"viewWidth"];
    int viewHeight = [eventDict intValueForKey:@"viewHeight"];
    int mouseX = [eventDict intValueForKey:@"mouseX"];
    int mouseY = [eventDict intValueForKey:@"mouseY"];
    [eventDict setValue:nsfmt(@"%d", mouseX / scaling) forKey:@"mouseX"];
    [eventDict setValue:nsfmt(@"%d", mouseY / scaling) forKey:@"mouseY"];
    [eventDict setValue:nsfmt(@"%d", viewWidth / scaling) forKey:@"viewWidth"];
    [eventDict setValue:nsfmt(@"%d", viewHeight / scaling) forKey:@"viewHeight"];
}
@end

static void setupKeyEvent(XKeyEvent *event, Display *display, Window win,
                           Window winRoot, int press,
                           int keycode, int modifiers)
{
    memset(event, 0, sizeof(XKeyEvent));
   event->display     = display;
   event->window      = win;
   event->root        = winRoot;
   event->subwindow   = None;
   event->time        = CurrentTime;
   event->x           = 1;
   event->y           = 1;
   event->x_root      = 1;
   event->y_root      = 1;
   event->same_screen = True;
   event->keycode     = XKeysymToKeycode(display, keycode);
   event->state       = modifiers;

   if(press)
      event->type = KeyPress;
   else
      event->type = KeyRelease;
}

@implementation Definitions(fjklsdjfksdlkjfjskdlfjksdf)

+ (void)generateLeftKeyEvent
{
    int keycode = XK_Left;

   Display *display = XOpenDisplay(0);
   if(display == NULL)
      return;

   Window winRoot = XDefaultRootWindow(display);

   Window winFocus;
   int    revert;
   XGetInputFocus(display, &winFocus, &revert);

   XKeyEvent event;
    setupKeyEvent(&event, display, winFocus, winRoot, 1, keycode, 0);
   XSendEvent(event.display, event.window, True, KeyPressMask, (XEvent *)&event);

   setupKeyEvent(&event, display, winFocus, winRoot, 0, keycode, 0);
   XSendEvent(event.display, event.window, True, KeyPressMask, (XEvent *)&event);

   XCloseDisplay(display);
}

+ (id)keyForXKeyCode:(unsigned int)keyCode modifiers:(unsigned int)modifiers
{
    id str = [Definitions simpleKeyForXKeyCode:keyCode modifiers:modifiers];
    
    if (modifiers & ShiftMask) {
        if ([str length] > 1) {
            if ([str isEqual:@"leftshift"]) {
            } else if ([str isEqual:@"rightshift"]) {
            } else {
                str = nsfmt(@"shift-%@", str);
            }
        }
    }

    if (modifiers & Mod1Mask) {
        str = nsfmt(@"alt-%@", str);
    }

    if (modifiers & ControlMask) {
        str = nsfmt(@"control-%@", str);
    }

    if (modifiers & Mod4Mask) {
        str = nsfmt(@"meta-%@", str);
    }

    return str;
}

+ (id)simpleKeyForXKeyCode:(unsigned int)keyCode modifiers:(unsigned int)modifiers
{
    if (modifiers & ShiftMask) {
        switch(keyCode) {
            case XK_period: return @">";
            case XK_comma: return @"<";
            case XK_equal: return @"+";
            case XK_semicolon: return @":";
            case XK_backslash: return @"|";
            case XK_grave: return @"~";
            case XK_0: return @")";
            case XK_1: return @"!";
            case XK_2: return @"@";
            case XK_3: return @"#";
            case XK_4: return @"$";
            case XK_5: return @"%";
            case XK_6: return @"^";
            case XK_7: return @"&";
            case XK_8: return @"*";
            case XK_9: return @"(";
            case XK_bracketleft: return @"{";
            case XK_bracketright: return @"}";
            case XK_minus: return @"_";
            case XK_a: return @"A";
            case XK_b: return @"B";
            case XK_c: return @"C";
            case XK_d: return @"D";
            case XK_e: return @"E";
            case XK_f: return @"F";
            case XK_g: return @"G";
            case XK_h: return @"H";
            case XK_i: return @"I";
            case XK_j: return @"J";
            case XK_k: return @"K";
            case XK_l: return @"L";
            case XK_m: return @"M";
            case XK_n: return @"N";
            case XK_o: return @"O";
            case XK_p: return @"P";
            case XK_q: return @"Q";
            case XK_r: return @"R";
            case XK_s: return @"S";
            case XK_t: return @"T";
            case XK_u: return @"U";
            case XK_v: return @"V";
            case XK_w: return @"W";
            case XK_x: return @"X";
            case XK_y: return @"Y";
            case XK_z: return @"Z";
        }
    }

    switch(keyCode) {
        case XK_BackSpace: return @"backspace";
        case XK_Tab: return @"tab";
        case XK_Linefeed: return @"linefeed";
        case XK_Clear: return @"clear";
        case XK_Return: return @"return";
        case XK_Pause: return @"pause";
        case XK_Scroll_Lock: return @"scrolllock";
        case XK_Sys_Req: return @"sysreq";
        case XK_Escape: return @"escape";
        case XK_Delete: return @"delete";
        case XK_Home: return @"home";
        case XK_Left: return @"left";
        case XK_Up: return @"up";
        case XK_Right: return @"right";
        case XK_Down: return @"down";
        case XK_Page_Up: return @"pageup";
        case XK_Page_Down: return @"pagedown";
        case XK_End: return @"end";
        case XK_Begin: return @"begin";
        case XK_Select: return @"select";
        case XK_Print: return @"print";
        case XK_Execute: return @"execute";
        case XK_Insert: return @"insert";
        case XK_Undo: return @"undo";
        case XK_Redo: return @"redo";
        case XK_Menu: return @"menu";
        case XK_Find: return @"find";
        case XK_Cancel: return @"cancel";
        case XK_Help: return @"help";
        case XK_Break: return @"break";
        case XK_Num_Lock: return @"numlock";
        case XK_KP_Space: return @"keypadspace";
        case XK_KP_Tab: return @"keypadtab";
        case XK_KP_Enter: return @"keypadenter";
        case XK_KP_F1: return @"keypadf1";
        case XK_KP_F2: return @"keypadf2";
        case XK_KP_F3: return @"keypadf3";
        case XK_KP_F4: return @"keypadf4";
        case XK_KP_Home: return @"keypadhome";
        case XK_KP_Left: return @"keypadleft";
        case XK_KP_Up: return @"keypadup";
        case XK_KP_Right: return @"keypadright";
        case XK_KP_Down: return @"keypaddown";
        case XK_KP_Page_Up: return @"keypadpageup";
        case XK_KP_Page_Down: return @"keypadpagedown";
        case XK_KP_End: return @"keypadend";
        case XK_KP_Begin: return @"keypadbegin";
        case XK_KP_Insert: return @"keypadinsert";
        case XK_KP_Delete: return @"keypaddelete";
        case XK_KP_Equal: return @"keypadequal";
        case XK_KP_Multiply: return @"keypadmultiply";
        case XK_KP_Add: return @"keypadadd";
        case XK_KP_Separator: return @"keypadseparator";
        case XK_KP_Subtract: return @"keypadsubtract";
        case XK_KP_Decimal: return @"keypaddecimal";
        case XK_KP_Divide: return @"keypaddivide";
        case XK_KP_0: return @"keypad0";
        case XK_KP_1: return @"keypad1";
        case XK_KP_2: return @"keypad2";
        case XK_KP_3: return @"keypad3";
        case XK_KP_4: return @"keypad4";
        case XK_KP_5: return @"keypad5";
        case XK_KP_6: return @"keypad6";
        case XK_KP_7: return @"keypad7";
        case XK_KP_8: return @"keypad8";
        case XK_KP_9: return @"keypad9";
        case XK_F1: return @"f1";
        case XK_F2: return @"f2";
        case XK_F3: return @"f3";
        case XK_F4: return @"f4";
        case XK_F5: return @"f5";
        case XK_F6: return @"f6";
        case XK_F7: return @"f7";
        case XK_F8: return @"f8";
        case XK_F9: return @"f9";
        case XK_F10: return @"f10";
        case XK_F11: return @"f11";
        case XK_F12: return @"f12";
        case XK_Shift_L: return @"leftshift";
        case XK_Shift_R: return @"rightshift";
        case XK_Control_L: return @"leftcontrol";
        case XK_Control_R: return @"rightcontrol";
        case XK_Caps_Lock: return @"capslock";
        case XK_Shift_Lock: return @"shiftlock";
        case XK_Meta_L: return @"leftmeta";
        case XK_Meta_R: return @"rightmeta";
        case XK_Alt_L: return @"leftalt";
        case XK_Alt_R: return @"rightalt";
        case XK_Super_L: return @"leftsuper";
        case XK_Super_R: return @"rightsuper";
        case XK_Hyper_L: return @"lefthyper";
        case XK_Hyper_R: return @"righthyper";
        case XK_space: return @"space";
        case XK_exclam: return @"!";
        case XK_quotedbl: return @"\"";
        case XK_numbersign: return @"#";
        case XK_dollar: return @"$";
        case XK_percent: return @"%";
        case XK_ampersand: return @"&";
        case XK_apostrophe: return @"'";
        case XK_parenleft: return @"(";
        case XK_parenright: return @")";
        case XK_asterisk: return @"*";
        case XK_plus: return @"+";
        case XK_comma: return @",";
        case XK_minus: return @"-";
        case XK_period: return @".";
        case XK_slash: return @"/";
        case XK_0: return @"0";
        case XK_1: return @"1";
        case XK_2: return @"2";
        case XK_3: return @"3";
        case XK_4: return @"4";
        case XK_5: return @"5";
        case XK_6: return @"6";
        case XK_7: return @"7";
        case XK_8: return @"8";
        case XK_9: return @"9";
        case XK_semicolon: return @";";
        case XK_less: return @"<";
        case XK_equal: return @"=";
        case XK_greater: return @">";
        case XK_question: return @"?";
        case XK_at: return @"@";
        case XK_bracketleft: return @"[";
        case XK_backslash: return @"\\";
        case XK_bracketright: return @"]";
        case XK_asciicircum: return @"asciicircum";
        case XK_underscore: return @"_";
        case XK_grave: return @"`";
        case XK_a: return @"a";
        case XK_b: return @"b";
        case XK_c: return @"c";
        case XK_d: return @"d";
        case XK_e: return @"e";
        case XK_f: return @"f";
        case XK_g: return @"g";
        case XK_h: return @"h";
        case XK_i: return @"i";
        case XK_j: return @"j";
        case XK_k: return @"k";
        case XK_l: return @"l";
        case XK_m: return @"m";
        case XK_n: return @"n";
        case XK_o: return @"o";
        case XK_p: return @"p";
        case XK_q: return @"q";
        case XK_r: return @"r";
        case XK_s: return @"s";
        case XK_t: return @"t";
        case XK_u: return @"u";
        case XK_v: return @"v";
        case XK_w: return @"w";
        case XK_x: return @"x";
        case XK_y: return @"y";
        case XK_z: return @"z";
        case XK_braceleft: return @"{";
        case XK_bar: return @"|";
        case XK_braceright: return @"}";
        case XK_asciitilde: return @"~";
        case XK_nobreakspace: return @"nobreakspace";
    }
    return nsfmt(@"%u", keyCode);  
}

@end

@implementation NSDictionary(jfkdsjlkfdsjlkfjklsdf)
- (void)showInXWindow
{
    [self showInXWindowWithWidth:600 height:0];
}
- (void)showInXWindowWithWidth:(int)width height:(int)height
{
    id obj = nsfmt(@"%@", self);
    [obj showInXWindowWithWidth:width height:height];
}
@end
@implementation NSArray(fjdlksjfldskjfldsjf)
- (void)showInXWindow
{
    [self showInXWindowWithWidth:600 height:0];
}
- (void)showInXWindowWithWidth:(int)width height:(int)height
{
    id obj = nsfmt(@"%@", self);
    [obj showInXWindowWithWidth:width height:height];
}
@end


@implementation NSObject(fjkdlsjfklsdjlkf)
- (void)showInXWindow
{
    [self showInXWindowWithWidth:600 height:0];
}

- (void)showInXWindowWithX:(int)x y:(int)y width:(int)width height:(int)height
{
    [Definitions runWindowManagerForObject:self x:x y:y w:width h:height];
}
- (void)showInXWindowWithWidth:(int)width height:(int)height
{
    [Definitions runWindowManagerForObject:self x:0 y:0 w:width h:height];
}

@end

static BOOL __didDetectWindowManagerFlag = NO;

static int handleDidDetectWindowManager(Display *display, XErrorEvent *err)
{
    if (err->error_code == BadAccess) {
        __didDetectWindowManagerFlag = YES;
    }
    return 0;
}
static int handleXError(Display *display, XErrorEvent *err)
{
    char buf[1024];
    buf[0] = 0;
    XGetErrorText(display, err->error_code, buf, 1024);
NSLog(@"handleXError: '%s' resourceid %lu", buf, err->resourceid);
    return 0;
}

static BOOL __receivedExitSignal = NO;

static void signal_handler(int num)
{
NSLog(@"signal_handler %d", num);
    __receivedExitSignal = YES;
}

@implementation Definitions(fjkldsjlkfjdsf)
+ (void)runWindowManager
{
//    [Definitions runWindowManager:@"enterAquaMode"];
    [Definitions runWindowManager:@"enterHotDogStandMode"];
}
+ (void)runWindowManager:(id)message
{
    if (signal(SIGINT, signal_handler) == SIG_ERR) {
NSLog(@"unable to set signal handler for SIGINT");
    }
    if (signal(SIGTERM, signal_handler) == SIG_ERR) {
NSLog(@"unable to set signal handler for SIGTERM");
    }
    [Definitions setupMonitors];
    id windowManager = [@"WindowManager" asInstance];
    [windowManager setAsValueForKey:@"windowManager"];
    if (![windowManager setupX11]) {
NSLog(@"unable to setup window manager");
exit(0);
    }
    if (![windowManager setupWindowManager]) {
        [windowManager cleanup];
        return;
    }
[windowManager grabHotKeys];
    [windowManager setValue:message forKey:@"pendingMessage"];
    [windowManager runLoop];
NSLog(@"exited windowManager runLoop");
    [@"windowManager" setNilValueForKey];
NSLog(@"windowManager setNilValueForKey");
}
+ (void)runWindowManagerForObject:(id)object
{
    int w = 640-3;
    int h = 0;
    if ([object respondsToSelector:@selector(preferredWidth)]) {
        int preferredWidth = [object preferredWidth];
        if (preferredWidth) {
            w = preferredWidth;
        }
    }
    if ([object respondsToSelector:@selector(preferredHeight)]) {
        int preferredHeight = [object preferredHeight];
        if (preferredHeight) {
            h = preferredHeight;
        }
    }
    [Definitions runWindowManagerForObject:object x:0 y:0 w:w h:h];
}
+ (void)runWindowManagerForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h
{
    id windowManager = [@"WindowManager" asInstance];
    [windowManager setAsValueForKey:@"windowManager"];
    if (![windowManager setupX11]) {
NSLog(@"unable to setup window manager");
exit(0);
    }

    unsigned long appMenuWindow = 0;
    if ([object respondsToSelector:@selector(generateAppMenuArray)]) {
        id appMenuArray = [object generateAppMenuArray];
        if (appMenuArray) {
            appMenuWindow = [windowManager openAppMenuWindowsForArray:appMenuArray];
        }
    }


    id dict = nil;
    int HOTDOGNOFRAME = [object intValueForKey:@"HOTDOGNOFRAME"];
    if (HOTDOGNOFRAME) {
        dict = [windowManager openWindowForObject:object x:x y:y w:w h:h overrideRedirect:NO propertyName:"HOTDOGNOFRAME"];
        if (dict) {
            if ([object respondsToSelector:@selector(x11WindowMaskCString)]) {
                if ([object respondsToSelector:@selector(x11WindowMaskChar)]) {
                    char *cstr = [object x11WindowMaskCString];
                    char c = [object x11WindowMaskChar];
                    Window win = [[dict valueForKey:@"window"] unsignedLongValue];
                    [windowManager addMaskToWindow:win cString:cstr c:c];
                }
            }
        }
    } else {
        dict = [windowManager openWindowForObject:object x:x y:y w:w h:h];
        int scaling = [[Definitions valueForEnvironmentVariable:@"HOTDOG_SCALING"] intValue];
        if (scaling >= 2) {
            [dict setValue:nsfmt(@"%d", scaling) forKey:@"pixelScaling"];
        }
    }
    if (dict && appMenuWindow) {
        unsigned long win = [dict unsignedLongValueForKey:@"window"];
        [windowManager XChangeProperty:win name:"HOTDOGAPPMENUHEAD" str:nsfmt(@"%lu", appMenuWindow)];
    }
    [windowManager runLoop];
}
+ (void)runWindowManagerForObject:(id)object propertyName:(char *)propertyName
{
    int w = 640-3;
    int h = 0;
    if ([object respondsToSelector:@selector(preferredWidth)]) {
        int preferredWidth = [object preferredWidth];
        if (preferredWidth) {
            w = preferredWidth;
        }
    }
    if ([object respondsToSelector:@selector(preferredHeight)]) {
        int preferredHeight = [object preferredHeight];
        if (preferredHeight) {
            h = preferredHeight;
        }
    }

    [Definitions runWindowManagerForObject:object x:0 y:0 w:w h:h propertyName:propertyName];
}
+ (void)runWindowManagerForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h propertyName:(char *)propertyName
{
    id windowManager = [@"WindowManager" asInstance];
    [windowManager setAsValueForKey:@"windowManager"];
    if (![windowManager setupX11]) {
NSLog(@"unable to setup window manager");
exit(0);
    }

    unsigned long appMenuWindow = 0;
    if ([object respondsToSelector:@selector(generateAppMenuArray)]) {
        id appMenuArray = [object generateAppMenuArray];
        if (appMenuArray) {
            appMenuWindow = [windowManager openAppMenuWindowsForArray:appMenuArray];
        }
    }

    id dict = [windowManager openWindowForObject:object x:x y:y w:w h:h overrideRedirect:NO propertyName:propertyName];

    if (dict && appMenuWindow) {
        unsigned long win = [dict unsignedLongValueForKey:@"window"];
        [windowManager XChangeProperty:win name:"HOTDOGAPPMENUHEAD" str:nsfmt(@"%lu", appMenuWindow)];
    }
        
    [windowManager runLoop];
}
@end
@implementation NSObject(fjdklsfjkldsjfklsdjkljf)
- (void)runWindowManagerForObject
{
    [Definitions runWindowManagerForObject:self];
}
@end


@interface WindowManager : IvarObject
{
    Display *_display;
    int _displayFD;
    Window _rootWindow;
    int _rootWindowX;
    int _rootWindowY;
    int _rootWindowWidth;
    int _rootWindowHeight;
    XVisualInfo _visualInfo;
    BOOL _isWindowManager;
    Cursor _leftPointerCursor;
    Cursor _leftSideCursor;
    Cursor _rightSideCursor;
    Cursor _topSideCursor;
    Cursor _bottomSideCursor;
    Cursor _topLeftCornerCursor;
    Cursor _topRightCornerCursor;
    Cursor _bottomLeftCornerCursor;
    Cursor _bottomRightCornerCursor;
    char _currentCursor;
    
    Colormap _colormap;
    id _objectWindows;

    id _reparentClassName;
    id _rootWindowObject;

    id _menuBar;
    int _menuBarHeight;
    time_t _backgroundUpdateTimestamp;
    id _focusDict;
    id _buttonDownDict;
    int _buttonDownWhich;
    int _mouseX;
    int _mouseY;
    id _openGLTexture;
    id _openGLObjectTexture;
    Window _openGLWindow;

    id _pendingMessage;

    id _menuDict;

    Window _focusInEventWindow;

    Window _desktopWindow;

    id _focusAppMenu;
}
@end
@implementation WindowManager
- (void)grabHotKeys
{
    XGrabKey(_display, AnyKey, Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);

    XGrabKey(_display, AnyKey, ShiftMask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, AnyKey, ControlMask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, AnyKey, Mod1Mask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);

    XGrabKey(_display, AnyKey, ShiftMask|ControlMask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, AnyKey, ShiftMask|Mod1Mask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);

    XGrabKey(_display, AnyKey, ControlMask|Mod1Mask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);

    XGrabKey(_display, AnyKey, ShiftMask|ControlMask|Mod1Mask|Mod4Mask, _rootWindow, True, GrabModeAsync, GrabModeSync);

    XGrabKey(_display, XKeysymToKeycode(_display, XK_F1), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F2), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F3), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F4), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F5), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F6), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F7), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F8), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F9), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F10), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F11), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
    XGrabKey(_display, XKeysymToKeycode(_display, XK_F12), AnyModifier, _rootWindow, True, GrabModeAsync, GrabModeSync);
}

- (void)dealloc
{
    [self cleanup];
    [super dealloc];
}
- (void)cleanup
{
    if (_desktopWindow) {
        [self XDestroyWindow:_desktopWindow];
        _desktopWindow = 0;
    }
    if (_display) {
        XCloseDisplay(_display);
        _display = NULL;
    }
    _rootWindow = NULL;
}
- (BOOL)setupX11
{
    _display = XOpenDisplay(0);
    if (!_display) {
NSLog(@"XOpenDisplay failed");
        return NO;
    }

    XSetCloseDownMode(_display, DestroyAll);
fcntl(ConnectionNumber(_display), F_SETFD, fcntl(ConnectionNumber(_display), F_GETFD) | FD_CLOEXEC);

    _displayFD = ConnectionNumber(_display);

    _rootWindow = DefaultRootWindow(_display);
    XWindowAttributes rootAttrs;
    XGetWindowAttributes(_display, _rootWindow, &rootAttrs);
    _rootWindowX = rootAttrs.x;
    _rootWindowY = rootAttrs.y;
    _rootWindowWidth = rootAttrs.width;
    _rootWindowHeight = rootAttrs.height;

    if (!XMatchVisualInfo(_display, DefaultScreen(_display), 32, TrueColor, &_visualInfo)) {
NSLog(@"XMatchVisualInfo failed for depth 32, trying 24");
        if (!XMatchVisualInfo(_display, DefaultScreen(_display), 24, TrueColor, &_visualInfo)) {
NSLog(@"XMatchVisualInfo failed for depth 24");
            return NO;
        }
    }
NSLog(@"XMatchVisualInfo depth %d", _visualInfo.depth);

    _colormap = XCreateColormap(_display, _rootWindow, _visualInfo.visual, AllocNone);

    _menuBarHeight = 20;
    [self setValue:nsarr() forKey:@"objectWindows"];

    return YES;
}
- (BOOL)setupWindowManager
{
    XSetErrorHandler(handleDidDetectWindowManager);
    XSelectInput(_display, _rootWindow, SubstructureRedirectMask|SubstructureNotifyMask|ButtonPressMask|ButtonReleaseMask|PointerMotionMask|FocusChangeMask|StructureNotifyMask|KeyPressMask|KeyReleaseMask);
    XSync(_display, False);

    if (__didDetectWindowManagerFlag) {
NSLog(@"Another window manager is running");
        return NO;
    }

    XSetErrorHandler(handleXError);

    _isWindowManager = YES;
    _leftPointerCursor = XCreateFontCursor(_display, XC_left_ptr);
    _leftSideCursor = XCreateFontCursor(_display, XC_left_side);
    _rightSideCursor = XCreateFontCursor(_display, XC_right_side);
    _topSideCursor = XCreateFontCursor(_display, XC_top_side);
    _bottomSideCursor = XCreateFontCursor(_display, XC_bottom_side);
    _topLeftCornerCursor = XCreateFontCursor(_display, XC_top_left_corner);
    _topRightCornerCursor = XCreateFontCursor(_display, XC_top_right_corner);
    _bottomLeftCornerCursor = XCreateFontCursor(_display, XC_bottom_left_corner);
    _bottomRightCornerCursor = XCreateFontCursor(_display, XC_bottom_right_corner);
    [self setX11Cursor:'5'];

    return YES;
}

- (void)getX11Color:(void *)ptr colormap:(unsigned long)colormap r:(int)r g:(int)g b:(int)b
{
    r = r & 0xff;
    g = g & 0xff;
    b = b & 0xff;
    XColor *color = ptr;
    color->red = (r<<8)|r;
    color->green = (g<<8)|g;
    color->blue = (b<<8)|b;
    color->flags = DoRed|DoGreen|DoBlue;
    XAllocColor(_display, colormap, color);
}
- (void)setBackgroundForBitmap:(id)bitmap
{
    int width = [bitmap bitmapWidth];
    int height = [bitmap bitmapHeight];

    int screen = DefaultScreen(_display);
    int depth = DefaultDepth(_display, screen);
    XImage *ximage = CreateTrueColorImage(_display, _visualInfo.visual, [bitmap pixelBytes], width, height, depth);


    Pixmap pixmap = XCreatePixmap(_display, _rootWindow, width, height, depth);
    GC gc = XCreateGC(_display, pixmap, 0, 0);
    XPutImage(_display, pixmap, gc, ximage, 0, 0, 0, 0, width, height);

    XSetWindowBackgroundPixmap(_display, _rootWindow, pixmap);

    XFreeGC(_display, gc);
    XFreePixmap(_display, pixmap);
    XDestroyImage(ximage);
    XClearWindow(_display, _rootWindow);
}
- (void)setBackgroundForCString:(char *)cstr palette:(char *)palette
{
    int width = [Definitions widthForCString:cstr];
    int height = [Definitions heightForCString:cstr];
    if (!width || !height) {
        return;
    }
    id bitmap = [Definitions bitmapWithWidth:width height:height];
    [bitmap drawCString:cstr palette:palette x:0 y:0];

    [self setBackgroundForBitmap:bitmap];
}

- (void)cleanupChildProcesses
{
    pid_t pid;
    int status;
    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        NSLog(@"cleaning up child with pid %d", pid);
    }
}
- (void)reparentAllWindows:(id)reparentClassName
{
    XGrabServer(_display);

    if (reparentClassName) {
        [self setValue:reparentClassName forKey:@"reparentClassName"];
    }

    Window returnedRoot, returnedParent;
    Window *topLevelWindows;
    unsigned int numTopLevelWindows;
    XQueryTree(_display, _rootWindow, &returnedRoot, &returnedParent, &topLevelWindows, &numTopLevelWindows);
    for (int i=0; i<numTopLevelWindows; i++) {
        Window win = topLevelWindows[i];
        XWindowAttributes attrs;
        if (!XGetWindowAttributes(_display, win, &attrs)) {
            continue;
        }
        if (attrs.override_redirect) {
            continue;
        }
        if (attrs.map_state != IsViewable) {
            continue;
        }
        int newY = attrs.y;
        if (newY < _menuBarHeight) {
            newY = _menuBarHeight;
        }
        [self reparentWindow:win x:attrs.x y:newY w:attrs.width h:attrs.height];
    }
    XFree(topLevelWindows);
    XUngrabServer(_display);
}
- (void)unparentAllWindows
{
NSLog(@"unparentAllWindows enter");
    for (int i=0; i<[_objectWindows count]; i++) {
        id elt = [_objectWindows nth:i];
        [self unparentObjectWindow:elt];
    }
NSLog(@"unparentAllWindows exit");
}

- (void)grabButtonForWindow:(unsigned long)win
{
//    XGrabButton(_display, Button1, AnyModifier, win, False, ButtonPressMask, GrabModeSync, GrabModeAsync, None, None);
    XGrabButton(_display, AnyButton, AnyModifier, win, False, ButtonPressMask, GrabModeSync, GrabModeAsync, None, None);
}
- (void)ungrabButtonForWindow:(unsigned long)win
{
//    XUngrabButton(_display, Button1, AnyModifier, win);
    XUngrabButton(_display, AnyButton, AnyModifier, win);
}

- (id)reparentWindow:(unsigned long)win x:(int)x y:(int)y w:(int)w h:(int)h
{
NSLog(@"reparentWindow:%lu", win);
    if ([self dictForObjectWindow:win]) {
        return nil;
    }
    id name = nil;
    {
        char *windowNameReturn = NULL;
        if (XFetchName(_display, win, &windowNameReturn)) {
            name = nscstr(windowNameReturn);
            XFree(windowNameReturn);
        }
    }
NSLog(@"reparentWindow:%lu name %@", win, name);


    id obj = [_reparentClassName asInstance];
    int leftBorder = [obj intValueForKey:@"leftBorder"];
    int rightBorder = [obj intValueForKey:@"rightBorder"];
    int topBorder = [obj intValueForKey:@"topBorder"];
    int bottomBorder = [obj intValueForKey:@"bottomBorder"];
    id dict = [self openWindowForObject:obj  x:x y:y w:w+leftBorder+rightBorder h:h+topBorder+bottomBorder];
     unsigned long objectWindow = [dict unsignedLongValueForKey:@"window"];
    XAddToSaveSet(_display, win);
    XSetWindowBorderWidth(_display, win, 0);

    // set property WM_STATE
    // seems to fix Wine wait_for_withdrawn_state
    {
        Atom atom = XInternAtom(_display, "WM_STATE", False);
        unsigned long state[2];
        state[0] = 1;
        state[1] = None;
        XChangeProperty(_display, win, atom, atom, 32, PropModeReplace, (unsigned char *)state, 2);
    }

    // set property _NET_FRAME_EXTENTS
    // fixes Firefox form history popup window location
    {
        long propdata[4];
        propdata[0] = leftBorder;
        propdata[1] = rightBorder;
        propdata[2] = topBorder;
        propdata[3] = bottomBorder;
        XChangeProperty(_display, win, XInternAtom(_display, "_NET_FRAME_EXTENTS", False), XA_CARDINAL, 32, PropModeReplace, &propdata[0], 4);
    }
    XSelectInput(_display, win, PointerMotionMask|PropertyChangeMask);
    XReparentWindow(_display, win, objectWindow, leftBorder, topBorder);
    XMapWindow(_display, objectWindow);

    [dict setValue:nsfmt(@"%lu", win) forKey:@"childWindow"];
    [dict setValue:name forKey:@"name"];

    [self addShadowMaskToObjectWindow:dict];
    [self addMaskToChildWindow:dict];

    return dict;
}
- (void)sendCloseEventToWindow:(unsigned long)win
{
    XEvent e;
    memset(&e, 0, sizeof(e));
    e.xclient.type = ClientMessage;
    e.xclient.window = win;
    e.xclient.message_type = XInternAtom(_display, "WM_PROTOCOLS", True);
    e.xclient.format = 32;
    e.xclient.data.l[0] = XInternAtom(_display, "WM_DELETE_WINDOW", False);
    e.xclient.data.l[1] = CurrentTime;
    XSendEvent(_display, win, False, NoEventMask, &e);
}
- (void)addShadowMaskToObjectWindow:(id)dict
{
    id object = [dict valueForKey:@"object"];
    if ([object respondsToSelector:@selector(x11WindowMaskPointsForWidth:height:)]) {
        Window win = [[dict valueForKey:@"window"] unsignedLongValue];
        int w = [dict intValueForKey:@"w"];
        int h = [dict intValueForKey:@"h"];
        int *points = [object x11WindowMaskPointsForWidth:w height:h];
        [self addMaskToWindow:win arrayOfPoints:points width:w height:h];
    }
}
- (void)addMaskToChildWindow:(id)dict
{
    id object = [dict valueForKey:@"object"];
    id x11HasChildMask = [object valueForKey:@"x11HasChildMask"];
    id childWindow = [dict valueForKey:@"childWindow"];
    if (!childWindow) {
        return;
    }
    unsigned long win = [childWindow unsignedLongValue];
    int w = [dict intValueForKey:@"w"];
    int h = [dict intValueForKey:@"h"];
    id obj = [dict valueForKey:@"object"];
    w -= [obj intValueForKey:@"leftBorder"];
    w -= [obj intValueForKey:@"rightBorder"];
    h -= [obj intValueForKey:@"topBorder"];
    h -= [obj intValueForKey:@"bottomBorder"];

    XGCValues xgcv;
    xgcv.foreground = WhitePixel(_display, DefaultScreen(_display));
    xgcv.line_width = 1;
    xgcv.line_style = LineSolid;
    Pixmap shape_pixmap = XCreatePixmap(_display, win, w, h, 1);
    GC shape_gc = XCreateGC(_display, shape_pixmap, 0, &xgcv);
    XSetForeground(_display, shape_gc, 1);
    XFillRectangle(_display, shape_pixmap, shape_gc, 0, 0, w, h);
    XSetForeground(_display, shape_gc, 0);
    if ([x11HasChildMask hasPrefix:@"bottomRightCorner"]) {
        int maskWidth = [x11HasChildMask intValueForKey:@"w"];
        int maskHeight = [x11HasChildMask intValueForKey:@"h"];
        if ((maskWidth > 0) && (maskHeight > 0)) {
            XFillRectangle(_display, shape_pixmap, shape_gc, w-maskWidth, h-maskHeight, maskWidth, maskHeight);
        }
    }
    XShapeCombineMask(_display, win, ShapeBounding, 0, 0, shape_pixmap, ShapeSet);
    XFreeGC(_display, shape_gc);
    XFreePixmap(_display, shape_pixmap);
}
- (void)addMaskToWindow:(unsigned long)win cString:(char *)pixels c:(char)c
{
    if (!win || !pixels || !c) {
        return;
    }
    int w = [Definitions widthForCString:pixels];
    int h = [Definitions heightForCString:pixels];
    XGCValues xgcv;
    xgcv.foreground = WhitePixel(_display, DefaultScreen(_display));
    xgcv.line_width = 1;
    xgcv.line_style = LineSolid;
    Pixmap shape_pixmap = XCreatePixmap(_display, win, w, h, 1);
    GC shape_gc = XCreateGC(_display, shape_pixmap, 0, &xgcv);
    XSetForeground(_display, shape_gc, 1);
    XFillRectangle(_display, shape_pixmap, shape_gc, 0, 0, w, h);
    XSetForeground(_display, shape_gc, 0);

    char *p = pixels;
    int x = 0;
    int y = 0;
    for(;;) {
        if (!*p) {
            break;
        }
        if (*p == '\n') {
            x = 0;
            y++;
            p++;
            continue;
        }
        if (*p == c) {
            XDrawPoint(_display, shape_pixmap, shape_gc, x, y);
        }
        x++;
        p++;
    }

    XShapeCombineMask(_display, win, ShapeBounding, 0, 0, shape_pixmap, ShapeSet);
    XFreeGC(_display, shape_gc);
    XFreePixmap(_display, shape_pixmap);
}
- (void)addMaskToWindow:(unsigned long)win arrayOfPoints:(int *)points width:(int)w height:(int)h
{
    if (!win || !points) {
        return;
    }

    XGCValues xgcv;
    xgcv.foreground = WhitePixel(_display, DefaultScreen(_display));
    xgcv.line_width = 1;
    xgcv.line_style = LineSolid;
    Pixmap shape_pixmap = XCreatePixmap(_display, win, w, h, 1);
    GC shape_gc = XCreateGC(_display, shape_pixmap, 0, &xgcv);
    XSetForeground(_display, shape_gc, 1);
    XFillRectangle(_display, shape_pixmap, shape_gc, 0, 0, w, h);
    XSetForeground(_display, shape_gc, 0);

    for (int i=1; i<points[0]; i+=2) {
        int x = points[i];
        int y = points[i+1];
        XDrawPoint(_display, shape_pixmap, shape_gc, x, y);
    }

    XShapeCombineMask(_display, win, ShapeBounding, 0, 0, shape_pixmap, ShapeSet);
    XFreeGC(_display, shape_gc);
    XFreePixmap(_display, shape_pixmap);
}
- (void)addMaskToWindow:(unsigned long)win bitmap:(id)bitmap
{
    int w = [bitmap bitmapWidth];
    int h = [bitmap bitmapHeight];

    XGCValues xgcv;
    xgcv.foreground = WhitePixel(_display, DefaultScreen(_display));
    xgcv.line_width = 1;
    xgcv.line_style = LineSolid;
    Pixmap shape_pixmap = XCreatePixmap(_display, win, w, h, 1);
    GC shape_gc = XCreateGC(_display, shape_pixmap, 0, &xgcv);
    {
        XSetForeground(_display, shape_gc, 1);
        XFillRectangle(_display, shape_pixmap, shape_gc, 0, 0, w, h);
        XSetForeground(_display, shape_gc, 0);
        uint8_t *pixelBytes = [bitmap pixelBytes];
        int bitmapStride = [bitmap bitmapStride];
        for (int i=0; i<w; i++) {
            for (int j=0; j<h; j++) {
                uint8_t *p = pixelBytes + bitmapStride*j + i*4;
                if (!p[3]) {
                    XDrawPoint(_display, shape_pixmap, shape_gc, i, j);
                }
            }
        }
    }
    XShapeCombineMask(_display, win, ShapeBounding, 0, 0, shape_pixmap, ShapeSet);
    XFreeGC(_display, shape_gc);
    XFreePixmap(_display, shape_pixmap);
}
- (void)unparentObjectWindow:(id)dict
{
    id childWindow = [dict valueForKey:@"childWindow"];
    if (childWindow) {
NSLog(@"unparent object %@", dict);
        unsigned long child = [childWindow unsignedLongValue];
        [self ungrabButtonForWindow:child];
        int x = [dict intValueForKey:@"x"];
        int y = [dict intValueForKey:@"y"];
        XReparentWindow(_display, child, _rootWindow, x, y);
        [dict setValue:nil forKey:@"childWindow"];
        [dict setValue:@"1" forKey:@"shouldCloseWindow"];
    } 
}
- (void)destroyObjectWindow:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (window) {
        XDestroyWindow(_display, [window unsignedLongValue]);
    }
    [_objectWindows removeObject:dict];
}
- (void)unmapObjectWindow:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    [dict setValue:@"1" forKey:@"isUnmapped"];
    XUnmapWindow(_display, [window unsignedLongValue]);
}
- (void)mapObjectWindow:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    [dict setValue:nil forKey:@"isUnmapped"];
    [dict setValue:@"1" forKey:@"needsRedraw"];
    XMapWindow(_display, [window unsignedLongValue]);
}
- (void)raiseObjectWindow:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (window) {
        XRaiseWindow(_display, [window unsignedLongValue]);
        return;
    }

    if ([dict intValueForKey:@"HOTDOGNOFRAME"]) {
        id childWindow = [dict valueForKey:@"childWindow"];
        if (childWindow) {
            XRaiseWindow(_display, [childWindow unsignedLongValue]);
        }
        return;
    }
}
- (void)lowerObjectWindow:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    XLowerWindow(_display, [window unsignedLongValue]);
}
- (void)moveObjectWindow:(id)dict x:(int)x y:(int)y
{
    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    Window win = [window unsignedLongValue];
    [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
    [self XMoveWindow:win :x :y];
}
- (void)resizeObjectWindow:(id)dict w:(int)w h:(int)h
{
    int x = [dict intValueForKey:@"x"];
    int y = [dict intValueForKey:@"y"];
    [self moveResizeObjectWindow:dict x:x y:y w:w h:h];
}
- (void)moveResizeObjectWindow:(id)dict x:(int)x y:(int)y w:(int)w h:(int)h
{
    if ([dict intValueForKey:@"HOTDOGNOFRAME"]) {
        id window = [dict valueForKey:@"childWindow"];
        if (window) {
            Window win = [window unsignedLongValue];
            [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
            [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
            [dict setValue:nsfmt(@"%d", w) forKey:@"w"];
            [dict setValue:nsfmt(@"%d", h) forKey:@"h"];
            [self XMoveResizeWindow:win :x :y :w :h];
        }
        return;
    }

    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    Window win = [window unsignedLongValue];
    id object = [dict valueForKey:@"object"];
    [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
    [dict setValue:nsfmt(@"%d", w) forKey:@"w"];
    [dict setValue:nsfmt(@"%d", h) forKey:@"h"];
    [self XMoveResizeWindow:win :x :y :w :h];
    id childWindowNumber = [dict valueForKey:@"childWindow"];
    if (childWindowNumber) {
        unsigned long childWindow = [childWindowNumber unsignedLongValue];
        id object = [dict valueForKey:@"object"];
        int leftBorder = [object intValueForKey:@"leftBorder"];
        int rightBorder = [object intValueForKey:@"rightBorder"];
        int topBorder = [object intValueForKey:@"topBorder"];
        int bottomBorder = [object intValueForKey:@"bottomBorder"];
        int childW = [dict intValueForKey:@"w"]-leftBorder-rightBorder;
        int childH = [dict intValueForKey:@"h"]-topBorder-bottomBorder;
        if (childW < 1) {
        } else if (childH < 1) {
        } else {
            [self XMoveResizeWindow:childWindow :leftBorder :topBorder :childW :childH];
        }
    }
    [self addShadowMaskToObjectWindow:dict];
    [self addMaskToChildWindow:dict];
    [dict setValue:@"1" forKey:@"needsRedraw"];
}

- (id)dictForObjectChildWindow:(unsigned long)win
{
    for (int i=0; i<[_objectWindows count]; i++) {
        id elt = [_objectWindows nth:i];
        id childWindow = [elt valueForKey:@"childWindow"];
        if (childWindow) {
            if (win == [childWindow unsignedLongValue]) {
                return elt;
            }
        }
    }
    return nil;
}
- (id)dictForObjectWindow:(unsigned long)win
{
    id key = nsfmt(@"%lu", win);
    return [_objectWindows objectWithValue:key forKey:@"window"];
}
- (id)dictForObjectWindowClassName:(id)className
{
    for (int i=0; i<[_objectWindows count]; i++) {
        id dict = [_objectWindows nth:i];
        id obj = [dict valueForKey:@"object"];
        if ([[obj class] isEqual:[className asClass]]) {
//FIXME
            if (![dict intValueForKey:@"shouldCloseWindow"]) {
                return dict;
            }
        }
    }
    return nil;
}
- (id)dictForObject:(id)obj
{
    for (int i=0; i<[_objectWindows count]; i++) {
        id dict = [_objectWindows nth:i];
        if (obj == [dict valueForKey:@"object"]) {
            return dict;
        }
    }
    return nil;
}

- (void)destroyWindowButKeepObject:(id)dict
{
    id window = [dict valueForKey:@"window"];
    if (!window) {
        return;
    }
    XDestroyWindow(_display, [window unsignedLongValue]);
    [dict setValue:nil forKey:@"window"];
}
- (id)openButtonDownMenuForObject:(id)obj x:(int)x y:(int)y w:(int)w h:(int)h
{
    if (!w) {
        if ([obj respondsToSelector:@selector(preferredWidth)]) {
            w = [obj preferredWidth];
        } else {
            w = 320;
        }
    }
    if (!h) {
        if ([obj respondsToSelector:@selector(preferredHeight)]) {
            h = [obj preferredHeight];
        } else {
            h = 480;
        }
    }
    id menuDict = [self openWindowForObject:obj x:x y:y w:w+3 h:h+3 overrideRedirect:YES];
    [self setValue:menuDict forKey:@"buttonDownDict"];
    [self setValue:menuDict forKey:@"menuDict"];
    return menuDict;
}

- (unsigned long)openWindowWithName:(id)name x:(int)x y:(int)y w:(int)w h:(int)h
{
    return [self openWindowWithName:name x:x y:y w:w h:h overrideRedirect:NO];
}
- (unsigned long)openWindowWithName:(id)name x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect
{
    return [self openWindowWithName:name x:x y:y w:w h:h overrideRedirect:overrideRedirect propertyName:NULL];
}
- (unsigned long)openWindowWithName:(id)name x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect propertyName:(char *)propertyName
{
    XSetWindowAttributes setAttrs;
    setAttrs.colormap = _colormap;
    if (_isWindowManager) {
        setAttrs.event_mask = SubstructureRedirectMask|SubstructureNotifyMask|ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask|EnterWindowMask|LeaveWindowMask;
    } else {
        setAttrs.event_mask = ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask;
    }
    setAttrs.bit_gravity = NorthWestGravity;
    setAttrs.background_pixmap = None;
    setAttrs.border_pixel = 0;
    unsigned long attrFlags = CWColormap|CWEventMask|CWBackPixmap|CWBorderPixel;
    if (!_isWindowManager) {
        if (overrideRedirect) {
            setAttrs.override_redirect = True;
            attrFlags |= CWOverrideRedirect;
        }
    }
    Window win = XCreateWindow(_display, _rootWindow, x, y, w, h, 0, _visualInfo.depth, InputOutput, _visualInfo.visual, attrFlags, &setAttrs);


    if (!_isWindowManager) {
        if (name) {
            [self XStoreName:win :name];
        }

        Atom wm_delete_window = XInternAtom(_display, "WM_DELETE_WINDOW", 0);
        XSetWMProtocols(_display, win, &wm_delete_window, 1);

        if (propertyName) {
            [self XChangeProperty:win name:propertyName value:NULL];
        }

        if (!_openGLTexture) {
            if ([Definitions respondsToSelector:@selector(setupOpenGLForDisplay:window:visualInfo:)]) {
                if ([Definitions setupOpenGLForDisplay:_display window:win visualInfo:&_visualInfo]) {
                    id texture = [@"GLTexture" asInstance];
        NSLog(@"x11 ALLOCATED textureID %d", [texture textureID]);
                    [self setValue:texture forKey:@"openGLTexture"];
                    id objectTexture = [@"GLTexture" asInstance];
                    [self setValue:objectTexture forKey:@"openGLObjectTexture"];
                    _openGLWindow = win;
                }
            }
        }
    }

    XMapWindow(_display, win);

    return win;
}
- (unsigned long)openUnmappedWindowWithName:(id)name x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect propertyName:(char *)propertyName
{
    XSetWindowAttributes setAttrs;
    setAttrs.colormap = _colormap;
    if (_isWindowManager) {
        setAttrs.event_mask = SubstructureRedirectMask|SubstructureNotifyMask|ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask|EnterWindowMask|LeaveWindowMask;
    } else {
        setAttrs.event_mask = ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask;
    }
    setAttrs.bit_gravity = NorthWestGravity;
    setAttrs.background_pixmap = None;
    setAttrs.border_pixel = 0;
    unsigned long attrFlags = CWColormap|CWEventMask|CWBackPixmap|CWBorderPixel;
    if (!_isWindowManager) {
        if (overrideRedirect) {
            setAttrs.override_redirect = True;
            attrFlags |= CWOverrideRedirect;
        }
    }
    Window win = XCreateWindow(_display, _rootWindow, x, y, w, h, 0, _visualInfo.depth, InputOutput, _visualInfo.visual, attrFlags, &setAttrs);


    if (!_isWindowManager) {
        if (name) {
            [self XStoreName:win :name];
        }

        Atom wm_delete_window = XInternAtom(_display, "WM_DELETE_WINDOW", 0);
        XSetWMProtocols(_display, win, &wm_delete_window, 1);

        if (propertyName) {
            [self XChangeProperty:win name:propertyName value:NULL];
        }

        if (!_openGLTexture) {
            if ([Definitions respondsToSelector:@selector(setupOpenGLForDisplay:window:visualInfo:)]) {
                if ([Definitions setupOpenGLForDisplay:_display window:win visualInfo:&_visualInfo]) {
                    id texture = [@"GLTexture" asInstance];
        NSLog(@"x11 ALLOCATED textureID %d", [texture textureID]);
                    [self setValue:texture forKey:@"openGLTexture"];
                    id objectTexture = [@"GLTexture" asInstance];
                    [self setValue:objectTexture forKey:@"openGLObjectTexture"];
                    _openGLWindow = win;
                }
            }
        }
    }

    return win;
}

- (id)openWindowForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h 
{
    return [self openWindowForObject:object x:x y:y w:w h:h overrideRedirect:NO];
}
- (id)openWindowForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect
{
    return [self openWindowForObject:object x:x y:y w:w h:h overrideRedirect:overrideRedirect propertyName:NULL];
}
- (id)openWindowForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect propertyName:(char *)propertyName
{
    if (!object) {
        return nil;
    }
    if (!h) {
w = 768.0 / 1.5;
h = 768;
#ifndef BUILD_FOR_OSX
id monitor = [Definitions monitorForX:0 y:0];
if ([monitor intValueForKey:@"height"] == 768) {
    w = 640.0 / 1.5;
    h = 640;
}
#endif
    }

    Window win = [self openWindowWithName:[@"." asRealPath] x:x y:y w:w h:h overrideRedirect:overrideRedirect propertyName:propertyName];

    id dict = nsdict();
    [dict setValue:nsfmt(@"%lu", win) forKey:@"window"];
    [dict setValue:object forKey:@"object"];
    [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
    [dict setValue:nsfmt(@"%d", w) forKey:@"w"];
    [dict setValue:nsfmt(@"%d", h) forKey:@"h"];
    [dict setValue:@"1" forKey:@"needsRedraw"];
    [_objectWindows addObject:dict];

    [self addShadowMaskToObjectWindow:dict];
    [self addMaskToChildWindow:dict];
    return dict;
}
- (id)openUnmappedWindowForObject:(id)object x:(int)x y:(int)y w:(int)w h:(int)h overrideRedirect:(BOOL)overrideRedirect propertyName:(char *)propertyName
{
    if (!object) {
        return nil;
    }

    Window win = [self openUnmappedWindowWithName:[@"." asRealPath] x:x y:y w:w h:h overrideRedirect:overrideRedirect propertyName:propertyName];

    id dict = nsdict();
    [dict setValue:nsfmt(@"%lu", win) forKey:@"window"];
    [dict setValue:object forKey:@"object"];
    [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
    [dict setValue:nsfmt(@"%d", w) forKey:@"w"];
    [dict setValue:nsfmt(@"%d", h) forKey:@"h"];
    [_objectWindows addObject:dict];

    return dict;
}
- (id)generateEventDictRootX:(int)rootX rootY:(int)rootY x:(int)x y:(int)y w:(int)w h:(int)h x11dict:(id)x11dict
{
    id dict = nsdict();
    [dict setValue:nsfmt(@"%d", rootX) forKey:@"mouseRootX"];
    [dict setValue:nsfmt(@"%d", rootY) forKey:@"mouseRootY"];
    [dict setValue:nsfmt(@"%d", x) forKey:@"mouseX"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"mouseY"];
    [dict setValue:nsfmt(@"%d", w) forKey:@"viewWidth"];
    [dict setValue:nsfmt(@"%d", h) forKey:@"viewHeight"];
    [dict setValue:x11dict forKey:@"x11dict"];
    [dict setValue:self forKey:@"windowManager"];
    return dict;
}
- (id)dictForButtonEvent:(void *)eptr w:(int)w h:(int)h x11dict:(id)x11dict
{
    XButtonEvent *e = eptr;
    return [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x y:e->y w:w h:h x11dict:x11dict];
}
- (id)dictForKeyEvent:(void *)eptr w:(int)w h:(int)h x11dict:(id)x11dict
{
    XKeyEvent *e = eptr;
    return [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x y:e->y w:w h:h x11dict:x11dict];
}

- (void)drawObjectWindow:(id)context
{
    id window = [context valueForKey:@"window"];
    if (!window) {
        return;
    }
    id object = [context valueForKey:@"object"];
    Window win = [window unsignedLongValue];
    int x = 0;
    int y = 0;
    int w = [context intValueForKey:@"w"];
    int h = [context intValueForKey:@"h"];
    if (_isWindowManager) {
        id bitmap = [Definitions bitmapWithWidth:w height:h];
        Int4 r = [Definitions rectWithX:x y:y w:w h:h];
        if ([object respondsToSelector:@selector(drawInBitmap:rect:context:)]) {
            [object drawInBitmap:bitmap rect:r context:context];
        } else if ([object respondsToSelector:@selector(drawInBitmap:rect:)]) {
            [object drawInBitmap:bitmap rect:r];
        } else {
            [bitmap setColor:@"white"];
            [bitmap fillRect:r];
            [bitmap setColor:@"black"];
            id text = [object description];
            text = [bitmap fitBitmapString:text width:r.w-10];
            [bitmap drawBitmapText:text x:r.x+5 y:r.y+5];
        }

        XImage *ximage = CreateTrueColorImage(_display, _visualInfo.visual, [bitmap pixelBytes], w, h, _visualInfo.depth);
        GC gc = XCreateGC(_display, win, 0, 0);
        XPutImage(_display, win, gc, ximage, 0, 0, 0, 0, w, h);
        XFreeGC(_display, gc);
        XDestroyImage(ximage);
    } else {
//NSLog(@"drawObject:%@ drawInRect w %d h %d", object, w, h);
        if (_openGLTexture && (win == _openGLWindow)) {
//NSLog(@"openGLTexture texture %d", [_openGLTexture textureID]);
            if ([object respondsToSelector:@selector(drawInBitmap:rect:context:)]) {
                int scaling = [context intValueForKey:@"pixelScaling"];
                int scaledW = w;
                int scaledH = h;
                if (scaling >= 2) {
                    scaledW /= scaling;
                    scaledH /= scaling;
                }
                Int4 rect = [Definitions rectWithX:0 y:0 w:scaledW h:scaledH];
                id bitmap = [Definitions bitmapWithWidth:scaledW height:scaledH];
                [object drawInBitmap:bitmap rect:rect context:context];

                [Definitions clearOpenGLForWidth:w height:h];
                [Definitions drawUsingNearestFilterToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
//                [Definitions drawToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
                [Definitions drawOpenGLTextureID:[_openGLTexture textureID]];
                if ([object respondsToSelector:@selector(drawAdditionalInRect:context:)]) {
                    [object drawAdditionalInRect:rect context:context];
                }
            } else if ([object respondsToSelector:@selector(drawInBitmap:rect:)]) {
                int scaling = [context intValueForKey:@"pixelScaling"];
                int scaledW = w;
                int scaledH = h;
                if (scaling >= 2) {
                    scaledW /= scaling;
                    scaledH /= scaling;
                }
                Int4 rect = [Definitions rectWithX:0 y:0 w:scaledW h:scaledH];
                id bitmap = [Definitions bitmapWithWidth:scaledW height:scaledH];
                [bitmap setColorIntR:0 g:0 b:0 a:255];
//                    [bitmap fillRectangleAtX:0 y:0 w:w h:h];
                [object drawInBitmap:bitmap rect:rect];

                [Definitions clearOpenGLForWidth:w height:h];
                [Definitions drawUsingNearestFilterToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
//                    [Definitions drawToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
                [Definitions drawOpenGLTextureID:[_openGLTexture textureID]];
                if ([object respondsToSelector:@selector(drawAdditionalInRect:)]) {
                    [object drawAdditionalInRect:rect];
                }
            } else {
                BOOL didDrawPixelBytes = NO;
                if ([object respondsToSelector:@selector(pixelBytesRGBA8888)]) {
                    unsigned char *pixelBytes = [object pixelBytesRGBA8888];
                    if (pixelBytes) {
                        int bitmapWidth = [object bitmapWidth];
                        int bitmapHeight = [object bitmapHeight];
                        int bitmapStride = bitmapWidth*4;
                        int draw_GL_NEAREST = 0;
                        if ([object respondsToSelector:@selector(glNearest)]) {
                            draw_GL_NEAREST = [object glNearest];
                        }
                        [Definitions clearOpenGLForWidth:w height:h];
                        if (draw_GL_NEAREST) {
                            [Definitions drawUsingNearestFilterToOpenGLTextureID:[_openGLObjectTexture textureID] bytes:pixelBytes bitmapWidth:bitmapWidth bitmapHeight:bitmapHeight bitmapStride:bitmapStride];
                        } else {
                            [Definitions drawToOpenGLTextureID:[_openGLObjectTexture textureID] bytes:pixelBytes bitmapWidth:bitmapWidth bitmapHeight:bitmapHeight bitmapStride:bitmapStride];
                        }
                        [Definitions drawOpenGLTextureID:[_openGLObjectTexture textureID] x:0 y:0 w:w h:h inW:w h:h];
                        didDrawPixelBytes = YES;
                    }
                }
                if ([object respondsToSelector:@selector(pixelBytesBGR565)]) {
                    unsigned char *pixelBytes = [object pixelBytesBGR565];
                    if (pixelBytes) {
                        int bitmapWidth = [object bitmapWidth];
                        int bitmapHeight = [object bitmapHeight];
                        int draw_GL_NEAREST = 0;
                        if ([object respondsToSelector:@selector(glNearest)]) {
                            draw_GL_NEAREST = [object glNearest];
                        }
                        [Definitions clearOpenGLForWidth:w height:h];
                        if (draw_GL_NEAREST) {
                            [Definitions drawUsingNearestFilterToOpenGLTextureID:[_openGLObjectTexture textureID] pixels565:pixelBytes width:bitmapWidth height:bitmapHeight];
                        } else {
                            [Definitions drawToOpenGLTextureID:[_openGLObjectTexture textureID] pixels565:pixelBytes width:bitmapWidth height:bitmapHeight];
                        }
                        [Definitions drawOpenGLTextureID:[_openGLObjectTexture textureID] x:0 y:0 w:w h:h inW:w h:h];
                        didDrawPixelBytes = YES;
                    }
                }
                if (!didDrawPixelBytes) {
                    id bitmap = [Definitions bitmapWithWidth:w height:h];
                    [bitmap setColor:@"#ffff88"];
                    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:w h:h]];
                    [bitmap setColor:@"black"];
                    id text = [object description];
                    text = [bitmap fitBitmapString:text width:w-10];
                    [bitmap drawBitmapText:text x:5 y:5];

                    [Definitions clearOpenGLForWidth:w height:h];
                    [Definitions drawUsingNearestFilterToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
    //                [Definitions drawToOpenGLTextureID:[_openGLTexture textureID] bytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] bitmapStride:[bitmap bitmapStride]];
                    [Definitions drawOpenGLTextureID:[_openGLTexture textureID]];
                }
            }





            [Definitions openGLXSwapBuffersForDisplay:_display window:win];
        } else {
            id bitmap = [Definitions bitmapWithWidth:w height:h];
            if ([object respondsToSelector:@selector(drawInBitmap:rect:context:)]) {
                [object drawInBitmap:bitmap rect:[Definitions rectWithX:0 y:0 w:w h:h] context:context];
            } else if ([object respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [bitmap setColorIntR:0 g:0 b:0 a:255];
    //            [bitmap fillRectangleAtX:0 y:0 w:w h:h];
                [object drawInBitmap:bitmap rect:[Definitions rectWithX:0 y:0 w:w h:h]];
            } else {
                [bitmap setColor:@"#ffff88"];
                [bitmap fillRect:[Definitions rectWithX:0 y:0 w:w h:h]];
                [bitmap setColor:@"black"];
                id text = [object description];
                text = [bitmap fitBitmapString:text width:w-10];
                [bitmap drawBitmapText:text x:5 y:5];
            }
            GC gc = XCreateGC(_display, win, 0, 0);
            XImage *ximage = CreateTrueColorImage(_display, _visualInfo.visual, [bitmap pixelBytes], w, h, _visualInfo.depth);
            XPutImage(_display, win, gc, ximage, 0, 0, 0, 0, w, h);
            XDestroyImage(ximage);
            XFreeGC(_display, gc);
        }
    }
}

- (void)setFocusDict:(id)dict
{
    [self setFocusDict:dict raiseWindow:YES setInputFocus:YES];
}

- (void)setFocusDict:(id)dict raiseWindow:(BOOL)raiseWindow setInputFocus:(BOOL)setInputFocus
{
NSLog(@"setFocusDict:%@", dict);
    {
        id arr = nil;
        if (!dict || (dict == _menuBar)) {
            arr = [self getAppMenuForWindow:_desktopWindow];
        } else if ([dict intValueForKey:@"HOTDOGNOFRAME"]) {
            id childWindow = [dict valueForKey:@"childWindow"];
            arr = [self getAppMenuForWindow:[childWindow unsignedLongValue]];
        }

        [self setValue:arr forKey:@"focusAppMenu"];
        id menuBar = [_menuBar valueForKey:@"object"];
        id oldArray = [menuBar valueForKey:@"array"];
        if (oldArray) {
            id newArray = [self incorporateFocusAppMenu:oldArray];
            [menuBar setValue:newArray forKey:@"array"];
        }
    }
    if (!dict) {
        dict = _menuBar;
    }
    [self setValue:dict forKey:@"focusDict"];
    [_menuBar setValue:@"1" forKey:@"needsRedraw"];
    if (dict) {
        if (raiseWindow) {
            [self raiseObjectWindow:dict];
        }
        if (setInputFocus) {
            id childWindow = [dict valueForKey:@"childWindow"];
            if (childWindow) {
                XSetInputFocus(_display, [childWindow unsignedLongValue], RevertToPointerRoot, CurrentTime);
            } else {
                id window = [dict valueForKey:@"window"];
                if (window) {
                    XSetInputFocus(_display, [window unsignedLongValue], RevertToPointerRoot, CurrentTime);
                }
            }
        }
    }
    for (int i=0; i<[_objectWindows count]; i++) {
        id elt = [_objectWindows nth:i];
        id childWindow = [elt valueForKey:@"childWindow"];
        if (elt == dict) {
            if (childWindow) {
                [self ungrabButtonForWindow:[childWindow unsignedLongValue]];
            }
            [elt setValue:@"1" forKey:@"hasFocus"];
            [elt setValue:@"1" forKey:@"needsRedraw"];
        } else {
            if ([elt valueForKey:@"hasFocus"]) {
                [elt setValue:nil forKey:@"hasFocus"];
                [elt setValue:@"1" forKey:@"needsRedraw"];
            }
            if (childWindow) {
                [self grabButtonForWindow:[childWindow unsignedLongValue]];
            }
        }
    }
    if ([_rootWindowObject respondsToSelector:@selector(handleDidSetInputFocusEvent:)]) {
        id eventDict = [self generateEventDictRootX:_mouseX rootY:_mouseY x:_mouseX y:_mouseY w:_rootWindowWidth h:_rootWindowHeight x11dict:dict];
        [_rootWindowObject handleDidSetInputFocusEvent:eventDict];
    }
}



- (void)runLoop
{
NSLog(@"_displayFD %d", _displayFD);

    for (;;) {
        id pool = [[NSAutoreleasePool alloc] init];
            if (_isWindowManager) {
                if (__receivedExitSignal) {
                    [self unparentAllWindows];
                    [pool drain];
                    break;
                }
            } else {
                if (![_objectWindows count]) {
NSLog(@"no object windows, exiting pid %d", getpid());
                    [pool drain];
                    break;
                }
            }

            if (_pendingMessage) {
                [Definitions evaluateMessage:_pendingMessage];
                [self setValue:nil forKey:@"pendingMessage"];
            }

            time_t timestamp = time(0);
            if (timestamp != _backgroundUpdateTimestamp) {

                for (int i=0; i<[_objectWindows count]; i++) {
                    id elt = [_objectWindows nth:i];
                    id obj = [elt valueForKey:@"object"];
                    if ([obj respondsToSelector:@selector(handleBackgroundUpdate:)]) {
                        id dict = nsdict();
                        [dict setValue:self forKey:@"windowManager"];
                        [dict setValue:elt forKey:@"x11dict"];
                        [obj handleBackgroundUpdate:dict];
                        [elt setValue:@"1" forKey:@"needsRedraw"];
                    }
                }

                _backgroundUpdateTimestamp = timestamp;
            }

            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                id obj = [elt valueForKey:@"object"];
                if ([obj respondsToSelector:@selector(beginIteration:rect:)]) {
                    Int4 r = [Definitions rectWithX:[elt intValueForKey:@"x"] y:[elt intValueForKey:@"y"] w:[elt intValueForKey:@"w"] h:[elt intValueForKey:@"h"]];
                    id dict = nsdict();
                    [dict setValue:self forKey:@"windowManager"];
                    [dict setValue:elt forKey:@"x11dict"];
                    [obj beginIteration:dict rect:r];
                }
            }

            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                if ([elt valueForKey:@"needsRedraw"]) {
                    [self drawObjectWindow:elt];
                    [elt setValue:nil forKey:@"needsRedraw"];
                }
            }

            fd_set rfds;
            int maxFD=0;
            FD_ZERO(&rfds);
            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                id obj = [elt valueForKey:@"object"];
                if (obj) {
                    if ([obj respondsToSelector:@selector(fileDescriptor)]) {
                        int fd = [obj fileDescriptor];
                        if (fd != -1) {
                            FD_SET(fd, &rfds);
                            if (fd > maxFD) {
                                maxFD = fd;
                            }
                        }
                    }
                    if ([obj respondsToSelector:@selector(fileDescriptors)]) {
                        int *objfds = [obj fileDescriptors];
                        if (objfds) {
                            for (int j=0;; j++) {
                                if (objfds[j] < 0) {
                                    break;
                                }
                                FD_SET(objfds[j], &rfds);
                                if (objfds[j] > maxFD) {
                                    maxFD = objfds[j];
                                }
                            }
                        }
                    }
                    if ([obj respondsToSelector:@selector(fileDescriptorObjects)]) {
                        id arr = [obj fileDescriptorObjects];
                        for (int j=0; j<[arr count]; j++) {
                            id fdobj = [arr nth:j];
                            if ([fdobj respondsToSelector:@selector(fileDescriptor)]) {
                                int fd = [fdobj fileDescriptor];
                                if (fd != -1) {
                                    FD_SET(fd, &rfds);
                                    if (fd > maxFD) {
                                        maxFD = fd;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            struct timeval tv;
            tv.tv_sec = 1;
            tv.tv_usec = 0;
            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                id obj = [elt valueForKey:@"object"];
                if ([obj respondsToSelector:@selector(shouldAnimate)]) {
                    if ([obj shouldAnimate]) {
                        [elt setValue:@"1" forKey:@"needsRedraw"];
                        tv.tv_sec = 0;
                        tv.tv_usec = 0;
                    }
                }
            }
            if (XPending(_display) > 0) {
                tv.tv_sec = 0;
                tv.tv_usec = 0;
            } else {
                FD_SET(_displayFD, &rfds);
                if (_displayFD > maxFD) {
                    maxFD = _displayFD;
                }
            }
            int result = select(maxFD+1, &rfds, NULL, NULL, &tv);
            if (result < 0) {
               continue;
            }
            while (XPending(_display) > 0) {
                XEvent event;
                XNextEvent(_display, &event);
                if (event.type == KeyPress) {
                    [self handleX11KeyPress:&event];
                } else if (event.type == KeyRelease) {
                    [self handleX11KeyRelease:&event];
                } else if (event.type == ButtonPress) {
                    [self handleX11ButtonPress:&event];
                } else if (event.type == ButtonRelease) {
                    [self handleX11ButtonRelease:&event];
                } else if (event.type == MotionNotify) {
                    [self handleX11MotionNotify:&event];
                } else if (event.type == EnterNotify) {
                    [self handleX11EnterNotify:&event];
                } else if (event.type == LeaveNotify) {
                    [self handleX11LeaveNotify:&event];
                } else if (event.type == FocusIn) {
                    [self handleX11FocusIn:&event];
                } else if (event.type == FocusOut) {
                    [self handleX11FocusOut:&event];
                } else if (event.type == Expose) {
NSLog(@"Expose event");
                } else if (event.type == VisibilityNotify) {
                    [self handleX11VisibilityNotify:&event];
                } else if (event.type == CreateNotify) {
                    [self handleX11CreateNotify:&event];
                } else if (event.type == DestroyNotify) {
                    [self handleX11DestroyNotify:&event];
                } else if (event.type == UnmapNotify) {
                    [self handleX11UnmapNotify:&event];
                } else if (event.type == MapNotify) {
NSLog(@"MapNotify event");
                } else if (event.type == MapRequest) {
                    [self handleX11MapRequest:&event];
                } else if (event.type == ConfigureNotify) {
                    [self handleX11ConfigureNotify:&event];
                } else if (event.type == ConfigureRequest) {
                    [self handleX11ConfigureRequest:&event];
                } else if (event.type == PropertyNotify) {
                    [self handleX11PropertyNotify:&event];
                } else if (event.type == ClientMessage) {
                    if (event.xclient.message_type == XInternAtom(_display, "WM_PROTOCOLS", 1)
                        && event.xclient.data.l[0] == XInternAtom(_display, "WM_DELETE_WINDOW", 1))
                    {
                        exit(1);
                        XClientMessageEvent *e = &event;
                        id dict = [self dictForObjectWindow:e->window];
NSLog(@"ClientMessage event %lu %@", e->window, dict);
                        [dict setValue:@"1" forKey:@"shouldCloseWindow"];
                    }
                } else {
NSLog(@"received X event type %d", event.type);
                }
            }

            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                id obj = [elt valueForKey:@"object"];
                if ([obj respondsToSelector:@selector(endIteration:)]) {
                    id dict = nsdict();
                    [dict setValue:self forKey:@"windowManager"];
                    [dict setValue:elt forKey:@"x11dict"];
                    [obj endIteration:dict];
                }
            }

            {
                id closeArr = nil;
                for (int i=0; i<[_objectWindows count]; i++) {
                    id dict = [_objectWindows nth:i];
                    if ([dict intValueForKey:@"shouldCloseWindow"]) {
                        if ([dict intValueForKey:@"shouldKeepObject"]) {
                            [self destroyWindowButKeepObject:dict];
                            [dict setValue:nil forKey:@"shouldCloseWindow"];
                        } else {
                            if (!closeArr) {
                                closeArr = nsarr();
                            }
                            [closeArr addObject:dict];
                        }
                    }
                }
                for (int i=0; i<[closeArr count]; i++) {
                    id dict = [closeArr nth:i];
                    [self destroyObjectWindow:dict];
                }
            }
            for (int i=0; i<[_objectWindows count]; i++) {
                id dict = [_objectWindows nth:i];
                id moveWindow = [dict valueForKey:@"moveWindow"];
                id resizeWindow = [dict valueForKey:@"resizeWindow"];
                id moveWindowTokens = [moveWindow split];
                id resizeWindowTokens = [resizeWindow split];
                int moveWindowTokensCount = [moveWindowTokens count];
                int resizeWindowTokensCount = [resizeWindowTokens count];
                if ((moveWindowTokensCount == 2) && (resizeWindowTokensCount == 2)) {
                    int x = [[moveWindowTokens nth:0] intValue];
                    int y = [[moveWindowTokens nth:1] intValue];
                    int w = [[resizeWindowTokens nth:0] intValue];
                    int h = [[resizeWindowTokens nth:1] intValue];
                    [self moveResizeObjectWindow:dict x:x y:y w:w h:h];
                } else if (moveWindowTokensCount == 2) {
                    int x = [[moveWindowTokens nth:0] intValue];
                    int y = [[moveWindowTokens nth:1] intValue];
                    [self moveObjectWindow:dict x:x y:y];
                } else if (resizeWindowTokensCount == 2) {
                    int w = [[resizeWindowTokens nth:0] intValue];
                    int h = [[resizeWindowTokens nth:1] intValue];
                    [self resizeObjectWindow:dict w:w h:h];
                }
                [dict setValue:nil forKey:@"moveWindow"];
                [dict setValue:nil forKey:@"resizeWindow"];
            }
            for (int i=0; i<[_objectWindows count]; i++) {
                id dict = [_objectWindows nth:i];
                id moveChildWindow = [dict valueForKey:@"moveChildWindow"];
                if (!moveChildWindow) {
                    continue;
                }
                id moveChildWindowTokens = [moveChildWindow split];
                int moveChildWindowTokensCount = [moveChildWindowTokens count];
                if (moveChildWindowTokensCount == 2) {
                    int x = [[moveChildWindowTokens nth:0] intValue];
                    int y = [[moveChildWindowTokens nth:1] intValue];
                    id childWindow = [dict valueForKey:@"childWindow"];
                    if (childWindow) {
                        [self XMoveWindow:[childWindow unsignedLongValue] :x :y];
                    }
                }
                [dict setValue:nil forKey:@"moveChildWindow"];
            }
            for (int i=0; i<[_objectWindows count]; i++) {
                id dict = [_objectWindows nth:i];
                id changeWindowName = [dict valueForKey:@"changeWindowName"];
                if (changeWindowName) {
                    id window = [dict valueForKey:@"window"];
                    if (window) {
                        Window win = [window unsignedLongValue];
                        [self XStoreName:win :changeWindowName];
                    }
                    [dict setValue:nil forKey:@"changeWindowName"];
                }
            }

            for (int i=0; i<[_objectWindows count]; i++) {
                id elt = [_objectWindows nth:i];
                id obj = [elt valueForKey:@"object"];
                if ([obj respondsToSelector:@selector(fileDescriptor)]) {
                    int fd = [obj fileDescriptor];
                    if (fd != -1) {
                        if (FD_ISSET(fd, &rfds)) {
                            if ([obj respondsToSelector:@selector(handleFileDescriptor)]) {
                                [obj handleFileDescriptor];
                            }
                            [elt setValue:@"1" forKey:@"needsRedraw"];
                        }
                    }
                }
                if ([obj respondsToSelector:@selector(fileDescriptors)]) {
                    int *objfds = [obj fileDescriptors];
                    if (objfds) {
                        for (int j=0;; j++) {
                            if (objfds[j] < 0) {
                                break;
                            }
                            if (FD_ISSET(objfds[j], &rfds)) {
                                if ([obj respondsToSelector:@selector(handleFileDescriptor:)]) {
                                    [obj handleFileDescriptor:objfds[j]];
                                }
                                [elt setValue:@"1" forKey:@"needsRedraw"];
                            }
                        }
                    }
                }
                if ([obj respondsToSelector:@selector(fileDescriptorObjects)]) {
                    id arr = [obj fileDescriptorObjects];
                    if (arr) {
                        for (int j=0; j<[arr count]; j++) {
                            id fdObject = [arr nth:j];
                            if ([fdObject respondsToSelector:@selector(fileDescriptor)]) {
                                int fd = [fdObject fileDescriptor];
                                if (fd != -1) {
                                    if ([fdObject respondsToSelector:@selector(handleFileDescriptor)]) {
                                        if (FD_ISSET(fd, &rfds)) {
                                            [fdObject handleFileDescriptor];
                                            [elt setValue:@"1" forKey:@"needsRedraw"];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            [self cleanupChildProcesses];
            XFlush(_display);

        [pool drain];
    }
}

- (void)handleX11KeyPress:(void *)eptr
{
    XKeyEvent *e = eptr;
    int keysym = XLookupKeysym(e, 0);
NSLog(@"keysym %d mod1 %d mod2 %d mod3 %d mod4 %d mod5 %d", keysym, e->state&Mod1Mask, e->state&Mod2Mask, e->state&Mod3Mask, e->state&Mod4Mask, e->state&Mod5Mask);
    if (_isWindowManager) {
        id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
NSLog(@"hotkey keyString %@", keyString);
        id hotKeyFiles = [[Definitions configDir:@"Config/hotKeyFiles.csv"] parseCSVFile];
        for (int i=0; i<[hotKeyFiles count]; i++) {
            id hotKeyFile = [hotKeyFiles nth:i];
            id path = [hotKeyFile valueForKey:@"path"];
            if (!path) {
                continue;
            }
            id menu = [[Definitions configDir:path] parseCSVFile];
            for (int j=0; j<[menu count]; j++) {
                id elt = [menu nth:j];
                id hotKey = [[elt valueForKey:@"hotKey"] lowercaseString];
                if ([keyString isEqual:hotKey]) {
                    id message = [elt valueForKey:@"messageForClick"];
                    if (message) {
                        id flashMessage = [hotKeyFile valueForKey:@"flashMessage"];
                        if (flashMessage) {
                            [self evaluateMessage:flashMessage];
                        }
                        [elt evaluateMessage:message];
                        XAllowEvents(_display, AsyncKeyboard, CurrentTime);
                        return;
                    }
                }
            }
        }

        XAllowEvents(_display, ReplayKeyboard, CurrentTime);

NSLog(@"********** buttonDownDict %@", _buttonDownDict);
        if (_buttonDownDict) {
            id dict = _buttonDownDict;
            id object = [dict valueForKey:@"object"];
            if ([object respondsToSelector:@selector(handleKeyDown:)]) {
                int w = [dict intValueForKey:@"w"];
                int h = [dict intValueForKey:@"h"];
                id event = [self dictForKeyEvent:e w:w h:h x11dict:dict];
                id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
                [event setValue:keyString forKey:@"keyString"];
NSLog(@"keyString %@", keyString);
                [event setValue:nsfmt(@"%d", keysym) forKey:@"keyCode"];
                if (e->state & Mod1Mask) {
                    [event setValue:@"1" forKey:@"altKey"];
                }
                if (e->state & Mod4Mask) {
                    [event setValue:@"1" forKey:@"windowsKey"];
                }
                [object handleKeyDown:event];
                [dict setValue:@"1" forKey:@"needsRedraw"];
            }
        }

        return;
    } else {
        if (keysym == XK_Escape) {
            exit(1);
            id dict = [self dictForObjectWindow:e->window];
            [dict setValue:@"1" forKey:@"shouldCloseWindow"];
            return;
        }

    }

    if (e->window == _rootWindow) {
        id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
NSLog(@"rootWindow keyString %@", keyString);
        return;
    }

    id dict = [self dictForObjectWindow:e->window];
    id object = [dict valueForKey:@"object"];
    if ([object respondsToSelector:@selector(handleKeyDown:)]) {
        int w = [dict intValueForKey:@"w"];
        int h = [dict intValueForKey:@"h"];
        id event = [self dictForKeyEvent:e w:w h:h x11dict:dict];
        id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
        [event setValue:keyString forKey:@"keyString"];
NSLog(@"keyString %@", keyString);
        [event setValue:nsfmt(@"%d", keysym) forKey:@"keyCode"];
        if (e->state & Mod1Mask) {
            [event setValue:@"1" forKey:@"altKey"];
        }
        if (e->state & Mod4Mask) {
            [event setValue:@"1" forKey:@"windowsKey"];
        }
        [object handleKeyDown:event];
        [dict setValue:@"1" forKey:@"needsRedraw"];
    } else if ([object respondsToSelector:@selector(contextualMenu)]) {
        id contextualObject = object;
        id menu = [object contextualMenu];
        id arr = nil;
        if (isnsarr(menu)) {
            arr = menu;
        } else {
            arr = [menu valueForKey:@"array"];
            contextualObject = [menu valueForKey:@"contextualObject"];
        }
        if (arr) {
            id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
NSLog(@"keyString '%@'", keyString);
            id choice = [arr objectWithValue:keyString forKey:@"hotKey"];
NSLog(@"choice '%@'", choice);
            if (choice) {
                id message = [choice valueForKey:@"messageForClick"];
                if (message) {
NSLog(@"message '%@'", message);
                    [object evaluateMessage:message];
                    [dict setValue:@"1" forKey:@"needsRedraw"];
                }
            }
        }
    }
}

- (void)handleX11KeyRelease:(void *)eptr
{
    XKeyEvent *e = eptr;
    if (XEventsQueued(_display, QueuedAfterReading)) {
        XEvent nextEvent;
        XPeekEvent(_display, &nextEvent);

        if ((nextEvent.type == KeyPress)
            && (nextEvent.xkey.time == e->time)
            && (nextEvent.xkey.keycode == e->keycode))
        {
NSLog(@"handleX11KeyRelease repeat");
            return;
        }
    }
    id dict = [self dictForObjectWindow:e->window];
    id object = [dict valueForKey:@"object"];
    if ([object respondsToSelector:@selector(handleKeyUp:)]) {
        int w = [dict intValueForKey:@"w"];
        int h = [dict intValueForKey:@"h"];
        id event = [self dictForKeyEvent:e w:w h:h x11dict:dict];
        int keysym = XLookupKeysym(e, 0);
        id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
        [event setValue:keyString forKey:@"keyString"];
        [event setValue:nsfmt(@"%d", keysym) forKey:@"keyCode"];
        if (e->state & Mod1Mask) {
            [event setValue:@"1" forKey:@"altKey"];
        }
        if (e->state & Mod4Mask) {
            [event setValue:@"1" forKey:@"windowsKey"];
        }
        [object handleKeyUp:event];
        [dict setValue:@"1" forKey:@"needsRedraw"];





    }
}

- (void)handleXCrossingEvent:(void *)eptr
{
    XCrossingEvent *e = eptr;
    _mouseX = e->x_root;
    _mouseY = e->y_root;
    if (_isWindowManager) {
        if (!_buttonDownDict) {
            id eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x_root y:e->y_root w:_rootWindowWidth h:_menuBarHeight x11dict:_menuBar];
            id object = [_menuBar valueForKey:@"object"];
            if ([object respondsToSelector:@selector(handleMouseMoved:)]) {
                [object handleMouseMoved:eventDict];
            }
            [_menuBar setValue:@"1" forKey:@"needsRedraw"];
        }
    }
}
- (void)handleX11EnterNotify:(void *)eptr
{
    XEnterWindowEvent *e = eptr;
NSLog(@"handleX11EnterNotify:%x", e->window);
    [self handleXCrossingEvent:eptr];
    if ([_rootWindowObject respondsToSelector:@selector(handleEnterWindowEvent:)]) {
        id x11dict = [self dictForObjectWindow:e->window];
        if (!x11dict) {
            x11dict = [self dictForObjectChildWindow:e->window];
        }
        id eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x_root y:e->y_root w:_rootWindowWidth h:_rootWindowHeight x11dict:x11dict];
        [_rootWindowObject handleEnterWindowEvent:eventDict];
    }
}
- (void)handleX11LeaveNotify:(void *)eptr
{
    XLeaveWindowEvent *e = eptr;
NSLog(@"handleX11LeaveNotify:%x", e->window);
    [self handleXCrossingEvent:eptr];
}
- (void)handleX11FocusIn:(void *)eptr
{
    XFocusInEvent *e = eptr;
    Window win = e->window;
NSLog(@"FocusIn event win %lu", win);
    if (!_isWindowManager) {
        _focusInEventWindow = win;
        id dict = [self dictForObjectWindow:win];
        [dict setValue:@"1" forKey:@"needsRedraw"];
    }

    id x11dict = [self dictForObjectWindow:e->window];
    if (x11dict) {
        id object = [x11dict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleFocusInEvent:)]) {
            id eventDict = [self generateEventDictRootX:0 /*e->x_root*/ rootY:0 /*e->y_root*/ x:0 /*e->x_root*/ y:0 /*e->y_root*/ w:_rootWindowWidth h:_rootWindowHeight x11dict:x11dict];
            [object handleFocusInEvent:eventDict];
        }
    }
}

- (void)handleX11FocusOut:(void *)eptr
{
    XFocusOutEvent *e = eptr;
    Window win = e->window;
NSLog(@"FocusOut event win %lu", win);
    if (!_isWindowManager) {
        if (_focusInEventWindow == win) {
            _focusInEventWindow = 0;
            id dict = [self dictForObjectWindow:win];
            [dict setValue:@"1" forKey:@"needsRedraw"];
        }
    }

    id x11dict = [self dictForObjectWindow:e->window];
    if (x11dict) {
        id object = [x11dict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleFocusOutEvent:)]) {
            id eventDict = [self generateEventDictRootX:0 /*e->x_root*/ rootY:0 /*e->y_root*/ x:0 /*e->x_root*/ y:0 /*e->y_root*/ w:_rootWindowWidth h:_rootWindowHeight x11dict:x11dict];
            [object handleFocusOutEvent:eventDict];
        }
    }
}
- (void)handleX11PropertyNotify:(void *)eptr
{
NSLog(@"PropertyChange event enter");
    XPropertyEvent *e = eptr;
    char *atom = XGetAtomName(_display, e->atom);
    if (atom) {
NSLog(@"PropertyChange atom %s state %d (PropertyNewValue %d PropertyDelete %d)", atom, e->state, PropertyNewValue, PropertyDelete);
        if (!strcmp(atom, "WM_NAME")) {
            id dict = [self dictForObjectChildWindow:e->window];
            char *windowNameReturn = NULL;
            if (XFetchName(_display, e->window, &windowNameReturn)) {
                id name = nscstr(windowNameReturn);
                [dict setValue:name forKey:@"name"];
                XFree(windowNameReturn);
                [dict setValue:@"1" forKey:@"needsRedraw"];
            }
        } else if (!strcmp(atom, "WM_HINTS")) {
            XWMHints *hints = XGetWMHints(_display, e->window);
            if (hints) {
NSLog(@"WM_HINTS flags %x", hints->flags);
                if (hints->flags & StateHint) {
NSLog(@"WM_HINTS initial_state %d", hints->initial_state);
                }
                XFree(hints);
            }
        } else if (!strcmp(atom, "_NET_WM_WINDOW_TYPE")) {
            Atom da;
            int di;
            unsigned long dl;
            unsigned char *prop_ret = NULL;
            int status = XGetWindowProperty(_display, e->window, e->atom, 0L, sizeof(Atom), False, XA_ATOM, &da, &di, &dl, &dl, &prop_ret);

            if ((status == Success) && prop_ret) {
//FIXME: Am I supposed to XFree(prop_ret)?
                Atom prop = ((Atom *)prop_ret)[0];

                char *str = XGetAtomName(_display, prop);
NSLog(@"_NET_WM_WINDOW_TYPE: %s\n", str);
                if (str) {
                    XFree(str);
                }
            }
        } else if (!strcmp(atom, "WM_NORMAL_HINTS")) {
            id normalHints = [self XGetWMNormalHints:e->window];
NSLog(@"WM_NORMAL_HINTS %@", normalHints);
            // FIXME
            // Move the window back and forth to trigger a redraw when WM_NORMAL_HINTS changes
            // Seems to fix the no-redrawing problem with x64sc (VICE) which uses GTK3
            // But there should be a better way
            XWindowAttributes attrs;
            XGetWindowAttributes(_display, e->window, &attrs);
            [self XMoveWindow:e->window :attrs.x :attrs.y+1];
            [self XMoveWindow:e->window :attrs.x :attrs.y];
        }
        XFree(atom);
    }
NSLog(@"PropertyChange event exit");
}
- (void)handleX11ConfigureNotify:(void *)eptr
{
    XConfigureEvent *e = eptr;
//NSLog(@"ConfigureNotify window %x root %x", e->window, _rootWindow);
//NSLog(@"event %x window %x x %d y %d override_redirect %d", e->event, e->window, e->x, e->y, e->override_redirect);
    if (_isWindowManager) {
        if (e->window == _rootWindow) {
            XWindowAttributes rootAttrs;
            XGetWindowAttributes(_display, _rootWindow, &rootAttrs);
            _rootWindowX = rootAttrs.x;
            _rootWindowY = rootAttrs.y;
            _rootWindowWidth = rootAttrs.width;
            _rootWindowHeight = rootAttrs.height;
            [self moveResizeObjectWindow:_menuBar x:0 y:0 w:_rootWindowWidth h:_menuBarHeight];
        }
    } else {
        id dict = [self dictForObjectWindow:e->window];
        XWindowAttributes attrs;
        XGetWindowAttributes(_display, e->window, &attrs);
        [dict setValue:nsfmt(@"%d", attrs.x) forKey:@"x"];
        [dict setValue:nsfmt(@"%d", attrs.y) forKey:@"y"];
        [dict setValue:nsfmt(@"%d", attrs.width) forKey:@"w"];
        [dict setValue:nsfmt(@"%d", attrs.height) forKey:@"h"];
        [dict setValue:@"1" forKey:@"needsRedraw"];
    }
}
- (void)handleX11VisibilityNotify:(void *)eptr
{
    XVisibilityEvent *e = eptr;
NSLog(@"VisibilityNotify window %x state %d", e->window, e->state);
    id dict = [self dictForObjectWindow:e->window];
    [dict setValue:@"1" forKey:@"needsRedraw"];
}
- (void)handleX11CreateNotify:(void *)eptr
{
    XCreateWindowEvent *e = eptr;
NSLog(@"CreateNotify event %lu", e->window);

}
- (void)handleX11ConfigureRequest:(void *)eptr
{
    XConfigureRequestEvent *e = eptr;
NSLog(@"handleX11ConfigureRequest: parent %x window %x x %d y %d w %d h %d", e->parent, e->window, e->x, e->y, e->width, e->height);

if ([self doesWindow:e->window haveProperty:"HOTDOGDESKTOP"]) {
NSLog(@"window %lu has property HOTDOGDESKTOP, setting as desktop window", e->window);
    if (_desktopWindow) {
        [self XDestroyWindow:_desktopWindow];
    }
    _desktopWindow = e->window;
}

    id dict = [self dictForObjectChildWindow:e->window];
    if (dict) {
NSLog(@"handleX11ConfigureRequest dict: %@", dict);
NSLog(@"changes x %d y %d width %d height %d", e->x, e->y, e->width, e->height);
        if ([self doesWindow:e->window haveProperty:"HOTDOGNOFRAME"]) {
        } else {
            return;
        }
    }

    XWindowChanges changes;
    changes.x = e->x;
    changes.y = e->y;
    changes.width = e->width;
    changes.height = e->height;
    changes.border_width = e->border_width;
    changes.sibling = e->above;
    changes.stack_mode = e->detail;
    XConfigureWindow(_display, e->window, e->value_mask, &changes);
}
- (void)handleX11MapRequest:(void *)eptr
{
    XMapRequestEvent *e = eptr;
NSLog(@"handleX11MapRequest parent %x window %x", e->parent, e->window);



    BOOL noframe = [self doesWindow:e->window haveProperty:"HOTDOGNOFRAME"];

    if (noframe) {
    } else {
        if ([self dictForObjectChildWindow:e->window]) {
            return;
        }
    }

    XWindowAttributes attrs;
    if (!XGetWindowAttributes(_display, e->window, &attrs)) {
        return;
    }


    if (attrs.override_redirect) {
        return;
    }

    BOOL moveWindowIfNoFrame = NO;

    if (attrs.x == 0) {
        if (attrs.y == 0) {
            id monitor = [Definitions monitorForX:_mouseX y:_mouseY];
            id focusDict = [Definitions currentWindow];
            int focusX = [focusDict intValueForKey:@"x"];
            int focusY = [focusDict intValueForKey:@"y"];
            int focusWidth = [focusDict intValueForKey:@"w"];
            int focusHeight = [focusDict intValueForKey:@"h"];
            id focusMonitor = [Definitions monitorForX:focusX y:focusY];
            int focusMonitorX = [focusMonitor intValueForKey:@"x"];
            int focusMonitorY = [focusMonitor intValueForKey:@"y"];
            int focusMonitorWidth = [focusMonitor intValueForKey:@"width"];
            int focusMonitorHeight = [focusMonitor intValueForKey:@"height"];
            id cmd = nsarr();
            [cmd addObject:@"hotdog-getCoordinatesForNewWindow.pl"];
            [cmd addObject:nsfmt(@"w:%d", attrs.width)];
            [cmd addObject:nsfmt(@"h:%d", attrs.height)];
            [cmd addObject:nsfmt(@"mouseX:%d", _mouseX)];
            [cmd addObject:nsfmt(@"mouseY:%d", _mouseY)];
            [cmd addObject:nsfmt(@"monitorX:%d", [monitor intValueForKey:@"x"])];
            [cmd addObject:nsfmt(@"monitorWidth:%d", [monitor intValueForKey:@"width"])];
            [cmd addObject:nsfmt(@"monitorHeight:%d", [monitor intValueForKey:@"height"])];
            [cmd addObject:nsfmt(@"focusX:%d", focusX)];
            [cmd addObject:nsfmt(@"focusY:%d", focusY)];
            [cmd addObject:nsfmt(@"focusWidth:%d", focusWidth)];
            [cmd addObject:nsfmt(@"focusHeight:%d", focusHeight)];
            [cmd addObject:nsfmt(@"focusMonitorX:%d", focusMonitorX)];
            [cmd addObject:nsfmt(@"focusMonitorY:%d", focusMonitorY)];
            [cmd addObject:nsfmt(@"focusMonitorWidth:%d", focusMonitorWidth)];
            [cmd addObject:nsfmt(@"focusMonitorHeight:%d", focusMonitorHeight)];
            id output = [[cmd runCommandAndReturnOutput] asString];
            id lines = [output split:@"\n"];
            id firstLine = [lines nth:0];
            attrs.x = [firstLine intValueForKey:@"x"];
            attrs.y = [firstLine intValueForKey:@"y"];
            
            moveWindowIfNoFrame = YES;
/*
            id monitor = [Definitions monitorForX:_mouseX y:_mouseY];
            attrs.x = [monitor intValueForKey:@"x"];
*/
        }
    }
    if (attrs.y < _menuBarHeight) {
        attrs.y = _menuBarHeight;
        moveWindowIfNoFrame = YES;
    }

    if (noframe) {
        id dict = nsdict();
//        [dict setValue:nsfmt(@"%lu", win) forKey:@"window"];
//        [dict setValue:object forKey:@"object"];
        [dict setValue:nsfmt(@"%d", attrs.x) forKey:@"x"];
        [dict setValue:nsfmt(@"%d", attrs.y) forKey:@"y"];
        [dict setValue:nsfmt(@"%d", attrs.width) forKey:@"w"];
        [dict setValue:nsfmt(@"%d", attrs.height) forKey:@"h"];
//        [dict setValue:@"1" forKey:@"needsRedraw"];
        [_objectWindows addObject:dict];
        [dict setValue:nsfmt(@"%lu", e->window) forKey:@"childWindow"];
//        [dict setValue:name forKey:@"name"];
        [dict setValue:@"1" forKey:@"HOTDOGNOFRAME"];

        if (moveWindowIfNoFrame) {
            XMoveWindow(_display, e->window, attrs.x, attrs.y);
        }
        XSelectInput(_display, e->window, EnterWindowMask|LeaveWindowMask);
        XMapWindow(_display, e->window);
        [self setFocusDict:dict];
        return;
    }



    id dict = [self reparentWindow:e->window x:attrs.x y:attrs.y w:attrs.width h:attrs.height];
    XMapWindow(_display, e->window);
    [self setFocusDict:dict];

}
- (void)handleX11DestroyNotify:(void *)eptr;
{
    XDestroyWindowEvent *e = eptr;
NSLog(@"handleX11DestroyNotify e->event %x e->window %x", e->event, e->window);

    if (!_isWindowManager) {
        id dict = [self dictForObjectWindow:e->window];
        if (dict) {
NSLog(@"window destroyed %@", dict);
            id object = [dict valueForKey:@"object"];
            if ([object respondsToSelector:@selector(handleDestroyNotifyEvent:)]) {
                id eventDict = [self generateEventDictRootX:0 /*e->x_root*/ rootY:0 /*e->y_root*/ x:0 /*e->x_root*/ y:0 /*e->y_root*/ w:_rootWindowWidth h:_rootWindowHeight x11dict:dict];
                [object handleDestroyNotifyEvent:eventDict];
            }
        }
        return;
    }

    if (_desktopWindow) {
        if (_desktopWindow == e->window) {
            _desktopWindow = 0;
            [self setValue:nil forKey:@"focusAppMenu"];
            id menuBar = [_menuBar valueForKey:@"object"];
            id oldArray = [menuBar valueForKey:@"array"];
            if (oldArray) {
                id newArray = [self incorporateFocusAppMenu:oldArray];
                [menuBar setValue:newArray forKey:@"array"];
            }
        }
    }

    id dict = [self dictForObjectChildWindow:e->window];
NSLog(@"dictForObjectChildWindow %@", dict);
    if (dict) {
        [dict setValue:nil forKey:@"childWindow"];
        [dict setValue:@"1" forKey:@"shouldCloseWindow"];
    }
    Window focus_return = 0;
    int revert_to_return = 0;
    XGetInputFocus(_display, &focus_return, &revert_to_return);
    if (focus_return == PointerRoot) {
NSLog(@"focus_return == PointerRoot");
        [self focusTopmostWindow];
    } else if (focus_return == None) {
NSLog(@"focus_return == None");
        [self focusTopmostWindow];
    } else {
        Window menuBarWindow = [[_menuBar valueForKey:@"window"] unsignedLongValue];
        if (focus_return == menuBarWindow) {
NSLog(@"focus_return == menu bar");
//            [self focusTopmostWindow];
        } else {
NSLog(@"focus_return %x", focus_return);
        }
    }
}
- (void)handleX11UnmapNotify:(void *)eptr;
{
    XUnmapEvent *e = eptr;
NSLog(@"handleX11UnmapNotify e->event %x e->window %x", e->event, e->window);

    // Seems to fix UAE file dialog
    {
        id dict = [self dictForObjectChildWindow:e->window];
        if (dict) {
            if (e->event == [dict unsignedLongValueForKey:@"window"]) {
                [self unparentObjectWindow:dict];
            }
        }
    }

    // For menu bar
    {
        id object = [_menuBar valueForKey:@"object"];
        if (object) {
            unsigned long win = [object unsignedLongValueForKey:@"menuWindowWaitForUnmapNotify"];
            if (win) {
                if (e->window == win) {
                    [object setValue:@"0" forKey:@"menuWindowWaitForUnmapNotify"];
                    [_menuBar setValue:@"1" forKey:@"needsRedraw"];
                }
            }
        }
    }
}





- (void)handleX11ButtonPress:(void *)eptr
{
    XButtonEvent *e = eptr;


    if (_buttonDownDict) {
        if (e->button == 4) {
            id dict = _buttonDownDict;
            id object = [dict valueForKey:@"object"];
NSLog(@"handleX11ButtonPress e->button 4 object %@", object);
            int x = [dict intValueForKey:@"x"];
            int y = [dict intValueForKey:@"y"];
            int w = [dict intValueForKey:@"w"];
            int h = [dict intValueForKey:@"h"];
            if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                id event = [self dictForButtonEvent:e w:w h:h x11dict:dict];
                [Definitions x11FixupEvent:event forBitmapObject:object];
                [event setValue:@"20" forKey:@"deltaY"];
                [event setValue:@"-20" forKey:@"scrollingDeltaY"];
                [object handleScrollWheel:event];
            }
            [dict setValue:@"1" forKey:@"needsRedraw"];
        } else if (e->button == 5) {
            id dict = _buttonDownDict;
            id object = [dict valueForKey:@"object"];
NSLog(@"handleX11ButtonPress e->button 5 object %@", object);
            int x = [dict intValueForKey:@"x"];
            int y = [dict intValueForKey:@"y"];
            int w = [dict intValueForKey:@"w"];
            int h = [dict intValueForKey:@"h"];
            if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                id event = [self dictForButtonEvent:e w:w h:h x11dict:dict];
                [Definitions x11FixupEvent:event forBitmapObject:object];
                [event setValue:@"-20" forKey:@"deltaY"];
                [event setValue:@"20" forKey:@"scrollingDeltaY"];
                [object handleScrollWheel:event];
            }
            [dict setValue:@"1" forKey:@"needsRedraw"];
        } else {
NSLog(@"ignoring handleX11ButtonPress:%x", e->window);
        }
        return;
    }
NSLog(@"handleX11ButtonPress:%x", e->window);

    if (e->window == _rootWindow) {
        id object = _rootWindowObject;
NSLog(@"rootWindow object %@", _rootWindowObject);
        int w = _rootWindowWidth;
        int h = _rootWindowHeight;
        id eventDict = [self dictForButtonEvent:e w:w h:h x11dict:nil];
        [eventDict setValue:nsfmt(@"%d", e->button) forKey:@"buttonDownWhich"];
        if (e->button == 1) {
NSLog(@"_desktopWindow %lu", _desktopWindow);
            if (_desktopWindow) {
                if (_isWindowManager) {
                    [self setFocusDict:nil];
                    e->window = _desktopWindow;
                    XSendEvent(_display, _desktopWindow, False, ButtonPressMask, e);
                    [self setValue:nsdict() forKey:@"buttonDownDict"];
                    _buttonDownWhich = e->button;
                }
            } else if ([object respondsToSelector:@selector(handleMouseDown:)]) {
                [object handleMouseDown:eventDict];
            }
        } else if (e->button == 3) {
            if ([object respondsToSelector:@selector(handleRightMouseDown:)]) {
                [object handleRightMouseDown:eventDict];
            }
        }
        return;
    }
    {
        id dict = [self dictForObjectWindow:e->window];
        if (dict) {
//only set for left button down and right button down
//           [self setValue:dict forKey:@"buttonDownDict"];
//            _buttonDownWhich = e->button;


            id object = [dict valueForKey:@"object"];
            int w = [dict intValueForKey:@"w"];
            int h = [dict intValueForKey:@"h"];
            id eventDict = [self dictForButtonEvent:e w:w h:h x11dict:dict];

            [Definitions x11FixupEvent:eventDict forBitmapObject:object];
            [Definitions x11FixupEventForPixelScaling:eventDict x11dict:dict];

            if (e->button == 1) {
                [self setValue:dict forKey:@"buttonDownDict"];
                _buttonDownWhich = e->button;
                if ([object respondsToSelector:@selector(handleMouseDown:)]) {
                    if (e->state & ShiftMask) {
                        [eventDict setValue:@"1" forKey:@"shiftKey"];
                    }
                    if (e->state & Mod1Mask) {
                        [eventDict setValue:@"1" forKey:@"altKey"];
                    }
                    if (e->state & Mod4Mask) {
                        [eventDict setValue:@"1" forKey:@"windowsKey"];
                    }
                    [object handleMouseDown:eventDict];
                }
            } else if (e->button == 3) {
                [self setValue:dict forKey:@"buttonDownDict"];
                _buttonDownWhich = e->button;
                if ([object respondsToSelector:@selector(handleRightMouseDown:)]) {
                    [object handleRightMouseDown:eventDict];
                } else if ([object respondsToSelector:@selector(contextualMenu)]) {
                    id menu = [object contextualMenu];
                    if (isnsarr(menu)) {
                        menu = [menu asMenu];
                        [menu setValue:object forKey:@"contextualObject"];
                        [menu setValue:nsfmt(@"%lu", e->window) forKey:@"contextualWindow"];
                    }
                    if (menu) {
                        [self openButtonDownMenuForObject:menu x:e->x_root y:e->y_root w:0 h:0];
                    }
                }
            } else if (e->button == 4) {
                if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                    [eventDict setValue:@"20" forKey:@"deltaY"];
                    [eventDict setValue:@"-20" forKey:@"scrollingDeltaY"];
                    [object handleScrollWheel:eventDict];
                }
            } else if (e->button == 5) {
                if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                    [eventDict setValue:@"-20" forKey:@"deltaY"];
                    [eventDict setValue:@"20" forKey:@"scrollingDeltaY"];
                    [object handleScrollWheel:eventDict];
                }
            } else if (e->button == 6) {
                if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                    [eventDict setValue:@"-100" forKey:@"deltaX"];
                    [eventDict setValue:@"-100" forKey:@"scrollingDeltaX"];
                    [object handleScrollWheel:eventDict];
                }
            } else if (e->button == 7) {
                if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
                    [eventDict setValue:@"100" forKey:@"deltaX"];
                    [eventDict setValue:@"100" forKey:@"scrollingDeltaX"];
                    [object handleScrollWheel:eventDict];
                }
            }
            [dict setValue:@"1" forKey:@"needsRedraw"];
            return;
        }
    }

    {
        id dict = [self dictForObjectChildWindow:e->window];
        if (dict) {
            // rootWindowObject might change after setFocusDict:, so save current value of shouldPassthroughClickToFocus
            BOOL passthrough = NO;
            if ([_rootWindowObject respondsToSelector:@selector(shouldPassthroughClickToFocus)]) {
                passthrough = [_rootWindowObject shouldPassthroughClickToFocus];
            }

            if ((e->button == 1) || (e->button == 3)) {
                [self setFocusDict:dict];
            } else {
                [self setFocusDict:dict raiseWindow:NO setInputFocus:YES];
            }

            if (passthrough) {
                XAllowEvents(_display, ReplayPointer, CurrentTime);
            } else {
                XAllowEvents(_display, AsyncPointer, CurrentTime);
            }
            XSync(_display, 0);
        }
    }







}
- (void)handleX11ButtonRelease:(void *)eptr
{
    XButtonEvent *e = eptr;
NSLog(@"ButtonRelease window %x e->button %d _buttonDownWhich %d", e->window, e->button, _buttonDownWhich);

    if (!_buttonDownDict) {
        return;
    }
    if (e->button != _buttonDownWhich) {
        return;
    }


    if (_isWindowManager) {
        if (_desktopWindow) {
            if (e->window == _rootWindow) {
                if (e->button == 1) {
                    e->window = _desktopWindow;
                    XSendEvent(_display, _desktopWindow, False, ButtonReleaseMask, e);
                    [self setValue:nil forKey:@"buttonDownDict"];
                    _buttonDownWhich = 0;
                    return;
                }
            }
        }
    }



    id dict = _buttonDownDict;
    id object = [dict valueForKey:@"object"];
    int x = [dict intValueForKey:@"x"];
    int y = [dict intValueForKey:@"y"];
    int w = [dict intValueForKey:@"w"];
    int h = [dict intValueForKey:@"h"];
    if (e->button == 1) {
        if ([object respondsToSelector:@selector(handleMouseUp:)]) {
            id event = [self dictForButtonEvent:e w:w h:h x11dict:dict];
            [Definitions x11FixupEvent:event forBitmapObject:object];
            [Definitions x11FixupEventForPixelScaling:event x11dict:dict];
            [object handleMouseUp:event];
        }
    } else if (e->button == 3) {
        if ([object respondsToSelector:@selector(handleRightMouseUp:)]) {
            id event = [self dictForButtonEvent:e w:w h:h x11dict:dict];
            [Definitions x11FixupEvent:event forBitmapObject:object];
            [Definitions x11FixupEventForPixelScaling:event x11dict:dict];
            [object handleRightMouseUp:event];
        }
    }
    [dict setValue:@"1" forKey:@"needsRedraw"];
    [self setValue:nil forKey:@"buttonDownDict"];
    [self setValue:nil forKey:@"menuDict"];
    _buttonDownWhich = 0;
}

- (void)handleX11MotionNotify:(void *)eptr
{
    XMotionEvent *e = eptr;

    _mouseX = e->x_root;
    _mouseY = e->y_root;
    if (_isWindowManager) {
        id x11dict = nil;
        if (_buttonDownDict) {

            if (_desktopWindow) {
                if (e->window == _rootWindow) {
                    if (_buttonDownWhich == 1) {
                        e->window = _desktopWindow;
                        XSendEvent(_display, _desktopWindow, False, PointerMotionMask, e);
                        return;
                    }
                }
            }



            x11dict = _buttonDownDict;
        } else if (e->window == _rootWindow) {
            if ([_rootWindowObject respondsToSelector:@selector(handleMouseMoved:)]) {
                id eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x_root y:e->y_root w:_rootWindowWidth h:_rootWindowHeight x11dict:nil];
                [_rootWindowObject handleMouseMoved:eventDict];
            }
        } else {
            x11dict = [self dictForObjectWindow:e->window];
        }

        if (x11dict) {
            id object = [x11dict valueForKey:@"object"];
            if ([object respondsToSelector:@selector(handleMouseMoved:)]) {
                int x = [x11dict intValueForKey:@"x"];
                int y = [x11dict intValueForKey:@"y"];
                int w = [x11dict intValueForKey:@"w"];
                int h = [x11dict intValueForKey:@"h"];
                id eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x_root-x y:e->y_root-y w:w h:h x11dict:x11dict];
                [Definitions x11FixupEvent:eventDict forBitmapObject:object];
                [object handleMouseMoved:eventDict];
            }
            [x11dict setValue:@"1" forKey:@"needsRedraw"];
        }
    } else {
        id x11dict = nil;
        if (_buttonDownDict) {
            x11dict = _buttonDownDict;
        } else {
            x11dict = [self dictForObjectWindow:e->window];
        }
        if (x11dict) {
            id object = [x11dict valueForKey:@"object"];
            int x = [x11dict intValueForKey:@"x"];
            int y = [x11dict intValueForKey:@"y"];
            int w = [x11dict intValueForKey:@"w"];
            int h = [x11dict intValueForKey:@"h"];
            if ([object respondsToSelector:@selector(handleMouseMoved:)]) {
                id eventDict = nil;
                if (_menuDict) {
                    eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x_root-x y:e->y_root-y w:w h:h x11dict:x11dict];
                } else {
                    eventDict = [self generateEventDictRootX:e->x_root rootY:e->y_root x:e->x y:e->y w:w h:h x11dict:x11dict];
                }
                [Definitions x11FixupEvent:eventDict forBitmapObject:object];
                [Definitions x11FixupEventForPixelScaling:eventDict x11dict:x11dict];
                [object handleMouseMoved:eventDict];
            }
            [x11dict setValue:@"1" forKey:@"needsRedraw"];
        }
    }
}

- (void)focusTopmostWindow
{
    Window menuBarWindow = [[_menuBar valueForKey:@"window"] unsignedLongValue];
    Window win = 0;
    Window returnedRoot, returnedParent;
    Window *topLevelWindows;
    unsigned int numTopLevelWindows;
    XQueryTree(_display, _rootWindow, &returnedRoot, &returnedParent, &topLevelWindows, &numTopLevelWindows);
    for (int i=numTopLevelWindows-1; i>=0; i--) {
        if (topLevelWindows[i] == menuBarWindow) {
            continue;
        }
        win = topLevelWindows[i];
        break;
    }
    XFree(topLevelWindows);
    if (win) {
        id dict = [self dictForObjectWindow:win];
        if (dict) {
            [self setFocusDict:dict];
        }
    }
}

- (id)allTopLevelWindows
{
    id results = nsarr();
    Window returnedRoot, returnedParent;
    Window *topLevelWindows;
    unsigned int numTopLevelWindows;
    XQueryTree(_display, _rootWindow, &returnedRoot, &returnedParent, &topLevelWindows, &numTopLevelWindows);
    for (int i=0; i<numTopLevelWindows; i++) {
        [results addObject:nsfmt(@"%x", topLevelWindows[i])];
    }
    XFree(topLevelWindows);
    return results;
}
- (unsigned long)topMostWindowUnderneathWindow:(unsigned long)excludeWindow x:(int)x y:(int)y
{
    Window returnedRoot, returnedParent;
    Window *topLevelWindows;
    unsigned int numTopLevelWindows;
    XQueryTree(_display, _rootWindow, &returnedRoot, &returnedParent, &topLevelWindows, &numTopLevelWindows);
    for (int i=numTopLevelWindows-1; i>=0; i--) {
        if (topLevelWindows[i] == excludeWindow) {
            continue;
        }
        XWindowAttributes attrs;
        XGetWindowAttributes(_display, topLevelWindows[i], &attrs);
        if ((x >= attrs.x) && (x < attrs.x+attrs.width)) {
            if ((y >= attrs.y) && (y < attrs.y+attrs.height)) {
                return topLevelWindows[i];
            }
        }
    }
    XFree(topLevelWindows);
    return 0;
}
- (void)XReparentWindow:(unsigned long)child :(unsigned long)parent :(int)x :(int)y
{
    int result = XReparentWindow(_display, child, parent, x, y);
}
- (void)XResizeWindow:(unsigned long)win :(int)w :(int)h
{
    XResizeWindow(_display, win, w, h);
}
- (void)XMoveWindow:(unsigned long)win :(int)x :(int)y
{
    XMoveWindow(_display, win, x, y);
}
- (void)XMoveResizeWindow:(unsigned long)win :(int)x :(int)y :(int)w :(int)h
{
    XMoveResizeWindow(_display, win, x, y, w, h);
}
- (id)XGetWindowAttributes:(unsigned long)win
{
    XWindowAttributes attrs;
    XGetWindowAttributes(_display, win, &attrs);
    return nsfmt(@"%d %d %d %d", attrs.x, attrs.y, attrs.width, attrs.height);
}
- (void)XRaiseWindow:(unsigned long)win
{
    XRaiseWindow(_display, win);
}

- (id)XGetWMNormalHints:(unsigned long)win
{
    XSizeHints hints_return;
    long supplied_return;
    if (!XGetWMNormalHints(_display, win, &hints_return, &supplied_return)) {
        return nil;
    }
    id dict = nsdict();
    if (supplied_return & USPosition) {
        [dict setValue:nsfmt(@"%d", hints_return.x) forKey:@"userX"];
        [dict setValue:nsfmt(@"%d", hints_return.y) forKey:@"userY"];
    }
    if (supplied_return & USSize) {
        [dict setValue:nsfmt(@"%d", hints_return.width) forKey:@"userWidth"];
        [dict setValue:nsfmt(@"%d", hints_return.height) forKey:@"userHeight"];
    }
    if (supplied_return & PPosition) {
        [dict setValue:nsfmt(@"%d", hints_return.x) forKey:@"x"];
        [dict setValue:nsfmt(@"%d", hints_return.y) forKey:@"y"];
    }
    if (supplied_return & PSize) {
        [dict setValue:nsfmt(@"%d", hints_return.width) forKey:@"width"];
        [dict setValue:nsfmt(@"%d", hints_return.height) forKey:@"height"];
    }
    if (supplied_return & PMinSize) {
        [dict setValue:nsfmt(@"%d", hints_return.min_width) forKey:@"minWidth"];
        [dict setValue:nsfmt(@"%d", hints_return.min_height) forKey:@"minHeight"];
    }
    if (supplied_return & PMaxSize) {
        [dict setValue:nsfmt(@"%d", hints_return.max_width) forKey:@"maxWidth"];
        [dict setValue:nsfmt(@"%d", hints_return.max_height) forKey:@"maxHeight"];
    }
    if (supplied_return & PResizeInc) {
        [dict setValue:nsfmt(@"%d", hints_return.width_inc) forKey:@"widthInc"];
        [dict setValue:nsfmt(@"%d", hints_return.height_inc) forKey:@"heightInc"];
    }
    if (supplied_return & PAspect) {
        [dict setValue:nsfmt(@"%d", hints_return.min_aspect.x) forKey:@"minAspectX"];
        [dict setValue:nsfmt(@"%d", hints_return.min_aspect.y) forKey:@"minAspectY"];
        [dict setValue:nsfmt(@"%d", hints_return.max_aspect.x) forKey:@"maxAspectX"];
        [dict setValue:nsfmt(@"%d", hints_return.max_aspect.y) forKey:@"maxAspectY"];
    }
    if (supplied_return & PBaseSize) {
        [dict setValue:nsfmt(@"%d", hints_return.base_width) forKey:@"baseWidth"];
        [dict setValue:nsfmt(@"%d", hints_return.base_height) forKey:@"baseHeight"];
    }
    if (supplied_return & PWinGravity) {
        [dict setValue:nsfmt(@"%d", hints_return.win_gravity) forKey:@"winGravity"];
    }
    return dict;
}

- (void)XDestroyWindow:(unsigned long)win
{
    XDestroyWindow(_display, win);
}

- (void)XSync:(BOOL)discard
{
    XSync(_display, (discard) ? True : False);
}
- (void)XStoreName:(unsigned long)win :(id)name
{
    XStoreName(_display, win, [name UTF8String]);
}
- (void)XMapWindow:(unsigned long)win
{
    XMapWindow(_display, win);
}
- (void)XUnmapWindow:(unsigned long)win
{
    XUnmapWindow(_display, win);
}
- (void)XSendButtonPressEvent:(unsigned long)win button:(int)button
{
    XButtonEvent e;
    memset(&e, 0, sizeof(XButtonEvent));
    e.type = ButtonPress;
    e.display = _display;
    e.window = win;
    e.root = _rootWindow;
    e.time = CurrentTime;
    e.x = 0;
    e.y = 0;
    e.x_root = 0;
    e.y_root = 0;
    e.button = button;
    e.same_screen = True;
    XSendEvent(_display, win, True, ButtonPressMask, (XEvent *)&e);
}
- (void)XSendButtonReleaseEvent:(unsigned long)win button:(int)button x:(int)x y:(int)y rootX:(int)rootX rootY:(int)rootY
{
    XButtonEvent e;
    memset(&e, 0, sizeof(XButtonEvent));
    e.type = ButtonRelease;
    e.display = _display;
    e.window = win;
    e.root = _rootWindow;
    e.time = CurrentTime;
    e.x = x;
    e.y = y;
    e.x_root = rootX;
    e.y_root = rootY;
    e.button = button;
    e.same_screen = True;
    XSendEvent(_display, win, True, ButtonReleaseMask, (XEvent *)&e);
}
- (void)XSendButtonReleaseEvent:(unsigned long)win button:(int)button
{
    XButtonEvent e;
    memset(&e, 0, sizeof(XButtonEvent));
    e.type = ButtonRelease;
    e.display = _display;
    e.window = win;
    e.root = _rootWindow;
    e.time = CurrentTime;
    e.x = 0;
    e.y = 0;
    e.x_root = 0;
    e.y_root = 0;
    e.button = button;
    e.same_screen = True;
    XSendEvent(_display, win, True, ButtonReleaseMask, (XEvent *)&e);
}
- (void)XSendMotionEvent:(unsigned long)win x:(int)x y:(int)y rootX:(int)rootX rootY:(int)rootY
{
    XMotionEvent e;
    memset(&e, 0, sizeof(XMotionEvent));
    e.type = MotionNotify;
    e.display = _display;
    e.window = win;
    e.root = _rootWindow;
    e.time = CurrentTime;
    e.x = x;
    e.y = y;
    e.x_root = rootX;
    e.y_root = rootY;
    e.same_screen = True;
    XSendEvent(_display, win, True, PointerMotionMask, (XEvent *)&e);
}

- (void)setX11Cursor:(char)cursor
{
    if (cursor == _currentCursor) {
        return;
    }
    _currentCursor = cursor;
    if (cursor == '5') {
        XDefineCursor(_display, _rootWindow, _leftPointerCursor);
    } else if (cursor == '7') {
        XDefineCursor(_display, _rootWindow, _topLeftCornerCursor);
    } else if (cursor == '8') {
        XDefineCursor(_display, _rootWindow, _topSideCursor);
    } else if (cursor == '9') {
        XDefineCursor(_display, _rootWindow, _topRightCornerCursor);
    } else if (cursor == '4') {
        XDefineCursor(_display, _rootWindow, _leftSideCursor);
    } else if (cursor == '6') {
        XDefineCursor(_display, _rootWindow, _rightSideCursor);
    } else if (cursor == '1') {
        XDefineCursor(_display, _rootWindow, _bottomLeftCornerCursor);
    } else if (cursor == '2') {
        XDefineCursor(_display, _rootWindow, _bottomSideCursor);
    } else if (cursor == '3') {
        XDefineCursor(_display, _rootWindow, _bottomRightCornerCursor);
    } else {
        XDefineCursor(_display, _rootWindow, _leftPointerCursor);
    }
}
- (void)XSetInputFocus:(unsigned long)window
{
//FIXME use RevertToNone or RevertToPointerRoot?
NSLog(@"XSetInputFocus:%lu", window);
    XSetInputFocus(_display, window, RevertToPointerRoot, CurrentTime);
}
- (Int2)XQueryPointer
{
    Window root_window = 0;
    Window child_window = 0;
    int root_x = 0;
    int root_y = 0;
    int win_x = 0;
    int win_y = 0;
    unsigned int mask = 0;
    XQueryPointer(_display, _rootWindow, &root_window, &child_window, &root_x, &root_y, &win_x, &win_y, &mask);
    Int2 result;
    result.x = root_x;
    result.y = root_y;
    return result;
}
- (id)XFetchName:(unsigned long)win
{
    id result = nil;
    char *windowNameReturn = NULL;
    if (XFetchName(_display, win, &windowNameReturn)) {
        result = nsfmt(@"%s", windowNameReturn);
        XFree(windowNameReturn);
    }
    return result;
}
- (void)XChangeProperty:(unsigned long)window name:(char *)name value:(char *)value
{
    Atom atom = XInternAtom(_display, name, False);
    XChangeProperty(_display, window, atom, atom, 8, PropModeReplace, "", 0);
}
- (void)XChangeProperty:(unsigned long)window name:(char *)name str:(id)str
{
    if (!str) {
        return;
    }
    unsigned char *cstr = [str UTF8String];
    int len = strlen(cstr);
    Atom atom = XInternAtom(_display, name, False);
    XChangeProperty(_display, window, atom, atom, 8, PropModeReplace, cstr, len);
}
- (id)XGetWindowProperty:(unsigned long)window name:(char *)name
{
    id result = nil;

    Atom actual_type_return = None;
    int actual_format_return = 0;
    unsigned long nitems_return = 0;
    unsigned long bytes_after_return = 0;
    unsigned char *prop_return = NULL;
    Atom atom = XInternAtom(_display, name, False);
    int status = XGetWindowProperty(_display, window, atom, 0, 256, False, AnyPropertyType, &actual_type_return, &actual_format_return, &nitems_return, &bytes_after_return, &prop_return);
    if ((status == Success) && prop_return) {
        if (actual_format_return == 8) {
            result = nsfmt(@"%s", prop_return);
        }
        XFree(prop_return);
    }

    return result;
}

- (BOOL)doesWindow:(unsigned long)win haveProperty:(char *)propertyName
{
    BOOL result = NO;

    Atom actual_type_return = None;
    int actual_format_return = 0;
    unsigned long nitems_return = 0;
    unsigned long bytes_after_return = 0;
    unsigned char *prop_return = NULL;
    int status = XGetWindowProperty(_display, win, XInternAtom(_display, propertyName, False), 0, 0, False, AnyPropertyType, &actual_type_return, &actual_format_return, &nitems_return, &bytes_after_return, &prop_return);
    if ((status == Success) && prop_return) {
NSLog(@"property %s actual_format_return %d", propertyName, actual_format_return);
NSLog(@"property %s nitems_return %d", propertyName, nitems_return);
NSLog(@"property %s bytes_after_return %d", propertyName, bytes_after_return);
if (actual_format_return == 8) {
result = YES;
NSLog(@"property %s prop_return '%s'", propertyName, prop_return);
}
        XFree(prop_return);
    }

    return result;
}
@end


@implementation NSDictionary(fjkdlsfjlksdjklf)
- (void)x11MoveChildWindowBackAndForthForWine
{
    id dict = self;
    unsigned long childWindow = [dict unsignedLongValueForKey:@"childWindow"];
    if (!childWindow) {
        return;
    }
    id object = [dict valueForKey:@"object"];
    int leftBorder = [object intValueForKey:@"leftBorder"];
    int rightBorder = [object intValueForKey:@"rightBorder"];
    int topBorder = [object intValueForKey:@"topBorder"];
    int bottomBorder = [object intValueForKey:@"bottomBorder"];
    int w = [dict intValueForKey:@"w"]-leftBorder-rightBorder;
    int h = [dict intValueForKey:@"h"]-topBorder-bottomBorder;
    id windowManager = [@"windowManager" valueForKey];
    [windowManager XMoveResizeWindow:childWindow :leftBorder-1 :topBorder :w :h];
    [windowManager XMoveResizeWindow:childWindow :leftBorder :topBorder :w :h];
}
- (void)x11MoveToMonitor:(int)monitorNumber
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    id monitors = [Definitions monitorConfig];
    id monitor = [monitors nth:monitorNumber];
    if (!monitor) {
        return;
    }
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    int monitorHeight = [monitor intValueForKey:@"height"];
    int newX = monitorX;
    int newY = menuBarHeight-1;
    int newW = monitorWidth;
    int newH = monitorHeight-(menuBarHeight-1);
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeTopHalf
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newX = monitorX;
    int newY = menuBarHeight;
    int newW = monitorWidth;
    int newH = ((monitorHeight-menuBarHeight)/2);
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeBottomHalf
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newX = monitorX;
    int newH = (monitorHeight-menuBarHeight)/2;
    int newY = monitorHeight - newH;
    int newW = monitorWidth;
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeLeftHalf
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newX = monitorX;
    int newY = menuBarHeight;
    int newW = monitorWidth/2;
    int newH = monitorHeight-menuBarHeight;
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeRightHalf
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newW = monitorWidth/2;
    int newX = monitorX+newW;
    int newH = monitorHeight-menuBarHeight;
    int newY = menuBarHeight;
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeTopLeft
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newX = monitorX;
    int newY = menuBarHeight;
    int newW = monitorWidth/2;
    int newH = ((monitorHeight-menuBarHeight)/2);
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeTopRight
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newY = menuBarHeight;
    int newW = monitorWidth/2;
    int newX = monitorX+newW;
    int newH = ((monitorHeight-menuBarHeight)/2);
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeBottomLeft
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newX = monitorX;
    int newW = monitorWidth/2;
    int newH = ((monitorHeight-menuBarHeight)/2);
    int newY = monitorHeight - newH;
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11MaximizeBottomRight
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    if (dict == menuBar) {
        [@"Which window should I move?" showAlert];
        return;
    }

    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = rootWindowWidth;
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorWidth = [monitor intValueForKey:@"width"];
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newW = monitorWidth/2;
    int newH = ((monitorHeight-menuBarHeight)/2);
    int newX = monitorX + newW;
    int newY = monitorHeight - newH;
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
}
- (void)x11FillToHeightOfMonitor
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int oldX = [dict intValueForKey:@"x"];
    int oldY = [dict intValueForKey:@"y"];
    int oldW = [dict intValueForKey:@"w"];
    id monitor = [Definitions monitorForX:oldX y:oldY];
    int monitorHeight = rootWindowHeight;
    if (monitor) {
        monitorHeight = [monitor intValueForKey:@"height"];
    }
    int newY = oldY;
    if (oldY >= monitorHeight - 40) {
        newY = menuBarHeight;
    }
    int newH = monitorHeight-newY;
    [dict setValue:nsfmt(@"%d %d", oldX, newY) forKey:@"moveWindow"];
    [dict setValue:nsfmt(@"%d %d", oldW, newH) forKey:@"resizeWindow"];
}
- (void)x11MoveWindowToX:(int)newX y:(int)newY
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
}
- (void)x11ChangeWindowWidthTo:(int)newW
{
    id dict = self;
    id windowManager = [@"windowManager" valueForKey];
    int oldH = [dict intValueForKey:@"h"];
    [dict setValue:nsfmt(@"%d %d", newW, oldH) forKey:@"resizeWindow"];
}
- (void)x11CloseWindow
{
    id x11dict = self;
    id windowManager = [@"windowManager" valueForKey];
    id childWindow = [x11dict valueForKey:@"childWindow"];
    if (childWindow) {
        int didSendCloseEvent = [x11dict intValueForKey:@"didSendCloseEvent"];
        if (didSendCloseEvent) {
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
        } else {
            [windowManager sendCloseEventToWindow:[childWindow unsignedLongValue]];
            [x11dict setValue:@"1" forKey:@"didSendCloseEvent"];
        }
    } else {
        [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
    }
}
- (void)x11ToggleMaximizeWindow
{
    id dict = self;
    unsigned long win = [dict unsignedLongValueForKey:@"window"];
    id windowManager = [@"windowManager" valueForKey];
    int rootWindowWidth = [windowManager intValueForKey:@"rootWindowWidth"];
    int rootWindowHeight = [windowManager intValueForKey:@"rootWindowHeight"];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    if ([dict valueForKey:@"revertMaximize"]) {
        id revert = [dict valueForKey:@"revertMaximize"];
        id tokens = [revert split:@" "];
        int newX = [[tokens nth:0] intValue];
        int newY = [[tokens nth:1] intValue];
        int newW = [[tokens nth:2] intValue];
        int newH = [[tokens nth:3] intValue];
        [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
        [dict setValue:nil forKey:@"revertMaximize"];
    } else {
        int midX = [dict intValueForKey:@"x"] + [dict intValueForKey:@"w"]/2;
        int midY = [dict intValueForKey:@"y"] + [dict intValueForKey:@"h"]/2;
        id attrs = [windowManager XGetWindowAttributes:win];
        [dict setValue:attrs forKey:@"revertMaximize"];
        id monitor = [Definitions monitorForX:midX y:midY];
        int monitorX = [monitor intValueForKey:@"x"];
        int monitorWidth = rootWindowWidth;
        int monitorHeight = rootWindowHeight;
        if (monitor) {
            monitorWidth = [monitor intValueForKey:@"width"];
            monitorHeight = [monitor intValueForKey:@"height"];
        }
        int newX = monitorX;
        int newY = menuBarHeight-1;
        int newW = monitorWidth;
        int newH = monitorHeight-(menuBarHeight-1);
        [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
    }
}
- (void)x11MoveToMonitorDelta:(int)delta
{
    id dict = self;
    unsigned long win = [dict unsignedLongValueForKey:@"window"];
    id windowManager = [@"windowManager" valueForKey];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];

    int midX = [dict intValueForKey:@"x"] + [dict intValueForKey:@"w"]/2;
    int midY = [dict intValueForKey:@"y"] + [dict intValueForKey:@"h"]/2;
    int monitorIndex = [Definitions monitorIndexForX:midX y:midY];

    id monitors = [Definitions monitorConfig];
    id oldMonitor = [monitors nth:monitorIndex];
    int offsetX = [dict intValueForKey:@"x"] - [oldMonitor intValueForKey:@"x"];
    int offsetY = [dict intValueForKey:@"y"] - [oldMonitor intValueForKey:@"y"];
    monitorIndex += delta;
    id monitor = [monitors nth:monitorIndex];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    int monitorHeight = [monitor intValueForKey:@"height"];
    int newX = monitorX+offsetX;
    int newY = offsetY;//menuBarHeight-1;
    int newW = monitorWidth;
    int newH = monitorHeight-(menuBarHeight-1);
    if ((newW > 0) && (newH > 0)) {
        [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
//        [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
        [dict setValue:nil forKey:@"revertMaximize"];
    }
}
- (void)x11MaximizeToMonitor:(int)monitorIndex
{
    id dict = self;
    unsigned long win = [dict unsignedLongValueForKey:@"window"];
    id windowManager = [@"windowManager" valueForKey];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];

    id monitors = [Definitions monitorConfig];
    id monitor = [monitors nth:monitorIndex];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    int monitorHeight = [monitor intValueForKey:@"height"];
    int newX = monitorX;
    int newY = menuBarHeight-1;
    int newW = monitorWidth;
    int newH = monitorHeight-(menuBarHeight-1);
    if ((newW > 0) && (newH > 0)) {
        [dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        [dict setValue:nsfmt(@"%d %d", newW, newH) forKey:@"resizeWindow"];
        [dict setValue:nil forKey:@"revertMaximize"];
    }
}
@end

@implementation WindowManager(jfkdslfjklsdjfksdjkfjksdljfkls)
- (unsigned long)openAppMenuWindowsForArray:(id)array
{
    unsigned long prev = 0;
    for (int i=[array count]-1; i>=0; i--) {
        id elt = [array nth:i];
        id title = [elt valueForKey:@"title"];
        if (!title) {
            title = @"Menu";
        }
        id dict = [self openAppMenuWindowForObject:elt name:title];
        if (dict) {
            unsigned long win = [dict unsignedLongValueForKey:@"window"];
            [self XChangeProperty:win name:"HOTDOGAPPMENUNEXT" str:nsfmt(@"%lu", prev)];
            prev = win;
        }
    }
    return prev;
}
- (id)openAppMenuWindowForObject:(id)object name:(id)name
{
    int x = 0;
    int y = 0;
    int w = [object preferredWidth];
    int h = [object preferredHeight];
NSLog(@"object %@ name %@", object, name);
    XSetWindowAttributes setAttrs;
    setAttrs.colormap = _colormap;
    setAttrs.event_mask = ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask;
    setAttrs.bit_gravity = NorthWestGravity;
    setAttrs.background_pixmap = None;
    setAttrs.border_pixel = 0;
    unsigned long attrFlags = CWColormap|CWEventMask|CWBackPixmap|CWBorderPixel;
    if (1 /*overrideRedirect*/) {
        setAttrs.override_redirect = True;
        attrFlags |= CWOverrideRedirect;
    }
    Window win = XCreateWindow(_display, _rootWindow, x, y, w, h, 0, _visualInfo.depth, InputOutput, _visualInfo.visual, attrFlags, &setAttrs);


    if (name) {
        [self XStoreName:win :name];
    }

    Atom wm_delete_window = XInternAtom(_display, "WM_DELETE_WINDOW", 0);
    XSetWMProtocols(_display, win, &wm_delete_window, 1);

//    XMapWindow(_display, win);

    id dict = nsdict();
    [dict setValue:nsfmt(@"%lu", win) forKey:@"window"];
    [dict setValue:object forKey:@"object"];
    [dict setValue:nsfmt(@"%d", x) forKey:@"x"];
    [dict setValue:nsfmt(@"%d", y) forKey:@"y"];
    [dict setValue:nsfmt(@"%d", w) forKey:@"w"];
    [dict setValue:nsfmt(@"%d", h) forKey:@"h"];
    [dict setValue:@"1" forKey:@"needsRedraw"];
    [_objectWindows addObject:dict];
    [self addShadowMaskToObjectWindow:dict];

    return dict;
}
- (id)getAppMenuForWindow:(unsigned long)win
{
    if (!win) {
        return nil;
    }

    id keys = nsdict();
    id arr = nsarr();
    id value = [self XGetWindowProperty:win name:"HOTDOGAPPMENUHEAD"];
    for(;;) {
        if (!value) {
            break;
        }
        if ([keys valueForKey:value]) {
            break;
        }
        [keys setValue:value forKey:value];
        unsigned long win = [value unsignedLongValue];
        if (!win) {
            break;
        }
        id name = [self XFetchName:win];
        if (!name) {
            break;
        }
        id object = [Definitions TextMenuItem:name];
        id dict = nsdict();
        [dict setValue:@"4" forKey:@"leftPadding"];
        [dict setValue:@"4" forKey:@"rightPadding"];
        [dict setValue:object forKey:@"object"];
        [dict setValue:value forKey:@"window"];
        [arr addObject:dict];
        value = [self XGetWindowProperty:win name:"HOTDOGAPPMENUNEXT"];
    }
    if ([arr count]) {
        return arr;
    }
    return nil;
}
- (id)incorporateFocusAppMenu:(id)menuBarArray
{
    id results = nsarr();
    for (int i=0; i<[menuBarArray count]; i++) {
        id elt = [menuBarArray nth:i];
        id window = [elt valueForKey:@"window"];
        if (!window) {
            int flexible = [elt intValueForKey:@"flexible"];
            if (flexible) {
                if (_focusAppMenu) {
                    [results addObjectsFromArray:_focusAppMenu];
                }
            }
            [results addObject:elt];
        }
    }
    return results;
}

@end

