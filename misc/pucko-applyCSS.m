/*

 PUCKO Web

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Web.

 PUCKO Web is free software: you can redistribute it and/or modify
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

@implementation NSDictionary(jefklwmfklsdmfklsdmklf)
- (void)applyCSS:(id)css
{
    for (int i=0; i<[css count]; i++) {
        id elt = [css nth:i];
        id type = [elt valueForKey:@"type"];
        if ([type isEqual:@"property"]) {
            id selectorTextArray = [elt valueForKey:@"selectorTextArray"];
            id text = [elt valueForKey:@"text"];
            id property = [text parseCSSProperty];
            id key = [property valueForKey:@"key"];
            id value = [property valueForKey:@"value"];
            [self applyCSSSelector:selectorTextArray property:key value:value];
        }
    }
}
- (void)applyInlineCSS:(id)css
{
    for (int i=0; i<[css count]; i++) {
        id elt = [css nth:i];
        id type = [elt valueForKey:@"type"];
        if ([type isEqual:@"statement"]) {
            id text = [elt valueForKey:@"text"];
            id property = [text parseCSSProperty];
            id key = [property valueForKey:@"key"];
            id value = [property valueForKey:@"value"];
            [self applyCSSProperty:key value:value];
        }
    }
}
@end

