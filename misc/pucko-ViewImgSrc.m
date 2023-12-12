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


@implementation NSString(fjeklwfjkldsklfmsdklmf)
- (id)convertFileToBitmap
{
    if ([self fileExists]) {
        id output = [self dataFromFile];
        id cmd = nsarr();
        [cmd addObject:@"convert"];
        [cmd addObject:@"-"];
        [cmd addObject:@"ppm:-"];
        id data = [output pipeToCommandAndReturnOutput:cmd];
        return [data bitmapFromPPMP6];
    }

    return nil;
}

@end

@implementation Definitions(fenmkwlfmksdlmfklsdmfkljfkdsf)
+ (void)loadImgSrc:(id)node :(id)origURL
{
    id name = [node valueForKey:@"name"];
    if ([name isEqual:@"img"]) {
        id bitmap = [node valueForKey:@"bitmap"];
        if (bitmap) {
            goto end;
        }
        id attrs = [node valueForKey:@"attrs"];
        id src = [attrs valueForKey:@"src"];
        if (!src) {
            goto end;
        }
        id url = [src resolveURLWithURL:origURL];
        id filename = [url urlAsValidFilename];
        if (![filename fileExists]) {
            id output = [url downloadURLWithCurl];
            [output writeToFile:filename];
        }
        bitmap = [filename convertFileToBitmap];
NSLog(@"filename '%@' bitmap %@", filename, bitmap);
        if (bitmap) {
            [node setValue:bitmap forKey:@"bitmap"];
        }
    }

end:
    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [Definitions loadImgSrc:elt :origURL];
    }
}
@end




@implementation Definitions(fenmkwlfmksdlmfklsdmfkl)
+ (void)ViewImgSrc:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    [Definitions loadImgSrc:document :url];
    id object = [@"ViewImgSrc" asInstance];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
+ (void)ViewImgSrc
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    [Definitions loadImgSrc:document :nil];
    id object = [@"ViewImgSrc" asInstance];
    [object setValue:document forKey:@"document"];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
@end

@interface ViewImgSrc : IvarObject
{
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    id _document;
}
@end
@implementation ViewImgSrc
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];

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
            [self panelText:text];
        }
    }
    if ([name isEqual:@"img"]) {
        id src = [attrs valueForKey:@"src"];

        id bitmap = [node valueForKey:@"bitmap"];
        if (bitmap) {
            [_bitmap drawBitmap:bitmap x:_r.x y:_cursorY];
            _cursorY += [bitmap bitmapHeight];
        }


    }

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [self drawHTMLNode:elt];
    }
}

- (void)panelText:(id)text
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    int x = _r.x + 10;
    [_bitmap setColor:@"black"];
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}

- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
@end




