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

static char *robotPalette =
". #ff0000\n"
"X #FF7600\n"
"o #00ff00\n"
"O #ffff00\n"
"+ #ffffff\n"
;

static char *robotPixels =
"          ...........          \n"
"          ...........          \n"
"          ...........          \n"
"          ...........          \n"
"       ooooooooooooooooo       \n"
"       ooooooooooooooooo       \n"
"       ooooooooooooooooo       \n"
"       XXXXXXXXXXXXXXXXX       \n"
"       XXXXXXXXXXXXXXXXX       \n"
"       XXXXXXXXXXXXXXXXX       \n"
"          ...........          \n"
"          ...........          \n"
"          ...........          \n"
".......+++...........+++.......\n"
".......+++...........+++.......\n"
".......+++...........+++.......\n"
"OOO.......+++++++++++.......OOO\n"
"OOO.......+++++++++++.......OOO\n"
"OOO.......+++++++++++.......OOO\n"
"OOO    .......+++.......    OOO\n"
"OOO    .......+++.......    OOO\n"
"OOO    .......+++.......    OOO\n"
"OOO    .......+++.......    OOO\n"
"OOO       ...........       OOO\n"
"OOO       ...........       OOO\n"
"OOO       ...........       OOO\n"
"          ...........          \n"
"          ...........          \n"
"          ...........          \n"
"       .......   .......       \n"
"       .......   .......       \n"
"       .......   .......       \n"
"       .......   .......       \n"
"       .......   .......       \n"
"       .......   .......       \n"
"   OOOOOOOOOOO   OOOOOOOOOOO   \n"
"   OOOOOOOOOOO   OOOOOOOOOOO   \n"
"   OOOOOOOOOOO   OOOOOOOOOOO   \n"
"   OOOOOOOOOOO   OOOOOOOOOOO   \n"
;

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

@implementation Definitions(fmekwlfmksdlfmklsdkfmfjdksjfkfjdksfjskfjdksfj)
+ (id)TrackListInterface
{
    return [Definitions TrackListInterface:nil];
}
+ (id)TrackListInterface:(id)album
{
    id obj = [@"TrackListInterface" asInstance];
    [obj setValue:album forKey:@"album"];
    [obj handleBackgroundUpdate:nil];
    return obj;
}
@end

@interface TrackListInterface : IvarObject
{
    time_t _timestamp;
    int _seconds;
    id _album;
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
@implementation TrackListInterface
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [@"." fileModificationTimestamp];
    if (timestamp == _timestamp) {
        _seconds++;
        return;
    }
    [self updateArray];
    _timestamp = [@"." fileModificationTimestamp];
    _seconds = 0;
}
- (void)updateArray
{
    if (!_album) {
        [self setValue:nsarr() forKey:@"array"];
        return;
    }

    id cmd = nsarr();
    [cmd addObject:@"pucko-music-listTracksForAlbum:.py"];
    [cmd addObject:_album];
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

        if (i == 0) {
            [self panelButtonHeader:elt];
        } else {
            [self panelButtonLine:elt alt:(i%2)];
        }
    }

    [self setValue:nil forKey:@"bitmap"];
}

- (void)panelButtonHeader:(id)line
{
    int photoWidth = 120;
    int photoHeight = 120;
    id photoBitmap = nil;

    id coverart = [line decodeBase64ForKey:@"coverart"];
    if (coverart) {
        photoBitmap = [coverart bitmapFromPPMP6];
        if (photoBitmap) {
            photoWidth = [photoBitmap bitmapWidth];
            photoHeight = [photoBitmap bitmapHeight];
        }
    }

    id text = [line valueForKey:@"name"];
    if (!text) {
        text = @"(no name)";
    }
    id detailText = [line valueForKey:@"detail"];
    if (!detailText) {
        detailText = @"";
    }

    [_bitmap useChicagoFont];
    id fittedText = [_bitmap fitBitmapString:text width:_r.w-40-photoWidth-10];
    [_bitmap useGenevaFont];
    id fittedDetailText = [_bitmap fitBitmapString:detailText width:_r.w-40-photoWidth-10];
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

    [_bitmap useGenevaFont];
    int detailTextWidth = [_bitmap bitmapWidthForText:fittedDetailText];
    int detailTextHeight = [_bitmap bitmapHeightForText:fittedDetailText];

    Int4 r1;
    r1.x = _r.x + photoWidth + 10;
    r1.y = _cursorY;
    r1.w = _r.w;
    r1.h = textHeight + 10;
    if (detailTextHeight) {
        r1.h += detailTextHeight + 2;
    }
    if ((photoHeight > 0) && (r1.h < photoHeight + 10)) {
        r1.h = photoHeight + 10;
    }
    r1.x += (_r.w - r1.w) / 2;
    _rect[buttonIndex] = r1;
    
    char *palette = "b #000000\n. #ffffff\n";
    id textColor = @"#000000";
    id detailTextColor = @"#404040";

    [_bitmap setColor:@"#e0e0e0"];
    [_bitmap fillRectangleAtX:_r.x y:_cursorY w:_r.w h:r1.h];

    [_bitmap setColor:textColor];
    [_bitmap useChicagoFont];
    [_bitmap drawBitmapText:fittedText x:r1.x+10 y:r1.y+5];
    if (detailTextHeight) {
        [_bitmap setColor:detailTextColor];
        [_bitmap useGenevaFont];
        [_bitmap drawBitmapText:fittedDetailText x:r1.x+10 y:r1.y+5+textHeight+2];
    }

    if ((photoWidth > 0) && (photoHeight > 0)) {
        Int4 photoRect;
        photoRect.x = _r.x+5;
        photoRect.y = _cursorY+5;
        photoRect.w = photoWidth;
        photoRect.h = photoHeight;
        if (photoBitmap) {
            [_bitmap drawBytes:[photoBitmap pixelBytes] bitmapWidth:[photoBitmap bitmapWidth] bitmapHeight:[photoBitmap bitmapHeight] x:photoRect.x y:photoRect.y];
        } else {
            [_bitmap setColor:@"black"];
            [_bitmap fillRect:photoRect];
            [_bitmap drawCString:robotPixels palette:robotPalette x:photoRect.x+(photoRect.w-31)/2 y:photoRect.y+(photoRect.h-39)/2];
        }
    }

    _cursorY += r1.h;
}
- (void)panelButtonLine:(id)line alt:(int)alt
{
    int trackWidth = 30;
    int durationWidth = 40;

    id text = [line valueForKey:@"name"];
    if (!text) {
        text = @"(no name)";
    }
    id trackText = [line valueForKey:@"track"];
    if (!trackText) {
        trackText = @"1";
    }
    id durationText = [line valueForKey:@"duration"];
    if (!durationText) {
        durationText = @"1:23";
    }

    [_bitmap useChicagoFont];
    id fittedText = [_bitmap fitBitmapString:text width:_r.w-20-trackWidth-durationWidth];
    id fittedTrackText = [_bitmap fitBitmapString:trackText width:trackWidth];
    [_bitmap useGenevaFont];
    id fittedDurationText = [_bitmap fitBitmapString:durationText width:durationWidth];
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

    int trackTextHeight = [_bitmap bitmapHeightForText:fittedTrackText];
    [_bitmap useGenevaFont];
    int durationTextWidth = [_bitmap bitmapWidthForText:fittedDurationText];
    int durationTextHeight = [_bitmap bitmapHeightForText:fittedDurationText];

    Int4 r1;
    r1.x = _r.x;
    r1.y = _cursorY;
    r1.w = _r.w;
    r1.h = textHeight + 10;
    if (trackTextHeight + 10 > r1.h) {
        r1.h = trackTextHeight + 10;
    }
    if (durationTextHeight + 10 > r1.h) {
        r1.h = durationTextHeight + 10;
    }
    _rect[buttonIndex] = r1;
    
    char *palette = "b #000000\n. #e0e0e0\n";
    if (alt) {
        palette = "b #000000\n. #ffffff\n";
    }
    id textColor = @"#000000";
    id durationTextColor = @"#404040";

    if (_buttonType[buttonIndex] == 'b') {
        if ((_buttonDown-1 == buttonIndex) && (_buttonDown == _buttonHover)) {
            palette = "b #000000\n. #0000ff\n";
            textColor = @"#ffffff";
            durationTextColor = @"#c0c0c0";
        } else if (!_buttonDown && (_buttonHover-1 == buttonIndex)) {
            palette = "b #000000\n. #000000\n";
            textColor = @"#ffffff";
            durationTextColor = @"#c0c0c0";
        }
    }

    [Definitions drawInBitmap:_bitmap left:top_middle middle:top_middle right:top_middle x:r1.x y:r1.y w:r1.w palette:palette];
    for (int buttonY=r1.y+3; buttonY<r1.y+r1.h-3; buttonY++) {
        [Definitions drawInBitmap:_bitmap left:button_middle_middle middle:button_middle_middle right:button_middle_middle x:r1.x y:buttonY w:r1.w palette:palette];
    }
    [Definitions drawInBitmap:_bitmap left:bottom_middle middle:bottom_middle right:bottom_middle x:r1.x y:r1.y+r1.h-3 w:r1.w palette:palette];
    [_bitmap setColor:textColor];
    [_bitmap useChicagoFont];
    [_bitmap drawBitmapText:fittedText x:r1.x+trackWidth+10 y:r1.y+(r1.h-textHeight)/2];
    [_bitmap drawBitmapText:fittedTrackText x:r1.x+10 y:r1.y+(r1.h-trackTextHeight)/2];

    [_bitmap setColor:durationTextColor];
    [_bitmap useGenevaFont];
    [_bitmap drawBitmapText:fittedDurationText x:r1.x+r1.w-durationWidth+10 y:r1.y+(r1.h-durationTextHeight)/2];

    [_bitmap setColor:@"black"];
    [_bitmap drawVerticalLineAtX:r1.x+trackWidth y:r1.y y:r1.y+r1.h-1];
    [_bitmap drawVerticalLineAtX:r1.x+r1.w-durationWidth y:r1.y y:r1.y+r1.h-1];

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
        id path = [line valueForKey:@"path"];
        if ([path length]) {
            id cmd = nsarr();
            [cmd addObject:@"pucko-music-open:.pl"];
            [cmd addObject:path];
            [cmd runCommandInBackground];
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

