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

@implementation NSDictionary(fmeklwmfklsdmfklmsdkfjfdksjfksd)
- (void)processInternalCSS
{
    id css = [self enumerateInternalCSS];
    [self applyCSS:css];
}
- (void)processExternalCSS:(id)url
{
    id css = [self enumerateExternalCSS:url];
    [self applyCSS:css];
}
- (void)processInlineCSS
{
    id name = [self valueForKey:@"name"];

    id attrs = [self valueForKey:@"attrs"];
    id style = [attrs valueForKey:@"style"];
    if (style) {
        id css = [style parseCSS];
        [self applyInlineCSS:css];
    }

    id children = [self valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [elt processInlineCSS];
    }
}
@end

