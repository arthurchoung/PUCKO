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

#include <stdio.h>
#include <errno.h>

#define MAX_RECT 500

@implementation Definitions(fmeklwmfklsdmklfmsdklfm)
+ (void)processAHref:(id)node :(id)href
{
    id type = [node valueForKey:@"type"];
    if ([type isEqual:@"Text"]) {
        [node setValue:href forKey:@"href"];
    }

    id name = [node valueForKey:@"name"];
    if ([name isEqual:@"img"]) {
        [node setValue:href forKey:@"href"];
    }

    if ([name isEqual:@"a"]) {
        id attrs = [node valueForKey:@"attrs"];
        href = [attrs valueForKey:@"href"];
    }

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [Definitions processAHref:elt :href];
    }
}
@end



@implementation Definitions(fenmkwlfmksdlmfklsdmfklfjdksfj)
+ (void)ViewAHref:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    [Definitions loadImgSrc:document :url];
    [Definitions processAHref:document :nil];
    id object = [@"ViewAHref" asInstance];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
@end

@interface ViewAHref : IvarObject
{
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    id _document;

    Int4 _rect[MAX_RECT];
    id _buttons;
    int _buttonDown;
    int _buttonHover;
}
@end
@implementation ViewAHref
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];

    [self setValue:nsarr() forKey:@"buttons"];

    _cursorY = -_scrollY + r.y;
    _r = r;


    [self setValue:bitmap forKey:@"bitmap"];

    [_bitmap setColor:@"black"];
    if (_document) {
        [self drawHTMLNode:_document];
    }

    [self setValue:nil forKey:@"bitmap"];

}

- (void)drawHTMLNode:(id)node
{
    id type = [node valueForKey:@"type"];
    id name = [node valueForKey:@"name"];
    id attrs = [node valueForKey:@"attrs"];
    if ([type isEqual:@"Text"]) {
        id text = [node valueForKey:@"text"];
        if (text) {
            id href = [node valueForKey:@"href"];
            [self panelText:text href:href];
        }
    }
    if ([name isEqual:@"img"]) {
        id src = [attrs valueForKey:@"src"];

        id bitmap = [node valueForKey:@"bitmap"];
        if (bitmap) {
            id href = [node valueForKey:@"href"];
            if (href) {
                int buttonIndex = [_buttons count];
                if (buttonIndex >= MAX_RECT) {
                    [_bitmap setColor:@"black"];
                    [_bitmap drawBitmapText:@"MAX_RECT reached" x:_r.x+10 y:_cursorY];
                    int textHeight = [_bitmap bitmapHeightForText:@"X"];
                    _cursorY += textHeight;
                    return;
                }
                Int4 r1;
                r1.x = _r.x;
                r1.y = _cursorY;
                r1.w = [bitmap bitmapWidth]+4;
                r1.h = [bitmap bitmapHeight]+4;
                _rect[buttonIndex] = r1;
                [_buttons addObject:href];
                [_bitmap drawBitmap:bitmap x:r1.x+2 y:r1.y+2];
                if (_buttonDown == buttonIndex+1) {
                    [_bitmap setColor:@"purple"];
                    [_bitmap drawRectangleAtX:r1.x+1 y:r1.y+1 w:r1.w-2 h:r1.h-2];
                    if (_buttonDown == _buttonHover) {
                        [_bitmap drawRectangle:r1];
                    }
                } else {
                    [_bitmap setColor:@"blue"];
                    [_bitmap drawRectangleAtX:r1.x+1 y:r1.y+1 w:r1.w-2 h:r1.h-2];
                    if (!_buttonDown && (_buttonHover == buttonIndex+1)) {
                        [_bitmap drawRectangle:r1];
                    }
                }
                _cursorY += r1.h;
            } else {
                [_bitmap drawBitmap:bitmap x:_r.x y:_cursorY];
                _cursorY += [bitmap bitmapHeight];
            }
        }


    }

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [self drawHTMLNode:elt];
    }
}

- (void)panelText:(id)text href:(id)href
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    if (href) {
        int buttonIndex = [_buttons count];
        if (buttonIndex >= MAX_RECT) {
            [_bitmap setColor:@"black"];
            [_bitmap drawBitmapText:@"MAX_RECT reached" x:_r.x+10 y:_cursorY];
            _cursorY += textHeight;
            return;
        }
        Int4 r1;
        r1.x = _r.x+10-4;
        r1.y = _cursorY;
        r1.w = textWidth+8;
        r1.h = textHeight+8;
        _rect[buttonIndex] = r1;
        [_buttons addObject:href];
        [_bitmap setColor:@"black"];
        [_bitmap drawBitmapText:text x:_r.x+10 y:_cursorY+4];
        if (_buttonDown == buttonIndex+1) {
            [_bitmap setColor:@"purple"];
            [_bitmap drawRectangleAtX:r1.x+1 y:r1.y+1 w:r1.w-2 h:r1.h-2];
            if (_buttonDown == _buttonHover) {
                [_bitmap drawRectangle:r1];
            }
        } else {
            [_bitmap setColor:@"blue"];
            [_bitmap drawRectangleAtX:r1.x+1 y:r1.y+1 w:r1.w-2 h:r1.h-2];
            if (!_buttonDown && (_buttonHover == buttonIndex+1)) {
                [_bitmap drawRectangle:r1];
            }
        }
        _cursorY += r1.h;
    } else {
        [_bitmap setColor:@"black"];
        [_bitmap drawBitmapText:text x:_r.x+10 y:_cursorY];
        _cursorY += textHeight;
    }
}

- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
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
        id href = [_buttons nth:_buttonDown-1];
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"showAlert:"];
        [cmd addObject:href];
        [cmd runCommandAndReturnOutput];
    }
    _buttonDown = 0;
}
@end




