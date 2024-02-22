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

static void drawStripedBackgroundInBitmap_rect_(id bitmap, Int4 r)
{
    [bitmap setColorIntR:205 g:212 b:222 a:255];
    [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:r.h];
    [bitmap setColorIntR:201 g:206 b:209 a:255];
    for (int i=6; i<r.w; i+=10) {
        [bitmap fillRectangleAtX:r.x+i y:r.y w:4 h:r.h];
    }
}

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


static unsigned char *button_top_left = 
"   b\n"
" bb.\n"
" b..\n"
;
static unsigned char *button_top_middle = 
"b\n"
".\n"
".\n"
;
static unsigned char *button_top_right = 
"b   \n"
".bb \n"
"..b \n"
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

static unsigned char *button_bottom_left =
" b..\n"
" bb.\n"
"   b\n"
;
static unsigned char *button_bottom_middle =
".\n"
".\n"
"b\n"
;
static unsigned char *button_bottom_right =
"..b \n"
".bb \n"
"b   \n"
;


@implementation Definitions(fmekwlfmksdlfmklsdkfmfjdksfjkls)
+ (id)ContactDetailInterface:(id)path
{
    id obj = [@"ContactDetailInterface" asInstance];
    [obj setValue:path forKey:@"path"];
    [obj handleBackgroundUpdate:nil];
    return obj;
}
@end

@interface ContactDetailInterface : IvarObject
{
    time_t _timestamp;
    int _seconds;
    id _path;
    id _line;
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
@implementation ContactDetailInterface
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [_path fileModificationTimestamp];
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
    [cmd addObject:@"pucko-contacts-printFile:.py"];
    [cmd addObject:_path];
    id output = [[[cmd runCommandAndReturnOutput] asString] find:@"\n" replace:@" "];
    if (output) {
        [self setValue:output forKey:@"line"];
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    drawStripedBackgroundInBitmap_rect_(bitmap, r);

    [self setValue:nsarr() forKey:@"buttons"];

    _cursorY = -_scrollY + r.y;
    _r = r;

    [self setValue:bitmap forKey:@"bitmap"];

/*
        if (_cursorY >= r.y + r.h) {
            break;
        }
        if ([_buttons count] >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }
*/

    [self panelPhoto:@"ABC" :[_line valueForKey:@"fullName"]];
    [self panelButton:@"full name" :[_line valueForKey:@"fullName"]];
    [self panelButton:@"company" :[_line valueForKey:@"company"]];
    [self panelButton:@"phone" :[_line valueForKey:@"phone"]];
    [self panelButton:@"address" :[_line valueForKey:@"address"]];


    [self setValue:nil forKey:@"bitmap"];
}

- (void)panelPhoto:(id)photo :(id)text
{
    int photoWidth = 82;
    int photoHeight = 82;
    id photoBitmap = nil;

    id photoData= [_line decodeBase64ForKey:@"photoData"];
    if (photoData) {
        photoBitmap = [photoData bitmapFromPPMP6];
        if (photoBitmap) {
            photoWidth = [photoBitmap bitmapWidth];
            photoWidth += 2;
            photoHeight = [photoBitmap bitmapHeight];
            photoHeight += 2;
        }
    }

    int leftWidth = (_r.w-40)/4;
    int rightWidth = ((_r.w-40)/4)*3;
    id fittedRightText = [_bitmap fitBitmapString:text width:rightWidth];
    _cursorY += 10;
    unsigned char *top_left = button_top_left;
    unsigned char *top_middle = button_top_middle;
    unsigned char *top_right = button_top_right;
    unsigned char *bottom_left = button_bottom_left;
    unsigned char *bottom_middle = button_bottom_middle;
    unsigned char *bottom_right = button_bottom_right;

    int textHeight = [_bitmap bitmapHeightForText:fittedRightText];

    Int4 r1;
    r1.x = _r.x;
    r1.y = _cursorY;
    r1.w = _r.w - 20;
    r1.h = textHeight + 20;
    r1.x += (_r.w - r1.w) / 2;
    
    char *palette = "b #000000\n. #000000\n";
    id textColor = @"#000000";

    Int4 photoRect;
    photoRect.x = _r.x+20;
    photoRect.y = _cursorY;
    photoRect.w = photoWidth;
    photoRect.h = photoHeight;
    photoRect.x += (leftWidth-20-photoRect.h)/2;
/*
    [_bitmap setColor:@"blue"];
    [_bitmap drawBitmapText:fittedLeftText rightAlignedAtX:r1.x+leftWidth-10 y:r1.y+10];
*/
    [_bitmap setColor:textColor];
    [_bitmap drawBitmapText:fittedRightText x:_r.x+10+leftWidth+10 y:_cursorY+(photoRect.h-textHeight)/2];

    if (photoBitmap) {
        [_bitmap drawBitmap:photoBitmap x:photoRect.x+1 y:photoRect.y+1];
        [_bitmap drawRectangle:photoRect];
    } else {
        [Definitions drawInBitmap:_bitmap left:top_left middle:top_middle right:top_right x:photoRect.x y:photoRect.y w:photoRect.w palette:palette];
        for (int buttonY=photoRect.y+3; buttonY<photoRect.y+photoRect.h-3; buttonY++) {
            [Definitions drawInBitmap:_bitmap left:button_middle_left middle:button_middle_middle right:button_middle_right x:photoRect.x y:buttonY w:photoRect.w palette:palette];
        }
        [Definitions drawInBitmap:_bitmap left:bottom_left middle:bottom_middle right:bottom_right x:photoRect.x y:photoRect.y+photoRect.h-3 w:photoRect.w palette:palette];
        [_bitmap drawCString:robotPixels palette:robotPalette x:photoRect.x+(photoRect.w-31)/2 y:photoRect.y+(photoRect.h-39)/2];
    }

    _cursorY += photoRect.h;
}


- (void)panelButton:(id)leftText :(id)rightText
{
    int leftWidth = (_r.w-40)/4;
    int rightWidth = ((_r.w-40)/4)*3;
    id fittedLeftText = [_bitmap fitBitmapString:leftText width:leftWidth-20];
    id fittedRightText = [_bitmap fitBitmapString:rightText width:rightWidth];
    _cursorY += 10;
    unsigned char *top_left = button_top_left;
    unsigned char *top_middle = button_top_middle;
    unsigned char *top_right = button_top_right;
    unsigned char *bottom_left = button_bottom_left;
    unsigned char *bottom_middle = button_bottom_middle;
    unsigned char *bottom_right = button_bottom_right;

    int buttonIndex = [_buttons count];
    [_buttons addObject:leftText];
    _buttonType[buttonIndex] = 'b';

    int leftTextHeight = [_bitmap bitmapHeightForText:fittedLeftText];
    int rightTextHeight = [_bitmap bitmapHeightForText:fittedRightText];
    int textHeight = leftTextHeight;
    if (rightTextHeight > textHeight) {
        textHeight = rightTextHeight;
    }

    Int4 r1;
    r1.x = _r.x;
    r1.y = _cursorY;
    r1.w = _r.w - 20;
    r1.h = textHeight + 20;
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
    [_bitmap setColor:@"blue"];
    [_bitmap drawBitmapText:fittedLeftText rightAlignedAtX:r1.x+leftWidth-10 y:r1.y+10];
    [_bitmap setColor:textColor];
    [_bitmap drawBitmapText:fittedRightText x:r1.x+leftWidth+10 y:r1.y+10];

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
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    int deltaY = [event intValueForKey:@"deltaY"];
    if (deltaY > 0) {
        _scrollY--;
    } else {
        _scrollY++;
    }
}
@end

