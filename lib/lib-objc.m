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

@implementation NSObject(jfkldsjflksdlkjf)
+ (id)className
{
    return nsfmt(@"<%s>", object_getClassName(self));
}
- (id)className
{
    return nsfmt(@"%s", object_getClassName(self));
}

- (id)allIvars
{
    static Class __NSObjectClass = nil;
    if (!__NSObjectClass) {
        __NSObjectClass = objc_getClass("NSObject");
        if (!__NSObjectClass) {
NSLog(@"ERROR! NSObject class not found");
            exit(0);
        }
    }

    id results = nsarr();

    Class cls = object_getClass(self);

    for (;;) {
        if (cls == __NSObjectClass) {
            break;
        }
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &outCount);
        if (!ivars) {
            break;
        }
        for (int i=0; i<outCount; i++) {
            char *type = ivar_getTypeEncoding(ivars[i]);
            [results addObject:nsfmt(@"%s %s", type, ivar_getName(ivars[i]))];
        }
        free(ivars);
        cls = class_getSuperclass(cls);
    }

    return [results join:@"\n"];
}

#ifndef BUILD_FOR_OSX
+ (id)classMethods
{
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList (object_getClass(self), &outCount);
    if (!outCount) {
        return nil;
    }
    id results = nsarr();
    for (int i=0; i<outCount; i++) {
        [results addObject:nscstr(sel_getName(method_getName(methods[i])))];
    }
    return results;
}

- (id)allKeysForAllClasses
{
    id results = nsarr();
    
    Class classCursor = object_getClass(self);
    while (classCursor) {
        unsigned int outCount = 0;
        objc_property_t *props = class_copyPropertyList(classCursor, &outCount);
        for (int i=0; i<outCount; i++) {
            char *str = property_getName(props[i]);
            if (!str) {
                continue;
            }
            [results addObject:[NSString stringWithUTF8String:str]];
        }
        free(props);
        classCursor = class_getSuperclass(classCursor);
    }
    
    return results;
}
- (id)allKeys
{
    id results = nsarr();
    unsigned int outCount = 0;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        char *str = property_getName(props[i]);
        if (!str) {
            continue;
        }
        [results addObject:[NSString stringWithUTF8String:str]];
    }
    free(props);
    return results;
}

#endif
@end


@implementation NSString(jfksdjfklsdjkffsdf)

- (id)asInstance
{
    return [[[objc_getClass([self UTF8String]) alloc] init] autorelease];
}
- (id)asClass
{
    Class cls = objc_getClass([self UTF8String]);
#ifdef BUILD_FOUNDATION
    if (!cls) {
NSLog(@"Class not found '%@'", self);
        exit(0);
    }
#endif
    return cls;
}
- (id)alloc
{
    return [objc_getClass([self UTF8String]) alloc];
}

- (SEL)asSelector
{
    return sel_registerName([self UTF8String]);
}

#ifndef BUILD_FOR_OSX
- (id)selectorsForClass
{
    id selectors = nsarr();
    {
        unsigned int outCount = 0;
        Method *methods = class_copyMethodList(object_getClass(objc_getClass([self UTF8String])), &outCount);
        for (int i=0; i<outCount; i++) {
            SEL sel = method_getName(methods[i]);
            const char *name = sel_getName(sel);
            [selectors addObject:nscstr(name)];
        }
        free(methods);
    }
    return [selectors sort];
}

- (id)selectorsForInstanceOfClass
{
    id selectors = nsarr();
    {
        unsigned int outCount = 0;
        Method *methods = class_copyMethodList(objc_getClass([self UTF8String]), &outCount);
        for (int i=0; i<outCount; i++) {
            SEL sel = method_getName(methods[i]);
            const char *name = sel_getName(sel);
            [selectors addObject:nscstr(name)];
        }
        free(methods);
    }
    return [selectors sort];
}
#endif

- (id)selectorKeywords
{
    id arr = nsarr();
    {
        char *str = strdup([self UTF8String]);
        char *p = str;
        for(;;) {
            char *q = strchr(p, ':');
            if (!q) {
                break;
            }
            *q = 0;
            [arr addObject:nscstr(p)];
            p = q + 1;
        }
        free(str);
    }
    return arr;
}
@end

@implementation Definitions(fjieowjfklsdjkflsdfj)
+ (id)allClassNames
{
    int count = objc_getClassList(NULL, 0);
    Class classList[count];
    count = objc_getClassList(classList, count);
    id results = nsarr();
    for (int i=0; i<count; i++) {
        id str = nscstr(class_getName(classList[i]));
        [results addObject:str];
    }
    return results;
}

@end
