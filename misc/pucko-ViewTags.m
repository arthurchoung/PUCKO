/*

 PUCKO Web

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Web.

 PUCKO Web is free software: you can redistribute it and/or modify
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

#define MAX_RECT 500

@implementation Definitions(fenmkwlfmksdlmfklsdmfklfjdksfjfjdksfjkdsfjdksjfksd)
+ (id)ViewTags:(id)url
{
    [Definitions downloadURL:url];
//    [Definitions downloadImagesForURL:url];
    id document = [Definitions loadURL:url];

    id object = [@"ViewTags" asInstance];
    [object setValue:url forKey:@"url"];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
@end

@interface ViewTags : IvarObject
{
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    id _url;
    id _document;

    Int4 _rect[MAX_RECT];
    id _buttons;
    id _buttonDown;
    id _buttonHover;
}
@end
@implementation ViewTags
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
        [self drawHTMLNode:_document x:r.x w:r.w];
    }

    [self setValue:nil forKey:@"bitmap"];

}

- (void)drawHTMLNode:(id)node x:(int)x w:(int)w
{
    id type = [node valueForKey:@"type"];
    id name = [node valueForKey:@"name"];
    id attrs = [node valueForKey:@"attrs"];

    if ([type isEqual:@"Text"]) {
        id text = [node valueForKey:@"text"];
        if (text) {
            text = [_bitmap fitBitmapString:text width:w-10];
            [_bitmap setColor:@"black"];
            [_bitmap drawBitmapText:text x:x y:_cursorY];
            int textHeight = [_bitmap bitmapHeightForText:text];
            _cursorY += textHeight;
        }
        return;
    }

    id buttonColor = @"black";
    if (_buttonDown == node) {
        if (_buttonHover == _buttonDown) {
            buttonColor = @"purple";
        } else {
            buttonColor = @"blue";
        }
    } else if (!_buttonDown && (_buttonHover == node)) {
        buttonColor = @"blue";
    } else {
        buttonColor = @"black";
    }
    [_bitmap setColor:buttonColor];
    [_bitmap fillRectangleAtX:x y:_cursorY w:w h:20];
    [_bitmap setColor:@"white"];
    [_bitmap drawBitmapText:nsfmt(@"%@", (name) ? name : type) x:x+5 y:_cursorY+4];
    int oldCursorY = _cursorY;
    _cursorY += 20;

    if ([name isEqual:@"img"]) {
        id src = [attrs valueForKey:@"src"];

        id bitmap = [node valueForKey:@"bitmap"];
        if (bitmap) {
            [_bitmap drawBitmap:bitmap x:x y:_cursorY];
            _cursorY += [bitmap bitmapHeight];
        }
    }

    if ([name isEqual:@"script"]) {
        goto end;
    }
    if ([name isEqual:@"style"]) {
        goto end;
    }


    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        _cursorY += 5;
        id elt = [children nth:i];
        [self drawHTMLNode:elt x:x+5 w:w-10];
    }

end:

    _cursorY += 5;

    [_bitmap setColor:buttonColor];
    [_bitmap drawVerticalLineAtX:x y:oldCursorY+20 y:_cursorY];
    [_bitmap drawVerticalLineAtX:x+w-1 y:oldCursorY+20 y:_cursorY];
    [_bitmap drawHorizontalLineAtX:x x:x+w-1 y:_cursorY];

    int buttonIndex = [_buttons count];
    if (buttonIndex >= MAX_RECT) {
        [_bitmap setColor:@"black"];
        [_bitmap drawBitmapText:@"MAX_RECT reached" x:x y:_cursorY];
        int textHeight = [_bitmap bitmapHeightForText:@"X"];
        _cursorY += textHeight;
        return;
    }

    Int4 r1;
    r1.x = x;
    r1.y = oldCursorY;
    r1.w = w;
    r1.h = _cursorY - oldCursorY;
    _rect[buttonIndex] = r1;
    [_buttons addObject:node];

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
            _buttonDown = [_buttons nth:i];
            return;
        }
    }
    _buttonDown = nil;
}
- (void)handleMouseMoved:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonHover = [_buttons nth:i];
            return;
        }
    }
    _buttonHover = nil;
}

- (void)handleMouseUp:(id)event
{
    if (!_buttonDown) {
        return;
    }
    if (_buttonDown == _buttonHover) {
        id name = [_buttonDown valueForKey:@"name"];
        if ([name isEqual:@"a"]) {
            id attrs = [_buttonDown valueForKey:@"attrs"];
            id href = [attrs valueForKey:@"href"];
            if (href) {
                href = [href resolveURLWithURL:_url];
                [Definitions downloadURL:href];
                [Definitions downloadImagesForURL:href];
                id document = [Definitions loadURL:href];
                if (document) {
                    [self setValue:href forKey:@"url"];
                    [self setValue:document forKey:@"document"];
                    _scrollY = 0;
                }
            }
        }
    }
    _buttonDown = nil;
}
- (void)handleKeyDown:(id)event
{
    id keyString = [event valueForKey:@"keyString"];
    if ([keyString isEqual:@"pageup"]) {
        _scrollY -= _r.h;
    } else if ([keyString isEqual:@"pagedown"]) {
        _scrollY += _r.h;
    }
}
- (void)handleRightMouseDown:(id)event
{
    if (_buttonHover) {
        id windowManager = [event valueForKey:@"windowManager"];
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        id attrs = [_buttonHover valueForKey:@"attrs"];
        id arr = nsarr();
        id dict = nsdict();
        [dict setValue:nsfmt(@"Tag: %@", [_buttonHover valueForKey:@"name"]) forKey:@"displayName"];
        [arr addObject:dict];
        id keys = [attrs allKeys];
        for (int i=0; i<[keys count]; i++) {
            id key = [keys nth:i];
            id dict = nsdict();
            [dict setValue:nsfmt(@"Attr: %@=%@", key, [attrs valueForKey:key]) forKey:@"displayName"];
            [arr addObject:dict];
        }

        keys = [_buttonHover allKeys];
        for (int i=0; i<[keys count]; i++) {
            id key = [keys nth:i];
            if ([key hasPrefix:@"css"]) {
                id dict = nsdict();
                [dict setValue:nsfmt(@"%@: %@", key, [_buttonHover valueForKey:key]) forKey:@"displayName"];
                [arr addObject:dict];
            }
        }

        id obj = [arr asMenu];
        [obj setValue:self forKey:@"contextualObject"];

        if (obj) {
            [windowManager openButtonDownMenuForObject:obj x:mouseRootX y:mouseRootY w:0 h:0];
        }
    }
}
@end



