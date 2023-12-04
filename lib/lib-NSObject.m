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

@implementation NSObject(sdfdsfdsfsdfdsf)
- (void)addToArray:(id)arr
{
    [arr addObject:self];
}
- (id)self
{
    return self;
}
- (id)returnNil
{
    return nil;
}
- (id)asPercentageInt
{
    return nsfmt(@"%d%%", (int)([self doubleValue]*100.0));
}
- (id)asPercentage
{
    return nsfmt(@"%+.2f%%", [self doubleValue]*100.0);
}

- (id)asPercentageString
{
    return nsfmt(@"%+.2f%%", [self doubleValue]*100.0);
}

- (id)percentageString
{
    return nsfmt(@"%+.2f%%", [self doubleValue]*100.0);
}
- (id)join:(id)separator
{
    return self;
}

- (void)ignoreReturnValueForMessage:(id)message
{
    [self evaluateMessage:message];
}
- (id)plus:(id)obj
{
    if (!obj) {
        return nil;
    }
    return nsfmt(@"%f", [self doubleValue] + [obj doubleValue]);
}
- (id)minus:(id)obj
{
    if (!obj) {
        return nil;
    }
    return nsfmt(@"%f", [self doubleValue] - [obj doubleValue]);
}
- (id)times:(id)obj
{
    if (!obj) {
        return nil;
    }
    return nsfmt(@"%f", [self doubleValue] * [obj doubleValue]);
}
- (id)dividedBy:(id)obj
{
    if (!obj) {
        return nil;
    }
    return nsfmt(@"%f", [self doubleValue] / [obj doubleValue]);
}
- (id)allKeysAndValues
{
    return nil;
}
- (id)arrayForKey:(id)key
{
    id val = [self valueForKey:key];
    if (isnsarr(val)) {
        return val;
    }
    val = nsarr();
    [self setValue:val forKey:key];
    return val;
}

- (id)dictForKey:(id)key
{
    id val = [self valueForKey:key];
    if (isnsdict(val)) {
        return val;
    }
    val = nsdict();
    [self setValue:val forKey:key];
    return val;
}

- (id)dictionaryForKey:(id)key
{
    return [self dictForKey:key];
}

- (BOOL)boolValue
{
    return NO;
}
- (int)intValue
{
    return 0;
}
- (BOOL)key:(id)key isEqual:(id)obj
{
    id val = [self valueForKey:key];
    return [val isEqual:obj];
}

- (void)incrementKey:(id)key
{
    int val = [self intValueForKey:key];
    [self setValue:nsfmt(@"%d", val+1) forKey:key];
}

- (void)decrementKey:(id)key
{
    int val = [self intValueForKey:key];
    [self setValue:nsfmt(@"%d", val-1) forKey:key];
}

- (int)intValueForKey:(id)key
{
    return [[self valueForKey:key] intValue];
}
- (int)intValueForKey:(id)key default:(int)def
{
    id val = [self valueForKey:key];
    if (!val) {
        return def;
    }
    return [val intValue];
}
- (double)doubleValueForKey:(id)key
{
    return [[self valueForKey:key] doubleValue];
}
- (long)longValueForKey:(id)key
{
    return [[self valueForKey:key] longValue];
}
- (unsigned long)unsignedLongValueForKey:(id)key
{
    return [[self valueForKey:key] unsignedLongValue];
}

+ (id)asInstance
{
    return [[[self alloc] init] autorelease];
}
- (id)asString
{
    return [self description];
}

- (int)compare:(id)compareObject key:(id)key
{
    id a = self;
    id b = compareObject;
    
    id aa = [a valueForKey:key];
    if (!aa) {
        return -1;
    }
    id bb = [b valueForKey:key];
    if (!bb) {
        return 1;
    }
    return [aa compare:bb];
}

- (int)reverseCompare:(id)compareObject
{
    int result = [self compare:compareObject];
    if (result > 0) {
        return -1;
    } else if (result < 0) {
        return 1;
    } else {
        return 0;
    }
}
- (int)reverseCompare:(id)compareObject key:(id)key
{
    int result = [self compare:compareObject key:key];
    if (result > 0) {
        return -1;
    } else if (result < 0) {
        return 1;
    } else {
        return 0;
    }
}


- (id)ifTrue:(id)ifMessage then:(id)thenMessage
{
    id result = [self evaluateMessage:ifMessage];
    if ([result intValue]) {
        return [self evaluateMessage:thenMessage];
    }
    return self;
}
- (id)ifFalse:(id)ifMessage then:(id)thenMessage
{
    id result = [self evaluateMessage:ifMessage];
    if (![result intValue]) {
        return [self evaluateMessage:thenMessage];
    }
    return self;
}
- (id)ifTrue:(id)ifMessage then:(id)thenMessage else:(id)elseMessage
{
    id result = [self evaluateMessage:ifMessage];
    if ([result intValue]) {
        return [self evaluateMessage:thenMessage];
    } else {
        return [self evaluateMessage:elseMessage];
    }
}
- (id)ifFalse:(id)ifMessage then:(id)thenMessage else:(id)elseMessage
{
    id result = [self evaluateMessage:ifMessage];
    if (![result intValue]) {
        return [self evaluateMessage:thenMessage];
    } else {
        return [self evaluateMessage:elseMessage];
    }
}
- (id)if:(id)ifMessage then:(id)thenMessage
{
    id result = [self evaluateMessage:ifMessage];
    if ([result intValue]) {
        return [self evaluateMessage:thenMessage];
    }
    return self;
}
- (id)if:(id)ifMessage then:(id)thenMessage else:(id)elseMessage
{
    id result = [self evaluateMessage:ifMessage];
    if ([result intValue]) {
        return [self evaluateMessage:thenMessage];
    } else {
        return [self evaluateMessage:elseMessage];
    }
}

- (BOOL)compareIsAscending:(id)obj
{
    return (obj && ([self compare:obj] < 0)) ? YES : NO;
}
- (BOOL)compareIsDescending:(id)obj
{
    return (obj && ([self compare:obj] > 0)) ? YES : NO;
}
- (BOOL)compareIsSame:(id)obj
{
    return (obj && ([self compare:obj] == 0)) ? YES : NO;
}

- (id)return:(id)arg
{
    return arg;
}


- (void)toggleBoolKey:(id)key
{
    id val = [self valueForKey:key];
    NSLog(@"toggleBoolKey:%@ old val %@", key, val);
    val = ([val intValue]) ? @"0" : @"1";
    [self setValue:val forKey:key];
    NSLog(@"new val %@", [self valueForKey:key]);
}

- (id)str:(id)str
{
    return [str strWithContext:self];
}

- (void)nop:(id)arg
{
}

- (id)null
{
    return nil;
}

- (id)asDictionaryWithKey:(id)key
{
    id dict = nsdict();
    [dict setValue:self forKey:key];
    NSLog(@"dict %@ %@", [dict allKeys], [dict allValues]);
    return dict;
}


- (id)asArray
{
    id arr = nsarr();
    [arr addObject:self];
    return arr;
}

- (BOOL)numericallyGreaterThan:(double)val
{
    return ([self doubleValue] > val) ? YES : NO;
}
- (BOOL)numericallyLessThan:(double)val
{
    return ([self doubleValue] < val) ? YES : NO;
}
- (BOOL)isGreaterThan:(id)obj
{
    return ([self compare:obj] > 0) ? YES : NO;
}
- (BOOL)isGreaterThanOrEqualTo:(id)obj
{
    return ([self compare:obj] < 0) ? NO : YES;
}
- (BOOL)isLessThan:(id)obj
{
    return ([self compare:obj] < 0) ? YES : NO;
}
- (BOOL)isLessThanOrEqualTo:(id)obj
{
    return ([self compare:obj] > 0) ? NO : YES;
}



- (double)doubleValue
{ return 0.0; }






- (void)toNSLog
{
    NSLog(@"toNSLog %@", self);
}

- (void)toNSLog:(id)str
{
    NSLog(@"toNSLog '%@' self %@", [self str:str], self);
}


@end
