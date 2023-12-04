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

static id processStyleTextForNode(id node)
{
    id results = nil;

    id name = [node valueForKey:@"name"];

    if ([name isEqual:@"style"]){ 
        id children = [node valueForKey:@"children"];
        for (int i=0; i<[children count]; i++) {
            id elt = [children nth:i];
            id type = [elt valueForKey:@"type"];
            if ([type isEqual:@"Text"]) {
                id text = [elt valueForKey:@"text"];
                id css = [text parseCSS];
                if (css) {
                    if (results) {
                        [results addObjectsFromArray:css];
                    } else {
                        results = css;
                    }
                }
            }
        }
        return results;
    }

    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        id css = processStyleTextForNode(elt);
        if (css) {
            if (results) {
                [results addObjectsFromArray:css];
            } else {
                results = css;
            }
        }
    }
    return results;
}

@implementation Definitions(fmekwlfmklsdmfklmsdklfmklsfjkdsjkfjfdksfjfdjskfsd)
+ (id)enumerateInternalCSS:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    return processStyleTextForNode(document);
}
@end

@implementation NSDictionary(fmekwlfmklsdklfmklsdfmk)
- (id)enumerateInternalCSS
{
    return processStyleTextForNode(self);
}
@end

