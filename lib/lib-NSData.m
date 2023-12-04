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

@implementation NSData(fiewojfidsojfkdsjfkdsj)
- (id)blocksFromData
{
    id results = nsarr();
    id dict = nsdict();
    for(;;) {
        id line = [self readLine];
        if (!line) {
            break;
        }
        int len = [line length];
        if (!len) {
            // empty line
            if ([dict count]) {
                [results addObject:dict];
                dict = nsdict();
            }
        } else {
            char *buf = [line UTF8String];
            char *p = strchr(buf, ':');
            if (p) {
                *p = 0;
                p++;
                [dict setValue:nsfmt(@"%s", p) forKey:nsfmt(@"%s", buf)];
            }
        }
    }
    if ([dict count]) {
        [results addObject:dict];
    }
    return results;
}

- (id)asStringOfByteValues
{
    id results = nsarr();
    unsigned char *bytes = [self bytes];
    for (int i=0; i<[self length]; i++) {
        [results addObject:nsfmt(@"%d\n", bytes[i])];
    }
    return [results join:@""];
}

- (id)description
{
    return nsfmt(@"<NSData: %d bytes>", [self length]);
}

- (const unsigned char) byteAtIndex:(int) i
{
    const unsigned char buffer[2];
    [self getBytes:(void *)&buffer location:i length:1];
    return buffer[0];
}
- (int32_t)int32AtIndex:(int)i
{
    uint8_t buffer[4];
    [self getBytes:(void *)&buffer location:i length:4];
    return buffer[0]*256*256*256 + buffer[1]*256*256 + buffer[2]*256 + buffer[3];
}


- (id)asString
{
    return [[[NSString alloc] initWithBytes:[self bytes] length:[self length]] autorelease];
}

- (id)readGroupOfLines
{
    id data = self;
    int len = [data length];
    if (!len) {
        return nil;
    }
    char *bytes = [data bytes];
    char *cursor = bytes;
    char *p = NULL;

    for (;;) {
        if (len-(cursor-bytes) <= 0) {
            return nil;
        }
        p = memchr(cursor, '\n', len-(cursor-bytes));
        if (!p) {
            return nil;
        }
        if (p == cursor) {
            break;
        }
        cursor = p+1;
    }


    id result;
    if (p == bytes) {
        result = @"";
    } else {
        result = nscstrn(bytes, p-bytes);
    }
    [data deleteBytesFromIndex:0 length:p-bytes+1];
    return result;
}
- (id)readLine
{
    id data = self;
    int len = [data length];
    if (!len) {
        return nil;
    }
    char *bytes = [data bytes];
    char *p = memchr(bytes, '\n', len);
    if (!p) {
        return nil;
    }
    id result;
    if (p == bytes) {
        result = @"";
    } else {
        result = nscstrn(bytes, p-bytes);
    }
    [data deleteBytesFromIndex:0 length:p-bytes+1];
    return result;
}
- (id)bitmapFromPPMP6
{
    id data = self;
    unsigned char *start = [data bytes];
    int len = [data length];
    unsigned char *end = start + len;

    unsigned char *p = start;
    unsigned char *q = start;

    int newline = 0;
    unsigned char *comment = 0;
    int values[3];
    values[0] = 0;
    values[1] = 0;
    values[2] = 0;
    int index = 0;
    for(;;) {
        if (q >= end) {
NSLog(@"premature end");
            return nil;
        }
        if (comment) {
            if (*q == '\n') {
NSLog(@"comment '%.*s'", q-comment, comment);
                comment = 0;
                p = q+1;
            }
        } else if (newline && (*q == '#')) {
            comment = q;
        } else if ((*q == ' ') || (*q == '\t') || (*q == '\r') || (*q == '\n')) {
            if (q == p) {
                p = q+1;
            } else {
                if (p == start) {
                    if ((q - p == 2) && (p[0] == 'P') && (p[1] == '6')) {
                        p = q+1;
                    } else {
NSLog(@"no magic (P6)");
                        return nil;
                    }
                } else {
                    values[index] = strtol(p, 0, 10);
NSLog(@"index %d val '%d'", index, values[index]);
                    index++;
                    p = q+1;
                    if (index == 3) {
NSLog(@"bytes remaining %d", end-p);
                        break;
                    }
                }
            }
        }
        if (*q == '\n') {
            newline = 1;
        } else {
            newline = 0;
        }
        q++;
    }

    int w = values[0];
    int h = values[1];
    int maxval = values[2];

    if (maxval == 255) {
        if ((w*h*3) == end-p) {
        } else {
NSLog(@"invalid length end-p %d w %d h %d", end-p, w, h);
            return nil;
        }
        id bitmap = [Definitions bitmapWithWidth:w height:h];
        unsigned char *pixels = [bitmap pixelBytes];
        for (int y=0; y<h; y++) {
            for (int x=0; x<w; x++) {
                pixels[0] = p[2];
                pixels[1] = p[1];
                pixels[2] = p[0];
                pixels[3] = 255;
                pixels += 4;
                p += 3;
            }
        }
        return bitmap;
    } else if (maxval == 65535) {
        if ((w*h*6) == end-p) {
        } else {
NSLog(@"invalid length");
            return nil;
        }
        id bitmap = [Definitions bitmapWithWidth:w height:h];
        unsigned char *pixels = [bitmap pixelBytes];
        for (int y=0; y<h; y++) {
            for (int x=0; x<w; x++) {
                pixels[0] = p[4];
                pixels[1] = p[2];
                pixels[2] = p[0];
                pixels[3] = 255;
                pixels += 4;
                p += 6;
            }
        }
        return bitmap;
    } else {
NSLog(@"unsupported maxval %d", maxval);
        return nil;
    }
}
@end




