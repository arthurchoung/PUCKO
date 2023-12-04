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

static void printAttrsForNode(id node)
{
    id tag = [node valueForKey:@"name"];
    id attrs = [node valueForKey:@"attrs"];
    id keys = [attrs allKeys];
    for (int i=0; i<[keys count]; i++) {
        id key = [keys nth:i];
        NSOut(@"tag:%@ key:%@ value:%@\n", tag, key, [attrs valueForKey:key]);
    }

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        printAttrsForNode(elt);
    }
}

@implementation Definitions(fmekwlfmklsdmfklmsdklfmklsfjkdsjkfjfkds)
+ (void)printAttrs
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    printAttrsForNode(document);
}
+ (void)printAttrs:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    printAttrsForNode(document);
}
@end

