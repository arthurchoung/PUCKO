/*

 PUCKO

 Copyright (c) 2020 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO.

 PUCKO is free software: you can redistribute it and/or modify
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

#ifdef BUILD_FOR_OSX_ON_LINUX
typedef double __m128d;
typedef long long __m128i;
#endif

#ifdef BUILD_FOR_OSX
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif

#ifndef BUILD_FOUNDATION
#ifdef BUILD_WORKAROUND_OSX_X11_CONFLICT
#import <Foundation/NSObject.h>
#import <Foundation/NSGeometry.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#include <stdlib.h>
#include <string.h>
#else
#import <Foundation/Foundation.h>
#endif
#endif

#ifdef BUILD_FOR_OSX
#ifndef BUILD_WORKAROUND_OSX_X11_CONFLICT
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#endif
#define CGFloat float
#include <unistd.h>
#import <objc/objc-runtime.h>
char *class_getName(Class cls);
int class_getInstanceSize(Class cls);
Class class_getSuperclass(Class cls);
char *ivar_getName(Ivar ivar);
int ivar_getOffset(Ivar ivar);
char *ivar_getTypeEncoding(Ivar ivar);
Ivar *class_copyIvarList(Class cls, unsigned int *outCount);
SEL method_getName(Method m);
IMP method_getImplementation(Method m);
void method_getReturnType(Method m, char *buf, int bufsize);
id object_getClass(id obj);
#endif

#ifdef BUILD_FOR_IOS
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define NSFont UIFont
#define NSColor UIColor
#define NSImage UIImage
#define NSBezierPath UIBezierPath
@interface NSObject(JFioewjfkldsjlkfjdslkfjlkds)
- (CGSize)sizeWithAttributes:(id)dict;
@end
#endif

struct Int2 {
    union {
        int x;
        int w;
    };
    union {
        int y;
        int h;
    };
};
typedef struct Int2 Int2;

struct Int4 {
    int x;
    int y;
    int w;
    int h;
};
typedef struct Int4 Int4;

#ifdef BUILD_FOUNDATION

#ifdef BUILD_FOR_MEDMOS

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>

#import <objc/runtime.h>
#import <objc/Object.h>

#import "MEDMOS.h"

#else

#define _GNU_SOURCE
#include <sys/param.h>
#import <objc/runtime.h>
#import <objc/Object.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdint.h>

#endif

id object_copy(id obj, size_t size);

typedef struct {
    unsigned long state;
    id *itemsPtr;
    unsigned long *mutationsPtr;
    unsigned long extra[5];
} NSFastEnumerationState;

@interface NSAutoreleasePool : Object
{
    id *_objs;
    int _nobjs;
    int _alloc;
}
@end
@interface NSConstantString : Object
{
#ifndef BUILD_WITH_GUNSTEP_RUNTIME
@public
#endif
    char *_contents;
    int _length;
}
@end
@interface NSObject : Object
{
#ifndef BUILD_WITH_GUNSTEP_RUNTIME
@public
#endif
    char *_contents;
    int _length;
    int _alloc;
    int _retainCount;
}
@end
@interface NSString : NSObject
@end
@interface NSMutableString : NSString
@end
@interface NSDictionary : NSObject
@end
@interface NSMutableDictionary : NSDictionary
@end
@interface NSArray : NSObject
@end
@interface NSMutableArray : NSArray
@end
@interface NSData : NSObject
@end
@interface NSMutableData : NSData
@end
@interface NSValue : NSObject
@end

#endif

@interface IvarObject : NSObject
@end
@interface Definitions : NSObject
@end

#import "HOTDOG-lib.h"

#ifdef BUILD_FOR_MEDMOS
#import "HOTDOG-linux.h"
#endif

#ifdef BUILD_FOR_LINUX
#import "HOTDOG-linux.h"
#endif

#ifdef BUILD_FOR_OSX
#import "HOTDOG-osx.h"
#import "HOTDOG-osx-ios.h"
#endif

#ifdef BUILD_FOR_IOS
#import "HOTDOG-ios.h"
#import "HOTDOG-osx-ios.h"
#endif


