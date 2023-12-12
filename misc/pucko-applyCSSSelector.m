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

@implementation NSDictionary(mflewmfklsdmklfmklsdfmklsdmf)
- (void)applyCSSSelector:(id)selectorTextArray property:(id)property value:(id)value
{
    int count = [selectorTextArray count];
    if (!count) {
        return;
    }
    if (count != 1) {
        NSOut(@"Error, nested selector not supported '%@'\n", selectorTextArray);
        return;
    }
    id selectorText = [selectorTextArray nth:0];
    selectorText = [selectorText trim];
    NSOut(@"selector '%@'\n", selectorText);
    [self applyCSSElementSelector:selectorText property:property value:value];
}

- (void)applyCSSElementSelector:(id)selector property:(id)property value:(id)value
{
    id name = [self valueForKey:@"name"];
    if ([name isEqual:selector]) {
        [self applyCSSProperty:property value:value];
    }

    id children = [self valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [elt applyCSSElementSelector:selector property:property value:value];
    }
}
@end

