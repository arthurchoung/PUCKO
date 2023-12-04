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

@implementation Definitions(fjklwemklfmksdlvijsodjfksdfj)
+ (id)scaleFont:(int)scaling :(unsigned char **)origFontCStrings :(int *)origFontWidths :(int *)origFontHeights :(int *)origFontXSpacings
{
    id results = nsarr();
    id fontCStrings = [[[NSData alloc] initWithCapacity:256*sizeof(unsigned char *)] autorelease];
    [results addObject:fontCStrings];
    id fontWidths = [[[NSData alloc] initWithCapacity:256*sizeof(int)] autorelease];
    [results addObject:fontWidths];
    id fontHeights = [[[NSData alloc] initWithCapacity:256*sizeof(int)] autorelease];
    [results addObject:fontHeights];
    id fontXSpacings = [[[NSData alloc] initWithCapacity:256*sizeof(int)] autorelease];
    [results addObject:fontXSpacings];
    {
        unsigned char **bytes = [fontCStrings bytes];
        for (int i=0; i<256; i++) {
            if (origFontCStrings[i]) {
                id pixels = [nsfmt(@"%s", origFontCStrings[i]) asXYScaledPixels:scaling];
                [results addObject:pixels];
                bytes[i] = [pixels UTF8String];
            } else {
                bytes[i] = "";
            }
        }
    }

    {
        int *bytes = [fontWidths bytes];
        for (int i=0; i<256; i++) {
            bytes[i] = origFontWidths[i]*scaling;
        }
    }

    {
        int *bytes = [fontHeights bytes];
        for (int i=0; i<256; i++) {
            bytes[i] = origFontHeights[i]*scaling;
        }
    }

    {
        int *bytes = [fontXSpacings bytes];
        for (int i=0; i<256; i++) {
            bytes[i] = origFontXSpacings[i]*scaling;
        }
    }
    return results;
}
@end


@implementation NSString(mfkewlmfklsdmklfmkdlsfmiewjfods)
- (id)asXScaledPixels:(int)scaling
{
    if (scaling <= 1) {
        return self;
    }

    char *str = [self UTF8String];
    int len = [self length];
    if (!len) {
        return @"";
    }
    int size = len*scaling+1;
    char *new = malloc(size);
    if (!new) {
NSLog(@"OUT OF MEMORY!!!");
exit(1);
    }
    memset(new, 0, size);
    char *src = str;
    char *dst = new;
    for(;;) {
        if (!*src) {
            *dst = 0;
            break;
        }
        if (*src == '\n') {
            *dst++ = *src;
        } else {
            for (int i=0; i<scaling; i++) {
                *dst++ = *src;
            }
        }
        src++;
    }
    return [[[NSString alloc] initWithBytesNoCopy:new length:len*scaling] autorelease];
}
- (id)asYScaledPixels:(int)scaling
{
    if (scaling <= 1) {
        return self;
    }

    id arr = [self split:@"\n"];
    id results = nsarr();
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        for (int j=0; j<scaling; j++) {
            [results addObject:elt];
        }
    }
    return [results join:@"\n"];
}
- (id)asXYScaledPixels:(int)scaling
{
    if (scaling <= 1) {
        return self;
    }

    id arr = [self split:@"\n"];
    id results = nsarr();
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        elt = [elt asXScaledPixels:scaling];
        for (int j=0; j<scaling; j++) {
            [results addObject:elt];
        }
    }
    return [results join:@"\n"];
}
@end

