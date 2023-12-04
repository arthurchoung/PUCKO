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

@implementation Definitions(fjieowfjkldsjflksdjkfl)
+ (id)NSArray
{
    return nsarr();
}
@end




@implementation NSArray(sdsadff)
- (void)addToArray:(id)arr
{
    [arr addObjectsFromArray:self];
}
- (id)asDictionaryGroupByKey:(id)groupKey
{
    id results = nsdict();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id eltKey = [elt valueForKey:groupKey];
        if (eltKey) {
            [results addObject:elt intoArrayForKey:eltKey];
        }
    }
    return results;
}




- (id)strWithContext:(id)context
{
    return nsfmt(@"NSArray strWithContext %@", [self description]);
}


- (BOOL)writeToFile:(id)path
{
    return [self writeLinesToFile:path];
}

- (id)nth:(int)n
{
    if (n < 0) {
        return nil;
    }
    if (n >= [self count]) {
        return nil;
    }
    return [self objectAtIndex:n];
}
- (id)subarrayFromIndex:(int)index
{
    if (index < 0) {
        int loc = [self count] + index;
        if (loc < 0) {
            loc = 0;
        }
        int len = [self count] - loc;
        return [self subarrayFromLocation:loc length:len];
    }
    if (index >= [self count]) {
        return nil;
    }
    int location = index;
    int length = [self count] - index;
    if (!length) {
        return nil;
    }
    return [self subarrayFromLocation:location length:length];
}
- (id)filterEmptyStrings
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([elt length]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}
- (id)join:(id)obj
{
    return [self componentsJoinedByString:obj];
}





- (void)setAllValues:(id)val forKey:(id)key
{
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        [elt setValue:val forKey:key];
    }
}


- (id)lowest
{
    id lowest = nil;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!lowest) {
            lowest = elt;
        } else if ([elt compare:lowest] < 0) {
            lowest = elt;
        }
    }
    return lowest;
}

- (id)highest
{
    id highest = nil;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!highest) {
            highest = elt;
        } else if ([elt compare:highest] > 0) {
            highest = elt;
        }
    }
    return highest;
}

- (id)removeIfContainsString:(id)string
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (![elt containsString:string]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

- (id)keepIfKey:(id)key startsWith:(id)string
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id val = [elt valueForKey:key];
        if ([val startsWith:string]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}
- (id)keepIfKey:(id)key equals:(id)string
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id val = [elt valueForKey:key];
        if ([val isEqual:string]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

- (id)keepIfContainsString:(id)string
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([elt containsString:string]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

- (id)keepPrefix:(id)prefix
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([elt hasPrefix:prefix]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}
- (id)keepSuffix:(id)suffix
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([elt hasSuffix:suffix]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

static int qsort_asArraySortedWithKey(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    id key = arg;
    return (int)[a compare:b key:key];
}

- (id)asArraySortedWithKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_asArraySortedWithKey argument:key];
}

- (id)sortedWithKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_asArraySortedWithKey argument:key];
}

static int qsort_asArrayReverseSortedWithKey(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    id key = arg;
    return (int)[a reverseCompare:b key:key];
}

- (id)asArrayReverseSortedWithKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_asArrayReverseSortedWithKey argument:key];
}

- (id)reverseSortedWithKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_asArrayReverseSortedWithKey argument:key];
}

static int qsort_asArrayReverseSortedWithKeys(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    id keys = arg;
    for (int i=0; i<[keys count]; i++) {
        id key = [keys nth:i];
        int cmp = [a reverseCompare:b key:key];
        if (cmp != 0) {
            return cmp;
        }
    }
    return 0;
}

- (id)asArrayReverseSortedWithKeys:(id)keys
{
    return [self asArraySortedWithFunction:qsort_asArrayReverseSortedWithKeys argument:keys];
}

static int qsort_asReverseSortedArray(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    return (int)[a reverseCompare:b];
}

- (id)reverseSort
{
    return [self asArraySortedWithFunction:qsort_asReverseSortedArray argument:nil];
}

- (id)asReverseSortedArray
{
    return [self asArraySortedWithFunction:qsort_asReverseSortedArray argument:nil];
}

static int qsort_asSortedArray(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    return (int)[a compare:b];
}

- (id)asSortedArray
{
    return [self asArraySortedWithFunction:qsort_asSortedArray argument:nil];
}

- (id)sort
{
    return [self asArraySortedWithFunction:qsort_asSortedArray argument:nil];
}

static int qsort_numericSortWithKey(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    id key = arg;
    double aa = [[a valueForKey:key] doubleValue];
    double bb = [[b valueForKey:key] doubleValue];
    if (aa < bb) {
        return -1;
    }
    if (aa > bb) {
        return 1;
    }
    return 0;
}

- (id)numericSortForKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_numericSortWithKey argument:key];
}

static int qsort_reverseNumericSortWithKey(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    id key = arg;
    double aa = [[a valueForKey:key] doubleValue];
    double bb = [[b valueForKey:key] doubleValue];
    if (aa < bb) {
        return 1;
    }
    if (aa > bb) {
        return -1;
    }
    return 0;
}

- (id)reverseNumericSortForKey:(id)key
{
    return [self asArraySortedWithFunction:qsort_reverseNumericSortWithKey argument:key];
}

- (id)numericKeySort
{
    return [self numericSortForKey:@"key"];
}

- (id)numericValueSort
{
    return [self numericSortForKey:@"value"];
}

- (id)reverseNumericValueSort
{
    return [self reverseNumericSortForKey:@"value"];
}

static int qsort_numericSort(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    double aa = [a doubleValue];
    double bb = [b doubleValue];
    if (aa < bb) {
        return -1;
    } else if (aa > bb) {
        return 1;
    } else {
        return 0;
    }
}

- (id)numericSort
{
    return [self asArraySortedWithFunction:qsort_numericSort argument:nil];
}

static int qsort_reverseNumericSort(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);
    double aa = [a doubleValue];
    double bb = [b doubleValue];
    if (aa < bb) {
        return 1;
    } else if (aa > bb) {
        return -1;
    } else {
        return 0;
    }
}


- (id)reverseNumericSort
{
    return [self asArraySortedWithFunction:qsort_reverseNumericSort argument:nil];
}

- (id)asDictionary
{
    id dict = nsdict();
    id key = nil;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!key) {
            key = elt;
            continue;
        }
        [dict setValue:elt forKey:key];
        key = nil;
    }
    return dict;
}

- (id)keepObjectsEqualTo:(id)objectToKeep
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([elt isEqual:objectToKeep]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

- (id)asStringForKeys:(id)keys titleKeys:(id)titleKeys
{
    int minLength = 4;
    id results = nsarr();
    
    id titleArr = nsarr();
    for (int i=0; i<[titleKeys count]; i++) {
        id obj = [titleKeys nth:i];
        [titleArr addObject:[[[self valueForKey:obj] uniq] join:@""]];
    }
    id title = [titleArr join:@"  "];
    if (title) {
        [results addObject:title];
        [results addObject:@""];
    }
    
    id header = nsarr();
    for (int i=0; i<[keys count]; i++) {
        id key = [keys nth:i];
        int len = [key length];
        if (len < minLength) {
            len = minLength;
        }
        [header addObject:nsfmt(@"%-*s", len, [key UTF8String])];
    }
    header = [header join:@"  "];
    
    id arr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id obj = [self nth:i];
        id mapArr = nsarr();
        for (int j=0; j<[keys count]; j++) {
            id key = [keys nth:j];
            int len = [key length];
            if (len < minLength) {
                len = minLength;
            }
            id val = [obj valueForKey:key];
            if ([val isKindOfClass:[@"NSNumber" asClass]]) {
                [mapArr addObject:nsfmt(@"%-*d", len, [[obj valueForKey:key] intValue])];
            } else {
                [mapArr addObject:nsfmt(@"%-*.*@", len, len, val)];
            }
        }
        [arr addObject:[mapArr join:@"  "]];
    }
    [results addObject:header];
    [results addObjectsFromArray:arr];
    return [results join:@"\n"];
}

- (id)uniq
{
    id results = nsarr();
    id prev = nil;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([prev isEqual:elt]) {
            continue;
        }
        [results addObject:elt];
        prev = elt;
    }
    return results;
}

- (id)asString
{
    return [self asStringForKeys:[[self allKeys] sort] titleKeys:nil];
}

- (id)asStringWithHeaderMessage:(id)message
{
    id header = (message) ? [self evaluateMessage:message] : nil;
    header = (header) ? [header cat:@"\n\n"] : @"";
    id str = [self asStringForKeys:[[self allKeys] sort] titleKeys:nil];
    return [header cat:str];
}


- (id)asDictionaryCount
{
    id results = nsdict();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        [results incrementKey:elt];
    }
    return results;
}

- (id)asMergedDictionary
{
    id results = nsdict();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        [results addEntriesFromDictionary:elt];
    }
    return results;
}

- (id)objectWithValue:(id)value forMessage:(id)message
{
    if (!value) {
        return nil;
    }
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([[elt evaluateMessage:message] isEqual:value]) {
            return elt;
        }
    }
    return nil;
}

- (id)objectWithValue:(id)value forKey:(id)key
{
    if (!value) {
        return nil;
    }
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([[elt valueForKey:key] isEqual:value]) {
            return elt;
        }
    }
    return nil;
}

- (id)objectWithValueContainingString:(id)str forKey:(id)key
{
    if (!str) {
        return nil;
    }
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([[elt valueForKey:key] containsString:str]) {
            return elt;
        }
    }
    return nil;
}

- (id)sliceFrom:(int)fromIndex to:(int)toIndex
{
    return [self subarrayFromLocation:fromIndex length:toIndex-fromIndex];
}
- (id)sliceTo:(int)index
{
    return [self subarrayToIndex:index];
}
- (id)sliceFrom:(int)index
{
    return [self subarrayFromIndex:index];
}
- (int)minInt
{
    BOOL first = YES;
    int lowest = 0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        int val = [elt intValue];
        if (first) {
            lowest = val;
            first = NO;
        } else if (val < lowest) {
            lowest = val;
        }
    }
    return lowest;
}
- (double)minDouble
{
    BOOL first = YES;
    double lowest = 0.0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        double val = [elt doubleValue];
        if (first) {
            lowest = val;
            first = NO;
        } else if (val < lowest) {
            lowest = val;
        }
    }
    return lowest;
}
- (id)min
{
    id arr = [self asSortedArray];
    return [arr nth:0];
}

- (int)maxInt
{
    BOOL first = YES;
    int highest = 0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        int val = [elt intValue];
        if (first) {
            highest = val;
            first = NO;
        } else if (val > highest) {
            highest = val;
        }
    }
    return highest;
}
- (double)maxDouble
{
    BOOL first = YES;
    double highest = 0.0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        double val = [elt doubleValue];
        if (first) {
            highest = val;
            first = NO;
        } else if (val > highest) {
            highest = val;
        }
    }
    return highest;
}

- (id)max
{
    id arr = [self asSortedArray];
    int count = [arr count];
    if (!count) {
        return nil;
    }
    return [arr nth:count-1];
}
- (id)median
{
    int count = [self count];
    if (count == 0) {
        return nil;
    } else if (count % 2 == 1) {
        return [self nth:count/2];
    } else {
        double a = [[self nth:count/2-1] doubleValue];
        double b = [[self nth:count/2] doubleValue];
        return nsfmt(@"%f", (a+b)/2.0);
    }
}

- (id)average
{
    int count = [self count];
    if (!count) {
        return @"0";
    }
    id sum = [self sum];
    return [sum dividedBy:nsfmt(@"%d", count)];
}
- (double)averageDouble
{
    int count = [self count];
    if (!count) {
        return 0.0;
    }
    double sum = [self sumDouble];
    return sum / (double)count;
}

- (double)sumDouble
{
    double result = 0.0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        result += [elt doubleValue];
    }
    return result;
}
- (int)sumIntegers
{
    int result = 0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        result += [elt intValue];
    }
    return result;
}
- (id)sum
{
    id result = @"0";
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        result = [result plus:elt];
    }
    return result;
}

- (id)asReverseArray
{
    id arr = nsarr();
    for (int i=[self count]-1; i>=0; i--) {
        id elt = [self nth:i];
        if (elt) {
            [arr addObject:elt];
        }
    }
    return arr;
}
- (id)reverse
{
    id arr = nsarr();
    for (int i=[self count]-1; i>=0; i--) {
        id elt = [self nth:i];
        if (elt) {
            [arr addObject:elt];
        }
    }
    return arr;
}

- (id)randomObject
{
    int count = [self count];
    if (!count) {
        return nil;
    }
    int index = [Definitions randomInt:count];
    return [self nth:index];
}

- (id)tail:(int)n
{
    int count = [self count];
    int index = count - n;
    if (index >= count) {
        return nil;
    }
    if (index <= 0) {
        return self;
    }
    return [self subarrayFromIndex:index];
}





- (id)chompEmptyLine
{
    id lastObject = [self lastObject];
    if ([lastObject isEqual:@""]) {
        return [self subarrayToIndex:[self count]-1];
    }
    return self;
}

- (id)cat:(id)arr
{
    return [self arrayByAddingObjectsFromArray:arr];
}

- (id)keepIfTrue:(id)message
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([[elt evaluateMessage:message] boolValue]) {
            [keepArr addObject:elt];
        }
    }
    return keepArr;
}

- (int)length
{
    return [self count];
}

- (int)depth
{
    return [self count];
}

- (id)top
{
    return [self lastObject];
}

- (id)keep:(id)message
{
    id results = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if ([[elt evaluateMessage:message] intValue]) {
            [results addObject:elt];
        }
    }
    return results;
}
- (id)mapMessage:(id)message
{
    return [self mapMessage:message nullValue:@"(null)"];
}
- (id)mapMessage:(id)message nullValue:(id)nullValue
{
    id results = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id obj = [elt evaluateMessage:message];
        [results addObject:(obj) ? obj : nullValue];
    }
    return results;
}
- (void)forEachMessage:(id)message
{
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id pool = [[NSAutoreleasePool alloc] init];

        [elt evaluateMessage:message];

        [pool drain];
    }
}

- (id)allKeys
{
    id results = nsdict();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        id allKeys = [elt allKeys];
        for (int j=0; j<[allKeys count]; j++) {
            id key = [allKeys nth:j];
            if ([key hasPrefix:@"_"] && ![key containsString:@"."]) {
                continue;
            }
            [results setValue:@"1" forKey:key];
        }
    }
    return [results allKeys];
}

- (id)subarrayToIndex:(int)index
{
    if (index == 0) {
        return self;
    }
    if (index < 0) {
        return [self subarrayToIndex:[self count]+index];
    }
    return [self subarrayFromLocation:0 length:index];
}

- (id)subarrayBetweenIndex:(int)index1 and:(int)index2
{
    if (index1 < 0) {
        return nil;
    }
    if (index2 < 0) {
        return nil;
    }
    int start, end;
    if (index1 < index2) {
        start = index1;
        end = index2;
    } else {
        start = index2;
        end = index1;
    }
    return [self subarrayFromLocation:start length:end-start+1];
}


- (int)indexForHighestKeyValue:(id)key
{
    id highest = nil;
    int index = 0;
    int highestIndex = 0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!highest) {
            highest = elt;
        } else {
            if ([[elt valueForKey:key] compare:[highest valueForKey:key]] > 0) {
                highest = elt;
                highestIndex = index;
            }
        }
        index++;
    }
    return highestIndex;
}

- (int)indexForLowestKeyValue:(id)key
{
    id lowest = nil;
    int index = 0;
    int lowestIndex = 0;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!lowest) {
            lowest = elt;
        } else {
            if ([[elt valueForKey:key] compare:[lowest valueForKey:key]] < 0) {
                lowest = elt;
                lowestIndex = index;
            }
        }
        index++;
    }
    return lowestIndex;
}



- (id)asShuffledArray
{
    id src = [[self mutableCopy] autorelease];
    id dst = nsarr();
    for (;;) {
        int count = [src count];
        if (count == 0) {
            break;
        }
        int index = [Definitions randomInt:count];
        id elt = [src nth:index];
        [dst addObject:elt];
        [src removeObjectAtIndex:index];
    }
    return dst;
}

@end

