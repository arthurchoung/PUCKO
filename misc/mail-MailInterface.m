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

@implementation Definitions(fmeklwmfklsdklfmklsdmfkl)

+ (void)MailInterface
{
    id obj = nil;

    id arr = [@"." contentsOfDirectory];
    arr = [arr keepSuffix:@".eml"];
    if (![arr count]) {
        obj = [nsarr() asMailInterface];
    } else {
        id cmd = nsarr();
        [cmd addObject:@"pucko-mail-list"];
        [cmd addObjectsFromArray:arr];
        id output = [cmd runCommandAndReturnOutput];
        id results = [output blocksFromData];
        obj = [results asMailInterface];
    }
    if (obj) {
        id nav = [Definitions navigationStack];
        [nav pushObject:obj];
        [Definitions runWindowManagerForObject:nav];
        [[Definitions navigationStack] setValue:nil forKey:@"context"];
    }
    exit(0);
}
+ (id)MailInterface:(id)path
{
    id arr = [path contentsOfDirectoryWithFullPaths];
    arr = [arr keepSuffix:@".eml"];
    if (![arr count]) {
        return [nsarr() asMailInterface];
    }

    id cmd = nsarr();
    [cmd addObject:@"pucko-mail-list"];
    [cmd addObjectsFromArray:arr];
    id output = [cmd runCommandAndReturnOutput];
    id results = [output blocksFromData];
    id obj = [results asMailInterface];
    return obj;
}
@end

@implementation NSArray(fjkdsljflksdlkjf)
- (id)asMailInterface
{
    id obj = [@"MailInterface" asInstance];
    [obj setValue:self forKey:@"array"];
    [obj setValue:@"MailHTMLMessageHeaders:(NSArray|addObject:'pucko-mail-printHeaders'|addObject:(selectedObject|name)|runCommandAndReturnOutput|asString) plain:(NSArray|addObject:'pucko-mail-printContentType'|addObject:(selectedObject|name)|addObject:'text/plain'|runCommandAndReturnOutput|asString) html:(NSArray|addObject:'pucko-mail-printContentType'|addObject:(selectedObject|name)|addObject:'text/html'|runCommandAndReturnOutput|asString) :(NSArray|addObject:'pucko-mail-extractPart'|addObject:(selectedObject|name)|runCommandAndReturnOutput|asString|lines)" forKey:@"defaultMessageForClick"];
    return obj;
}
@end

@interface MailInterface : IvarObject
{
    id _currentDirectory;
    id _headerFormat;
    id _defaultMessageForClick;
    id _defaultStringFormat;
    id _message;
    id _observer;
    id _dict;
    id _array;
    int _objectOffsetY;
    id _buttonHover;
    id _buttonDown;
    int _index;
    int _viewWidth;
    int _viewHeight;
    int _cellHeight;
    id _selectedObject;
    id _sortMessage;
    id _rightButtonDown;
    id _searchText;
    Int4 _rect;
    time_t _currentDirectoryTimestamp;
}
@end

@implementation MailInterface

- (id)init
{
    self = [super init];
    if (self) {
        _cellHeight = 66.0;
    }
    return self;
}

- (void)beginIteration:(id)event rect:(Int4)r
{
    if (_currentDirectoryTimestamp) {
        time_t timestamp = [@"." fileModificationTimestamp];
        if (timestamp != _currentDirectoryTimestamp) {
            _currentDirectoryTimestamp = timestamp;
            [self updateFromCurrentDirectory];
        }
    }
}

- (void)updateObjectOffsetY:(int)delta
{
    NSLog(@"viewHeight %d", _viewHeight);
    if (!_viewHeight) {
        return;
    }
    int cellHeight = _cellHeight;
    int numberOfCells = ceil((double)_viewHeight / (double)cellHeight);

    _objectOffsetY+delta;
    if (_objectOffsetY < 0) {
        _objectOffsetY = 0;
    }
    
    id arr = [self valueForKey:@"array"];
    int count = [arr count];
    if (_objectOffsetY > (count-1)*cellHeight) {
        _objectOffsetY = (count-1)*cellHeight;
    }
}

- (void)handlePageUp
{
    int cellHeight = _cellHeight;
    int numberOfCells = ceil(_viewHeight / cellHeight);
    [self updateObjectOffsetY:(numberOfCells-1)*cellHeight];
}
- (void)handlePageDown
{
    int cellHeight = _cellHeight;
    int numberOfCells = ceil(_viewHeight / cellHeight);
    [self updateObjectOffsetY:-(numberOfCells-1)*cellHeight];
}
- (void)handleMoveUp
{
    [self updateObjectOffsetY:_cellHeight];
}
- (void)handleMoveDown
{
    [self updateObjectOffsetY:-_cellHeight];
}
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


- (id)buttonForMousePosEvent:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];

    if (mouseX < _rect.x) {
        return nil;
    }
    if (mouseX >= _rect.x+_rect.w) {
        return nil;
    }
    if (mouseY < _rect.y) {
        return nil;
    }
    if (mouseY >= _rect.y+_rect.h) {
        return nil;
    }
    
    int cellHeight = _cellHeight;
    int y = _objectOffsetY + mouseY - _rect.y;
    if (y < 0) {
        return nil;
    }
    int n = y / cellHeight;
    
    return nsfmt(@"%d", n);
}

- (void)handleScrollTouch:(id)event
{
    [self handleScrollWheel:event];
}

- (void)handleScrollWheel:(id)event
{
    _objectOffsetY -= [event intValueForKey:@"deltaY"];
    if (_objectOffsetY < 0) {
        _objectOffsetY = 0;
    }
    
    int cellHeight = _cellHeight;
    int numberOfCells = ceil([event intValueForKey:@"viewHeight"] / cellHeight);
    id arr = [self valueForKey:@"array"];
    int count = [arr count];
    if (_objectOffsetY > (count-1)*cellHeight) {
        _objectOffsetY = (count-1)*cellHeight;
    }
    [self handleMouseMoved:event];
}

- (void)handleMouseDown:(id)event
{
    [self setValue:[self buttonForMousePosEvent:event] forKey:@"buttonDown"];
}

- (void)handleRightMouseDown:(id)event
{
    [self setValue:[self buttonForMousePosEvent:event] forKey:@"rightButtonDown"];
}
- (void)handleMouseUp:(id)event
{
    id buttonDown = [self valueForKey:@"buttonDown"];
    id buttonHover = [self valueForKey:@"buttonHover"];
    [self setValue:nil forKey:@"buttonDown"];
    if ([buttonDown isEqual:buttonHover]) {
        if ([buttonDown isInt]) {
            NSLog(@"handleClick:%@", buttonDown);
            id arr = [self valueForKey:@"array"];
            id elt = [arr nth:[buttonDown intValue]];
            if (!elt) {
                return;
            }
            id messageForClick = _defaultMessageForClick;
NSLog(@"messageForClick '%@'", messageForClick);
            if (messageForClick) {
                _index = [buttonDown intValue];
                [self setValue:elt forKey:@"selectedObject"];
                id result = [self evaluateMessage:messageForClick];
                if ([elt intValueForKey:@"drawChevron" default:1]) {
                    [result pushToNavigationStack];
                }
                NSLog(@"result %@", result);
            }
        }
    }
}

- (void)handleRightMouseUp:(id)event
{
    id rightButtonDown = [self valueForKey:@"rightButtonDown"];
    id buttonHover = [self valueForKey:@"buttonHover"];
NSLog(@"rightMouseUp %@", rightButtonDown);
    [self setValue:nil forKey:@"rightButtonDown"];
    if ([rightButtonDown isEqual:buttonHover]) {
        NSLog(@"handleRightClick:%@", rightButtonDown);
        id arr = [self valueForKey:@"array"];
        if ([rightButtonDown isInt]) {
            id elt = [arr nth:[rightButtonDown intValue]];
            if (!elt) {
                return;
            }
            [self setValue:elt forKey:@"selectedObject"];
            id rightClickMenu = [[[Definitions configDir:@"Config/rightClickMenu.csv"] menuFromPath] asListInterface];
NSLog(@"rightClickMenu %@", rightClickMenu);
            [rightClickMenu pushToNavigationStack];
        }
    }
}

- (void)handleMouseMoved:(id)event
{
    [self setValue:[self buttonForMousePosEvent:event] forKey:@"buttonHover"];
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap useChicagoFont];
    _rect = r;
    _viewWidth = r.w;
    _viewHeight = r.h;
    [bitmap setColor:@"white"];
//[bitmap setColor:@"#b1b2ac"];
    [bitmap fillRect:r];
    [bitmap setColor:@"black"];
//r = [Definitions rectWithPadding:r w:-4 h:0];
    [self drawArray:[self valueForKey:@"array"] inBitmap:bitmap rect:r];
}

- (void)drawArray:(id)arr inBitmap:(id)bitmap rect:(Int4)rect
{
    int numberOfElements = [arr count];

    int index = _objectOffsetY/_cellHeight - 1;
    if (index < 0) {
        index = 0;
    }

    for (;;) {
        int cellY = index*_cellHeight - _objectOffsetY;
        if (cellY >= rect.h) {
            break;
        }

        if (cellY + _cellHeight < 0) {
            goto next;
        }

        id elt = [arr nth:index];
        if (!elt) {
            goto next;
        }
        
        
        id style = @"";
        if ([_buttonHover isInt]) {
            if ([_buttonHover intValue] == index) {
                if ([_buttonDown isInt]) {
                    if ([_buttonDown intValue] == index) {
                        style = @"selected";
                    }
                } else if ([_buttonDown isKindOfClass:[NSString class]]) {
                } else {
                    style = @"highlighted";
                }
            }
        }
        [self drawElement:elt inBitmap:bitmap rect:[Definitions rectWithX:rect.x y:rect.y+cellY w:rect.w h:_cellHeight] style:style];

next:
        index++;
    }
}
- (void)drawElement:(id)elt inBitmap:(id)bitmap rect:(Int4)r style:(id)style
{
    char *unseenPixels = 
" bbbbb \n"
"bbbbbbb\n"
"bbbbbbb\n"
"bbbbbbb\n"
"bbbbbbb\n"
"bbbbbbb\n"
" bbbbb \n"
;
    char *unseenPalette = "b #0000ff\n";
    char *paperclipPixels2 =
"                    b      \n"
"                 bbbbbbb   \n"
"                bbbbbbbbb  \n"
"               bbb     bbb \n"
"              bbb       bbb\n"
"             bbb         bb\n"
"            bbb          bb\n"
"           bbb           bb\n"
"          bbb            bb\n"
"         bbb            bbb\n"
"        bbb            bbb \n"
"       bbb     b      bbb  \n"
"      bbb     bb     bbb   \n"
"     bbb     bb     bbb    \n"
"    bbb     bb     bbb     \n"
"   bbb     bb     bbb      \n"
"  bbb     bb    ,bbb       \n"
" bbbb    bb     bbb        \n"
" bbb    bb     bbb         \n"
"bbb    bb     bbb     bb   \n"
"bbb    bb    bbb     bbb   \n"
"bb     bb   bbb     bbb    \n"
"bb     bbbbbbb     bbb     \n"
"bb      bbbb      bbb      \n"
"bbb              bbb       \n"
"bbb             bbb        \n"
"bbbb           bbb,        \n"
" bbbb        bbbb          \n"
"  bbbb      bbbb           \n"
"   bbbbbbbbbbbb            \n"
"     bbbbbbbb              \n"
"         b                 \n"
;
    char *paperclipPixels =
"        bbb  \n"
"       b   b \n"
"      b     b\n"
"     b      b\n"
"    b       b\n"
"   b   b   b \n"
"  b   b   b  \n"
" b   b   b   \n"
" b  b   b    \n"
"b   b  b  b  \n"
"b    bb  b   \n"
"b       b    \n"
" b    bb     \n"
"  bbbb       \n"
;
    char *paperclipPalette = "b #000000\n";
    int paperclipWidth = [Definitions widthForCString:paperclipPixels];
    int attachments = [elt intValueForKey:@"attachments"];
    int indent = 6;

    int textHeight = [bitmap bitmapHeightForText:@"X"];
    id datecolor = nil;
    id fgcolor = nil;
    id bgcolor = nil;
    id previewcolor = nil;
    if ([style isEqual:@"selected"]) {
        previewcolor = @"#a0a0a0";
        datecolor = @"white";
        fgcolor = @"white";
        bgcolor = @"blue";
    } else if ([style isEqual:@"highlighted"]) {
        previewcolor = @"#a0a0a0";
        datecolor = @"white";
        fgcolor = @"white";
        bgcolor = @"black";
    } else {
        previewcolor = @"#606060";
        datecolor = @"blue";
        fgcolor = @"black";
        bgcolor = @"white";
    }
    [bitmap setColor:bgcolor];
    [bitmap fillRect:r];
    [bitmap setColor:@"black" alpha:0.5];
    [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w y:r.y+r.h-1];
    id date = [elt valueForKey:@"date"];
    Int4 rr = r;
    rr.x += 18;
    rr.y += 4;
    rr.w -= 32;
    rr.h -= 8;
    [bitmap setColor:datecolor];
    [bitmap drawBitmapText:date topRightAlignedInRect:rr];
    id from = [elt valueForKey:@"from"];
    rr.w -= [bitmap bitmapWidthForText:date];
    rr.w -= 4;
    if (attachments) {
        rr.w -= paperclipWidth;
        rr.w -= 4;
    }
    id fromText = [[[bitmap fitBitmapString:from width:rr.w] split:@"\n"] nth:0];
    [bitmap setColor:fgcolor];
    [bitmap drawBitmapText:fromText x:rr.x y:rr.y];
    if (attachments) {
        int fromWidth = [bitmap bitmapWidthForText:fromText];
        [bitmap drawCString:paperclipPixels palette:paperclipPalette x:rr.x+fromWidth+4 y:rr.y-2];
    }
    rr.x += indent;
    rr.w = r.w - 32 - indent;
    rr.y += 16;
    rr.h -= 16;
    id subject = [elt valueForKey:@"subject"];
    [bitmap drawBitmapText:[[[bitmap fitBitmapString:subject width:rr.w] split:@"\n"] nth:0] x:rr.x y:rr.y];
    rr.x -= indent;
    rr.y += 16;
    rr.w += indent;
    rr.h -= 16;
    id preview = [elt valueForKey:@"preview"];
    if (preview) {
        [bitmap useWinSystemFont];
        preview = [[[[bitmap fitBitmapString:preview width:rr.w] split:@"\n"] subarrayToIndex:2] join:@"\n"];
        [bitmap setColor:previewcolor];
        [bitmap drawBitmapText:preview x:rr.x y:rr.y];
        [bitmap useChicagoFont];
    }
    if ([elt intValueForKey:@"drawChevron" default:1]) {
        [bitmap setColor:fgcolor];
        [bitmap drawBitmapText:@">" rightAlignedInRect:r];
    }
    if ([elt intValueForKey:@"unseen"]) {
        int y = r.y + (r.h-7)/2;
        [bitmap drawCString:unseenPixels palette:unseenPalette x:r.x+4 y:y];
    }
}

@end
