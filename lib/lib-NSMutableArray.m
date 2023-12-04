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

#include <stdarg.h>

#ifdef BUILD_FOR_IOS
@implementation NSMutableArray(main)
#else
@implementation NSArray(fjkdslfjklsdjfklsdjk)
#endif

- (void)push:(id)object
{
    [self addObject:object];
}

#ifdef BUILD_FOR_LINUX
- (void)removeLastObject
{
    int count = [self count];
    if (count < 1) {
        return;
    }
    [self removeObjectAtIndex:count-1];
}
#endif

- (id)pop
{
    if ([self count] > 0) {
        id object = [[self lastObject] retain];
        [self removeLastObject];
        [object autorelease];
        return object;
    }
    else {
        return nil;
    }
}

- (id)shift
{
    if ([self count] == 0) {
        return nil;
    }
    id obj = [[self objectAtIndex:0] retain];
    [self removeObjectAtIndex:0];
    return [obj autorelease];
}

@end
