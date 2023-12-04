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

@implementation Definitions(fmekwlfmklsdmfklsdmffdjskfjsdkfj)
+ (id)parseCSSProperty
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id arr = [str parseCSS];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        id type = [elt valueForKey:@"type"];
        if ([type isEqual:@"property"]) {
            id text = [elt valueForKey:@"text"];
            id result = [text parseCSSProperty];
            NSOut(@"property key:'%@' value '%@'\n", [result valueForKey:@"key"], [result valueForKey:@"value"]);
        }
    }
    return nil;
}
@end
@implementation NSString(fmkelwmfklsdmfklsdmklfmskldmfksdfdjksfjksd)
- (id)parseCSSProperty
{
    id str = self;

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
        if (*q == ' ') {
            if (q == p) {
                p = q+1;
            } else {
                NSOut(@"cssproperty whitespace '%.*s'\n", q-p, p);
                p = q+1;
            }
        } else if (*q == ':') {
//            NSOut(@"cssproperty colon '%.*s' value '%s'\n", q-p, p, q+1);
            id dict = nsdict();
            [dict setValue:nsfmt(@"%.*s", q-p, p) forKey:@"key"];
            [dict setValue:nsfmt(@"%s", q+1) forKey:@"value"];
            return dict;
        }
        q++;
    }
    return nil;
}
@end

