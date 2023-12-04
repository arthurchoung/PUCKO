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

@implementation NSDictionary(fmklewmfkldmsklfmklsdmfklsdmf)
- (void)applyCSSProperty:(id)key value:(id)value
{
    NSOut(@"apply css property key '%@' value '%@' to '%@'\n", key, value, [self valueForKey:@"name"]);
    if ([key isEqual:@"width"]) {
        [self setValue:value forKey:@"cssWidth"];
    } else if ([key isEqual:@"color"]) {
        [self setValue:value forKey:@"cssColor"];
    }
}
@end

