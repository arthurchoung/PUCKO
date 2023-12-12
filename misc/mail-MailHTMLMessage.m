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

@implementation Definitions(mnfklewnfklsdjklfjskdlfjfjdksjfksd)
+ (id)MailHTMLMessageHeaders:(id)headers plain:(id)plain html:(id)html :(id)arr
{
    id obj = [@"MailHTMLMessage" asInstance];

    id mimeTypes = nsarr();
    for (int i=0; i<[arr count]; i++) {
        [mimeTypes addObject:nsfmt(@"%@", [[arr nth:i] valueForKey:@"mimeType"])];
    };
    [obj setValue:mimeTypes forKey:@"mimeTypes"];

    [obj setValue:headers forKey:@"headers"];
    [obj setValue:arr forKey:@"array"];

    [obj setValue:html forKey:@"htmlText"];
    [obj setValue:plain forKey:@"plainText"];

    id document = [html parseHTML];
    [Definitions processAHref:document :nil];
    [Definitions loadImgSrc:document :nil];
    [document processInternalCSS];
    [document processInlineCSS];

    id viewHTMLTable = [@"ViewHTMLTable" asInstance];
    [viewHTMLTable setValue:document forKey:@"document"];

    [obj setValue:viewHTMLTable forKey:@"viewHTMLTable"];

    return obj;
}
@end

@interface MailHTMLMessage : IvarObject
{
    id _plainText;
    id _htmlText;

    id _headers;
    id _array;
    int _headersHeight;
    int _partsHeight;
    id _mimeTypes;
    int _scrollY;

    Int4 _viewHTMLRect;
    id _viewHTMLTable;
}
@end

@implementation MailHTMLMessage

- (void)handleTouchesBegan:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseDown:event];
}
- (void)handleTouchesEnded:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseUp:event];
}
- (void)handleTouchesMoved:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseMoved:event];
}
- (void)handleTouchesCancelled:(id)event
{
    [self handleTouchesEnded:event];
}


- (void)handleScrollTouch:(id)event
{
    [self handleScrollWheel:event];
}

- (void)handleScrollWheel:(id)event
{
    if (_viewHTMLTable) {
        if ([_viewHTMLTable respondsToSelector:@selector(handleScrollWheel:)]) {
            [_viewHTMLTable handleScrollWheel:event];
        }
    }
}

- (void)handleRightMouseDown:(id)event
{
    if (_viewHTMLTable) {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_viewHTMLRect]) {
            if ([_viewHTMLTable respondsToSelector:@selector(handleRightMouseDown:)]) {
                [_viewHTMLTable handleRightMouseDown:event];
            }
            return;
        }
    }

    id arr = nsarr();
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id path = [elt valueForKey:@"path"];
        id part = [elt valueForKey:@"part"];
        id mimeType = [elt valueForKey:@"mimeType"];
        id dict = nsdict();
        [dict setValue:nsfmt(@"%@. %@", part, mimeType) forKey:@"displayName"];
        [dict setValue:path forKey:@"path"];
        [dict setValue:part forKey:@"part"];
        [dict setValue:mimeType forKey:@"mimeType"];
        [dict setValue:@"NSArray|addObject:'pucko-mail-openPart.pl'|addObject:(path)|addObject:(part)|addObject:(mimeType)|runCommandInBackground" forKey:@"messageForClick"];
        [arr addObject:dict];
    }

    id windowManager = [event valueForKey:@"windowManager"];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];

    id obj = [arr asMenu];
    [windowManager openButtonDownMenuForObject:obj x:mouseRootX y:mouseRootY w:0 h:0];
}
- (void)handleMouseUp:(id)event
{
}

- (void)handleMouseMoved:(id)event
{
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];

    [bitmap useWinSystemFont];
    id headersText = nil;
    if (_headers) {
        headersText = [bitmap fitBitmapString:_headers width:r.w-8];
        _headersHeight = [bitmap bitmapHeightForText:headersText]+8;
    } else {
        _headersHeight = 0;
    }
    id partsText = nil;
    if (_array) {
        partsText = nsfmt(@"Parts: %d (%@)", [_array count], [_mimeTypes join:@", "]);
        partsText = [bitmap fitBitmapString:partsText width:r.w-8];
        _partsHeight = [bitmap bitmapHeightForText:partsText]+8;
    } else {
        _partsHeight = 0;
    }

    if (_viewHTMLTable) {
        _viewHTMLRect = r;
        _viewHTMLRect.y += _headersHeight;
        _viewHTMLRect.h -= _headersHeight;
        _viewHTMLRect.h -= _partsHeight;
        [_viewHTMLTable drawInBitmap:bitmap rect:_viewHTMLRect];
        [bitmap useWinSystemFont];
    } else if (_plainText) {
        [bitmap setColor:@"black"];
        id text = [bitmap fitBitmapString:_plainText width:r.w-8];
        [bitmap drawBitmapText:text x:r.x+4 y:r.y+_headersHeight+4+_scrollY];
    }


    if (headersText) {
        [bitmap setColor:@"white"];
        [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:_headersHeight];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:headersText x:4 y:r.y+4];
        [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w y:r.y+_headersHeight-1];
    }
    if (partsText) {
        [bitmap setColor:@"white"];
        [bitmap fillRectangleAtX:r.x y:r.y+r.h-_partsHeight w:r.w h:_partsHeight];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:partsText x:4 y:r.y+r.h-_partsHeight+4];
        [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w y:r.y+r.h-_partsHeight];
    }

}

@end

