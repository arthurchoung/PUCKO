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

@implementation Definitions(ewmkflmsdklfmksdomfiowemkf)
+ (void)testParseCSSImport:(id)origURL
{
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
NSOut(@"text '%@'\n", text);
            id url1 = [text parseCSSImport];
            id url2 = [url1 resolveURLWithURL:origURL];
NSOut(@"url '%@' -> '%@'\n", url1, url2);
        }
    }
}
@end

@implementation NSString(fmekwlfmklsdmfklsdmfklsdmklfmsdkl)
- (id)parseCSSImport
{
    id str = self;

    id quotedString = nil;

    int import = 0;
    char *parenthesis = 0;
    char *quote = 0;

    char *cstr = [str UTF8String];

    char *p = cstr;
    char *q = p;
    for(;;) {
        if (!*q) {
            break;
        }
        if (*q == '\n') {
            *q = ' ';
        }
        if (quote) {
            if (*q == *quote) {
                quotedString = nsfmt(@"%.*s", q-(quote+1), quote+1);
NSLog(@"quote %c '%@'", *quote, quotedString);
                quote = 0;
            }
        } else if (*q == ' ') {
            if (q == p) {
                p = q+1;
            } else {
                id token = nsfmt(@"%.*s", q-p, p);
NSLog(@"csstoken whitespace '%@'", token);
                if ([token isEqual:@"@import"]) {
                    import++;
                }
                p = q+1;
            }
        } else if (*q == '(') {
            parenthesis = p;
NSLog(@"before parenthesis '%.*s'", q-p, p);
            p = q+1;
        } else if (*q == ')') {
            if (parenthesis) {
NSLog(@"parenthesis '%.*s' before '%.*s'", q-p, p, q+1-parenthesis, parenthesis);
                if (import && !strncmp(parenthesis, "url(", 4)) {
                    if (quotedString) {
                        return quotedString;
                    }
                    return nsfmt(@"%.*s", q-p, p);
                }
                p = q+1;
                parenthesis = 0;
            }
        } else if (*q == '\'') {
            quote = q;
        } else if (*q == '"') {
            quote = q;
        }
        q++;
    }
    return nil;
}
@end

