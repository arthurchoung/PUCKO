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

static int hexchartoint(char c)
{
    switch(c) {
        case '0': return 0;
        case '1': return 1;
        case '2': return 2;
        case '3': return 3;
        case '4': return 4;
        case '5': return 5;
        case '6': return 6;
        case '7': return 7;
        case '8': return 8;
        case '9': return 9;
        case 'A': case 'a': return 10;
        case 'B': case 'b': return 11;
        case 'C': case 'c': return 12;
        case 'D': case 'd': return 13;
        case 'E': case 'e': return 14;
        case 'F': case 'f': return 15;
    }
    return 0;
}


@interface Bitmap : IvarObject
{
    int _bitmapWidth;
    int _bitmapHeight;
    int _bitmapStride;
    unsigned char *_pixelBytes;
    int _r;
    int _g;
    int _b;
    int _a;
    double _alphaDouble;
    double _oneMinusAlphaDouble;
    int _redTimesAlpha;
    int _greenTimesAlpha;
    int _blueTimesAlpha;
    id _savedStates;
    unsigned char **_fontCStrings;
    int *_fontWidths;
    int *_fontHeights;
    int *_fontXSpacings;
    int _glNearest;
}
@end

@implementation Definitions(fjeiowmfklsjvojiewjfksdjksjkdjfks)
+ (id)bitmapWithWidth:(int)width height:(int)height
{
    id bitmap = [[[Bitmap alloc] initWithWidth:width height:height] autorelease];
    return bitmap;
    
}
@end


@implementation Bitmap

- (void)dealloc
{
    if (_pixelBytes) {
        free(_pixelBytes);
        _pixelBytes = NULL;
    }
    [super dealloc];
}

- (id)initWithWidth:(int)width height:(int)height
{
    self = [super init];
    if (self) {
        int size = width*height*4;
        _pixelBytes = malloc(size);
        if (!_pixelBytes) {
NSLog(@"Out of memory!");
            return nil;
        }
        memset(_pixelBytes, 0, size);
        _bitmapWidth = width;
        _bitmapHeight = height;
        _bitmapStride = width*4;

        [self useChicagoFont];

    }
    return self;
}

- (BOOL)glNearest
{
    if (_glNearest) {
        return YES;
    }
    return NO;
}

- (unsigned char *)pixelBytesRGBA8888
{
    return _pixelBytes;
}
- (unsigned char *)pixelBytes
{
    return _pixelBytes;
}

- (int)bitmapWidth
{
    return _bitmapWidth;
}
- (int)bitmapHeight
{
    return _bitmapHeight;
}
- (int)bitmapStride
{
    return _bitmapStride;
}

- (void)useFont:(unsigned char **)fontCStrings :(int *)fontWidths :(int *)fontHeights :(int *)fontXSpacings
{
    _fontCStrings = fontCStrings;
    _fontWidths = fontWidths;
    _fontHeights = fontHeights;
    _fontXSpacings = fontXSpacings;
}
- (void)useAtariSTFont
{
    _fontCStrings = [Definitions arrayOfCStringsForAtariSTFont];
    _fontWidths = [Definitions arrayOfWidthsForAtariSTFont];
    _fontHeights = [Definitions arrayOfHeightsForAtariSTFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForAtariSTFont];
}
- (void)useTopazFont
{
    _fontCStrings = [Definitions arrayOfCStringsForTopazFont];
    _fontWidths = [Definitions arrayOfWidthsForTopazFont];
    _fontHeights = [Definitions arrayOfHeightsForTopazFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForTopazFont];
}
- (void)useC64Font
{
    _fontCStrings = [Definitions arrayOfCStringsForC64Font];
    _fontWidths = [Definitions arrayOfWidthsForC64Font];
    _fontHeights = [Definitions arrayOfHeightsForC64Font];
    _fontXSpacings = [Definitions arrayOfXSpacingsForC64Font];
}
- (void)useChicagoFont
{
    _fontCStrings = [Definitions arrayOfCStringsForChicagoFont];
    _fontWidths = [Definitions arrayOfWidthsForChicagoFont];
    _fontHeights = [Definitions arrayOfHeightsForChicagoFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForChicagoFont];
}
- (void)useMonacoFont
{
    _fontCStrings = [Definitions arrayOfCStringsForMonacoFont];
    _fontWidths = [Definitions arrayOfWidthsForMonacoFont];
    _fontHeights = [Definitions arrayOfHeightsForMonacoFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForMonacoFont];
}
- (void)useGenevaFont
{
    _fontCStrings = [Definitions arrayOfCStringsForGenevaFont];
    _fontWidths = [Definitions arrayOfWidthsForGenevaFont];
    _fontHeights = [Definitions arrayOfHeightsForGenevaFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForGenevaFont];
}
- (void)useWinSystemFont
{
    _fontCStrings = [Definitions arrayOfCStringsForWinSystemFont];
    _fontWidths = [Definitions arrayOfWidthsForWinSystemFont];
    _fontHeights = [Definitions arrayOfHeightsForWinSystemFont];
    _fontXSpacings = [Definitions arrayOfXSpacingsForWinSystemFont];
}
- (void)setColorIntR:(int)r g:(int)g b:(int)b a:(int)a
{
    _r = r;
    _g = g;
    _b = b;
    _a = a;
    _alphaDouble = (double)a / 255.0;
    _oneMinusAlphaDouble = 1.0 - _alphaDouble;
    _redTimesAlpha = ((double)_r)*_alphaDouble;
    _greenTimesAlpha = ((double)_g)*_alphaDouble;
    _blueTimesAlpha = ((double)_b)*_alphaDouble;
}
- (void)setColorDoubleR:(double)r g:(double)g b:(double)b a:(double)a
{
    _r = r*255.0;
    _g = g*255.0;
    _b = b*255.0;
    _a = a*255.0;
    _alphaDouble = a;
    _oneMinusAlphaDouble = 1.0 - a;
    _redTimesAlpha = ((double)_r)*a;
    _greenTimesAlpha = ((double)_g)*a;
    _blueTimesAlpha = ((double)_b)*a;
}
- (void)setColor:(id)color
{
    color = [color asColor];
    _r = [color redInt];
    _g = [color greenInt];
    _b = [color blueInt];
    _a = [color alphaInt];
    _alphaDouble = ((double)_a) / 255.0;
    _oneMinusAlphaDouble = 1.0 - _alphaDouble;
    _redTimesAlpha = ((double)_r)*_alphaDouble;
    _greenTimesAlpha = ((double)_g)*_alphaDouble;
    _blueTimesAlpha = ((double)_b)*_alphaDouble;
}
- (void)setColor:(id)color alpha:(double)alpha
{
    color = [color asColor];
    _r = [color redInt];
    _g = [color greenInt];
    _b = [color blueInt];
    _a = alpha*255.0;
    _alphaDouble = alpha;
    _oneMinusAlphaDouble = 1.0 - alpha;
    _redTimesAlpha = ((double)_r)*alpha;
    _greenTimesAlpha = ((double)_g)*alpha;
    _blueTimesAlpha = ((double)_b)*alpha;
}
- (void)setColor:(id)color alphaInt:(int)alphaInt
{
    double alpha = ((double)alphaInt) / 255.0;
    color = [color asColor];
    _r = [color redInt];
    _g = [color greenInt];
    _b = [color blueInt];
    _a = alpha*255.0;
    _alphaDouble = alpha;
    _oneMinusAlphaDouble = 1.0 - alpha;
    _redTimesAlpha = ((double)_r)*alpha;
    _greenTimesAlpha = ((double)_g)*alpha;
    _blueTimesAlpha = ((double)_b)*alpha;
}
- (void)drawRectangle:(Int4)r
{
    [self drawRectangleAtX:r.x y:r.y w:r.w h:r.h];
}
- (void)drawRectangleAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawHorizontalLineAtX:x x:x+w-1 y:y];
    [self drawHorizontalLineAtX:x x:x+w-1 y:y+h-1];
    [self drawVerticalLineAtX:x y:y y:y+h-1];
    [self drawVerticalLineAtX:x+w-1 y:y y:y+h-1];
}
- (void)drawRectangleAtX:(int)x1 y:(int)y1 x:(int)x2 y:(int)y2
{
    [self drawHorizontalLineAtX:x1 x:x2 y:y1];
    [self drawHorizontalLineAtX:x1 x:x2 y:y2];
    [self drawVerticalLineAtX:x1 y:y1 y:y2];
    [self drawVerticalLineAtX:x2 y:y1 y:y2];
}

- (void)drawHLineAtX:(int)x1 x:(int)x2 y:(int)y
{
    [self drawHorizontalLineAtX:x1 x:x2 y:y];
}
- (void)drawHorizontalLineAtX:(int)x1 x:(int)x2 y:(int)y
{
    if ((y < 0) || (y >= _bitmapHeight)) {
        return;
    }

    if (x1 > x2) {
        int temp = x1;
        x1 = x2;
        x2 = temp;
    }
    if (x1 < 0) {
        x1 = 0;
    }
    if (x1 >= _bitmapWidth) {
        return;
    }
    if (x2 >= _bitmapWidth) {
        x2 = _bitmapWidth-1;
    }
    if (_a == 255) {
        unsigned char *p = _pixelBytes + _bitmapStride*y + (x1*4);
        for (int x=x1; x<=x2; x++) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
            p[0] = _b;
            p[1] = _g;
            p[2] = _r;
            p[3] = _a;
#else
            p[0] = _r;
            p[1] = _g;
            p[2] = _b;
            p[3] = _a;
#endif
            p += 4;
        }
    } else if (_a == 0) {
    } else {
        unsigned char *p = _pixelBytes + _bitmapStride*y + (x1*4);
        for (int x=x1; x<=x2; x++) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
            p[0] = _blueTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
            p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
            p[2] = _redTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
            p[3] = 255;
#else
            p[0] = _redTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
            p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
            p[2] = _blueTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
            p[3] = 255;
#endif
            p += 4;
        }
    }
}
- (void)drawHorizontalDashedLineAtX:(int)x1 x:(int)x2 y:(int)y dashLength:(int)dashLength
{
    if ((y < 0) || (y >= _bitmapHeight)) {
        return;
    }

    if (x1 > x2) {
        int temp = x1;
        x1 = x2;
        x2 = temp;
    }
    if (x1 < 0) {
        x1 = 0;
    }
    if (x1 >= _bitmapWidth) {
        return;
    }
    if (x2 >= _bitmapWidth) {
        x2 = _bitmapWidth-1;
    }
    int dashCount = 0;

    if (_a == 255) {
        unsigned char *p = _pixelBytes + _bitmapStride*y + (x1*4);
        for (int x=x1; x<=x2; x++) {
            if ((dashCount / dashLength) % 2 == 0) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                p[0] = _b;
                p[1] = _g;
                p[2] = _r;
                p[3] = _a;
#else
                p[0] = _r;
                p[1] = _g;
                p[2] = _b;
                p[3] = _a;
#endif
            }
            dashCount++;
            p += 4;
        }
    } else if (_a == 0) {
    } else {
        unsigned char *p = _pixelBytes + _bitmapStride*y + (x1*4);
        for (int x=x1; x<=x2; x++) {
            if ((dashCount / dashLength) % 2 == 0) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                p[0] = _blueTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
                p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
                p[2] = _redTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
                p[3] = 255;
#else
                p[0] = _redTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
                p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
                p[2] = _blueTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
                p[3] = 255;
#endif
            }
            dashCount++;
            p += 4;
        }
    }
}
- (void)drawVLineAtX:(int)x y:(int)y1 y:(int)y2
{
    [self drawVerticalLineAtX:x y:y1 y:y2];
}
- (void)drawVerticalLineAtX:(int)x y:(int)y1 y:(int)y2
{
    if ((x < 0) || (x >= _bitmapWidth)) {
        return;
    }

    if (y1 > y2) {
        int temp = y1;
        y1 = y2;
        y2 = temp;
    }
    if (y1 < 0) {
        y1 = 0;
    }
    if (y1 >= _bitmapHeight) {
        return;
    }
    if (y2 >= _bitmapHeight) {
        y2 = _bitmapHeight-1;
    }
    if (_a == 255) {
        unsigned char *p = _pixelBytes + _bitmapStride*y1 + (x*4);
        for (int y=y1; y<=y2; y++) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
            p[0] = _b;
            p[1] = _g;
            p[2] = _r;
            p[3] = _a;
#else
            p[0] = _r;
            p[1] = _g;
            p[2] = _b;
            p[3] = _a;
#endif
            p += _bitmapStride;
        }
    } else if (_a == 0) {
    } else {
        unsigned char *p = _pixelBytes + _bitmapStride*y1+(x*4);
        for (int y=y1; y<=y2; y++) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
            p[0] = _blueTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
            p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
            p[2] = _redTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
            p[3] = 255;
#else
            p[0] = _redTimesAlpha + ((double)p[0]*_oneMinusAlphaDouble);
            p[1] = _greenTimesAlpha + ((double)p[1]*_oneMinusAlphaDouble);
            p[2] = _blueTimesAlpha + ((double)p[2]*_oneMinusAlphaDouble);
            p[3] = 255;
#endif
            p += _bitmapStride;
        }
    }
}
- (void)drawLineAtX:(int)x1 y:(int)y1 x:(int)x2 y:(int)y2
{
    if (x1 == x2) {
        [self drawVerticalLineAtX:x1 y:y1 y:y2];
    } else if (y1 == y2) {
        [self drawHorizontalLineAtX:x1 x:x2 y:y1];
    } else if (abs(x2-x1) < abs(y2-y1)) {
        if (y1 > y2) {
            int temp = y1;
            y1 = y2;
            y2 = temp;
            temp = x1;
            x1 = x2;
            x2 = temp;
        }
        double step = (double)(x2-x1) / (double)(y2-y1);
        if (_a == 255) {
            for (int y=y1; y<=y2; y++) {
                if ((y >= 0) && (y < _bitmapHeight)) {
                    int x = x1 + step*(y-y1);
                    if ((x >= 0) && (x < _bitmapWidth)) {
                        unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                        q[0] = _b;
                        q[1] = _g;
                        q[2] = _r;
                        q[3] = _a;
#else
                        q[0] = _r;
                        q[1] = _g;
                        q[2] = _b;
                        q[3] = _a;
#endif
                    }
                }
            }
        } else if (_a == 0) {
        } else {
            for (int y=y1; y<=y2; y++) {
                if ((y >= 0) && (y < _bitmapHeight)) {
                    int x = x1 + step*(y-y1);
                    if ((x >= 0) && (x < _bitmapWidth)) {
                        unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                        q[0] = _blueTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                        q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                        q[2] = _redTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                        q[3] = 255;
#else
                        q[0] = _redTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                        q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                        q[2] = _blueTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                        q[3] = 255;
#endif
                    }
                }
            }
        }
    } else {
        if (x1 > x2) {
            int temp = x1;
            x1 = x2;
            x2 = temp;
            temp = y1;
            y1 = y2;
            y2 = temp;
        }
        double step = (double)(y2-y1) / (double)(x2-x1);
        if (_a == 255) {
            for (int x=x1; x<=x2; x++) {
                if ((x >= 0) && (x < _bitmapWidth)) {
                    int y = y1 + step*(x-x1);
                    if ((y >= 0) && (y < _bitmapHeight)) {
                        unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                        q[0] = _b;
                        q[1] = _g;
                        q[2] = _r;
                        q[3] = _a;
#else
                        q[0] = _r;
                        q[1] = _g;
                        q[2] = _b;
                        q[3] = _a;
#endif
                    }
                }
            }
        } else if (_a == 0) {
        } else {
            for (int x=x1; x<=x2; x++) {
                if ((x >= 0) && (x < _bitmapWidth)) {
                    int y = y1 + step*(x-x1);
                    if ((y >= 0) && (y < _bitmapHeight)) {
                        unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                        q[0] = _blueTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                        q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                        q[2] = _redTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                        q[3] = 255;
#else
                        q[0] = _redTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                        q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                        q[2] = _blueTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                        q[3] = 255;
#endif
                    }
                }
            }
        }
    }
}
- (void)fillRectangleAtX:(int)x1 y:(int)y1 x:(int)x2 y:(int)y2
{
    if (x2 < x1) {
        int tmp = x1;
        x1 = x2;
        x2 = tmp;
    }
    if (y2 < y1) {
        int tmp = y1;
        y1 = y2;
        y2 = tmp;
    }
    if (x1 == x2) {
        return;
    }
    if (y1 == y2) {
        return;
    }
    [self fillRect:[Definitions rectWithX:x1 y:y1 w:x2-x1 h:y2-y1]];
}
- (void)fillRectangleAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self fillRect:[Definitions rectWithX:x y:y w:w h:h]];
}
- (void)fillRect:(Int4)r
{
    int rx = (int)r.x;
    int ry = (int)r.y;
    int rw = (int)r.w;
    int rh = (int)r.h;
    if (_a == 255) {
        if ((rx >= 0) && (rx+rw <= _bitmapWidth) && (ry >= 0) && (ry+rh<=_bitmapHeight)) {
            for (int y=ry; y<ry+rh; y++) {
                unsigned char *p = _pixelBytes + _bitmapStride*y;
                unsigned char *q = p+(rx*4);
                for (int x=0; x<rw; x++) {
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                    q[0] = _b;
                    q[1] = _g;
                    q[2] = _r;
                    q[3] = _a;
#else
                    q[0] = _r;
                    q[1] = _g;
                    q[2] = _b;
                    q[3] = _a;
#endif
                    q+=4;
                }
            }
        } else {
            for (int x=rx; x<rx+rw; x++) {
                for (int y=ry; y<ry+rh; y++) {
                    if ((x >= 0) && (x < _bitmapWidth)) {
                        if ((y >= 0) && (y < _bitmapHeight)) {
                            unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                            q[0] = _b;
                            q[1] = _g;
                            q[2] = _r;
                            q[3] = _a;
#else
                            q[0] = _r;
                            q[1] = _g;
                            q[2] = _b;
                            q[3] = _a;
#endif
                        }
                    }
                }
            }
        }
    } else if (_a == 0) {
    } else {
        if ((rx >= 0) && (rx+rw <= _bitmapWidth) && (ry >= 0) && (ry+rh<=_bitmapHeight)) {
            for (int x=rx; x<rx+rw; x++) {
                for (int y=ry; y<ry+rh; y++) {
                    unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                    q[0] = _blueTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                    q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                    q[2] = _redTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                    q[3] = 255;
#else
                    q[0] = _redTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                    q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                    q[2] = _blueTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                    q[3] = 255;
#endif
                }
            }
        } else {
            for (int x=rx; x<rx+rw; x++) {
                for (int y=ry; y<ry+rh; y++) {
                    if ((x >= 0) && (x < _bitmapWidth)) {
                        if ((y >= 0) && (y < _bitmapHeight)) {
                            unsigned char *q = _pixelBytes + _bitmapStride*y+(x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                            q[0] = _blueTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                            q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                            q[2] = _redTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                            q[3] = 255;
#else
                            q[0] = _redTimesAlpha + ((double)q[0]*_oneMinusAlphaDouble);
                            q[1] = _greenTimesAlpha + ((double)q[1]*_oneMinusAlphaDouble);
                            q[2] = _blueTimesAlpha + ((double)q[2]*_oneMinusAlphaDouble);
                            q[3] = 255;
#endif
                        }
                    }
                }
            }
        }
    }
}
- (void)drawBytes565:(uint16_t *)src bitmapWidth:(int)bitmapWidth bitmapHeight:(int)bitmapHeight x:(int)x y:(int)y w:(int)w h:(int)h
{
    uint8_t *dst = _pixelBytes;
    for (int j=0; j<h; j++) {
        double ypct = (double)j / (double)(h-1);
        int srcy = (int)((double)(bitmapHeight-1)*ypct);
        int dsty = y+j;
        if ((dsty >= 0) && (dsty < _bitmapHeight)) {
            for (int i=0; i<w; i++) {
                double xpct = (double)i / (double)(w-1);
                int srcx = (int)((double)(bitmapWidth-1)*xpct);
                int dstx = x+i;
                
                if ((dstx >= 0) && (dstx < _bitmapWidth)) {
                    int dstidx = dsty*_bitmapStride+dstx*4;
                    int srcidx = srcy*bitmapWidth+srcx;
                    dst[dstidx] = (src[srcidx] & 0x1f) << 3;
                    dst[dstidx+1] = ((src[srcidx] >> 5) & 0x3f) << 2;
                    dst[dstidx+2] = ((src[srcidx] >> 11) & 0x1f) << 3;
                    dst[dstidx+3] = 255;
                }
            }
        }
    }
}
- (void)drawBytes:(uint8_t *)src bitmapWidth:(int)bitmapWidth bitmapHeight:(int)bitmapHeight x:(int)x y:(int)y w:(int)w h:(int)h
{
    uint8_t *dst = _pixelBytes;
    for (int j=0; j<h; j++) {
        double ypct = (double)j / (double)(h-1);
        int srcy = (int)((double)(bitmapHeight-1)*ypct);
        int dsty = y+j;
        if ((dsty >= 0) && (dsty < _bitmapHeight)) {
            for (int i=0; i<w; i++) {
                double xpct = (double)i / (double)(w-1);
                int srcx = (int)((double)(bitmapWidth-1)*xpct);
                int dstx = x+i;
                
                if ((dstx >= 0) && (dstx < _bitmapWidth)) {
                    int dstidx = dsty*_bitmapStride+dstx*4;
                    int srcidx = srcy*bitmapWidth*4+srcx*4;
                    dst[dstidx] = src[srcidx];
                    dst[dstidx+1] = src[srcidx+1];
                    dst[dstidx+2] = src[srcidx+2];
                    dst[dstidx+3] = src[srcidx+3];
                }
            }
        }
    }
}
- (void)drawBytes:(uint8_t *)src bitmapWidth:(int)bitmapWidth bitmapHeight:(int)bitmapHeight x:(int)x y:(int)y
{
    uint8_t *dst = _pixelBytes;
    for (int j=0; j<bitmapHeight; j++) {
        int srcy = j;
        int dsty = y+j;
        if ((dsty >= 0) && (dsty < _bitmapHeight)) {
            for (int i=0; i<bitmapWidth; i++) {
                int srcx = i;
                int dstx = x+i;
                
                if ((dstx >= 0) && (dstx < _bitmapWidth)) {
                    int dstidx = dsty*_bitmapStride+dstx*4;
                    int srcidx = srcy*bitmapWidth*4+srcx*4;
                    dst[dstidx] = src[srcidx];
                    dst[dstidx+1] = src[srcidx+1];
                    dst[dstidx+2] = src[srcidx+2];
                    dst[dstidx+3] = src[srcidx+3];
                }
            }
        }
    }
}
- (void)drawBitmap:(id)bitmap x:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawBytes:[bitmap pixelBytes] bitmapWidth:[bitmap bitmapWidth] bitmapHeight:[bitmap bitmapHeight] x:x y:y w:w h:h];
}
- (void)drawBitmap:(id)bitmap x:(int)x y:(int)y
{
    uint8_t *src = [bitmap pixelBytes];
    int bitmapWidth = [bitmap bitmapWidth];
    int bitmapHeight = [bitmap bitmapHeight];
    uint8_t *dst = _pixelBytes;
    for (int j=0; j<bitmapHeight; j++) {
        int srcy = j;
        int dsty = y+j;
        if ((dsty >= 0) && (dsty < _bitmapHeight)) {
            for (int i=0; i<bitmapWidth; i++) {
                int srcx = i;
                int dstx = x+i;
                
                if ((dstx >= 0) && (dstx < _bitmapWidth)) {
                    int dstidx = dsty*_bitmapStride+dstx*4;
                    int srcidx = srcy*bitmapWidth*4+srcx*4;
                    dst[dstidx] = src[srcidx];
                    dst[dstidx+1] = src[srcidx+1];
                    dst[dstidx+2] = src[srcidx+2];
                    dst[dstidx+3] = src[srcidx+3];
                }
            }
        }
    }
}
- (void)saveState
{
    if (!_savedStates) {
        [self setValue:nsarr() forKey:@"savedStates"];
    }
    id color = nsfmt(@"%d %d %d %d", _r, _g, _b, _a);
    [_savedStates addObject:color];
}
- (void)restoreState
{
    int count = [_savedStates count];
    if (!count) {
        return;
    }
    int index = count-1;
    id color = [_savedStates nth:index];
    id tokens = [color split:@" "];
    int r = [[tokens nth:0] intValue];
    int g = [[tokens nth:1] intValue];
    int b = [[tokens nth:2] intValue];
    int a = [[tokens nth:3] intValue];
    [self setColorIntR:r g:g b:b a:a];
    [_savedStates removeObjectAtIndex:index];
}
- (BOOL)writeAsPPMToFile:(id)path
{
    unsigned char *filename = [path UTF8String];
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        return NO;
    }
    fprintf(fp, "P3\n");
    fprintf(fp, "%d %d\n", _bitmapWidth, _bitmapHeight);
    fprintf(fp, "255\n");
    unsigned char *p = _pixelBytes;
    for (int i=0; i<_bitmapHeight; i++) {
        for (int j=0; j<_bitmapWidth; j++) {
            fprintf(fp, "%d %d %d\n", p[2], p[1], p[0]);
            p += 4;
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
    return YES;
}
- (int)bitmapHeightForText:(id)text
{
    return [Definitions bitmapHeightForText:text heights:_fontHeights];
}
- (int)bitmapWidthForText:(id)text
{
    return [Definitions bitmapWidthForText:text widths:_fontWidths xspacings:_fontXSpacings];
}
- (int)bitmapWidthForLineOfTextCString:(unsigned char *)str
{
    return [Definitions bitmapWidthForLineOfTextCString:str widths:_fontWidths xspacings:_fontXSpacings];
}
- (void)drawCString:(unsigned char *)str rotatedRightAtX:(int)x y:(int)y c:(unsigned char)c r:(int)r g:(int)g b:(int)b a:(int)a
{
    [self drawCString:str x:x y:y c:c r:r g:g b:b a:a ix:0 iy:0 cx:0 cy:1 lx:-1 ly:0];
}
- (void)drawCString:(unsigned char *)str rotatedLeftAtX:(int)x y:(int)y c:(unsigned char)c r:(int)r g:(int)g b:(int)b a:(int)a
{
    [self drawCString:str x:x y:y c:c r:r g:g b:b a:a ix:0 iy:0 cx:0 cy:-1 lx:1 ly:0];
}
- (void)drawCString:(unsigned char *)str x:(int)x y:(int)y c:(unsigned char)c r:(int)r g:(int)g b:(int)b a:(int)a
{
    [self drawCString:str x:x y:y c:c r:r g:g b:b a:a ix:0 iy:0 cx:1 cy:0 lx:0 ly:1];
}
- (void)drawBitmapText:(id)text rotatedRightAtX:(int)startX y:(int)startY
{
    if (![text length]) {
        return;
    }
    int textHeight = _fontHeights['A'];
    unsigned char *str = [text UTF8String];
    unsigned char *p = str;
    int x = startX;
    int y = startY;
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
            x += textHeight;
            y = startY;
        } else {
            unsigned char *cstr = _fontCStrings[*p];
            if (cstr) {
                int width = [Definitions widthForCString:cstr];
                [self drawCString:cstr rotatedRightAtX:x y:y c:'b' r:_r g:_g b:_b a:_a];
                int textXSpacing = _fontXSpacings[*p];
                y += width + textXSpacing;
            }
        }
        p++;
    }
}
- (void)drawBitmapText:(id)text rotatedLeftAtX:(int)startX y:(int)startY
{
    if (![text length]) {
        return;
    }
    int textHeight = _fontHeights['A'];
    unsigned char *str = [text UTF8String];
    unsigned char *p = str;
    int x = startX;
    int y = startY;
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
            x += textHeight;
            y = startY;
        } else {
            unsigned char *cstr = _fontCStrings[*p];
            if (cstr) {
                int width = [Definitions widthForCString:cstr];
                [self drawCString:cstr rotatedLeftAtX:x y:y c:'b' r:_r g:_g b:_b a:_a];
                int textXSpacing = _fontXSpacings[*p];
                y -= width + textXSpacing;
            }
        }
        p++;
    }
}
- (void)drawBitmapText:(id)text rightAlignedRotatedLeftAtX:(int)startX y:(int)startY
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    [self drawBitmapText:text rotatedLeftAtX:startX y:startY+textWidth];
}
- (void)drawBitmapText:(id)text x:(int)startX y:(int)startY
{
    if (![text length]) {
        return;
    }
    int textHeight = _fontHeights['A'];
    unsigned char *str = [text UTF8String];
    unsigned char *p = str;
    int x = startX;
    int y = startY;
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
            x = startX;
            y += textHeight;
        } else {
            unsigned char *cstr = _fontCStrings[*p];
            if (cstr) {
                int width = [Definitions widthForCString:cstr];
                [self drawCString:cstr x:x y:y c:'b' r:_r g:_g b:_b a:_a];
                int textXSpacing = _fontXSpacings[*p];
                x += width + textXSpacing;
            }
        }
        p++;
    }
}
- (void)drawBitmapText:(id)text x:(int)startX y:(int)startY palette:(id)palette
{
    if (![text length]) {
        return;
    }
    if (![palette length]) {
        return;
    }
    unsigned char *palettecstr = [palette UTF8String];
    int textHeight = _fontHeights['A'];
    unsigned char *str = [text UTF8String];
    unsigned char *p = str;
    int x = startX;
    int y = startY;
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
            x = startX;
            y += textHeight;
        } else {
            unsigned char *cstr = _fontCStrings[*p];
            if (cstr) {
                int width = [Definitions widthForCString:cstr];
                [self drawCString:cstr palette:palettecstr x:x y:y];
                int textXSpacing = _fontXSpacings[*p];
                x += width + textXSpacing;
            }
        }
        p++;
    }
}

- (void)drawBitmapText:(id)text centeredAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawBitmapText:text centeredInRect:(Int4){x, y, w, h}];
}

- (void)drawBitmapText:(id)text centeredInRect:(Int4)rect
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    int textHeight = _fontHeights['A'];
    Int4 textRect = [Definitions centerRect:[Definitions rectWithX:0 y:0 w:textWidth h:textHeight] inRect:rect];
    [self drawBitmapText:text x:textRect.x y:textRect.y+1];
}
- (void)drawBitmapText:(id)text centeredInRect:(Int4)rect palette:(id)palette
{
    if (![text length]) {
        return;
    }
    if (![palette length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    int textHeight = _fontHeights['A'];
    Int4 textRect = [Definitions centerRect:[Definitions rectWithX:0 y:0 w:textWidth h:textHeight] inRect:rect];
    [self drawBitmapText:text x:textRect.x y:textRect.y+1 palette:palette];
}

- (void)drawBitmapText:(id)text leftAlignedAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawBitmapText:text leftAlignedAtRect:(Int4){x, y, w, h}];
}

- (void)drawBitmapText:(id)text leftAlignedInRect:(Int4)rect
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    int textHeight = _fontHeights['A'];
    Int4 textRect = [Definitions centerRect:[Definitions rectWithX:0 y:0 w:textWidth h:textHeight] inRect:rect];
    [self drawBitmapText:text x:rect.x+8 y:textRect.y+2];
}

- (void)drawBitmapText:(id)text topRightAlignedAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawBitmapText:text topRightAlignedInRect:(Int4){x, y, w, h}];
}

- (void)drawBitmapText:(id)text topRightAlignedInRect:(Int4)rect
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    [self drawBitmapText:text x:rect.x+rect.w-textWidth-8 y:rect.y];
}

- (void)drawBitmapText:(id)text rightAlignedAtX:(int)x y:(int)y w:(int)w h:(int)h
{
    [self drawBitmapText:text rightAlignedInRect:(Int4){x, y, w, h}];
}

- (void)drawBitmapText:(id)text rightAlignedInRect:(Int4)rect
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    int textHeight = _fontHeights['A'];
    Int4 textRect = [Definitions centerRect:[Definitions rectWithX:0 y:0 w:textWidth h:textHeight] inRect:rect];
    [self drawBitmapText:text x:rect.x+rect.w-textRect.w-8 y:textRect.y+2];
}
- (void)drawBitmapText:(id)text rightAlignedAtX:(int)x y:(int)y
{
    if (![text length]) {
        return;
    }
    int cursorY = y;
    int textHeight = _fontHeights['A'];
    id arr = [text split:@"\n"];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        int textWidth = [self bitmapWidthForText:elt];
        [self drawBitmapText:elt x:x-textWidth y:cursorY];
        cursorY += textHeight;
    }
}

- (void)drawBitmapText:(id)text centeredAtX:(int)x y:(int)y
{
    if (![text length]) {
        return;
    }
    int textWidth = [self bitmapWidthForText:text];
    int textHeight = [self bitmapHeightForText:text];
    [self drawBitmapText:text x:x-textWidth/2 y:y+textHeight-textHeight/2];
}

- (id)fitBitmapString:(id)text width:(int)maxWidth
{
    return [Definitions fitBitmapString:text width:maxWidth widths:_fontWidths];
}


- (void)drawPixelString:(id)str palette:(id)palette x:(int)x y:(int)y
{
    char *pixelcstr = [str UTF8String];
    char *palettecstr = [palette UTF8String];
    if (!pixelcstr || !palettecstr) {
        return;
    }
    [self drawCString:pixelcstr palette:palettecstr x:x y:y];
}

- (void)drawCString:(unsigned char *)str palette:(unsigned char *)palette x:(int)x y:(int)y
{
    unsigned char *p = palette;
    for(;;) {
        if (!*p) {
            break;
        }
        unsigned char *q = strchr(p, '\n');
        if (!q) {
            int len = strlen(p);
            if (len < 9) {
                break;
            }
            q = p+len;
        } else {
            q++;
            if (q - p < 10) {
                p = q;
                continue;
            }
        }
        unsigned char c = p[0];
        int r = hexchartoint(p[3])*16 + hexchartoint(p[4]);
        int g = hexchartoint(p[5])*16 + hexchartoint(p[6]);
        int b = hexchartoint(p[7])*16 + hexchartoint(p[8]);
        [self drawCString:str x:x y:y c:c r:r g:g b:b a:255];
        p = q;
    }
}
- (void)drawCString:(unsigned char *)str x:(int)x y:(int)y c:(unsigned char)c r:(int)r g:(int)g b:(int)b a:(int)a ix:(int)ix iy:(int)iy cx:(int)cx cy:(int)cy lx:(int)lx ly:(int)ly
{
    if (!str) {
        return;
    }
    unsigned char *pixels = _pixelBytes;
    if (!pixels) {
        return;
    }
    int bitmapWidth = _bitmapWidth;
    int bitmapHeight = _bitmapHeight;
    int bitmapStride = _bitmapStride;
    int initial_x = (ix) ? (bitmapWidth-1-x) : x;
    int initial_y = (iy) ? (bitmapHeight-1-y) : y;
    int cursor_x = initial_x;
    int cursor_y = initial_y;
    unsigned char *p = str;
    while (*p) {
        if (*p == '\n') {
            if (lx) {
                cursor_x += lx;
            } else {
                cursor_x = initial_x;
            }
            if (ly) {
                cursor_y += ly;
            } else {
                cursor_y = initial_y;
            }
            p++;
            continue;
        }
        if (*p != c) {
            cursor_x += cx;
            cursor_y += cy;
            p++;
            continue;
        }
        if ((cursor_x >= 0) && (cursor_x < bitmapWidth)) {
            if ((cursor_y >= 0) && (cursor_y < bitmapHeight)) {
                unsigned char *q = pixels + bitmapStride*cursor_y+(cursor_x*4);
#ifdef BUILD_WITH_BGRA_PIXEL_FORMAT
                q[0] = b;
                q[1] = g;
                q[2] = r;
                q[3] = a;
#else
                q[0] = r;
                q[1] = g;
                q[2] = b;
                q[3] = a;
#endif
            }
        }
        cursor_x += cx;
        cursor_y += cy;
        p++;
    }
}

@end


