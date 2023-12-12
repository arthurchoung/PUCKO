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

#define MAX_RECT 2000

@implementation Definitions(mfkelwmfklsdmfklsdmklfmklsdfmklsdfmjfdksjfkjfdksjfksd)
+ (void)ViewHTMLTable
{
    id url = nil;
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    [Definitions processAHref:document :nil];
    [Definitions loadImgSrc:document :nil];
    [document processExternalCSS:url];
    [document processInternalCSS];
    [document processInlineCSS];

    id object = [@"ViewHTMLTable" asInstance];
    [object setValue:url forKey:@"url"];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
+ (void)ViewHTMLTable:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    [Definitions processAHref:document :nil];
    [Definitions loadImgSrc:document :url];
    [document processExternalCSS:url];
    [document processInternalCSS];
    [document processInlineCSS];

    id object = [@"ViewHTMLTable" asInstance];
    [object setValue:url forKey:@"url"];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
@end
@interface ViewHTMLTable : IvarObject
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

    int _nodeWidth;

    int _showTagBorders;
}
@end
@implementation ViewHTMLTable
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

- (void)drawChildren:(id)node x:(int)x w:(int)w
{
    int padding = 0;
    if (_showTagBorders) {
        padding = 5;
    }

    int origCursorY = _cursorY;
    int highestCursorY = origCursorY;
    int cursorX = 0;
    int highestCursorX = 0;

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        id type = [elt valueForKey:@"type"];
        id name = [elt valueForKey:@"name"];

        if ([type isEqual:@"Comment"]) {
            continue;
        }

        _cursorY = origCursorY+padding;
        _nodeWidth = 0;

        int newline = 0;
        if ([name isEqual:@"p"]) {
            newline = 1;
        }
        if (newline) {
            cursorX = 0;
            _cursorY = highestCursorY+padding;
            origCursorY = _cursorY;
        }

        if (cursorX > 0) {
            cursorX += padding;
        }
        [self drawHTMLNode:elt x:x+cursorX w:w-cursorX];
        if (_cursorY > highestCursorY) {
            highestCursorY = _cursorY;
        }
        cursorX += _nodeWidth;
        if (cursorX > highestCursorX) {
            highestCursorX = cursorX;
        }

        newline = 0;
        if ([name isEqual:@"html"]) {
            newline = 1;
        } else if ([name isEqual:@"head"]) {
            newline = 1;
        } else if ([name isEqual:@"meta"]) {
            newline = 1;
        } else if ([name isEqual:@"link"]) {
            newline = 1;
        } else if ([name isEqual:@"style"]) {
            newline = 1;
        } else if ([name isEqual:@"title"]) {
            newline = 1;
        } else if ([name isEqual:@"body"]) {
            newline = 1;
        } else if ([name isEqual:@"div"]) {
            newline = 1;
        } else if ([name isEqual:@"table"]) {
            newline = 1;
        } else if ([name isEqual:@"tr"]) {
            newline = 1;
        } else if ([name isEqual:@"br"]) {
            newline = 1;
        } else if ([type isEqual:@"Comment"]) {
            newline = 1;
        }
        if (newline) {
            cursorX = 0;
            _cursorY = highestCursorY;
            origCursorY = _cursorY;
        }
    }
    _cursorY = highestCursorY;
    _nodeWidth = highestCursorX;
}



- (void)drawHTMLNode:(id)node x:(int)x w:(int)w
{
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

    int padding = 0;
    if (_showTagBorders) {
        padding = 5;
    }

    id type = [node valueForKey:@"type"];
    id name = [node valueForKey:@"name"];
    id attrs = [node valueForKey:@"attrs"];

    if (!_showTagBorders) {
        if ([name isEqual:@"head"]) {
            return;
        }
    }

    int oldCursorY = _cursorY;
    if (_showTagBorders) {
        _cursorY += 20;
    }

    if ([type isEqual:@"Text"]) {
        id text = [node valueForKey:@"text"];
        if (text) {
            unsigned char *p = [text UTF8String];
            for(;;) {
                if (!*p) {
                    break;
                }
                if (*p == 0xa0) {
                    *p = ' ';
                }
                p++;
            }
            text = [_bitmap fitBitmapString:text width:w-10];
            if ([node valueForKey:@"href"]) {
                [_bitmap setColor:buttonColor];
            } else {
                [_bitmap setColor:@"black"];
            }
            [_bitmap drawBitmapText:text x:x+5 y:_cursorY+5];
            int textWidth = [_bitmap bitmapWidthForText:text];
            int textHeight = [_bitmap bitmapHeightForText:text];
            _cursorY += textHeight+5;
            if (textWidth+10 > _nodeWidth) {
                _nodeWidth = textWidth+10;
            }
        }
        goto end;
    }

    if ([name isEqual:@"img"]) {
        id src = [attrs valueForKey:@"src"];

        id widthAttr = [attrs valueForKey:@"width"];

        id bitmap = [node valueForKey:@"bitmap"];
        if (bitmap) {
            _cursorY += 5;

            int renderWidth = [bitmap bitmapWidth];
            int renderHeight = [bitmap bitmapHeight];
            if (widthAttr && ([widthAttr intValue] > 0)) {
                double resizeRatio = (double)[widthAttr intValue] / (double)renderWidth;
                renderWidth = [widthAttr intValue];
                renderHeight = (int)((double)renderHeight * resizeRatio);
                [_bitmap drawBitmap:bitmap x:x+5 y:_cursorY w:renderWidth h:renderHeight];
            } else {
                [_bitmap drawBitmap:bitmap x:x+5 y:_cursorY];
            }
            _cursorY += renderHeight;
            if (renderWidth+10 > _nodeWidth) {
                _nodeWidth = renderWidth+10;
            }
        }
        goto end;
    }

    if ([name isEqual:@"script"]) {
        goto end;
    }
    if ([name isEqual:@"style"]) {
        goto end;
    }

    if ([name isEqual:@"td"] || [name isEqual:@"table"]) {
        id widthValue = [attrs valueForKey:@"width"];
        if (widthValue) {
            if ([widthValue containsString:@"%"]) {
            } else {
                int width = [widthValue intValue];
                if (width) {
                    w = width;
                }
            }
        }

        id bgcolorValue = [attrs valueForKey:@"bgcolor"];
        if (bgcolorValue) {
            id color = [bgcolorValue asColor];
            if (color) {
                int renderWidth = [node intValueForKey:@"renderWidth"];
                int renderHeight = [node intValueForKey:@"renderHeight"];
                if (renderWidth && renderHeight) {
                    [_bitmap setColor:color];
                    [_bitmap fillRectangleAtX:x y:_cursorY w:renderWidth h:renderHeight];
                }
            }
        }
    }

    [self drawChildren:node x:x+padding w:w-padding-padding];

end:

    int buttonIndex = [_buttons count];
    if (buttonIndex >= MAX_RECT) {
        [_bitmap setColor:@"black"];
        [_bitmap drawBitmapText:@"MAX_RECT reached" x:x y:_cursorY];
        int textHeight = [_bitmap bitmapHeightForText:@"X"];
        _cursorY += textHeight;
        return;
    }

    id text = nil;
    if (_showTagBorders) {
        _cursorY += padding;
        _nodeWidth += padding+padding;
        text = nsfmt(@"%@", (name) ? name : type);
        if ([name isEqual:@"td"]) {
            id width = [attrs valueForKey:@"width"];
            if (width) {
                text = nsfmt(@"%@ width:%@", text, width);
            }
        }
        int textWidth = [_bitmap bitmapWidthForText:text];
        if (textWidth + 10 > _nodeWidth) {
            _nodeWidth = textWidth + 10;
        }
    }
    Int4 r1;
    r1.x = x;
    r1.y = oldCursorY;
    r1.w = _nodeWidth;
    r1.h = _cursorY - oldCursorY;
    _rect[buttonIndex] = r1;
    [_buttons addObject:node];

    if (_showTagBorders) {
        [_bitmap setColor:buttonColor];
        [_bitmap fillRectangleAtX:r1.x y:r1.y w:r1.w h:20];
        [_bitmap setColor:@"white"];
        [_bitmap drawBitmapText:text x:r1.x+5 y:r1.y+4];

        [_bitmap setColor:buttonColor];
        [_bitmap drawVerticalLineAtX:r1.x y:r1.y+20 y:_cursorY];
        [_bitmap drawVerticalLineAtX:r1.x+r1.w-1 y:r1.y+20 y:_cursorY];
        [_bitmap drawHorizontalLineAtX:r1.x x:r1.x+r1.w-1 y:_cursorY];
    }

    if (_showTagBorders) {
        [node setValue:nsfmt(@"%d", r1.w) forKey:@"renderWidth"];
        [node setValue:nsfmt(@"%d", r1.h-20) forKey:@"renderHeight"];
    } else {
        [node setValue:nsfmt(@"%d", r1.w) forKey:@"renderWidth"];
        [node setValue:nsfmt(@"%d", r1.h) forKey:@"renderHeight"];
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
        id href = [_buttonDown valueForKey:@"href"];
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
        [dict setValue:@"Toggle Tag Borders" forKey:@"displayName"];
        [dict setValue:@"toggleBoolKey:'showTagBorders'" forKey:@"messageForClick"];
        [arr addObject:dict];
        dict = nsdict();
        [dict setValue:@"" forKey:@"displayName"];
        [arr addObject:dict];
        dict = nsdict();
        [dict setValue:nsfmt(@"Type: %@", [_buttonHover valueForKey:@"type"]) forKey:@"displayName"];
        [arr addObject:dict];
        dict = nsdict();
        [dict setValue:nsfmt(@"Tag: %@", [_buttonHover valueForKey:@"name"]) forKey:@"displayName"];
        [arr addObject:dict];
        id keys = [attrs allKeys];
        for (int i=0; i<[keys count]; i++) {
            id key = [keys nth:i];
            dict = nsdict();
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



