/*

 HOT DOG Linux

 Copyright (c) 2020 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of HOT DOG Linux.

 HOT DOG Linux is free software: you can redistribute it and/or modify
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

@implementation NSString(fjkdlsjfkldsjkflskdjf)
- (id)split:(id)separator maxTokens:(int)maxTokens
{
    if (maxTokens < 1) {
        return nil;
    }
    if (maxTokens == 1) {
        id arr = nsarr();
        [arr addObject:self];
        return arr;
    }
    id tokens = [self componentsSeparatedByString:separator];
    if ([tokens length] <= maxTokens) {
        return tokens;
    }
    id last = [[tokens subarrayFromIndex:maxTokens-1] join:separator];
    id results = [tokens subarrayToIndex:maxTokens-1];
    results = [results arrayByAddingObject:last];
    return results;
}
@end

@implementation NSString(jfkdlsjfklsdjf)
- (int)x
{
    id tokens = [self split];
    return [[tokens nth:0] intValue];
}
- (int)y
{
    id tokens = [self split];
    return [[tokens nth:1] intValue];
}
- (int)w
{
    id tokens = [self split];
    return [[tokens nth:2] intValue];
}
- (int)h
{
    id tokens = [self split];
    return [[tokens nth:3] intValue];
}
@end

@implementation NSString(jfksdljfklsdjfsdfjksdjfkdsjfksdjfkiji)
- (void)addToArray:(id)arr
{
    [arr addObject:self];
}

- (BOOL)hasAnySuffix:(id)suffixes
{
    for (int i=0; i<[suffixes count]; i++) {
        id suffix = [suffixes nth:i];
        if ([self hasSuffix:suffix]) {
            return YES;
        }
    }
    return NO;
}

- (id)capitalizeFirstLetter
{
    int len = [self length];
    if (!len) {
        return self;
    }
    if (len == 1) {
        return [self uppercaseString];
    }
    id first = [self stringToIndex:1];
    id last = [self stringFromIndex:1];
    return nsfmt(@"%@%@", [first uppercaseString], last);
}

- (unsigned char)unsignedCharValue
{
    unsigned char val = [self intValue];
    return val;
}
- (unsigned long)unsignedLongValue
{
    return strtoul([self UTF8String], NULL, 10);
}
- (long)longValue
{
    return strtol([self UTF8String], NULL, 10);
}

- (id)keepAlphanumericCharacters
{
    return [self keepCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890"];
}
- (id)keepAlphanumericCharactersAndSpaces
{
    return [self keepCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890 "];
}
- (id)keepAlphanumericCharactersAndSpacesAndPunctuation
{
    return [self keepCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890 !@#$%^&*()-_=+[];:'\",<.>/?|"];
}
- (id)keepAlphanumericCharactersAndSpacesAndPunctuationAndNewlines
{
    return [self keepCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890 !@#$%^&*()-_=+[];:'\",<.>/?|\n"];
}
- (id)replaceNonAlphanumericCharactersWithSpaces
{
    id str = [[self mutableCopy] autorelease];
    return [str destructiveReplaceCharactersNotInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890" withChar:' '];
}

- (id)split:(id)sep
{
    return [[self componentsSeparatedByString:sep] filterEmptyStrings];
}
- (id)cat:(id)str
{
    return (str) ? [self stringByAppendingString:str] : self;
}

- (id)asCapitalizedString
{
    return [[[self stringToIndex:1] uppercaseString] cat:[self stringFromIndex:1]];
}


- (id)keepCharactersInString:(id)keepString
{
    char *selfChars = [self UTF8String];
    char *keepChars = [keepString UTF8String];
    id results = nsarr();
    char *p = selfChars;
    while (*p) {
        if (strchr(keepChars, *p)) {
            [results addObject:nsfmt(@"%c", *p)];
        }
        p++;
    }
    return [results join:@""];
}

- (id)splitMaxLength:(int)maxLength
{
    id results = nsarr();
    id str = self;
    for(;;) {
        if ([str length] > maxLength) {
            [results addObject:[str substringToIndex:maxLength]];
            str = [str substringFromIndex:maxLength];
            continue;
        }
        [results addObject:str];
        break;
    }
    return results;
}
- (int)nthChar:(int)index
{
    int len = [self length];
    if (index < 0) {
        return 0;
    }
    if (index >= len) {
        return 0;
    }
    return [self characterAtIndex:index];
}


- (id)strip:(id)str
{
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}
- (id)stripTabs
{
    return [self strip:@"\t"];
}
- (id)stripNewlines
{
    return [self strip:@"\n"];
}


- (id)splitCharacters
{
    int length = [self length];
    id arr = nsarr();
    for (int i=0; i<length; i++) {
        [arr addObject:nsfmt(@"%c", [self characterAtIndex:i])];
    }
    return arr;
}

- (id)str:(id)str
{
    return [str strWithContext:self];
}

- (id)strWithContext:(id)context
{
    id string = self;
    id components = [string componentsSeparatedByString:@"#{"];
    if ([components count] == 0) {
        return @"";
    }
    if ([components count] == 1) {
        return string;
    }

    id results = nsarr();
    [results addObject:[components objectAtIndex:0]];

    for (int i=1; i<[components count]; i++) {
        id parts = [[components objectAtIndex:i] componentsSeparatedByString:@"}"];
        id expression = [parts objectAtIndex:0];
        if (expression) {
            id stringValue = nil;
            stringValue = [context valueForKey:expression];
            if (!stringValue) {
                 stringValue = [context evaluateMessage:expression];
            }
            if (stringValue) {
                [results addObject:[stringValue description]];
            } else {
            }
        }
        [results addObject:[parts objectAtIndex:1]];
        for (int j=2; j<[parts count]; j++) {
            [results addObject:@"}"];
            [results addObject:[parts objectAtIndex:j]];
        }
    }
    return [results join:@""];
}

- (BOOL)isInt
{
    char *cstring = [self UTF8String];
    if (!cstring || !*cstring) {
        return NO;
    }
    char *endptr;
    long long lvalue = strtoll(cstring, &endptr, 10);
    if (*endptr == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isDouble
{
    char *cstring = [self UTF8String];
    if (!cstring || !*cstring) {
        return NO;
    }
    char *endptr;
    double dvalue = strtod(cstring, &endptr);
    if (*endptr == 0) {
        return YES;
    }
    return NO;
}

- (id)stringFromIndex:(int)index
{
    int len = [self length];
    if (len == 0) {
        return self;
    }
    if (index < 0) {
        index += len;
        if (index < 0) {
            return self;
        }
    }
    if (index == 0) {
        return self;
    }
    if (index >= len) {
        return @"";
    }
    return [self substringFromIndex:index];
}

- (id)stringToIndex:(int)index
{
    int len = [self length];
    if (len == 0) {
        return self;
    }
    if (index < 0) {
        index += len;
        if (index <= 0) {
            return @"";
        }
    }
    if (index == 0) {
        return @"";
    }
    if (index >= len) {
        return self;
    }
    return [self substringToIndex:index];
}

- (id)prepend:(id)str
{
    return (str) ? [str cat:self] : self;
}

- (id)cat:(id)str1 cat:(id)str2
{
    return [[self cat:str1] cat:str2];
}

- (id)cat:(id)str1 cat:(id)str2 cat:(id)str3
{
    return [[[self cat:str1] cat:str2] cat:str3];
}

- (id)cat:(id)str1 cat:(id)str2 cat:(id)str3 cat:(id)str4
{
    return [[[[self cat:str1] cat:str2] cat:str3] cat:str4];
}

- (id)cat:(id)str1 cat:(id)str2 cat:(id)str3 cat:(id)str4 cat:(id)str5
{
    return [[[[[self cat:str1] cat:str2] cat:str3] cat:str4] cat:str5];
}

- (id)cat:(id)str1 :(id)str2
{
    return [[self cat:str1] cat:str2];
}

- (id)cat:(id)str1 :(id)str2 :(id)str3
{
    return [[[self cat:str1] cat:str2] cat:str3];
}

- (id)cat:(id)str1 :(id)str2 :(id)str3 :(id)str4
{
    return [[[[self cat:str1] cat:str2] cat:str3] cat:str4];
}

- (id)cat:(id)str1 :(id)str2 :(id)str3 :(id)str4 :(id)str5
{
    return [[[[[self cat:str1] cat:str2] cat:str3] cat:str4] cat:str5];
}

- (BOOL)isString
{
    return isnsstr(self);
}



- (id)asQuotedString
{
//FIXME
    return [self asEscapedString];
}



- (id)asEscapedString
{
//FIXME
    id results = nsarr();
    [results addObject:@"\""];
    int length = [self length];
    for (int i=0; i<length; i++) {
        int c = [self characterAtIndex:i];
        if (c < 32) {
            switch (c) {
                case 0x07: [results addObject:@"\\a"]; break;
                case 0x08: [results addObject:@"\\b"]; break;
                case 0x09: [results addObject:@"\\t"]; break;
                case 0x0a: [results addObject:@"\\n"]; break;
                case 0x0c: [results addObject:@"\\f"]; break;
                case 0x0d: [results addObject:@"\\r"]; break;
                case 0x1b: [results addObject:@"\\e"]; break;
                default:
                    [results addObject:nsfmt(@"\\x%02x", c)];
            }
        }
        else if (c == '"') {
            [results addObject:@"\\\""];
        }
        else if (c == '\\') {
            [results addObject:@"\\\\"];
        }
        else if (c < 127) {
            [results addObject:nsfmt(@"%c", c)];
        }
        else if (c < 256) {
            [results addObject:nsfmt(@"\\x%02x", c)];
        }
        else {
            [results addObject:nsfmt(@"\\u%04x", c)];
        }
    }
    [results addObject:@"\""];
    return [results join:@""];
}





- (id)lines
{
    id a = [self componentsSeparatedByString:@"\n"];
    if ([[a lastObject] isEqual:@""]) {
        return [a subarrayFromLocation:0 length:[a count]-1];
    }
    else {
        return a;
    }
}

- (id)urlDecode
{
    return [self stringByRemovingPercentEncoding];
}

- (id)urlEncode
{
    return [self stringByAddingPercentEscapes];
}



- (id)dataValue
{
    return [NSData dataWithBytes:[self UTF8String] length:strlen([self UTF8String])];
}
- (id)asData
{
    return [NSData dataWithBytes:[self UTF8String] length:strlen([self UTF8String])];
}




@end




@implementation NSString(fjeieiivdklsfjlksdjf)
- (id)allKeys
{
    id results = nsarr();
    id tokens = [self split:@" "];
    for (int i=0; i<[tokens count]; i++) {
        id token = [tokens nth:i];
        id keyval = [token split:@":"];
        if ([keyval count] == 2) {
            [results addObject:[keyval nth:0]];
        }
    }
    return results;
}
@end

static char *find_key_in_string(id key, id str)
{
    char *cstr = [str UTF8String];
    char *p = cstr;
loop:
    // skip whitespace
    for(;;) {
        if (!*p) {
            return NULL;
        }
        if (!isspace(*p)) {
            break;
        }
        p++;
    }
    int keylen = [key length];
    char *keycstr = [key UTF8String];
    if (strncmp(keycstr, p, keylen) != 0) {
        p++;
        // look for whitespace
        for (;;) {
            if (!*p) {
                return NULL;
            }
            if (isspace(*p)) {
                p++;
                break;
            }
            p++;
        }
        goto loop;
    }
    p += keylen;
    if (*p != ':') {
        // look for whitespace
        for (;;) {
            if (!*p) {
                return NULL;
            }
            if (isspace(*p)) {
                p++;
                break;
            }
            p++;
        }
        goto loop;
    }
    p++;
    return p;
}

@implementation NSString(fjdsciklfjklsdjfklsdjf)
- (BOOL)hasKey:(id)key
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return NO;
    }
    return YES;
}
- (id)valueForKey:(id)key
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return NULL;
    }
    // look for whitespace
    char *q = p;
    for(;;) {
        if (!*q) {
            break;
        }
        if (isspace(*q)) {
            break;
        }
        q++;
    }
    return [nscstrn(p, q-p) percentDecode];
}
- (double)doubleValueForKey:(id)key
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return 0.0;
    }
    return strtod(p, NULL);
}
- (int)intValueForKey:(id)key
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return 0;
    }
    return strtol(p, NULL, 10);
}
- (int)intValueForKey:(id)key default:(int)def
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return def;
    }
    return strtol(p, NULL, 10);
}
- (id)removeKey:(id)key
{
    int keylen = [key length];
    char *cstr = [self UTF8String];
    char *p = find_key_in_string(key, self);
    if (!p) {
        return nil;
    }
    // look for whitespace
    char *q = p;
    for(;;) {
        if (!*q) {
            break;
        }
        if (isspace(*q)) {
            break;
        }
        q++;
    }
    char *startkey = p - keylen - 1;
    if (startkey > cstr) {
        startkey--;
    } else {
        q++;
    }
    return nsfmt(@"%.*s%s", startkey-cstr, cstr, q);
}
- (id)decodeBase64ForKey:(id)key
{
    char *p = find_key_in_string(key, self);
    if (!p) {
        return nil;
    }
    // look for whitespace
    char *q = p;
    for(;;) {
        if (!*q) {
            break;
        }
        if (isspace(*q)) {
            break;
        }
        q++;
    }
    int len = q-p;
    if (len > 0) {
        return [Definitions decodeBase64Bytes:p length:len];
    }
    return nil;
}
@end

