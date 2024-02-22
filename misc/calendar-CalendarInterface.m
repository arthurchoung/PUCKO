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

#define MAX_RECT 640

static void drawStripedBackgroundInBitmap_rect_(id bitmap, Int4 r)
{
    [bitmap setColorIntR:205 g:212 b:222 a:255];
    [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:r.h];
    [bitmap setColorIntR:201 g:206 b:209 a:255];
    for (int i=6; i<r.w; i+=10) {
        [bitmap fillRectangleAtX:r.x+i y:r.y w:4 h:r.h];
    }
}

static int monthNameAsInt(id str)
{
    if ([str isEqual:@"January"]) {
        return 1;
    } else if ([str isEqual:@"February"]) {
        return 2;
    } else if ([str isEqual:@"March"]) {
        return 3;
    } else if ([str isEqual:@"April"]) {
        return 4;
    } else if ([str isEqual:@"May"]) {
        return 5;
    } else if ([str isEqual:@"June"]) {
        return 6;
    } else if ([str isEqual:@"July"]) {
        return 7;
    } else if ([str isEqual:@"August"]) {
        return 8;
    } else if ([str isEqual:@"September"]) {
        return 9;
    } else if ([str isEqual:@"October"]) {
        return 10;
    } else if ([str isEqual:@"November"]) {
        return 11;
    } else if ([str isEqual:@"December"]) {
        return 12;
    }
    return 0;
}

@implementation Definitions(fjkdlsjfklsdjfklsdfjdksjfkdsfjdskfjksdljfjjfdksfjksd)
+ (void)CalendarInterface
{
    int year = [Definitions currentYear];
    id object = [Definitions CalendarInterface:year];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
+ (void)CalendarInterface:(int)year
{
    id object = [Definitions CalendarInterface:year columns:3];
    [Definitions runWindowManagerForObject:object];
    exit(0);
}
+ (void)CalendarInterface:(int)year columns:(int)numberOfColumns
{
    int currentYear = [Definitions currentYear];
    int currentMonth = [Definitions currentMonth];
    int currentDay = [Definitions currentDay];

    id obj = [@"CalendarInterface" asInstance];
    [obj setValue:nsfmt(@"%d", year) forKey:@"year"];
    [obj setValue:nsfmt(@"%d", numberOfColumns) forKey:@"numberOfColumns"];

    [obj setValue:nsfmt(@"%d", currentYear) forKey:@"currentYear"];
    [obj setValue:nsfmt(@"%d", currentMonth) forKey:@"currentMonth"];
    [obj setValue:nsfmt(@"%d", currentDay) forKey:@"currentDay"];

    [obj updateCalendarArray];

    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)CalendarInterfaceSingleColumn
{
    int currentYear = [Definitions currentYear];
    int currentMonth = [Definitions currentMonth];
    int currentDay = [Definitions currentDay];

    id obj = [@"CalendarInterface" asInstance];
    [obj setValue:nsfmt(@"%d", currentYear) forKey:@"year"];
    [obj setValue:@"1" forKey:@"numberOfColumns"];
    [obj setValue:nsfmt(@"%d", currentMonth) forKey:@"pendingScrollToIndex"];

    [obj setValue:nsfmt(@"%d", currentYear) forKey:@"currentYear"];
    [obj setValue:nsfmt(@"%d", currentMonth) forKey:@"currentMonth"];
    [obj setValue:nsfmt(@"%d", currentDay) forKey:@"currentDay"];

    [obj updateCalendarArray];

    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
@end



@interface CalendarInterface : IvarObject
{
    time_t _timestamp;
    int _seconds;
    Int4 _rect[MAX_RECT];
    id _buttons;
    int _buttonDown;
    int _buttonHover;
    int _scrollY;

    id _eventsArray;
    id _calendarArray;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    int _numberOfColumns;
    int _year;
    int _pendingScrollToIndex;

    int _currentYear;
    int _currentMonth;
    int _currentDay;
}
@end
@implementation CalendarInterface
- (id)contextualMenu
{
    if (_buttonHover) {
        id arr = nsarr();
        id dict = nsdict();
        [dict setValue:[_buttons nth:_buttonHover-1] forKey:@"displayName"];
        [arr addObject:dict];
        return arr;
    }
    id str =
@"hotKey,displayName,messageForClick\n"
@"left,Go To Previous Year,goToPreviousYear\n"
@"right,Go To Next Year,goToNextYear\n"
@"1,Use 1 Column,useSingleColumn\n"
@"3,Use 3 Columns,useThreeColumns\n"
;
    return [str parseCSVFromString];
}
- (void)useSingleColumn
{
    _numberOfColumns = 1;
    _scrollY = 0;
}
- (void)useThreeColumns
{
    _numberOfColumns = 3;
    _scrollY = 0;
}
- (void)goToPreviousYear
{
    _year--;
    [self updateCalendarArray];
}
- (void)goToNextYear
{
    _year++;
    [self updateCalendarArray];
}
- (id)hoverObject
{
    if (_buttonHover) {
        return [_buttons nth:_buttonHover-1];
    }
    return nil;
}
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [@"." fileModificationTimestamp];
    if (timestamp == _timestamp) {
        _seconds++;
        return;
    }
    [self updateEventsArray];
    _timestamp = timestamp;
    _seconds = 0;
}
- (void)updateEventsArray
{
    id cmd = nsarr();
    [cmd addObject:@"pucko-calendar-listEvents.py"];
    id output = [[[cmd runCommandAndReturnOutput] asString] split:@"\n"];
    if (output) {
        [self setValue:output forKey:@"eventsArray"];
    }
}
- (void)updateCalendarArray
{
    [self setValue:nsarr() forKey:@"calendarArray"];

    if (_numberOfColumns == 1) {
        id cmd = nsarr();
        [cmd addObject:@"cal"];
        [cmd addObject:nsfmt(@"%d", 12)];
        [cmd addObject:nsfmt(@"%d", _year-1)];
        id output = [[[cmd runCommandAndReturnOutput] asString] split:@"\n"];
        if (output) {
            [_calendarArray addObject:output];
        }
    }

    for (int i=1; i<=12; i++) {
        id cmd = nsarr();
        [cmd addObject:@"cal"];
        [cmd addObject:nsfmt(@"%d", i)];
        [cmd addObject:nsfmt(@"%d", _year)];
        id output = [[[cmd runCommandAndReturnOutput] asString] split:@"\n"];
        if (output) {
            [_calendarArray addObject:output];
        }
    }

    if (_numberOfColumns == 1) {
        id cmd = nsarr();
        [cmd addObject:@"cal"];
        [cmd addObject:nsfmt(@"%d", 1)];
        [cmd addObject:nsfmt(@"%d", _year+1)];
        id output = [[[cmd runCommandAndReturnOutput] asString] split:@"\n"];
        if (output) {
            [_calendarArray addObject:output];
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    drawStripedBackgroundInBitmap_rect_(bitmap, r);

    [self setValue:nsarr() forKey:@"buttons"];

    _cursorY = -_scrollY + r.y + 5;
    _r = r;


    [self setValue:bitmap forKey:@"bitmap"];
start:
    int rowCursorY = -_scrollY + r.y + 5;
    int nextCursorY = rowCursorY;

    int numberOfColumns = _numberOfColumns;
    if (numberOfColumns < 1) {
        numberOfColumns = 3;
    }
    int gridWidth = r.w / numberOfColumns;
    for (int i=0; i<[_calendarArray count]; i++) {
        id output = [_calendarArray nth:i];

        if (_pendingScrollToIndex && (_pendingScrollToIndex == i)) {
            _pendingScrollToIndex = 0;
            _scrollY = rowCursorY;
            drawStripedBackgroundInBitmap_rect_(bitmap, r);
            goto start;
        }

        _cursorY = rowCursorY;

        _cursorY += 10;

        Int4 gridRect;
        int gridX = i%numberOfColumns;
        gridRect.x = r.x + gridWidth*gridX + 3;
        gridRect.y = _cursorY; 
        gridRect.w = gridWidth - 6;
        gridRect.h = r.h;

        _r = gridRect;

        [self drawCalendarArray:output square:NO];

        if (_cursorY > nextCursorY) {
            nextCursorY = _cursorY;
        }
        if (gridX == numberOfColumns-1) {
            rowCursorY = nextCursorY;
        }
    }

    [self setValue:nil forKey:@"bitmap"];

}
- (void)drawCalendarArray:(id)arr square:(BOOL)square
{
    int year = 0;
    int month = 0;

    for (int i=0; i<[arr count]; i++) {
        if (_cursorY >= _r.y + _r.h) {
            break;
        }
        if ([_buttons count] >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }
        id line = [arr nth:i];
        id tokens = [line split];
        if ([tokens count]) {
            if ([[tokens nth:0] intValue] > 0) {
                id days = nsarr();
                if ([tokens count] < 7) {
                    if ([[tokens nth:0] intValue] == 1) {
                        for (int j=[tokens count]; j<7; j++) {
                            [days addObject:@""];
                        }
                    }
                }
                for (int j=0; j<[tokens count]; j++) {
                    id jelt = [tokens nth:j];
                    int day = [jelt intValue];

                    id event = nil;
                    for (int k=0; k<[_eventsArray count]; k++) {
                        id kelt = [_eventsArray nth:k];
                        int eventDay = [kelt intValueForKey:@"day"];
                        if (day == eventDay) {
                            int eventMonth = [kelt intValueForKey:@"month"];
                            if (month == eventMonth) {
                                int eventYear = [kelt intValueForKey:@"year"];
                                if (year == eventYear) {
                                    event = kelt;
                                    break;
                                }
                            }
                        }
                    }

                    if (event) {
                        [days addObject:event];
                    } else {
                        id str = nsfmt(@"year:%d month:%d day:%d", year, month, day);
                        [days addObject:str];
                    }
                }
                [self drawCalendarRow:days year:year month:month];
            } else if ([tokens count] == 2) {
                id monthName = [tokens nth:0];
                month = monthNameAsInt(monthName);
                year = [[tokens nth:1] intValue];
                [self panelText:nsfmt(@"%@ %d", monthName, year)];
                [self panelText:@""];
            } else if ([tokens length] == 7) {
                id daysofweek = nsarr();
                for (int j=0; j<[tokens count]; j++) {
                    id jelt = [tokens nth:j];
                    [daysofweek addObject:nsfmt(@"header:%@", jelt)];
                }
                [self drawCalendarRow:daysofweek square:NO year:year month:month];
            }
        }
    }
    [self drawCalendarRow:nsarr() year:year month:month];
}
- (void)panelText:(id)text color:(id)color
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    int x = _r.x;
    x += (_r.w - textWidth) / 2;
    if (color) {
        [_bitmap setColor:color];
    }
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}
- (void)panelText:(id)text
{
    [self panelText:text color:@"black"];
}
- (void)drawCalendarRow:(id)elts year:(int)year month:(int)month
{
    [self drawCalendarRow:elts square:YES year:year month:month];
}
- (void)drawCalendarRow:(id)elts square:(BOOL)square year:(int)year month:(int)month
{
    int count = 7;
    int cellW = _r.w/count;
    if (cellW == _r.w) {
        cellW--;
    }
    int cellH = cellW;
    if (!square) {
        cellH = [_bitmap bitmapHeightForText:@"X"] + 10;
    }
    int rowW = cellW*count+1;
    int offsetX = (_r.w - rowW)/2;
    [_bitmap setColor:@"black"];
    [_bitmap drawHorizontalLineAtX:_r.x+offsetX x:_r.x+offsetX+rowW-1 y:_cursorY];
    _cursorY += 1;
    if ([elts count] == 0) {
        return;
    }
    for (int i=0; i<=count; i++) {
        id elt = [elts nth:i];
        int x = _r.x+offsetX+i*cellW;
        int y = _cursorY;

        if (i == 7) {
            [_bitmap setColor:@"black"];
            [_bitmap drawVerticalLineAtX:x y:y y:_cursorY+cellH-1];
            continue;
        }

        if (![elt length]) {
            [_bitmap setColor:@"black"];
            [_bitmap drawVerticalLineAtX:x y:y y:_cursorY+cellH-1];
            [_bitmap setColor:@"white"];
            [_bitmap fillRectangleAtX:x+1 y:y w:cellW-1 h:cellH];
            continue;
        }

        id header = [elt valueForKey:@"header"];
        if ([header length]) {
            [_bitmap setColor:@"black"];
            [_bitmap drawVerticalLineAtX:x y:y y:_cursorY+cellH-1];
            [_bitmap setColor:@"#606060"];
            [_bitmap fillRectangleAtX:x+1 y:y w:cellW-1 h:cellH];
            [_bitmap setColor:@"white"];
            [_bitmap drawBitmapText:header x:x+5 y:y+5];
            continue;
        }

        int day = [elt intValueForKey:@"day"];
        if (!day) {
            continue;
        }

        id dayTextColor = @"black";
        id cellColor = [elt valueForKey:@"color"];
        if (![cellColor length]) {
            cellColor = @"white";
        }
        
        int buttonIndex = [_buttons count];

        if (_buttonHover == buttonIndex+1) {
            if (_buttonDown == _buttonHover) {
                cellColor = @"#0055aa";
                dayTextColor = @"white";
            } else if (!_buttonDown) {
                cellColor = @"orange";
                dayTextColor = @"white";
            }
        }

        [_bitmap setColor:cellColor];
        [_bitmap fillRectangleAtX:x+1 y:y w:cellW-1 h:cellH];

        [_bitmap setColor:@"black"];
        [_bitmap drawVerticalLineAtX:x y:y y:_cursorY+cellH-1];

        id dayText = nsfmt(@"%d", day);
        if (day == _currentDay) {
            if (month == _currentMonth) {
                if (year == _currentYear) {
                    [_bitmap setColor:dayTextColor];
                    [_bitmap fillRectangleAtX:x+4 y:y+4 w:cellW-8 h:cellH-8];
                    dayTextColor = cellColor;
                }
            }
        }
        [_bitmap setColor:dayTextColor];
        [_bitmap drawBitmapText:dayText x:x+5 y:y+5];
        {
            id eventText = [elt valueForKey:@"text"];
            if (eventText) {
                eventText = [_bitmap fitBitmapString:eventText width:cellW-10];
                int charHeight = [_bitmap bitmapHeightForText:@"X"];
                int maxLines = (cellH - 5 - charHeight - 5 - 5) / charHeight;
                if (maxLines > 0) {
                    eventText = [[[eventText split:@"\n"] subarrayToIndex:maxLines] join:@"\n"];
                    [_bitmap drawBitmapText:eventText x:x+5 y:y+5+charHeight+5];
                }
            }
        }

        if (buttonIndex < MAX_RECT) {
            [_buttons addObject:elt];
            _rect[buttonIndex].x = x;
            _rect[buttonIndex].y = y;
            _rect[buttonIndex].w = cellW;
            _rect[buttonIndex].h = cellH;
        }

    }
    _cursorY += cellH;
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
        id elt = [_buttons nth:_buttonDown-1];
        if (elt) {
            id cmd = nsarr();
            [cmd addObject:@"pucko"];
            [cmd addObject:@"showAlert:"];
            [cmd addObject:elt];
            [cmd runCommandInBackground];
        }
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
@end

