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

@implementation Definitions(fjkdsljfkldsjlkfsdjf)

+ (void)drawStripedBackgroundInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColorIntR:205 g:212 b:222 a:255];
    [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:r.h];
    [bitmap setColorIntR:201 g:206 b:209 a:255];
    for (int i=6; i<r.w; i+=10) {
        [bitmap fillRectangleAtX:r.x+i y:r.y w:4 h:r.h];
    }
}

+ (Int4)centerRectX:(int)smX y:(int)smY w:(int)smW h:(int)smH inW:(int)lgW h:(int)lgH
{
    
    Int2 boundsSize;
    boundsSize.w = lgW;
    boundsSize.h = lgH;
    Int4 frameToCenter = [Definitions rectWithX:smX y:smY w:smW h:smH];
    
    if (frameToCenter.w < boundsSize.w) {
        frameToCenter.x = (boundsSize.w - frameToCenter.w) / 2;
    } else {
        frameToCenter.x = 0;
    }
    
    if (frameToCenter.h < boundsSize.h) {
        int diff = boundsSize.h - frameToCenter.h;
        frameToCenter.y = diff / 2;
    } else {
        frameToCenter.y = 0;
    }
    
    return frameToCenter;
}

+ (Int2)proportionalSizeForWidth:(int)w height:(int)h origWidth:(int)origw  origHeight:(int)origh
{
    int tmp_width = w;
    int tmp_height = ((((tmp_width * origh) / origw)+7)&~7);
    if(tmp_height > h)
    {
        tmp_height = h;
        tmp_width = ((((tmp_height * origw) / origh)+7)&~7);
    }
    Int2 size;
    size.w = tmp_width;
    size.h = tmp_height;
    return size;
}

+ (int)adjustedXForPct:(double)pct rect:(Int4)innerRect insideRect:(Int4)outerRect
{
    int val = outerRect.x+pct*(outerRect.w-innerRect.w);
    return val;
}
+ (int)adjustedYForPct:(double)pct rect:(Int4)innerRect insideRect:(Int4)outerRect
{
    int val = outerRect.y+pct*(outerRect.h-innerRect.h);
    return val;
}

+ (double)normalizedXForRect:(Int4)innerRect insideRect:(Int4)outerRect
{
    return (double)(innerRect.x - outerRect.x) / (double)(outerRect.w-innerRect.w);
}
+ (double)normalizedYForRect:(Int4)innerRect insideRect:(Int4)outerRect
{
    return (double)(innerRect.y - outerRect.y) / (double)(outerRect.h-innerRect.h);
}

+ (BOOL)isX:(int)x insideRect:(Int4)r
{
    if (x >= r.x) {
        if (x < r.x+r.w) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)isX:(int)x y:(int)y insideRect:(Int4)r
{
    if (x >= r.x) {
        if (x < r.x+r.w) {
            if (y >= r.y) {
                if (y < r.y+r.h) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
+ (BOOL)doesRect:(Int4)r1 intersectRect:(Int4)r2
{
    if (r2.x > r1.x+r1.w-1) {
        return NO;
    }
    if (r1.x > r2.x+r2.w-1) {
        return NO;
    }
    if (r1.y > r2.y+r2.h-1) {
        return NO;
    }
    if (r2.y > r1.y+r1.h-1) {
        return NO;
    }
    return YES;
}

+ (Int4)rectWithOffset:(Int4)r x:(int)x y:(int)y
{
    return [Definitions rectWithX:r.x+x y:r.y+y w:r.w h:r.h];
}

+ (Int4)rectWithPadding:(Int4)r w:(int)paddingWidth h:(int)paddingHeight
{
    Int4 result = r;
    result.x -= paddingWidth;
    result.y -= paddingHeight;
    result.w += paddingWidth*2;
    result.h += paddingHeight*2;
    return result;
}

+ (Int4)rectWithX:(int)x y:(int)y w:(int)w h:(int)h
{
    Int4 result = (Int4){
        x, y, w, h
    };
    return result;
}


+ (Int4)centerRect:(Int4)innerRect inRect:(Int4)outerRect
{
    return [Definitions rectWithX:outerRect.x+(outerRect.w-innerRect.w)/2
                            y:outerRect.y+(outerRect.h-innerRect.h)/2
                            w:innerRect.w
                            h:innerRect.h];
}

+ (id)fitBitmapString:(id)text width:(int)maxWidth
{
    return [Definitions fitBitmapString:text width:maxWidth widths:[Definitions arrayOfWidthsForChicagoFont]];
}
+ (id)fitBitmapString:(id)text width:(int)maxWidth widths:(int *)widths
{
    if (maxWidth <= 0) {
        return nil;
    }
    id results = @"";
    unsigned char *str = [text UTF8String];
    if (!str) {
        return nil;
    }
    int len = strlen(str);
    unsigned char *p = str;
    unsigned char *lineP = p;
    unsigned char *spaceP = NULL;
    int lineWidth = 0;
    while(*p) {
        if (*p == '\n') {
            if (p == lineP) {
                results = [results cat:@"\n"];
            } else {
                results = [results cat:nsfmt(@"%.*s\n", p - lineP, lineP)];
            }
            lineWidth = 0;
            p++;
            lineP = p;
            spaceP = NULL;
            continue;
        }
        if (*p == ' ') {
            spaceP = p;
        }
        int charWidth = widths[*p];
        if (lineWidth + charWidth < maxWidth) {
            if (!lineWidth) {
                lineWidth = charWidth;
            } else {
                lineWidth += 2 + charWidth;
            }
            p++;
            continue;
        }
        if (p == lineP) {
            return nil;
        }
        if (spaceP) {
            results = [results cat:nsfmt(@"%.*s\n", spaceP - lineP, lineP)];
            lineWidth = 0;
            lineP = spaceP+1;
            p = lineP;
            spaceP = NULL;
            continue;
        }
        results = [results cat:nsfmt(@"%.*s\n", p - lineP, lineP)];
        lineWidth = charWidth;
        lineP = p;
        spaceP = NULL;
        p++;
    }
    if (p != lineP) {
        results = [results cat:nsfmt(@"%.*s\n", p - lineP, lineP)];
    }
    return results;
}

+ (int)bitmapHeightForText:(id)text
{
    return [Definitions bitmapHeightForText:text heights:[Definitions arrayOfHeightsForChicagoFont]];
}
+ (int)bitmapHeightForText:(id)text heights:(int *)heights
{
    unsigned char *p = [text UTF8String];
    if (!p) {
        return 0;
    }
    int h = 0;
    int charHeight = heights['X'];
    BOOL lineHasChar = NO;
    while (*p) {
        if (*p == '\n') {
            h += charHeight;
            lineHasChar = NO;
        } else {
            lineHasChar = YES;
        }
        p++;
    }
    if (lineHasChar) {
        h += charHeight;
    }
    return h;
}
+ (int)bitmapWidthForText:(id)text
{
    return [Definitions bitmapWidthForText:text widths:[Definitions arrayOfWidthsForChicagoFont] xspacings:[Definitions arrayOfXSpacingsForChicagoFont]];
}
+ (int)bitmapWidthForText:(id)text widths:(int *)widths xspacings:(int *)xspacings
{
    if (!text) {
        return 0;
    }
    unsigned char *str = [text UTF8String];
    unsigned char *p = str;
    int maxLineWidth = 0;
    int lineWidth = 0;
    while (*p) {
        if (*p == '#') {
            if (p[1] == '{') {
                unsigned char *q = strchr(p+2, '}');
                id message = nsfmt(@"%.*s", q - p - 2, p+2);
                [self evaluateMessage:message];
                p = q+1;
                continue;
            }
        }

        if (*p == '\n') {
            if (lineWidth > maxLineWidth) {
                maxLineWidth = lineWidth;
            }
            lineWidth = 0;
        } else {
            int width = widths[*p];
            if (lineWidth) {
                lineWidth += xspacings[*p];
            }
            lineWidth += width;
        }
        p++;
    }
    if (lineWidth > maxLineWidth) {
        maxLineWidth = lineWidth;
    }
    return maxLineWidth;
}
+ (int)bitmapWidthForLineOfTextCString:(unsigned char *)str widths:(int *)widths xspacings:(int *)xspacings
{
    unsigned char *p = str;
    int maxLineWidth = 0;
    int lineWidth = 0;
    while (*p) {
        if (*p == '\n') {
            return lineWidth;
        } else {
            int width = widths[*p];
            if (lineWidth) {
                lineWidth += xspacings[*p];
            }
            lineWidth += width;
        }
        p++;
    }
    return lineWidth;
}

+ (int)widthForCString:(unsigned char *)str
{
    if (!str) {
        return 0;
    }
    unsigned char *p = strchr(str, '\n');
    if (!p) {
        return strlen(str);
    }
    return p - str;
}
+ (int)heightForCString:(unsigned char *)str
{
    if (!str) {
        return 0;
    }
    unsigned char *p = str;
    int numberOfLines = 0;
    int lineLength = 0;
    for (;;) {
        if (!*p) {
            break;
        }
        if (*p == '\n') {
            lineLength = 0;
            numberOfLines++;
        } else {
            lineLength++;
        }
        p++;
    }
    if (lineLength) {
        numberOfLines++;
    }
    return numberOfLines;
}
+ (void)drawInBitmap:(id)bitmap left:(unsigned char *)left palette:(unsigned char *)leftPalette middle:(unsigned char *)middle palette:(unsigned char *)middlePalette right:(unsigned char *)right palette:(unsigned char *)rightPalette x:(int)startX y:(int)startY w:(int)w
{
    int middleHeight = [Definitions heightForCString:middle];
    int leftWidth = [Definitions widthForCString:left];
    int middleWidth = [Definitions widthForCString:middle];
    int rightWidth = [Definitions widthForCString:right];

    [bitmap drawCString:left palette:leftPalette x:startX y:startY];

    if (middleWidth) {
        int x = leftWidth;
        for (x=leftWidth; x<w-rightWidth; x+=middleWidth) {
            [bitmap drawCString:middle palette:middlePalette x:startX+x y:startY];
        }
    }

    [bitmap drawCString:right palette:rightPalette x:startX+w-rightWidth y:startY];
}
+ (void)drawInBitmap:(id)bitmap left:(unsigned char *)left middle:(unsigned char *)middle right:(unsigned char *)right x:(int)startX y:(int)startY w:(int)w palette:(unsigned char *)palette
{
    int middleHeight = [Definitions heightForCString:middle];
    int leftWidth = [Definitions widthForCString:left];
    int middleWidth = [Definitions widthForCString:middle];
    int rightWidth = [Definitions widthForCString:right];

    [bitmap drawCString:left palette:palette x:startX y:startY];

    if (middleWidth) {
        int x = leftWidth;
        for (x=leftWidth; x<w-rightWidth; x+=middleWidth) {
            [bitmap drawCString:middle palette:palette x:startX+x y:startY];
        }
    }

    [bitmap drawCString:right palette:palette x:startX+w-rightWidth y:startY];
}

+ (void)drawInBitmap:(id)bitmap left:(unsigned char *)left middle:(unsigned char *)middle right:(unsigned char *)right centeredInRect:(Int4)r palette:(unsigned char *)palette
{
    int middleHeight = [Definitions heightForCString:middle];
    int leftWidth = [Definitions widthForCString:left];
    int middleWidth = [Definitions widthForCString:middle];
    int rightWidth = [Definitions widthForCString:right];
    Int4 centeredRect = [Definitions centerRect:[Definitions rectWithX:0 y:0 w:r.w-4.0 h:middleHeight] inRect:r];
    [bitmap drawCString:left palette:palette x:centeredRect.x y:centeredRect.y];

    if (middleWidth) {
        int x = leftWidth;
        for (x=leftWidth; x<centeredRect.w-rightWidth; x+=middleWidth) {
            [bitmap drawCString:middle palette:palette x:centeredRect.x+x y:centeredRect.y];
        }
    }

    [bitmap drawCString:right palette:palette x:centeredRect.x+centeredRect.w-rightWidth y:centeredRect.y];
}
+ (void)drawInBitmap:(id)bitmap top:(unsigned char *)top palette:(unsigned char *)topPalette middle:(unsigned char *)middle palette:(unsigned char *)middlePalette bottom:(unsigned char *)bottom palette:(unsigned char *)bottomPalette x:(int)startX y:(int)startY h:(int)h
{
    int heightForTop = [Definitions heightForCString:top];
    int heightForMiddle = [Definitions heightForCString:middle];
    int heightForBottom = [Definitions heightForCString:bottom];

    [bitmap drawCString:top palette:topPalette x:startX y:startY];
    for (int y=startY+heightForTop; y<startY+h-heightForBottom; y+=heightForMiddle) {
        [bitmap drawCString:middle palette:middlePalette x:startX y:y];
    }
    [bitmap drawCString:bottom palette:bottomPalette x:startX y:startY+h-heightForBottom];
}


+ (void)drawButtonInBitmap:(id)bitmap rect:(Int4)r palette:(unsigned char *)palette
{
    unsigned char *left = [Definitions cStringForBitmapButtonLeft];
    unsigned char *middle = [Definitions cStringForBitmapButtonMiddle];
    unsigned char *right = [Definitions cStringForBitmapButtonRight];

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}
+ (unsigned char *)cStringForBitmapButtonLeft
{
    return
"   b\n"
" bb.\n"
" b..\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
" b..\n"
" bb.\n"
"   b\n"
;
}
+ (unsigned char *)cStringForBitmapButtonMiddle
{
    return
"b\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
;
}
+ (unsigned char *)cStringForBitmapButtonRight
{
    return
"b   \n"
".bb \n"
"..b \n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"..b \n"
".bb \n"
"b   \n"
;
}
+ (void)drawDefaultButtonInBitmap:(id)bitmap rect:(Int4)r palette:(unsigned char *)palette
{
    id left = [Definitions cStringForBitmapDefaultButtonLeft];
    id middle = [Definitions cStringForBitmapDefaultButtonMiddle];
    id right = [Definitions cStringForBitmapDefaultButtonRight];

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}
+ (unsigned char *)cStringForBitmapDefaultButtonLeft
{
    return
"     bbb\n"
"   bbbbb\n"
"  bbbbbb\n"
" bbbbwww\n"
" bbbwwwb\n"
"bbbwwbb.\n"
"bbbwwb..\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwwb..\n"
"bbbwwbb.\n"
" bbbwwwb\n"
" bbbbwww\n"
"  bbbbbb\n"
"   bbbbb\n"
"     bbb\n"
;
}
+ (unsigned char *)cStringForBitmapDefaultButtonMiddle
{
    return
"b\n"
"b\n"
"b\n"
"w\n"
"b\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
"w\n"
"b\n"
"b\n"
"b\n"
;
}
+ (unsigned char *)cStringForBitmapDefaultButtonRight
{
    return
"bbb     \n"
"bbbbb   \n"
"bbbbbb  \n"
"wwwbbbb \n"
"bwwwbbb \n"
".bbwwbbb\n"
"..bwwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"..bwwbbb\n"
".bbwwbbb\n"
"bwwwbbb \n"
"wwwbbbb \n"
"bbbbbb  \n"
"bbbbb   \n"
"bbb     \n"
;
}

+ (void)drawAlertBorderInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    unsigned char *pixels = [bitmap pixelBytes];
    if (!pixels) {
        return;
    }
    int bitmapWidth = [bitmap bitmapWidth];
    int bitmapHeight = [bitmap bitmapHeight];
    int bitmapStride = [bitmap bitmapStride];
    for (int i=0; i<bitmapWidth; i++) {
        unsigned char *p = pixels + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=3; i<bitmapWidth-3; i++) {
        unsigned char *p = pixels + bitmapStride*3 + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapWidth-4; i++) {
        unsigned char *p = pixels + bitmapStride*4 + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

    for (int i=0; i<bitmapWidth; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=3; i<bitmapWidth-3; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1-3) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapWidth-4; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1-4) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

    for (int i=1; i<bitmapHeight-1; i++) {
        unsigned char *p = pixels + bitmapStride*i + 0;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=1; i<bitmapHeight-1; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapHeight-4; i++) {
        unsigned char *p = pixels + bitmapStride*i + 3*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapHeight-4; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1-3)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=5; i<bitmapHeight-5; i++) {
        unsigned char *p = pixels + bitmapStride*i + 4*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=5; i<bitmapHeight-5; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1-4)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

}

@end



