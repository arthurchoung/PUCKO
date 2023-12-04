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

@implementation Definitions(fmeklwfmklsdfklsdklf)
+ (id)enumerateExternalCSS:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    return [document enumerateExternalCSS:url];
}
@end

@implementation NSDictionary(fmkelwfmklsdmfklsdmklfmkl)
- (id)enumerateExternalCSS:(id)origURL
{
    id results = nil;

    id name = [self valueForKey:@"name"];

    if ([name isEqual:@"link"]) {
        id attrs = [self valueForKey:@"attrs"];
        id rel = [attrs valueForKey:@"rel"];
        if ([rel isEqual:@"stylesheet"]) {
            id href = [attrs valueForKey:@"href"];
            if (href) {
                id url = [href resolveURLWithURL:origURL];
                id css = [Definitions processLinkHrefCSS:url];
                if (css) {
                    if (results) {
                        [results addObjectsFromArray:css];
                    } else {
                        results = css;
                    }
                }
            }
        }
    }

    id children = [self valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        id css = [elt enumerateExternalCSS:origURL];
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
@end

@implementation Definitions(mfkelwmfklsdmklfmsdklfm)
+ (id)processLinkHrefCSS:(id)origURL
{
    id results = nsarr();

    id filename = [origURL urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:origURL];
    }
    id str = [filename stringFromFile];
    id arr = [str parseCSS];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        id type = [elt valueForKey:@"type"];
        if ([type isEqual:@"statement"]) {
            id text = [elt valueForKey:@"text"];
NSLog(@"text '%@'", text);
            id url1 = [text parseCSSImport];
            if (url1) {
                id url2 = [url1 resolveURLWithURL:origURL];
NSLog(@"url '%@' -> '%@'", url1, url2);
                id dict = nsdict();
                [dict setValue:@"debug" forKey:@"type"];
                [dict setValue:nsfmt(@"Processing '%@' (%@)", url1, url2) forKey:@"text"];
                [results addObject:dict];
                if (url2) {
                    id css = [Definitions processLinkHrefCSS:url2];
                    if (css) {
                        [results addObjectsFromArray:css];
                    }
                }
                continue;
            }
        }
        [results addObject:elt];
    }

    if ([results count]) {
        return results;
    }
    return nil;
}
@end

