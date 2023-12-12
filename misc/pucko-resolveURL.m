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

@implementation NSString(fmeklwfmklsdmfklsdmklfmklsdmf)
- (id)asRootURL
{
    char *cstr = [self UTF8String];
    if (((cstr[0] >= 'a') && (cstr[0] <= 'z')) || ((cstr[0] >= 'A') && (cstr[0] <= 'Z'))) {
        char *p = cstr + 1;
        for(;;) {
            if (!*p) {
                return nil;
            }
            if (*p == ':') {
                p++;
                break;
            }
            if (((*p >= 'a') && (*p <= 'z')) || ((*p >= 'A') && (*p <= 'Z')) || ((*p >= '0') && (*p <= '9')) || (*p == '+') || (*p == '-') || (*p == '.')) {
                p++;
                continue;
            }
            return nil;
        }
        if (*p != '/') {
            return nil;
        }
        p++;
        if (*p != '/') {
            return nil;
        }
        p++;
        if (!*p || (*p == '/')) {
            return nil;
        }
        p++;
        for(;;) {
            if (!*p) {
                break;
            }
            if (*p == '/') {
                p++;
                break;
            }
            p++;
        }

        return nsfmt(@"%.*s", p-cstr, cstr);
    }
    return nil;
}
- (id)asBaseURL
{
    char *cstr = [self UTF8String];
    if (((cstr[0] >= 'a') && (cstr[0] <= 'z')) || ((cstr[0] >= 'A') && (cstr[0] <= 'Z'))) {
        char *p = cstr + 1;
        for(;;) {
            if (!*p) {
                return nil;
            }
            if (*p == ':') {
                p++;
                break;
            }
            if (((*p >= 'a') && (*p <= 'z')) || ((*p >= 'A') && (*p <= 'Z')) || ((*p >= '0') && (*p <= '9')) || (*p == '+') || (*p == '-') || (*p == '.')) {
                p++;
                continue;
            }
            return nil;
        }
        if (*p != '/') {
            return nil;
        }
        p++;
        if (*p != '/') {
            return nil;
        }
        p++;
        if (!*p || (*p == '/')) {
            return nil;
        }
        p++;
        for(;;) {
            if (!*p) {
                break;
            }
            if (*p == '/') {
                p++;
                break;
            }
            p++;
        }

        char *base = p;
        char *q = 0;
        for(;;) {
            if (!*p) {
                break;
            }
            if (*p == '/') {
                q = p+1;
            } else if (*p == '?') {
                break;
            }
            p++;
        }
        if (q) {
            return nsfmt(@"%.*s", q-cstr, cstr);
        } else {
            return nsfmt(@"%.*s", base-cstr, cstr);
        }
    }
    return nil;
}
static void testAsRootURLForNode(id node)
{
    id name = [node valueForKey:@"name"];
    if ([name isEqual:@"a"]) {
        id attrs = [node valueForKey:@"attrs"];
        id href = [attrs valueForKey:@"href"];
        id url = [href asRootURL];
        NSOut(@"a href '%@' -> '%@'\n", href, url);
    } else if ([name isEqual:@"img"]) {
        id attrs = [node valueForKey:@"attrs"];
        id src = [attrs valueForKey:@"src"];
        id url = [src asRootURL];
        NSOut(@"img src '%@' -> '%@'\n", src, url);
    }
    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        testAsRootURLForNode(elt);
    }
}
static void testAsBaseURLForNode(id node)
{
    id name = [node valueForKey:@"name"];
    if ([name isEqual:@"a"]) {
        id attrs = [node valueForKey:@"attrs"];
        id href = [attrs valueForKey:@"href"];
        id url = [href asBaseURL];
        NSOut(@"a href '%@' -> '%@'\n", href, url);
    } else if ([name isEqual:@"img"]) {
        id attrs = [node valueForKey:@"attrs"];
        id src = [attrs valueForKey:@"src"];
        id url = [src asBaseURL];
        NSOut(@"img src '%@' -> '%@'\n", src, url);
    }
    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        testAsBaseURLForNode(elt);
    }
}
@implementation Definitions(fmekwlfmklsdmfklmsdklfmklsfjkdsjkfjfdksjkjfkjfkfjeiwfnkjsd)
+ (void)testAsRootURL
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    testAsRootURLForNode(document);
}
+ (void)testAsBaseURL
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    testAsBaseURLForNode(document);
}
@end


@implementation NSString(fmewklfmklsdfmklsdfm)
- (id)resolveURLWithURL:(id)url
{
    char *cstr = [self UTF8String];
    if (((cstr[0] >= 'a') && (cstr[0] <= 'z')) || ((cstr[0] >= 'A') && (cstr[0] <= 'Z'))) {
        char *p = cstr + 1;
        for(;;) {
            if (!*p) {
                break;
            }
            if (*p == ':') {
                return self;
            }
            if (((*p >= 'a') && (*p <= 'z')) || ((*p >= 'A') && (*p <= 'Z')) || ((*p >= '0') && (*p <= '9')) || (*p == '+') || (*p == '-') || (*p == '.')) {
                p++;
                continue;
            }
            break;
        }
    }

    if ([self hasPrefix:@"/"]) {
        id rootURL = [url asRootURL];
        if ([rootURL hasSuffix:@"/"]) {
            return nsfmt(@"%@%@", rootURL, self);
        } else {
            return nsfmt(@"%@/%@", rootURL, self);
        }
    } else {
        id baseURL = [url asBaseURL];
        if ([baseURL hasSuffix:@"/"]) {
            return nsfmt(@"%@%@", baseURL, self);
        } else {
            return nsfmt(@"%@/%@", baseURL, self);
        }
    }

    return nil;
}
@end


static void testResolveURLForNode(id node, id origURL)
{
    id name = [node valueForKey:@"name"];
    if ([name isEqual:@"a"]) {
        id attrs = [node valueForKey:@"attrs"];
        id href = [attrs valueForKey:@"href"];
        id url = [href resolveURLWithURL:origURL];
        NSOut(@"a href '%@' -> '%@'\n", href, url);
    } else if ([name isEqual:@"img"]) {
        id attrs = [node valueForKey:@"attrs"];
        id src = [attrs valueForKey:@"src"];
        id url = [src resolveURLWithURL:origURL];
        NSOut(@"img src '%@' -> '%@'\n", src, url);
    }
    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        testResolveURLForNode(elt, origURL);
    }
}

@implementation Definitions(fmekwlfmklsdmfklmsdklfmklsfjkdsjkfjfdks)
+ (void)testResolveURL:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    testResolveURLForNode(document, url);
}
@end
