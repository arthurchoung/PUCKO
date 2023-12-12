/*

 PUCKO Linux

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Linux.

 PUCKO Linux is free software: you can redistribute it and/or modify
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

#define MAX_RECT 640

static unsigned char *button_top_middle = 
"b\n"
".\n"
".\n"
;

static unsigned char *button_middle_left =
"b...\n"
;
static unsigned char *button_middle_middle =
".\n"
;
static unsigned char *button_middle_right =
"...b\n"
;

static unsigned char *button_bottom_middle =
".\n"
".\n"
"b\n"
;

static unsigned char *button_top_left_squared = 
"bbbb\n"
"b...\n"
"b...\n"
;
static unsigned char *button_top_right_squared = 
"bbbb\n"
"...b\n"
"...b\n"
;

static unsigned char *button_bottom_left_squared =
"b...\n"
"b...\n"
"bbbb\n"
;
static unsigned char *button_bottom_right_squared =
"...b\n"
"...b\n"
"bbbb\n"
;

@implementation Definitions(fmekwlfmksdlfmklsdkfmfjdksjfkfjsdk)
+ (void)ArtistListNavigation
{
    id object = [Definitions ArtistListInterface];
    if (object) {
        id nav = [Definitions navigationStack];
        [nav pushObject:object];
        [Definitions runWindowManagerForObject:nav];
    }
    exit(0);
}
+ (id)ArtistListInterface
{
    id obj = [@"ArtistListInterface" asInstance];
    [obj handleBackgroundUpdate:nil];
    return obj;
}
@end

@interface ArtistListInterface : IvarObject
{
    time_t _timestamp;
    int _seconds;
    id _array;
    Int4 _rect[MAX_RECT];
    id _buttons;
    char _buttonType[MAX_RECT];
    int _buttonDown;
    int _buttonHover;
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;
}
@end
@implementation ArtistListInterface
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [@"." fileModificationTimestamp];
    if (timestamp == _timestamp) {
        _seconds++;
        return;
    }
    [self updateArray];
    _timestamp = timestamp;
    _seconds = 0;
}
- (void)updateArray
{
    id cmd = nsarr();
    [cmd addObject:@"pucko-music-listArtists.py"];
    id output = [[[cmd runCommandAndReturnOutput] asString] split:@"\n"];
    if (output) {
        [self setValue:output forKey:@"array"];
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [Definitions drawStripedBackgroundInBitmap:bitmap rect:r];

    [self setValue:nsarr() forKey:@"buttons"];

    _cursorY = -_scrollY + r.y;
    _r = r;

    [self setValue:bitmap forKey:@"bitmap"];

    [self panelButton:@"name:All%20Albums allAlbums:1"];

    id arr = _array;
    for (int i=0; i<[arr count]; i++) {
        if (_cursorY >= r.y + r.h) {
            break;
        }
        if ([_buttons count] >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }

        id elt = [arr nth:i];
        [self panelButton:elt];
    }

    [self setValue:nil forKey:@"bitmap"];
}

- (void)panelButton:(id)line
{
    id text = [line valueForKey:@"name"];
    if (!text) {
        text = @"(no name)";
    }

    [_bitmap useChicagoFont];
    id fittedText = [_bitmap fitBitmapString:text width:_r.w-40];
    _cursorY -= 1;
    unsigned char *top_left = button_top_left_squared;
    unsigned char *top_middle = button_top_middle;
    unsigned char *top_right = button_top_right_squared;
    unsigned char *bottom_left = button_bottom_left_squared;
    unsigned char *bottom_middle = button_bottom_middle;
    unsigned char *bottom_right = button_bottom_right_squared;


    int buttonIndex = [_buttons count];
    [_buttons addObject:line];
    _buttonType[buttonIndex] = 'b';

    [_bitmap useChicagoFont];
    int textWidth = [_bitmap bitmapWidthForText:fittedText];
    int textHeight = [_bitmap bitmapHeightForText:fittedText];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    Int4 r1;
    r1.x = _r.x;
    r1.y = _cursorY;
    r1.w = _r.w;
    r1.h = textHeight + 10;
    r1.x += (_r.w - r1.w) / 2;
    _rect[buttonIndex] = r1;
    
    char *palette = "b #000000\n. #ffffff\n";
    id textColor = @"#000000";

    if (_buttonType[buttonIndex] == 'b') {
        if ((_buttonDown-1 == buttonIndex) && (_buttonDown == _buttonHover)) {
            palette = "b #000000\n. #0000ff\n";
            textColor = @"#ffffff";
        } else if (!_buttonDown && (_buttonHover-1 == buttonIndex)) {
            palette = "b #000000\n. #000000\n";
            textColor = @"#ffffff";
        }
    }

    [Definitions drawInBitmap:_bitmap left:top_left middle:top_middle right:top_right x:r1.x y:r1.y w:r1.w palette:palette];
    for (int buttonY=r1.y+3; buttonY<r1.y+r1.h-3; buttonY++) {
        [Definitions drawInBitmap:_bitmap left:button_middle_left middle:button_middle_middle right:button_middle_right x:r1.x y:buttonY w:r1.w palette:palette];
    }
    [Definitions drawInBitmap:_bitmap left:bottom_left middle:bottom_middle right:bottom_right x:r1.x y:r1.y+r1.h-3 w:r1.w palette:palette];
    [_bitmap setColor:textColor];
    [_bitmap useChicagoFont];
    [_bitmap drawBitmapText:fittedText x:r1.x+10 y:r1.y+5];

    int chevronWidth = [_bitmap bitmapWidthForText:@">"];
    int chevronHeight = [_bitmap bitmapHeightForText:@">"];
    [_bitmap drawBitmapText:@">" x:r1.x+r1.w-10-chevronWidth y:r1.y+(r1.h-chevronHeight)/2];

    _cursorY += r1.h;
}

- (void)handleMouseDown:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];

    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonDown = i+1;
            return;
        }
    }
    _buttonDown = 0;
}
- (void)handleMouseMoved:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonHover = i+1;
            return;
        }
    }
    _buttonHover = 0;
}

- (void)handleMouseUp:(id)event
{
    if (_buttonDown == 0) {
        return;
    }
    if (_buttonDown == _buttonHover) {
        id line = [_buttons nth:_buttonDown-1];
        if ([line intValueForKey:@"allAlbums"]) {
            id obj = [Definitions AlbumListInterface];
            [obj pushToNavigationStack];
        } else {
            id artist = [line valueForKey:@"name"];
            id obj = nil;
            if ([artist length]) {
                obj = [Definitions AlbumListInterface:artist];
            } else {
                obj = [Definitions AlbumListInterface];
            }
            [obj pushToNavigationStack];
        }
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    int deltaY = [event intValueForKey:@"deltaY"];
    _scrollY -= deltaY;
}
@end

