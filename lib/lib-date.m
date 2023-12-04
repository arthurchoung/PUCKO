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

#include <time.h>

@implementation Definitions(fjksdlfkjsdfj)
+ (id)testYearWeek:(int)year
{
    id results = nsarr();
    for (int i=1; i<=53; i++) {
        [results addObject:[Definitions year:year week:i]];
    }
    return results;
}

+ (id)testPositiveDayOffset
{
    id results = nsarr();
    id date = [Definitions currentDateTime];
    for (int i=0; i<1000; i++) {
        date = [date dayOffset:1];
        [results addObject:date];
    }
    return results;
}
+ (id)testPositiveDayOffset2
{
    id results = nsarr();
    id date = [Definitions currentDateTime];
    for (int i=0; i<1000; i++) {
        [results addObject:[date dayOffset:i]];
    }
    return results;
}
+ (id)testNegativeDayOffset
{
    id results = nsarr();
    id date = [Definitions currentDateTime];
    for (int i=0; i<1000; i++) {
        date = [date dayOffset:-1];
        [results addObject:date];
    }
    return results;
}
+ (id)testNegativeDayOffset2
{
    id results = nsarr();
    id date = [Definitions currentDateTime];
    for (int i=0; i<1000; i++) {
        [results addObject:[date dayOffset:-i]];
    }
    return results;
}

+ (id)testWeekOfYear
{
    id results = nsarr();
    for (int year=2005; year<=2010; year++) {
        for (int day=1; day<=[Definitions daysInYear:year]; day++) {
            id comps = [Definitions year:year day:day];
            [results addObject:nsfmt(@"%@ / %.4d-W%.2d-%d", [comps asDateString], [comps yearForWeekOfYear], [comps weekOfYear], [comps dayOfWeek])];
        }
    }
    return results;
}

+ (int)currentYear
{
    time_t timestamp = time(0);
    struct tm *t = localtime(&timestamp);
    return t->tm_year+1900;
}
+ (int)currentMonth
{
    time_t timestamp = time(0);
    struct tm *t = localtime(&timestamp);
    return t->tm_mon+1;
}
+ (int)currentDay
{
    time_t timestamp = time(0);
    struct tm *t = localtime(&timestamp);
    return t->tm_mday;
}
+ (id)currentDateTime
{
    time_t timestamp = time(0);
    struct tm *t = localtime(&timestamp);
    return [Definitions year:t->tm_year+1900 month:t->tm_mon+1 day:t->tm_mday hour:t->tm_hour minute:t->tm_min second:t->tm_sec];
}
+ (id)dateTimeForTimestamp:(time_t)arg
{
    time_t timestamp = arg;
    struct tm *t = localtime(&timestamp);
    return [Definitions year:t->tm_year+1900 month:t->tm_mon+1 day:t->tm_mday hour:t->tm_hour minute:t->tm_min second:t->tm_sec];
}
@end

@implementation NSString(fjkdlsjkflsdjkf)

- (int)yearForWeekOfYear
{
    int year = [self year];
    int month = [self month];
    int day = [self day];
    int dayOfWeekForFirstDayOfYear = [[Definitions year:year month:1 day:1] dayOfWeek];
    int dayOfWeekForLastDayOfYear = [[Definitions year:year month:12 day:31] dayOfWeek];
    if ((month == 1) && (day == 1)) {
        switch (dayOfWeekForFirstDayOfYear) {
            case 1: // Monday
            case 2: // Tuesday
            case 3: // Wednesday
            case 4: // Thursday
                return [self year];
            case 5: // Friday
            case 6: // Saturday
            case 7: // Sunday
                return [self year]-1;
        }
    }
    if ((month == 1) && (day == 2)) {
        switch (dayOfWeekForFirstDayOfYear) {
            case 1: // Monday
            case 2: // Tuesday
            case 3: // Wednesday
            case 4: // Thursday
                return [self year];
            case 5: // Friday
            case 6: // Saturday
                return [self year]-1;
            case 7: // Sunday
                return [self year];
        }
    }
    if ((month == 1) && (day == 3)) {
        switch (dayOfWeekForFirstDayOfYear) {
            case 1: // Monday
            case 2: // Tuesday
            case 3: // Wednesday
            case 4: // Thursday
                return [self year];
            case 5: // Friday
                return [self year]-1;
            case 6: // Saturday
            case 7: // Sunday
                return [self year];
        }
    }
    if ((month == 12) && (day == 31)) {
        switch (dayOfWeekForLastDayOfYear) {
            case 1: // Monday
            case 2: // Tuesday
            case 3: // Wednesday
                return [self year]+1;
            case 4: // Thursday
            case 5: // Friday
            case 6: // Saturday
            case 7: // Sunday
                return [self year];
        }
    }
    if ((month == 12) && (day == 30)) {
        switch (dayOfWeekForLastDayOfYear) {
            case 1: // Monday
                return [self year];
            case 2: // Tuesday
            case 3: // Wednesday
                return [self year]+1;
            case 4: // Thursday
            case 5: // Friday
            case 6: // Saturday
            case 7: // Sunday
                return [self year];
        }
    }
    if ((month == 12) && (day == 29)) {
        switch (dayOfWeekForLastDayOfYear) {
            case 1: // Monday
            case 2: // Tuesday
                return [self year];
            case 3: // Wednesday
                return [self year]+1;
            case 4: // Thursday
            case 5: // Friday
            case 6: // Saturday
            case 7: // Sunday
                return [self year];
        }
    }
    return [self year];
}
- (int)weekOfYear
{
    int dayOfYear = [self dayOfYear];
    int year = [self year];
    int month = [self month];
    int day = [self day];
    int yearForWeekOfYear = [self yearForWeekOfYear];
    int dayOfWeekForFirstDayOfYear = [[Definitions year:year month:1 day:1] dayOfWeek];
    if (year < yearForWeekOfYear) {
        return 1;
    }
    if (year > yearForWeekOfYear) {
        if ((month == 1) && (day == 1)) {
            switch (dayOfWeekForFirstDayOfYear) {
                case 5: // Friday
                    return 53;
                case 6: // Saturday
                    if ([Definitions isLeapYear:year-1]) {
                        return 53;
                    } else {
                        return 52;
                    }
                case 7: // Sunday
                    return 52;
            }
        }
        if ((month == 1) && (day == 2)) {
            switch (dayOfWeekForFirstDayOfYear) {
                case 5: // Friday
                    return 53;
                case 6: // Saturday
                    if ([Definitions isLeapYear:year-1]) {
                        return 53;
                    } else {
                        return 52;
                    }
            }
        }
        if ((month == 1) && (day == 3)) {
            switch (dayOfWeekForFirstDayOfYear) {
                case 5: // Friday
                    return 53;
            }
        }
    }
    switch (dayOfWeekForFirstDayOfYear) {
        case 1: // Monday
            return ((dayOfYear-1)/7)+1;
        case 2: // Tuesday
            return ((dayOfYear+1-1)/7)+1;
        case 3: // Wednesday
            return ((dayOfYear+2-1)/7)+1;
        case 4: // Thursday
            return ((dayOfYear+3-1)/7)+1;
        case 5: // Friday
            return ((dayOfYear-3-1)/7)+1;
        case 6: // Saturday
            return ((dayOfYear-2-1)/7)+1;
        case 7: // Sunday
            return ((dayOfYear-1-1)/7)+1;
    }

    return 0;
}

- (int)daysUntil:(id)end
{
    id start = [Definitions year:[self year] month:[self month] day:[self day]];
    end = [Definitions year:[end year] month:[end month] day:[end day]];
    if (!start || !end) {
        return 0;
    }
    if (![start compareIsAscending:end]) {
        return 0;
    }
    id cursor = start;
    int count = 0;
    for (;;) {
        cursor = [cursor nextDay];
        count++;
        if ([cursor compareIsAscending:end]) {
            continue;
        }
        return count;
    }
}




- (id)dayOfWeekAsString
{
    switch([self dayOfWeek]) {
        case 1: return @"Monday";
        case 2: return @"Tuesday";
        case 3: return @"Wednesday";
        case 4: return @"Thursday";
        case 5: return @"Friday";
        case 6: return @"Saturday";
        case 7: return @"Sunday";
    }
    return @"Unknown";
}

- (id)monthAsString
{
    switch([self month]) {
        case 1: return @"January";
        case 2: return @"February";
        case 3: return @"March";
        case 4: return @"April";
        case 5: return @"May";
        case 6: return @"June";
        case 7: return @"July";
        case 8: return @"August";
        case 9: return @"September";
        case 10: return @"October";
        case 11: return @"November";
        case 12: return @"December";
    }
    return @"Unknown";
}

- (int)dayOfYear
{
    int day = 0;
    for (int i=1; i<[self month]; i++) {
        day += [Definitions daysInMonth:i year:[self year]];
    }
    day += [self day];
    return day;
}

- (id)nextYear
{
    return [Definitions year:[self year]+1 month:[self month] day:[self day]];
}

- (id)nextMonth
{
    return [Definitions year:[self year] month:[self month]+1 day:[self day]];
}

- (id)nextDay
{
    return [Definitions year:[self year] month:[self month] day:[self day]+1];
}

- (id)dayOffset:(int)offset
{
    if (offset > 0) {
        return [Definitions year:[self year] month:[self month] day:[self day]+offset];
    } else if (offset == 0) {
        return self;
    }

    int year = [self year];
    int month = [self month];
    int day = [self day];
    int newDay = day + offset;
    if (newDay >= 1) {
        return [Definitions year:year month:month day:newDay];
    }

    for(int i=0; i<-offset; i++) {
        day--;
        if (day == 0) {
            month--;
            if (month == 0) {
                year--;
                month = 12;
                day = 31;
                continue;
            }
            day = [Definitions daysInMonth:month year:year];
            continue;
        }
    }
    return [Definitions year:year month:month day:day];
}
- (id)asDateTimeString
{
    if (![self isValidDateTime]) {
        return nil;
    }
    return nsfmt(@"%@ %@", [self asDateString], [self asTimeString]);
}

- (id)asTimeStringNoSeconds
{
    if (![self isValidDateTime]) {
        return nil;
    }
    return [self sliceFrom:11 to:16];
}


- (id)asTimeString
{
    if (![self isValidDateTime]) {
        return nil;
    }
    return [self sliceFrom:11 to:19];
}

- (id)asDateString
{
    if (![self isValidDateTime]) {
        return nil;
    }
    return [self sliceFrom:0 to:10];
}

- (BOOL)isValidDateTime
{
    if ([self length] == 27) {
        return YES;
    }
    if ([self length] == 30) {
        return YES;
    }
    return NO;
}
- (int)year
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:0 to:4] intValue];
}
- (int)quarter
{
    if (![self isValidDateTime]) {
        return 0;
    }
    int month = [self month];
    return ((month-1)/3)+1;
}
- (int)month
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:5 to:7] intValue];
}
- (int)day
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:8 to:10] intValue];
}
- (int)hour
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:11 to:13] intValue];
}
- (int)minute
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:14 to:16] intValue];
}
- (int)second
{
    if (![self isValidDateTime]) {
        return 0;
    }
    return [[self sliceFrom:17 to:19] intValue];
}
- (int)weekday
{
    return [self dayOfWeek];
}
- (int)dayOfWeek
{
    return [Definitions dayOfWeekForYear:[self year] month:[self month] day:[self day]];
}
@end

@implementation Definitions(jfkdlsjfklsdjf)
+ (int)dayOfWeekForYear:(int)y month:(int)m day:(int)d
{
    if (m < 1) {
        m = 1;
    }
    if (m > 12) {
        m = 12;
    }
    if (d < 1) {
        d = 1;
    }
    y-=m<3;
    int dayOfWeek = (y+y/4-y/100+y/400+"-bed=pen+mad."[m]+d)%7;
    if (dayOfWeek == 0) {
        dayOfWeek = 7;
    }
    return dayOfWeek;
}

+ (id)year:(int)year week:(int)week
{
    int dayOfWeekForFirstDayOfYear = [[Definitions year:year month:1 day:1] dayOfWeek];
    switch (dayOfWeekForFirstDayOfYear) {
        case 1: // Monday
        case 2: // Tuesday
        case 3: // Wednesday
        case 4: // Thursday
        {
            id date = [Definitions year:year month:1 day:1];
            for (;;) {
                if ([date dayOfWeek] == 1) {
                    break;
                }
                date = [date dayOffset:-1];
            }
            return [date dayOffset:(week-1)*7];
        }
        case 5: // Friday
        case 6: // Saturday
        case 7: // Sunday
        {
            id date = [Definitions year:year month:1 day:1];
            for (;;) {
                if ([date dayOfWeek] == 1) {
                    break;
                }
                date = [date dayOffset:+1];
            }
            return [date dayOffset:(week-1)*7];
        }
    }
    
    return nil;
}
+ (id)year:(int)year day:(int)day
{
    return [Definitions year:year month:1 day:day hour:0 minute:0 second:0];
}
+ (id)year:(int)year
{
    return [Definitions year:year month:0 day:0 hour:0 minute:0 second:0];
}
+ (id)hour:(int)hour minute:(int)minute second:(int)second
{
    return [Definitions year:0 month:0 day:0 hour:hour minute:minute second:second];
}
+ (id)year:(int)year month:(int)month day:(int)day
{
    return [Definitions year:year month:month day:day hour:0 minute:0 second:0];
}
+ (id)year:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second
{
check_year:
    if (year > 9999) {
        year = year % 10000;
    }
    if (year < 0) {
        year = 0;
    }
check_month:
    if (month > 12) {
        year++;
        month -= 12;
        goto check_year;
    }
check_day:
    if (month > 0) {
        int daysInMonth = [Definitions daysInMonth:month year:year];
        if (day > daysInMonth) {
            month++;
            day -= daysInMonth;
            goto check_month;
        }
    }
    if (day < 0) {
        day = 0;
    }
check_hour:
    if (hour > 23) {
        day++;
        hour -= 24;
        goto check_day;
    }
    if (hour < 0) {
        hour = 0;
    }
check_minute:
    if (minute > 59) {
        hour++;
        minute -= 60;
        goto check_hour;
    }
    if (minute < 0) {
        minute = 0;
    }
    if (second > 59) {
        minute++;
        second -= 60;
        goto check_minute;
    }
    if (second < 0) {
        second = 0;
    }
    return nsfmt(@"%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.000000Z", year, month, day, hour, minute, second);
}

+ (int)isLeapYear:(int)year
{
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0) {
                return 1;
            } else {
                return 0;
            }
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}
+ (int)daysInYear:(int)year
{
    if ([Definitions isLeapYear:year]) {
        return 366;
    } else {
        return 365;
    }
}
+ (int)daysInMonth:(int)month year:(int)year
{
    switch(month) {
        case 1: return 31; // January
        case 2: // February
            if ([Definitions isLeapYear:year]) {
                return 29;
            } else {
                return 28;
            }
        case 3: return 31; // March
        case 4: return 30; // April
        case 5: return 31; // May
        case 6: return 30; // June
        case 7: return 31; // July
        case 8: return 31; // August
        case 9: return 30; // September
        case 10: return 31; // October
        case 11: return 30; // November
        case 12: return 31; // December
    }
    return 0;
}
@end

static int l(char *p, int idx)
{
    return (int)(*(p+idx));
}

static int d(char *p, int idx)
{
    return isdigit(l(p, idx));
}

static int c(char *p, int idx, int c)
{
    return (l(p, idx) == c) ? 1 : 0;
}

static int n(char *p, int idx)
{
    return l(p, idx) - '0';
}

@implementation NSString(fjklwpeofjksdjf)
- (id)parseDateComponents
{
    char *p = [self UTF8String];
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && (c(p, 4, '-') || c(p, 4, '.') || c(p, 4, '/')) && d(p, 5) && d(p, 6) && (c(p, 7, '-') || c(p, 7, '.') || c(p, 7, '/')) && d(p, 8) && d(p, 9) && c(p, 10, 0)) {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        return [Definitions year:year month:month day:day];
    }
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, 0)) {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        return [Definitions year:year month:month];
    }
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, 0)) {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        return [Definitions year:year];
    }
    if (d(p, 0) && d(p, 1) && c(p, 2, '/') && d(p, 3) && d(p, 4) && c(p, 5, '/') && d(p, 6) && d(p, 7) && d(p, 8) && d(p, 9) && c(p, 10, 0)) {
        int year = n(p, 6)*1000 + n(p, 7)*100 + n(p, 8)*10 + n(p, 9);
        int month = n(p, 0)*10 + n(p, 1);
        int day = n(p, 3)*10 + n(p, 4);
        return [Definitions year:year month:month day:day];
    }
    
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, '-') && d(p, 8) && d(p, 9)
        && c(p, 10, ' ')
        && d(p, 11) && d(p, 12) && c(p, 13, ':') && d(p, 14) && d(p, 15) && c(p, 16, 0))
    {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        int hour = n(p, 11)*10 + n(p, 12);
        int minute = n(p, 14)*10 + n(p, 15);
        return [Definitions year:year month:month day:day hour:hour minute:minute second:0];
    }
    
    
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, '-') && d(p, 8) && d(p, 9)
        && c(p, 10, ' ')
        && d(p, 11) && d(p, 12) && c(p, 13, ':') && d(p, 14) && d(p, 15) && c(p, 16, ':') && d(p, 17) && d(p, 18))
    {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        int hour = n(p, 11)*10 + n(p, 12);
        int minute = n(p, 14)*10 + n(p, 15);
        int second = n(p, 17)*10 + n(p, 18);
        return [Definitions year:year month:month day:day hour:hour minute:minute second:second];
    }
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, '-') && d(p, 8) && d(p, 9)
        && c(p, 10, 'T')
        && d(p, 11) && d(p, 12) && c(p, 13, ':') && d(p, 14) && d(p, 15) && c(p, 16, ':') && d(p, 17) && d(p, 18)
        && c(p, 19, '.')
        && d(p, 20) && d(p, 21) && d(p, 22) && d(p, 23) && d(p, 24) && d(p, 25)
        && c(p, 26, 'Z'))
    {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        int hour = n(p, 11)*10 + n(p, 12);
        int minute = n(p, 14)*10 + n(p, 15);
        int second = n(p, 17)*10 + n(p, 18);
        return [Definitions year:year month:month day:day hour:hour minute:minute second:second];
    }
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, '-') && d(p, 8) && d(p, 9)
        && c(p, 10, 'T')
        && d(p, 11) && d(p, 12) && c(p, 13, ':') && d(p, 14) && d(p, 15) && c(p, 16, ':') && d(p, 17) && d(p, 18)
        && c(p, 19, '+')
        && d(p, 20) && d(p, 21) && c(p, 22, ':') && d(p, 23) && d(p, 24)
        && c(p, 25, 0))
    {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        int hour = n(p, 11)*10 + n(p, 12);
        int minute = n(p, 14)*10 + n(p, 15);
        int second = n(p, 17)*10 + n(p, 18);
        return [Definitions year:year month:month day:day hour:hour minute:minute second:second];
    }
    if (d(p, 0) && d(p, 1) && d(p, 2) && d(p, 3) && c(p, 4, '-') && d(p, 5) && d(p, 6) && c(p, 7, '-') && d(p, 8) && d(p, 9)
        && c(p, 10, 'T')
        && d(p, 11) && d(p, 12) && c(p, 13, ':') && d(p, 14) && d(p, 15) && c(p, 16, ':') && d(p, 17) && d(p, 18)
        && c(p, 19, '.')
        && d(p, 20) && d(p, 21) && d(p, 22) && d(p, 23) && d(p, 24) && d(p, 25) && d(p, 26) && d(p, 27) && d(p, 28)
        && c(p, 29, 'Z'))
    {
        int year = n(p, 0)*1000 + n(p, 1)*100 + n(p, 2)*10 + n(p, 3);
        int month = n(p, 5)*10 + n(p, 6);
        int day = n(p, 8)*10 + n(p, 9);
        int hour = n(p, 11)*10 + n(p, 12);
        int minute = n(p, 14)*10 + n(p, 15);
        int second = n(p, 17)*10 + n(p, 18);
        return [Definitions year:year month:month day:day hour:hour minute:minute second:second];
    }
    
    return nil;
}

- (id)parseTimeComponents
{
    char *p = [self UTF8String];
    if (d(p, 0) && d(p, 1) && c(p, 2, ':') && d(p, 3) && d(p, 4) && c(p, 5, ':') && d(p, 6) && d(p, 7) && c(p, 8, 0)) {
        int h = n(p, 0)*10 + n(p, 1);
        int m = n(p, 3)*10 + n(p, 4);
        int s = n(p, 6)*10 + n(p, 7);
        return [Definitions hour:h minute:m second:s];
    }
    if (d(p, 0) && d(p, 1) && (c(p, 2, ':') || c(p, 2, '.')) && d(p, 3) && d(p, 4) && c(p, 5, 0)) {
        int h = n(p, 0)*10 + n(p, 1);
        int m = n(p, 3)*10 + n(p, 4);
        return [Definitions hour:h minute:m second:0];
    }
    return nil;
}

@end



