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

@implementation Definitions(fmekwlfmklsdmfklsdmkflsdkl)
+ (id)parseCSS
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id arr = [str parseCSS];
    return arr;
}
@end
@implementation NSString(ewfimosdkfmklsdmflk)
- (id)parseCSS
{
    id str = self;

    id selectorTextArrayStack = nsarr();

    id results = nsarr();

    char *comment = 0;
    int bracket = 0;

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
        if (comment) {
            if ((q[0] == '*') && (q[1] == '/')) {
                id text = nsfmt(@"%.*s", q+2-comment, comment);
NSLog(@"comment '%@'", text);
                id dict = nsdict();
                [dict setValue:@"comment" forKey:@"type"];
                [dict setValue:text forKey:@"text"];
                [results addObject:dict];
                if (comment == p) {
                    p = q+2;
                }
                while (comment < q+2) {
                    *comment++ = ' ';
                }
                comment = 0;
            }
        } else {
            if ((q[0] == '/') && (q[1] == '*')) {
                comment = q;
            } else if ((q[0] == ' ') && (q == p)) {
                p = q+1;
            } else {
                if (bracket == 0) {
                    if (*q == '{') {
                        bracket++;
                        id text = nsfmt(@"%.*s", q-p, p);
NSLog(@"open bracket '%@'", text);
                        id selectorTextArray = nsarr();
                        [selectorTextArray addObject:text];
                        [selectorTextArrayStack addObject:selectorTextArray];
                        p = q+1;
                    } else if (*q == ';') {
                        id text = nsfmt(@"%.*s", q-p, p);
NSLog(@"semicolon outside bracket '%@'", text);
                        id dict = nsdict();
                        [dict setValue:@"statement" forKey:@"type"];
                        [dict setValue:text forKey:@"text"];
                        [results addObject:dict];
                        p = q+1;
                    }
                } else {
                    if (*q == ';') {
                        id text = nsfmt(@"%.*s", q-p, p);
NSLog(@"semicolon inside bracket '%@'", text);
                        id dict = nsdict();
                        [dict setValue:@"property" forKey:@"type"];
                        [dict setValue:text forKey:@"text"];
                        [dict setValue:[selectorTextArrayStack nth:bracket-1] forKey:@"selectorTextArray"];
                        [results addObject:dict];
                        p = q+1;
                    } else if (*q == '}') {
                        bracket--;
                        if (bracket) {
NSLog(@"nested close bracket '%.*s'", q-p, p);
                            if (q > p) {
                                id text = nsfmt(@"%.*s", q-p, p);
                                id dict = nsdict();
                                [dict setValue:@"property" forKey:@"type"];
                                [dict setValue:text forKey:@"text"];
                                [dict setValue:[selectorTextArrayStack nth:bracket-1] forKey:@"selectorTextArray"];
                                [results addObject:dict];
                            }
                        } else {
NSLog(@"close bracket '%.*s'", q-p, p);
                            if (q > p) {
                                id text = nsfmt(@"%.*s", q-p, p);
                                id dict = nsdict();
                                [dict setValue:@"property" forKey:@"type"];
                                [dict setValue:text forKey:@"text"];
                                [dict setValue:[selectorTextArrayStack nth:bracket-1] forKey:@"selectorTextArray"];
                                [results addObject:dict];
                            }
                        }
                        [selectorTextArrayStack removeObjectAtIndex:bracket];
                        p = q+1;
                    } else if (*q == '{') {
                        id selectorTextArray = [[[selectorTextArrayStack nth:bracket] copy] autorelease];
                        bracket++;
                        id text = nsfmt(@"%.*s", q-p, p);
NSLog(@"nested open bracket '%@'", text);
                        [selectorTextArray addObject:text];
                        [selectorTextArrayStack addObject:selectorTextArray];
                        p = q+1;
                    }
                }
            }
        }
        q++;
    }
    return results;
}
@end


