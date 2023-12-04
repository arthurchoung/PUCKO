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

#import <objc/objc.h>
#import <objc/Object.h>
#ifndef BUILD_WITH_GNUSTEP_RUNTIME
#import <objc/message.h>
#else
#import <objc/hooks.h>
#endif

#ifdef BUILD_WITH_GNU_PRINTF
#else
#import "foundation-printf.h"
#endif

static FILE *HOTDOG_stdout = NULL;

#define OUT(...) ((void)fprintf(HOTDOG_stdout, __VA_ARGS__))

static FILE *HOTDOG_stderr = NULL;

#define LOG(...) ((void)fprintf(HOTDOG_stderr, __VA_ARGS__))


static Class __NSConstantStringClass = nil;
static Class __NSStringClass = nil;
static Class __NSMutableStringClass = nil;
static Class __NSObjectClass = nil;

static IMP my_objc_msg_forward2(id receiver, SEL sel)
{
LOG("objc_msg_forward2 receiver %p class '%s' selector '%s'\n", receiver, object_getClassName(receiver), sel_getName(sel));
exit(0);
    return NULL;
}

#ifdef BUILD_WITH_GNUSTEP_RUNTIME
static long long nil_method(id self, SEL _cmd) { return 0; }
static struct objc_slot nil_slot = { Nil, Nil, 0, 1, (IMP)nil_method };

static struct objc_slot *my_objc_msg_forward3(id receiver, SEL sel)
{
LOG("objc_msg_forward3 receiver %p class '%s' selector '%s'\n", receiver, object_getClassName(receiver), sel_getName(sel));
exit(0);
    return &nil_slot;
}
#endif

void NSOut(id formatString, ...)///$;
{
#ifdef BUILD_WITH_GNU_PRINTF
    va_list args;
    va_start(args, formatString);
    vfprintf(HOTDOG_stdout, [formatString UTF8String], args);
    va_end(args);
#else
    char *fmt = [formatString UTF8String];
    char *strp = NULL;
    va_list args;
    va_start(args, formatString);
    int result = foundation_vasprintf(&strp, fmt, args);
    va_end(args);
    if (result < 0) {
LOG("OUT OF MEMORY! NSString +stringWithFormat:\n");
        exit(0);
    }
    if (strp) {
OUT("%s", strp);
        free(strp);
    }
#endif
}

void NSLog(id formatString, ...)///$;
{
#ifdef BUILD_WITH_GNU_PRINTF
    va_list args;
    va_start(args, formatString);
    vfprintf(HOTDOG_stderr, [formatString UTF8String], args);
    va_end(args);
    fprintf(HOTDOG_stderr, "\n");
#else
    char *fmt = [formatString UTF8String];
    char *strp = NULL;
    va_list args;
    va_start(args, formatString);
    int result = foundation_vasprintf(&strp, fmt, args);
    va_end(args);
    if (result < 0) {
LOG("OUT OF MEMORY! NSString +stringWithFormat:\n");
        exit(0);
    }
    if (strp) {
LOG("%s\n", strp);
        free(strp);
    }
#endif
}



#define AUTORELEASEPOOL_ALLOC_SIZE 512
#define NSARRAY_ALLOC_SIZE 512
#define NSDICTIONARY_ALLOC_SIZE 512
#define NSDATA_ALLOC_SIZE 4096
#define OBJC_TYPE_BUFSIZE 500

static id __currentAutoreleasePool = NULL;
static id *__autoreleasePoolStack = NULL;
static int __autoreleasePoolAlloc = 0;
static int __autoreleasePoolIndex = 0;

@implementation NSAutoreleasePool
+ (int)currentAutoreleasePoolNumberOfObjects
{
    NSAutoreleasePool *pool = __currentAutoreleasePool;
    return pool->_nobjs;
}
+ (int)autoreleasePoolIndex
{
    return __autoreleasePoolIndex;
}
+ (int)autoreleasePoolAlloc
{
    return __autoreleasePoolAlloc;
}
+ (Class)class
{
//NSLog(@"NSAutoreleasepool +class");
    return self;
}
+ (id)alloc
{
//NSLog(@"NSAutoreleasePool +alloc");
    id obj = class_createInstance(self, 0);
    if (__autoreleasePoolIndex > __autoreleasePoolAlloc) {
NSLog(@"SOMETHING'S WRONG");
        exit(0);
    }
    if (__autoreleasePoolIndex == __autoreleasePoolAlloc) {
        int newAutoreleasePoolAlloc = __autoreleasePoolAlloc + AUTORELEASEPOOL_ALLOC_SIZE;
        id *newAutoreleasePoolStack = malloc(sizeof(id)*newAutoreleasePoolAlloc);
        if (!newAutoreleasePoolStack) {
NSLog(@"OUT OF MEMORY! NSAutoreleasePool +alloc");
            exit(0);
        }
        if (__autoreleasePoolStack) {
            memcpy(newAutoreleasePoolStack, __autoreleasePoolStack, sizeof(id)*__autoreleasePoolAlloc);
            free(__autoreleasePoolStack);
        }
        __autoreleasePoolStack = newAutoreleasePoolStack;
        __autoreleasePoolAlloc = newAutoreleasePoolAlloc;
    }
    __currentAutoreleasePool = obj;
    __autoreleasePoolStack[__autoreleasePoolIndex++] = obj;
    return obj;
}
+ (id)new
{
    return [[NSAutoreleasePool alloc] init];
}
- (id)init
{
//NSLog(@"NSAutoreleasePool -init");
    _alloc = AUTORELEASEPOOL_ALLOC_SIZE;
    _objs = malloc(sizeof(id)*_alloc);
    if (!_objs) {
NSLog(@"OUT OF MEMORY NSAutoreleasePool -init");
        exit(0);
    }
    _nobjs = 0;
    return self;
}
- (void)drain
{
//NSLog(@"NSAutoreleasePool -drain");
    [self release];
}
- (void)release
{
//NSLog(@"NSAutoreleasePool -release nobjs %d", _nobjs);
    if (__autoreleasePoolIndex < 1) {
NSLog(@"No NSAutoreleasePool!");
        exit(0);
    }
    if (__autoreleasePoolStack[__autoreleasePoolIndex-1] != self) {
NSLog(@"WRONG NSAutoreleasePool!");
NSLog(@"self %p", self);
NSLog(@"__autoreleasePoolIndex %d", __autoreleasePoolIndex);
for (int i=0; i<__autoreleasePoolIndex; i++) {
NSLog(@"__autoreleasePoolStack[%d] %p", i, __autoreleasePoolStack[i]);
}
        exit(0);
    }
    for (int i=0; i<_nobjs; i++) {
        [_objs[i] release];
    }
    if (__autoreleasePoolIndex > 1) {
        __currentAutoreleasePool = __autoreleasePoolStack[__autoreleasePoolIndex-2];
    } else {
        __currentAutoreleasePool = NULL;
    }
    __autoreleasePoolIndex--;
    free(_objs);
    object_dispose(self);
}
+ (void)addObject:(id)obj
{
    [__currentAutoreleasePool addObject:obj];
}
- (void)addObject:(id)obj
{
    if (_nobjs > _alloc) {
NSLog(@"SOMETHING'S WRONG!");
        exit(0);
    }
    if (_nobjs == _alloc) {
        int newAlloc = _alloc + AUTORELEASEPOOL_ALLOC_SIZE;
        id newObjs = malloc(sizeof(id)*newAlloc);
        if (!newObjs) {
NSLog(@"OUT OF MEMORY! NSAutoreleasePool -addObject: newAlloc %d", newAlloc);
            exit(0);
        }
        if (_objs) {
            memcpy(newObjs, _objs, sizeof(id)*_alloc);
            free(_objs);
        }
        _objs = newObjs;
        _alloc = newAlloc;
    }
    _objs[_nobjs++] = obj;
}
- (id)description
{
    return @"<NSAutoreleasePool>";
}
@end



@implementation NSConstantString
+ (id)className
{
    return @"<NSConstantString>";
}
- (id)className
{
    return @"NSConstantString";
}
+ (Class)class
{
    return self;
}
- (Class)class
{
    return object_getClass(self);
}
- (void)dealloc
{
}
- (id)init
{
    return self;
}
- (int)retainCount
{
    return 1;
}
- (void)setRetainCount:(int)val
{
}
- (id)retain
{
    return self;
}
- (void)release
{
}
- (id)autorelease
{
    return self;
}
- (char *)UTF8String
{
    return _contents;
}
- (int)length
{
    return _length;
}
+ (id)description
{
    return @"<NSConstantString>";
}
- (id)description
{
    return self;
}
- (BOOL)respondsToSelector:(SEL)sel
{
    Class cls = object_getClass(self);
    return class_respondsToSelector(cls, sel);
}
- (BOOL)isKindOfClass:(Class)cls
{
    if (cls == __NSStringClass) {
        return YES;
    }
    if (cls == __NSConstantStringClass) {
        return YES;
    }
    return NO;
}
+ (void)setNilValueForKey:(id)key
{
}
+ (void)setValue:(id)val forKey:(id)key
{
}
+ (id)valueForKey:(id)key
{
    return nil;
}
+ (BOOL)hasKey:(id)key
{
    return NO;
}
- (void)setNilValueForKey:(id)key
{
}
- (void)setValue:(id)val forKey:(id)key
{
}
#ifndef BUILD_WITH_GNUSTEP_RUNTIME
- (BOOL)isEqual:(id)obj
{
    if (!obj) {
        return NO;
    }
    if (obj == self) {
        return YES;
    }
    char *cstr = ((NSObject *)obj)->_contents;
    if (!cstr) {
        return NO;
    }
/*
    if (_length != ((NSObject *)obj)->_length) {
        return NO;
    }
    Class cls = object_getClass(obj);
    if ((cls != __NSConstantStringClass) && (cls != __NSStringClass) && (cls != __NSMutableStringClass)) {
        return NO;
    }

*/
    if (!strcmp(_contents, cstr)) {
        return YES;
    }
    return NO;
}
#endif
@end




@implementation NSObject
+ (Class)class
{
    return self;
}
- (Class)class
{
    return object_getClass(self);
}
+ (id)alloc
{
//NSLog(@"NSObject -alloc (%s)\n", object_getClassName(self));
    id obj = class_createInstance(self, 0);
    return obj;
}
- (id)copy
{
    Class cls = object_getClass(self);
    id obj = object_copy(self, class_getInstanceSize(cls));
    [obj setRetainCount:1];
    return obj;
}

- (void)dealloc
{
//NSLog(@"NSObject -dealloc");
    object_dispose(self);
}

- (id)init
{
//NSLog(@"NSObject -init (%s)", object_getClassName(self));
    _retainCount = 1;
    return self;
}
- (int)retainCount
{
    return _retainCount;
}
- (void)setRetainCount:(int)val
{
    _retainCount = val;
}
+ (id)retain
{
    return self;
}
- (id)retain
{
//NSLog(@"NSObject -retain");
    _retainCount++;
    return self;
}
+ (void)release
{
}
- (void)release
{
//NSLog(@"NSObject -release");
    _retainCount--;
//NSLog(@"retainCount %d", _retainCount);
    if (_retainCount < 0) {
NSLog(@"SOMETHING'S WRONG!");
        exit(0);
    }
    if (_retainCount == 0) {
        [self dealloc];
        return;
    }
    return;
}
+ (id)autorelease
{
    return self;
}
- (id)autorelease
{
//NSLog(@"NSObject -autorelease (%s)", object_getClassName(self));
    if (__currentAutoreleasePool) {
        [__currentAutoreleasePool addObject:self];
    } else {
NSLog(@"WARNING: no autorelease pool");
    }
    return self;
}
+ (BOOL)isKindOfClass:(Class)obj
{
    return NO;
}
- (BOOL)isKindOfClass:(Class)obj
{
    Class cls1 = object_getClass(self);
    Class cls2 = obj;
//NSLog(@"isKindOfClass cls1 %s %p cls2 %s %p", class_getName(cls1), cls1, class_getName(cls2), cls2);
    if (class_isMetaClass(cls2)) {
//NSLog(@"isMetaClass");
        return NO;
    }

    Class cursor = cls1;
    while (cursor) {
        if (cursor == cls2) {
//NSLog(@"YES");
            return YES;
        }
        cursor = class_getSuperclass(cursor);
    }
//NSLog(@"NO");
    return NO;
}
+ (BOOL)respondsToSelector:(SEL)sel
{
    Class cls = object_getClass(self);
    return class_respondsToSelector(cls, sel);
}
- (BOOL)respondsToSelector:(SEL)sel
{
    Class cls = object_getClass(self);
    return class_respondsToSelector(cls, sel);
}
+ (id)description
{
    return nsfmt(@"<class %s>", object_getClassName(self));
}
- (id)description
{
    return nsfmt(@"<%s %p>", object_getClassName(self), self);
}
- (BOOL)writeToFile:(id)path
{
    if (!_contents) {
        return NO;
    }
    char *cpath = [path UTF8String];
    if (!cpath || !cpath[0]) {
        return NO;
    }
    id basePath = [path stringByDeletingLastPathComponent];
    if ([basePath length]) {
        if (![basePath fileExists]) {
            [basePath makeDirectory];
        }
    }
    FILE *fp = fopen(cpath, "w");
    if (!fp) {
        return NO;
    }
    BOOL result = NO;
    if (_length) {
        if (fwrite(_contents, 1, _length, fp) == _length) {
            result = YES;
        }
    } else {
        result = YES;
    }
    fclose(fp);
    return result;
}
+ (BOOL)isEqual:(id)obj
{
    if (self == obj) {
        return YES;
    }
    return NO;
}
+ (void)setNilValueForKey:(id)key
{
}
+ (void)setValue:(id)val forKey:(id)key
{
}
+ (id)valueForKey:(id)key
{
    return nil;
}
+ (BOOL)hasKey:(id)key
{
    return NO;
}
- (void)setNilValueForKey:(id)key
{
}
- (void)setValue:(id)val forKey:(id)key
{
}
- (id)valueForKey:(id)key
{
    return nil;
}
- (BOOL)hasKey:(id)key
{
    return NO;
}
@end

static int hexchartoint(char c)
{
    switch(c) {
        case '0': return 0;
        case '1': return 1;
        case '2': return 2;
        case '3': return 3;
        case '4': return 4;
        case '5': return 5;
        case '6': return 6;
        case '7': return 7;
        case '8': return 8;
        case '9': return 9;
        case 'A': case 'a': return 10;
        case 'B': case 'b': return 11;
        case 'C': case 'c': return 12;
        case 'D': case 'd': return 13;
        case 'E': case 'e': return 14;
        case 'F': case 'f': return 15;
    }
    return -1;
}
static void percent_decode(char *buf)
{
    char *p = buf;
    char *dst = buf;
    for(;;) {
        if (!*p) {
            *dst = 0;
            return;
        }
        if (*p == '%') {
            int val1 = hexchartoint(p[1]);
            int val2 = hexchartoint(p[2]);
            if ((val1 >= 0) && (val2 >= 0)) {
                int val = val1*16+val2;
                *dst = val;
                dst++;
                p += 3;
                continue;
            }
        }
        *dst = *p;
        dst++;
        p++;
    }
}

@implementation NSMutableString
@end
@implementation NSString
- (id)substringFromIndex:(int)index
{
    if (index < 0) {
        return nil;
    }
    if (index >= _length) {
        return nil;
    }
    return nsfmt(@"%s", _contents+index);
}
- (id)substringToIndex:(int)index
{
    if (index <= 0) {
        return nil;
    }
    if (index > _length) {
        return nil;
    }
    return nsfmt(@"%.*s", index, _contents);
}
- (BOOL)writeToFile:(id)path
{
// This is so that the IMP gets copied to NSConstantString
    return [super writeToFile:path];
}
- (int)intValueForKey:(id)key
{
    return 0;
}

- (void)dealloc
{
    if (_contents) {
        free(_contents);
    }
    [super dealloc];
}
- (char *)UTF8String
{
    return _contents;
}
- (int)length
{
    return _length;
}
- (id)description
{
    return self;
}
- (id)initWithFormat:(id)formatString arguments:(va_list)args
{
    self = [super init];
    if (self) {
        char *fmt = [formatString UTF8String];
        char *strp = NULL;
#ifdef BUILD_WITH_GNU_PRINTF
        int result = vasprintf(&strp, fmt, args);
#else
        int result = foundation_vasprintf(&strp, fmt, args);
#endif
        if (result < 0) {
NSLog(@"OUT OF MEMORY! NSString -initWithFormat:arguments:");
            exit(0);
        }
        _contents = strp;
        _length = strlen(_contents);
        _alloc = _length+1;
    }
    return self;
}
- (id)initWithBytesNoCopy:(char *)cstr length:(int)length
{
    self = [super init];
    if (self) {
        _contents = cstr;
        _length = length;
        _alloc = length+1;
    }
    return self;
}
- (id)initWithBytes:(char *)cstr length:(int)length
{
    self = [super init];
    if (self) {
        _contents = malloc(length+1);
        if (!_contents) {
NSLog(@"OUT OF MEMORY! NSString -initWithBytes:length:");
            exit(0);
        }
        if (cstr && length) {
            strncpy(_contents, cstr, length);
        } else {
            memset(_contents, 0, length+1);
        }
        _contents[length] = 0;
        _length = strlen(_contents);
        _alloc = length+1;
    }
    return self;
}
+ (id)stringWithFormat:(id)formatString, ...
{
    char *fmt = [formatString UTF8String];
    char *strp = NULL;
    va_list args;
    va_start(args, formatString);
#ifdef BUILD_WITH_GNU_PRINTF
    int result = vasprintf(&strp, fmt, args);
#else
    int result = foundation_vasprintf(&strp, fmt, args);
#endif
    va_end(args);
    if (result < 0) {
NSLog(@"OUT OF MEMORY! NSString +stringWithFormat:");
        exit(0);
    }
    return [[[NSMutableString alloc] initWithBytesNoCopy:strp length:result] autorelease];
}

- (id)destructivePercentDecode
{
    if (!_alloc) {
        return nil;
    }
    if (!*_contents) {
        return self;
    }
    percent_decode(_contents);
    _length = strlen(_contents);
    return self;
}

- (id)destructiveReplaceCharactersNotInString:(id)keepString withChar:(char)c
{
    char *keepChars = [keepString UTF8String];
    char *p = _contents;
    while (*p) {
        if (!strchr(keepChars, *p)) {
            *p = c;
        }
        p++;
    }
    return self;
}
- (id)destructiveChomp
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    int len = strlen(p);
    if (len <= 0) {
        return self;
    }
    if (p[len-1] == 10) {
        p[len-1] = 0;
        _length = len-1;
    }
    return self;
}
- (id)destructiveDeleteLastPathComponent
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    if (!*p) {
        return self;
    }
    char *q = p+1;
    for(;;) {
        if (!*q) {
            break;
        }
        q++;
    }
    q--;
    char *lastChar = q;
    for(;;) {
        if (*q == '/') {
            if ((q == lastChar) && (q == p)) {
                break;
            }
            *q = NULL;
            break;
        }
        if (q == p) {
            *q = NULL;
            break;
        }
        q--;
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveDeletePathExtension
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    if (!*p) {
        return self;
    }
    char *q = p+1;
    for(;;) {
        if (!*q) {
            break;
        }
        q++;
    }
    q--;
    for(;;) {
        if (*q == '/') {
            break;
        }
        if (*q == '.') {
            *q = NULL;
            break;
        }
        if (q == p) {
            break;
        }
        q--;
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveCamelCaseString
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    char *q = _contents;
    BOOL capitalize = NO;
    for(;;) {
        if (!*q) {
            *p = NULL;
            break;
        }
        if (isspace(*q)) {
            q++;
            capitalize = YES;
            continue;
        }
        if (capitalize) {
            if (p == _contents) {
                *p = tolower(*q);
                p++;
                q++;
                capitalize = NO;
                continue;
            }
            *p = toupper(*q);
            p++;
            q++;
            capitalize = NO;
            continue;
        }
        *p = tolower(*q);
        p++;
        q++;
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveRemoveNonASCIICharacters
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    char *q = _contents;
    for(;;) {
        if (!*q) {
            *p = NULL;
            break;
        }
        if (isprint(*q)) {
            *p = *q;
            p++;
            q++;
            continue;
        }
        q++;
    }
    if (p != q) {
        _length = strlen(_contents);
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveLowercaseString
{
    if (!_alloc) {
        return nil;
    }
    for (int i=0; i<_length; i++) {
        _contents[i] = tolower(_contents[i]);
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveUppercaseString
{
    if (!_alloc) {
        return nil;
    }
    for (int i=0; i<_length; i++) {
        _contents[i] = toupper(_contents[i]);
    }
    _length = strlen(_contents);
    return self;
}
- (id)destructiveTrim
{
    if (!_alloc) {
        return nil;
    }
    while (_length > 0) {
        if (!isspace(_contents[_length-1])) {
            break;
        }
        _length--;
        _contents[_length] = 0;
    }

    char *p = _contents;
    for(;;) {
        if (!*p) {
            break;
        }
        if (!isspace(*p)) {
            break;
        }
        p++;
    }
    if (p == _contents) {
        return self;
    }

    char *q = _contents;
    for(;;) {
        *q = *p;
        if (!*p) {
            break;
        }
        q++;
        p++;
    }
    _length = strlen(_contents);
        
    return self;
}
- (id)destructiveLastPathComponent
{
    if (!_alloc) {
        return nil;
    }
    while (_length > 1) {
        if (_contents[_length-1] != '/') {
            break;
        }
        _length--;
        _contents[_length] = 0;
    }
    for (int i=_length-2; i>=0; i--) {
        if (_contents[i] == '/') {
            char *p = _contents;
            char *q = _contents+i+1;
            for(;;) {
                *p = *q;
                if (!*p) {
                    _length = strlen(_contents);
                    return self;
                }
                p++;
                q++;
            }
        }
    }
    _length = strlen(_contents);
    return self;
}



- (id)pathExtension
{
    if (!_alloc) {
        return nil;
    }
    char *p = _contents;
    if (!*p) {
        return nil;
    }
    char *q = p+1;
    for(;;) {
        if (!*q) {
            break;
        }
        q++;
    }
    q--;
    for(;;) {
        if (*q == '/') {
            return nscstr(q+1);
        }
        if (*q == '.') {
            return nscstr(q+1);
        }
        if (q == p) {
            return self;
        }
        q--;
    }
}




- (id)dataFromFile
{
    id path = self;
    char *cpath = [path UTF8String];
    if (!cpath || !cpath[0]) {
        return nil;
    }
    int fileSize = [path fileSize];
    FILE *fp = fopen(cpath, "r");
    if (!fp) {
        return nil;
    }
    id data = [[[NSData alloc] init] autorelease];
    char *contents = malloc(fileSize);
    if (fread(contents, 1, fileSize, fp) != fileSize) {
        data = nil;
    } else {
        [data appendBytes:contents length:fileSize];
    }
    free(contents);
    fclose(fp);
    return data;
}
- (int)compare:(id)obj
{
    if (!_contents) {
        return -1;
    }
    if (![obj respondsToSelector:@selector(UTF8String)]) {
        return 1;
    }
    char *str = [obj UTF8String];
    return strcmp(_contents, str);
}
- (id)mutableCopy
{
    return [self copy];
}
- (id)copy
{
    return [[NSString alloc] initWithBytes:_contents length:_length];
}
- (id)percentDecode
{
    return [[[self copy] autorelease] destructivePercentDecode];
}
- (id)chomp
{
    return [[[self copy] autorelease] destructiveChomp];
}
- (id)stringByDeletingLastPathComponent
{
    return [[[self copy] autorelease] destructiveDeleteLastPathComponent];
}
- (id)stringByDeletingPathExtension
{
    return [[[self copy] autorelease] destructiveDeletePathExtension];
}
- (id)find:(id)findStr replace:(id)replaceStr
{
    return [self stringByReplacingOccurrencesOfString:findStr withString:replaceStr];
}

- (id)stringByReplacingOccurrencesOfString:(id)findStr withString:(id)replaceStr
{
    char *findcstr = [findStr UTF8String];
    if (!findcstr) {
        return self;
    }
    int findcstrlen = strlen(findcstr);
    if (!_contents) {
        return nil;
    }
    int replacecstrlen = [replaceStr length];
    id results = nsarr();
    char *p = _contents;
    for (;;) {
        if (!*p) {
            break;
        }
        char *q = strstr(p, findcstr);
        if (!q) {
            [results addObject:nscstr(p)];
            break;
        }
        [results addObject:nscstrn(p, q-p)];
        if (replacecstrlen) {
            [results addObject:replaceStr];
        }
        p = q + findcstrlen;
    }
    return [results join:@""];
}
- (id)stringByAppendingPathComponent:(id)path
{
    return nsfmt(@"%@/%@", self, path);
}
- (id)sliceFrom:(int)from to:(int)to
{
    return [[[NSString alloc] initWithBytes:_contents+from length:to-from] autorelease];
}
- (id)camelCaseString
{
    return [[[self copy] autorelease] destructiveCamelCaseString];
}
- (id)firstLine
{
    if (!_contents) {
        return nil;
    }
    char *p = _contents;
    for(;;) {
        if (!*p) {
            return self;
        }
        if (*p == '\n') {
            return [[[NSString alloc] initWithBytes:_contents length:p-_contents] autorelease];
        }
        p++;
    }
}
- (id)stringByRemovingNonASCIICharacters
{
    return [[[self copy] autorelease] destructiveRemoveNonASCIICharacters];
}

- (BOOL)containsString:(id)str
{
    char *cstr = [str UTF8String];
    if (!_contents) {
        return NO;
    }
    if (strstr(_contents, cstr)) {
        return YES;
    }
    return NO;
}
- (id)asInstance
{
    id cls = objc_getClass(_contents);
    if (!cls) {
        return nil;
    }
    return [[[cls alloc] init] autorelease];
}
- (id)lastPathComponent
{
    return [[[self copy] autorelease] destructiveLastPathComponent];
}
+ (id)stringWithString:(id)str
{
    return [[str copy] autorelease];
}
- (int)characterAtIndex:(int)index
{
    if (index < 0) {
        return 0;
    }
    if (index >= _length) {
        return 0;
    }
    return _contents[index];
}
- (id)split
{
    if (!_contents) {
        return nil;
    }
    id results = nsarr();
    char *p = _contents;
    char *q = p;
    for (;;) {
        if (!*q) {
            if (q-p) {
                id str = [[[NSString alloc] initWithBytes:p length:q-p] autorelease];
                [results addObject:str];
            }
            break;
        } else if (isspace(*q)) {
            if (q-p) {
                id str = [[[NSString alloc] initWithBytes:p length:q-p] autorelease];
                [results addObject:str];
            }
            q++;
            p = q;
        } else {
            q++;
        }
    }
    return results;
}
- (id)trim
{
    return [[[self copy] autorelease] destructiveTrim];
}
- (id)lowercaseString
{
    return [[[self copy] autorelease] destructiveLowercaseString];
}
- (id)uppercaseString
{
    return [[[self copy] autorelease] destructiveUppercaseString];
}
- (id)asClass
{
    if (_contents) {
        return objc_getClass(_contents);
    }
    return nil;
}
- (BOOL)hasPrefix:(id)prefix
{
    if (!_contents) {
        return NO;
    }
    if (!strncmp([prefix UTF8String], _contents, [prefix length])) {
        return YES;
    }
    return NO;
}
- (BOOL)hasSuffix:(id)suffix
{
    if (!_contents) {
        return NO;
    }
    int len = [suffix length];
    if (_length < len) {
        return NO;
    }
    if (!strncmp([suffix UTF8String], _contents+_length-len, len)) {
        return YES;
    }
    return NO;
}
- (BOOL)boolValue
{
    return (strtol(_contents, NULL, 10)) ? YES : NO;
}
- (unsigned char)unsignedCharValue
{
    unsigned char c = strtoul(_contents, NULL, 10);
    return c;
}
- (unsigned int)unsignedIntValue
{
    return strtoul(_contents, NULL, 10);
}
- (int)intValue
{
    return strtol(_contents, NULL, 10);
}
- (long long)longLongValue
{
    return strtoll(_contents, NULL, 10);
}
- (unsigned long long)unsignedLongLongValue
{
    return strtoull(_contents, NULL, 10);
}
- (double)doubleValue
{
    double result = strtod(_contents, NULL);
    return result;
}
- (id)stringFromFile
{
    id path = self;
    char *cpath = [path UTF8String];
    if (!cpath || !cpath[0]) {
        return nil;
    }
    int fileSize = [path fileSize];
    FILE *fp = fopen(cpath, "r");
    if (!fp) {
        return nil;
    }
    id str = nil;
    if (fileSize > 0) {
        str = [[[NSString alloc] initWithBytes:NULL length:fileSize] autorelease];
        char *contents = [str UTF8String];
        int n = fread(contents, 1, fileSize, fp);
        if (n == fileSize) {
            ((NSObject *)str)->_length = fileSize;
        } else if (n > 0) {
            ((NSObject *)str)->_length = n;
        } else {
            str = nil;
        }
    } else {
        id results = nsarr();
        char buf[4096]; 
        for (;;) {
            int n = fread(buf, 1, 4096, fp);
            if (n > 0) {
                [results addObject:nscstrn(buf, n)];
            }
            if (n != 4096) {
                break;
            }
        }
        if ([results count]) {
            str = [results join:@""];
        } else {
            str = @"";
        }
    }
    fclose(fp);
    return str;
}
+ (id)string
{
    return nsfmt(@"");
}
+ (id)stringWithUTF8String:(char *)cstr
{
    return nsfmt(@"%s", cstr);
}
- (id)stringByAppendingString:(id)str
{
    return nsfmt(@"%@%@", self, str);
}
- (BOOL)isEqual:(id)obj
{
    if (!obj) {
        return NO;
    }
    if (obj == self) {
        return YES;
    }
    char *cstr = ((NSObject *)obj)->_contents;
    if (!cstr) {
        return NO;
    }
/*
    if (_length != ((NSObject *)obj)->_length) {
        return NO;
    }
    Class cls = object_getClass(obj);
    if ((cls != __NSConstantStringClass) && (cls != __NSStringClass) && (cls != __NSMutableStringClass)) {
        return NO;
    }

*/
    if (!strcmp(_contents, cstr)) {
        return YES;
    }
    return NO;
}
- (id)componentsSeparatedByString:(id)separatorString
{
    if (!_contents) {
        return nil;
    }
    char *sep = [separatorString UTF8String];
    int sepLength = [separatorString length];
    id results = nsarr();
    char *p = _contents;
    for (;;) {
        char *q = strstr(p, sep);
        if (!q) {
            [results addObject:nsfmt(@"%s", p)];
            break;
        }
        id str = [[[NSString alloc] initWithBytes:p length:q-p] autorelease];
        [results addObject:str];
        p = q + sepLength;
    }
    return results;
}
- (id)splitTerminator:(id)terminatorString
{
    if (!_contents) {
        return nil;
    }
    char *term = [terminatorString UTF8String];
    int termLength = [terminatorString length];
    id results = nsarr();
    char *p = _contents;
    for (;;) {
        char *q = strstr(p, term);
        if (!q) {
            break;
        }
        id str = [[[NSString alloc] initWithBytes:p length:q-p+termLength] autorelease];
        [results addObject:str];
        p = q + termLength;
    }
    return results;
}
@end




@implementation NSMutableArray
@end
@implementation NSArray
- (id)valueForKey:(id)key
{
NSLog(@"NSArray valueForKey:%@", key);
    return nil;
}

- (BOOL)containsObject:(id)obj
{
    int index = [self findObject:obj];
    if (index == -1) {
        return NO;
    }
    return YES;
}
- (int)findObject:(id)obj
{
    id *elts = _contents;
    for (int i=0; i<_length; i++) {
        if ([obj isEqual:elts[i]]) {
            return i;
        }
    }
    return -1;
}
- (void)dealloc
{
    id *elts = _contents;
    for (int i=0; i<_length; i++) {
        [elts[i] autorelease];
    }
    if (_contents) {
        free(_contents);
    }
    [super dealloc];
}
- (id)subarrayFromLocation:(int)location length:(int)length
{
    id arr = [[[NSArray alloc] init] autorelease];
    for (int i=0; i<length; i++) {
        id elt = [self objectAtIndex:location+i];
        if (elt) {
            [arr addObject:elt];
        }
    }
    return arr;
}
- (id)firstObject
{
    if (_length > 0) {
        id *elts = _contents;
        return elts[0];
    }
    return nil;
}
- (id)lastObject
{
    if (_length > 0) {
        id *elts = _contents;
        return elts[_length-1];
    }
    return nil;
}
- (void)removeAllObjects
{
    id *elts = _contents;
    for (int i=0; i<_length; i++) {
        [elts[i] autorelease];
    }
    _length = 0;
    memset(elts, 0, sizeof(id)*_alloc);
}
- (id)mutableCopy
{
    return [self copy];
}
- (id)copy
{
    id arr = [[NSArray alloc] init];
    for (id elt in self) {
        [arr addObject:elt];
    }
    return arr;
}

- (id)arrayByAddingObject:(id)obj
{
    id arr = [[self copy] autorelease];
    [arr addObject:obj];
    return arr;
}
- (id)arrayByAddingObjectsFromArray:(id)arr
{
    id results = [[self copy] autorelease];
    for (id elt in arr) {
        [results addObject:elt];
    }
    return results;
}

- (unsigned int)countByEnumeratingWithState:(NSFastEnumerationState *)enumerationState objects:(id *)stackBuffer count:(unsigned int)length
{
//NSLog(@"countByEnumeratingWithState:objects:count: %d", length);
    id *elts = _contents;
    if (enumerationState->state == 0) {
        enumerationState->state = 1;
        enumerationState->mutationsPtr = self;
        enumerationState->itemsPtr = stackBuffer;
        if (_length > length) {
            for (int i=0; i<length; i++) {
                stackBuffer[i] = elts[i];
            }
            enumerationState->extra[0] = length;
            return length;
        } else {
            for (int i=0; i<_length; i++) {
                stackBuffer[i] = elts[i];
            }
            enumerationState->extra[0] = _length;
            return _length;
        }
    }
    if (_length - enumerationState->extra[0] > length) {
        for (int i=0; i<length; i++) {
            stackBuffer[i] = elts[enumerationState->extra[0]+i];
        }
        enumerationState->extra[0] += length;
        return length;
    } else {
        int count = _length - enumerationState->extra[0];
        for (int i=0; i<count; i++) {
            stackBuffer[i] = elts[enumerationState->extra[0]+i];
        }
        enumerationState->extra[0] += count;
        return count;
    }
}
+ (id)array
{
    return [[[NSArray alloc] init] autorelease];
}
+ (id)arrayWithObjects:(id *)objects count:(unsigned int)count
{
    id arr = [[[NSArray alloc] init] autorelease];
    for (int i=0; i<count; i++) {
        [arr addObject:objects[i]];
    }
    return arr;
}
- (id)componentsJoinedByStringOld:(id)separator
{
    separator = [separator description];
    id *elts = _contents;
    id str = nil;
    for (int i=0; i<_length; i++) {
        if (!str) {
            str = [elts[i] description];
        } else {
            str = [str stringByAppendingString:separator];
            str = [str stringByAppendingString:[elts[i] description]];
        }
    }
    return ([str length]) ? str : @"";
}
- (id)componentsJoinedByString:(id)separator
{
    if (_length < 1) {
        return @"";
    }

    separator = [separator description];
    char *separatorCStr = [separator UTF8String];
    int separatorLength = [separator length];
    if (!separatorCStr) {
        separatorCStr = "";
        separatorLength = 0;
    }

    id *elts = _contents;

    id arr = nsarr();
    int totalLength = 0;
    for (int i=0; i<_length; i++) {
        id str = [elts[i] description];
        totalLength += [str length];
        [arr addObject:str];
    }
    totalLength += [separator length]*(_length-1);

    if (!totalLength) {
        return @"";
    }

    char *dest = malloc(totalLength+1);
    if (!dest) {
NSLog(@"OUT OF MEMORY!");
        exit(0);
    }
    char *destptr = dest;

    for (int i=0; i<[arr count]; i++) {
        if (i > 0) {
            strcpy(destptr, separatorCStr);
            destptr += separatorLength;
        }
        id str = [arr nth:i];
        char *cstr = [str UTF8String];
        strcpy(destptr, cstr);
        destptr += [str length];
    }

    return [[[NSMutableString alloc] initWithBytesNoCopy:dest length:totalLength] autorelease];
}
- (void)addObject:(id)obj
{
    if (!obj) {
        return;
    }
    if (_length > _alloc) {
NSLog(@"SOMETHING'S WRONG!");
        exit(0);
    }
    if (_length == _alloc) {
        int newAlloc = _alloc + NSARRAY_ALLOC_SIZE;
        id *newElts = malloc(sizeof(id)*newAlloc);
        if (!newElts) {
NSLog(@"OUT OF MEMORY! NSArray -addObject:");
            exit(0);
        }
        if (_contents) {
            memcpy(newElts, _contents, sizeof(id)*_alloc);
            free(_contents);
        }
        _alloc = newAlloc;
        _contents = newElts;
    }
    [obj retain];
    id *elts = _contents;
    elts[_length++] = obj;
}
- (void)removeObjectAtIndex:(int)i
{
    if (i < 0) {
        return;
    }
    if (i >= _length) {
        return;
    }
    id *elts = _contents;
    [elts[i] autorelease];
    for (int j=i; j<_length-1; j++) {
        elts[j] = elts[j+1];
    }
    _length--;
    elts[_length] = NULL;
}
- (void)removeObject:(id)obj
{
    if (!obj) {
        return;
    }
    id *elts = _contents;
    for (int i=0; i<_length; i++) {
        if ([elts[i] isEqual:obj]) {
            [self removeObjectAtIndex:i];
            return;
        }
    }
}
- (void)replaceObjectAtIndex:(int)i withObject:(id)obj
{
    if (i < 0) {
        return;
    }
    if (i >= _length) {
        return;
    }
    if (!obj) {
        return;
    }
    id *elts = _contents;
    [obj retain];
    [elts[i] autorelease];
    elts[i] = obj;
}
- (void)addObjectsFromArray:(id)arr
{
    for (id elt in arr) {
        [self addObject:elt];
    }
}
- (int)length
{
    return _length;
}
- (int)count
{
    return _length;
}
- (id)objectAtIndex:(int)index
{
    if (index < 0) {
        return nil;
    }
    if (index >= _length) {
        return nil;
    }
    id *elts = _contents;
    return elts[index];
}
int qsort_compare_helper(void *a, void *b, void *arg)
{
    int (*func)(id a, id b) = arg;
    return func(*((id *)a), *((id *)b));
}
- (id)destructiveSortArrayWithFunction:(void *)func argument:(void *)arg
{
#ifdef BUILD_WITH_GNU_QSORT_R
    qsort_r(_contents, _length, sizeof(id), func, arg);
#else
    foundation_qsort_r(_contents, _length, sizeof(id), func, arg);
#endif
    return self;
}
- (id)asArraySortedWithFunction:(void *)func argument:(void *)arg
{
    return [[[self copy] autorelease] destructiveSortArrayWithFunction:func argument:arg];
}
- (id)description
{
    return nsfmt(@"(%@)", [self join:@", "]);
}
@end

@implementation NSData
+ (id)data
{
    return [[[self alloc] init] autorelease];
}
+ (id)dataWithCapacity:(int)length
{
    return [[[self alloc] initWithCapacity:length] autorelease];
}
- (id)initWithCapacity:(int)capacity
{
    self = [super init];
    if (self) {
        if (capacity > 0) {
            _contents = malloc(capacity);
            if (!_contents) {
    NSLog(@"out of memory!");
                exit(0);
            }
            memset(_contents, 0, capacity);
            _length = 0;
            _alloc = capacity;
        }
    }
    return self;
}
+ (id)dataWithBytes:(char *)bytes length:(int)length
{
    return [[[self alloc] initWithBytes:bytes length:length] autorelease];
}
- (id)initWithBytes:(char *)bytes length:(int)length
{
    self = [super init];
    if (self) {
        if (length > 0) {
            _contents = malloc(length);
            if (!_contents) {
    NSLog(@"out of memory!");
                exit(0);
            }
            memcpy(_contents, bytes, length);
            _length = length;
            _alloc = length;
        }
    }
    return self;
}

+ (id)dataWithBytesNoCopy:(char *)bytes length:(int)length
{
    return [[[self alloc] initWithBytesNoCopy:bytes length:length] autorelease];
}
- (id)initWithBytesNoCopy:(char *)bytes length:(int)length
{
    self = [super init];
    if (self) {
        _contents = bytes;
        _length = length;
        _alloc = length;
    }
    return self;
}
- (void)dealloc
{
    if (_contents) {
        free(_contents);
    }
    [super dealloc];
}
- (id)mutableCopy
{
    return [self copy];
}
- (id)copy
{
    id data = [[NSData alloc] init];
    if (_length) {
        [data appendBytes:_contents length:_length];
    }
    return data;
}
- (void)appendBytes:(char *)bytes length:(int)length
{
    if (_length + length > _alloc) {
        int newAlloc = _length + length + NSDATA_ALLOC_SIZE;
        unsigned char *newContents = malloc(newAlloc);
        if (!newContents) {
NSLog(@"OUT OF MEMORY! NSData -appendBytes:length:");
            exit(0);
        }
        if (_contents) {
            memcpy(newContents, _contents, _length);
            free(_contents);
        }
        memcpy(newContents + _length, bytes, length);
        _alloc = newAlloc;
        _contents = newContents;
        _length += length;
NSLog(@"alloc %d", _alloc);
        return;
    }
    memcpy(_contents + _length, bytes, length);
    _length += length;
}
- (unsigned char *)bytes
{
    return _contents;
}
- (int)length
{
    return _length;
}
- (void)setLength:(int)length
{
    if (length > _alloc) {
        _length = _alloc;
    } else {
        _length = length;
    }
}
- (void)deleteBytesFromIndex:(int)index length:(int)length
{
    if (length <= 0) {
        return;
    }
    char *dst = _contents + index;
    char *src = dst + length;
    char *end = _contents + _length;
    for (;;) {
        if (src >= end) {
            break;
        }
        if (dst >= end) {
            break;
        }
        *dst++ = *src++;
    }
    _length -= length;
    if (_length < 0) {
        _length = 0;
    }
}
@end
@implementation NSMutableData
@end
@implementation NSMutableDictionary
@end
@implementation NSDictionary
- (int)count
{
    return _length/2;
}
- (BOOL)isEqual:(id)obj
{
    if (self == obj) {
        return YES;
    }
    return NO;
}
- (id)description
{
    return nsfmt(@"<%@ %@>", [self class], [self allKeysAndValues]);
}
- (void)dealloc
{
    if (_contents) {
        id *elts = _contents;
        for (int i=0; i<_length; i++) {
            [elts[i] autorelease];
        }
        free(_contents);
    }
    [super dealloc];
}
- (id)mutableCopy
{
    return [self copy];
}
- (id)copy
{
    id dict = [[NSMutableDictionary alloc] init];
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        [dict setValue:elts[i+1] forKey:elts[i]];
    }
    return dict;
}
+ (id)dictionary
{
    return [[[NSMutableDictionary alloc] init] autorelease];
}
+ (id)dictionaryWithObjects:(id *)objects forKeys:(id *)keys count:(int)count
{
    id dict = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i=0; i<count; i++) {
        [dict setValue:objects[i] forKey:keys[i]];
    }
    return dict;
}
- (id)allKeys
{
    id arr = [[[NSArray alloc] init] autorelease];
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if (elts[i]) {
            [arr addObject:elts[i]];
        }
    }
    return arr;
}
- (id)allValues
{
    id arr = [[[NSArray alloc] init] autorelease];
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if (elts[i]) {
            [arr addObject:elts[i+1]];
        }
    }
    return arr;
}
- (id)allKeysAndValues
{
    id arr = [[[NSArray alloc] init] autorelease];
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if (elts[i]) {
            [arr addObject:elts[i]];
            [arr addObject:elts[i+1]];
        }
    }
    return arr;
}
- (void)setNilValueForKey:(id)key
{
    [self setValue:nil forKey:key];
}
- (void)setValue:(id)val forKey:(id)key
{
    if (!key) {
        return;
    }
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if ([elts[i] isEqual:key]) {
            if (val) {
                [elts[i+1] autorelease];
                [val retain];
                elts[i+1] = val;
            } else {
                [elts[i] autorelease];
                [elts[i+1] autorelease];
                elts[i] = 0;
                elts[i+1] = 0;
            }
            return;
        }
    }
    if (val) {
        for (int i=0; i<_length; i+=2) {
            if (!elts[i]) {
                [key retain];
                [val retain];
                elts[i] = key;
                elts[i+1] = val;
                return;
            }
        }
    }
    if (!val) {
        return;
    }
    if (_length > _alloc) {
NSLog(@"SOMETHING'S WRONG");
        exit(0);
    }
    if (_length == _alloc) {
        int newAlloc = _alloc + NSDICTIONARY_ALLOC_SIZE;
        id *newContents = malloc(sizeof(id)*newAlloc);
        if (!newContents) {
NSLog(@"OUT OF MEMORY! NSDictionary -setValue:forKey:");
            exit(0);
        }
        if (_contents) {
            memcpy(newContents, _contents, sizeof(id)*_alloc);
            free(_contents);
        }
        _alloc = newAlloc;
        _contents = newContents;
        elts = _contents;
    }
    [key retain];
    [val retain];
    elts[_length++] = key;
    elts[_length++] = val;
}
/*
- (id)valueForKey:(id)key
{
    if (!key) {
        return nil;
    }
    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if ([elts[i] isEqual:key]) {
            return elts[i+1];
        }
    }
    return nil;
}
*/
- (id)valueForKey:(id)key
{
    if (!key) {
        return nil;
    }
    char *keycstr = ((NSObject *)key)->_contents;

    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if (!elts[i]) {
            continue;
        }
        if (elts[i] == key) {
            return elts[i+1];
        }
        char *cstr = ((NSObject *)elts[i])->_contents;
        if (!cstr) {
            continue;
        }
        if (!strcmp(keycstr, cstr)) {
            return elts[i+1];
        }
    }
    return nil;
}
- (BOOL)hasKey:(id)key
{
    if (!key) {
        return NO;
    }
    char *keycstr = ((NSObject *)key)->_contents;

    id *elts = _contents;
    for (int i=0; i<_length; i+=2) {
        if (!elts[i]) {
            continue;
        }
        if (elts[i] == key) {
            return YES;
        }
        char *cstr = ((NSObject *)elts[i])->_contents;
        if (!cstr) {
            continue;
        }
        if (!strcmp(keycstr, cstr)) {
            return YES;
        }
    }
    return NO;
}

@end
@implementation NSValue
+ (id)valueWithPointer:(void *)ptr
{
    return [[[self alloc] initWithPointer:ptr] autorelease];
}
- (id)initWithPointer:(void *)ptr
{
    self = [super init];
    if (self) {
        _contents = ptr;
    }
    return self;
}
- (void *)pointerValue
{
    return _contents;
}
@end

#ifdef BUILD_WITH_GNU_PRINTF
#include <printf.h>
int print_objc_object(FILE *stream, struct printf_info *info, void **args)
{
    id obj = *((id *) args[0]);
    id description = [obj description];
    char *str = [description UTF8String];
    if (!obj) {
        str = "<null>";
    } else if (!str) {
        str = "<no description>";
    }
    return fprintf(stream, "%*s", (info->left) ? -info->width : info->width, str);
}

int print_objc_object_arginfo(struct printf_info *info, size_t n, int *argtypes)
{
    if (n > 0) {
        argtypes[0] = PA_POINTER;
    }
    return 1;
}
#endif

void copyMethodsToNSConstantString(char *className)
{
    static BOOL initialized = NO;
    if (initialized) {
        return;
    }
    Class cls = objc_getClass(className);
    if (!cls) {
NSLog(@"copyMethodsToNSConstantString class '%s' not found", className);
        return;
    }
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(cls, &outCount);
    if (methods) {
//NSLog(@"copyMethodsToNSConstantString count %d", outCount);
        for (int i=0; i<outCount; i++) {
            SEL sel = method_getName(methods[i]);
            char *name = sel_getName(sel);
            if (!strncmp(name, "init", 4)) {
//NSLog(@"i %d skipping sel '%s'", i, name);
                continue;
            }
            if (!strncmp(name, "destructive", 11)) {
//NSLog(@"i %d skipping sel '%s'", i, name);
                continue;
            }
            Method m = class_getInstanceMethod(objc_getClass("NSConstantString"), sel);
            if (m) {
//                NSLog(@"i %d method exists for %s in class %s", i, name, "NSConstantString");
                continue;
            }
            IMP imp = method_getImplementation(methods[i]);
            if (!imp) {
                NSLog(@"i %d no implementation for %s in class %s", i, name, "NSString");
                continue;
            }
            imp = class_replaceMethod(objc_getClass("NSConstantString"), sel, imp, method_getTypeEncoding(methods[i]));
            if (imp) {
                NSLog(@"i %d replaced implementation for %s in class %s", i, name, "NSConstantString");
            } else {
//                NSLog(@"i %d added implementation for %s in class %s", i, name, "NSConstantString");
            }
        }
        free(methods);
    }
    initialized = YES;

}

void HOTDOG_initialize_stdout(FILE *fp)
{
    HOTDOG_stdout = fp;
}

void HOTDOG_initialize(FILE *fp)
{
    HOTDOG_stderr = fp;

    __objc_msg_forward2 = my_objc_msg_forward2;
#ifdef BUILD_WITH_GNUSTEP_RUNTIME
    __objc_msg_forward3 = my_objc_msg_forward3;
#endif
    __NSConstantStringClass = objc_getClass("NSConstantString");
    if (!__NSConstantStringClass) {
LOG("ERROR! missing NSConstantString\n");
        exit(0);
    }
    __NSStringClass = objc_getClass("NSString");
    if (!__NSStringClass) {
LOG("ERROR! missing NSString\n");
        exit(0);
    }
    __NSMutableStringClass = objc_getClass("NSMutableString");
    if (!__NSMutableStringClass) {
LOG("ERROR! missing NSMutableString\n");
        exit(0);
    }
    __NSObjectClass = objc_getClass("NSObject");
    if (!__NSObjectClass) {
LOG("ERROR! missing NSObject\n");
        exit(0);
    }

#ifdef BUILD_WITH_GNU_PRINTF
    if (register_printf_function('@', print_objc_object, print_objc_object_arginfo) != 0) {
fprintf(HOTDOG_stderr, "ERROR! register_printf_function\n");
        exit(0);
    }
#endif

    id pool = [[NSAutoreleasePool alloc] init];

    nscstr(@"Initialize NSString for forwarding NSConstantString");
    copyMethodsToNSConstantString("NSString");

    [pool drain];
}

