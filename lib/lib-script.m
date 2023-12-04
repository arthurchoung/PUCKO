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

#ifdef BUILD_FOR_OSX
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#endif

#define OBJC_TYPE_BUFSIZE 500

static id callMethod(id target, struct objc_method *m, id args)
{
    SEL sel = method_getName(m);
    char *selectorName = sel_getName(sel);
    if (!strncmp("init", selectorName, 4)) {
        return nil;
    }
    if (!strncmp("alloc", selectorName, 5)) {
        return nil;
    }
    if (!strncmp("copy", selectorName, 4)) {
        return nil;
    }
    if (!strncmp("mutableCopy", selectorName, 11)) {
        return nil;
    }
    if (!strcmp("new", selectorName)) {
        return nil;
    }

    IMP imp = method_getImplementation(m);
    
    int numberOfArguments = method_getNumberOfArguments(m);
    
    if ([args count] != numberOfArguments-2) {
        id arr = nsarr();
        [arr addObject:@"Incorrect number of arguments:"];
        [arr addObject:nsfmt(@"| target: %@", target)];
        [arr addObject:nsfmt(@"| selector: %s", selectorName)];
        [arr addObject:nsfmt(@"| arguments: %@", args)];
#ifdef BUILD_FOUNDATION
#else
        [arr addObject:nsfmt(@"| callStackSymbols %@", [NSThread callStackSymbols])];
#endif
        id str = [arr join:@"\n"];
NSLog(@"Error callMethod %@", str);
        return nil;
    }

    if ([args count] > OBJC_TYPE_BUFSIZE-2) {
NSLog(@"Too many arguments");
        return nil;
    }

    char signature[OBJC_TYPE_BUFSIZE];
    int signatureIndex = 0;

    char typeBuffer[OBJC_TYPE_BUFSIZE];
    method_getReturnType(m, typeBuffer, OBJC_TYPE_BUFSIZE);
    signature[signatureIndex++] = typeBuffer[0];
    
#ifdef BUILD_FOR_OSX
    for (int i=0; i<numberOfArguments; i++) {
        char *argType = NULL;
        int argOffset = 0;
        method_getArgumentInfo(m, i, &argType, &argOffset);

        signature[signatureIndex++] = argType[0];
    }
#else
    for (int i=0; i<numberOfArguments; i++) {
        method_getArgumentType(m, i, typeBuffer, OBJC_TYPE_BUFSIZE);
        signature[signatureIndex++] = typeBuffer[0];
    }
#endif

    if (signature[1] != '@') {
NSLog(@"Bad signature");
        return nil;
    }

    if (signature[2] != ':') {
NSLog(@"Bad signature");
        return nil;
    }

    signature[signatureIndex] = 0;
    if (signature[3] == 0) {
        if (signature[0] == 'v') {
            void (*func)(id, SEL) = imp;
            func(target, sel);
            return target;
        } else if (signature[0] == '@') {
            id (*func)(id, SEL) = imp;
            return func(target, sel);
        } else if (signature[0] == 'i') {
            int (*func)(id, SEL) = imp;
            int val = func(target, sel);
            return nsfmt(@"%d", val);
        } else if (signature[0] == 'd') {
            double (*func)(id, SEL) = imp;
            double val = func(target, sel);
            return nsfmt(@"%f", val);
        } else if (signature[0] == 'C') {
            unsigned char (*func)(id, SEL) = imp;
            unsigned char val = func(target, sel);
            return nsfmt(@"%u", val);
        } else if (signature[0] == 'c') {
            char (*func)(id, SEL) = imp;
            char val = func(target, sel);
            return nsfmt(@"%d", val);
        } else if (signature[0] == 'L') {
            unsigned long (*func)(id, SEL) = imp;
            unsigned long val = func(target, sel);
            return nsfmt(@"%lu", val);
        } else if (signature[0] == 'B') {
            _Bool (*func)(id, SEL) = imp;
            _Bool val = func(target, sel);
            return (val) ? @"1" : @"0";
        } else if (signature[0] == 'Q') {
            unsigned long long (*func)(id, SEL) = imp;
            unsigned long long val = func(target, sel);
            return nsfmt(@"%llu", val);
        } else if (signature[0] == 'I') {
            unsigned int (*func)(id, SEL) = imp;
            unsigned int val = func(target, sel);
            return nsfmt(@"%u", val);
        }
    } else if (signature[3] == '@') {
        if (signature[4] == 0) {
            if (signature[0] == 'v') {
                void (*func)(id, SEL, id) = imp;
                func(target, sel, [args nth:0]);
                return target;
            } else if (signature[0] == '@') {
                id (*func)(id, SEL, id) = imp;
                return func(target, sel, [args nth:0]);
            } else if (signature[0] == 'i') {
                int (*func)(id, SEL, id) = imp;
                int val = func(target, sel, [args nth:0]);
                return nsfmt(@"%d", val);
            } else if (signature[0] == 'C') {
                unsigned char (*func)(id, SEL, id) = imp;
                unsigned char val = func(target, sel, [args nth:0]);
                return nsfmt(@"%u", val);
            } else if (signature[0] == 'c') {
                char (*func)(id, SEL, id) = imp;
                char val = func(target, sel, [args nth:0]);
                return nsfmt(@"%d", val);
            } else if (signature[0] == 'B') {
                _Bool (*func)(id, SEL, id) = imp;
                _Bool val = func(target, sel, [args nth:0]);
                return (val) ? @"1" : @"0";
            }
        } else if (signature[4] == '@') {
            if (signature[5] == 0) {
                if (signature[0] == 'v') {
                    void (*func)(id, SEL, id, id) = imp;
                    func(target, sel, [args nth:0], [args nth:1]);
                    return target;
                } else if (signature[0] == '@') {
                    id (*func)(id, SEL, id, id) = imp;
                    return func(target, sel, [args nth:0], [args nth:1]);
                } else if (signature[0] == 'C') {
                    unsigned char (*func)(id, SEL, id, id) = imp;
                    unsigned char val = func(target, sel, [args nth:0], [args nth:1]);
                    return nsfmt(@"%u", val);
                }
            } else if (signature[5] == '@') {
                if (signature[6] == 0) {
                    if (signature[0] == '@') {
                        id (*func)(id, SEL, id, id, id) = imp;
                        return func(target, sel, [args nth:0], [args nth:1], [args nth:2]);
                    } else if (signature[0] == 'v') {
                        void (*func)(id, SEL, id, id, id) = imp;
                        func(target, sel, [args nth:0], [args nth:1], [args nth:2]);
                        return target;
                    } else if (signature[0] == 'C') {
                        unsigned char (*func)(id, SEL, id, id, id) = imp;
                        unsigned char val = func(target, sel, [args nth:0], [args nth:1], [args nth:2]);
                        return nsfmt(@"%u", val);
                    }
                } else if (signature[6] == '@') {
                    if (signature[7] == 0) {
                        if (signature[0] == 'v') {
                            void (*func)(id, SEL, id, id, id, id) = imp;
                            func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3]);
                            return target;
                        } else if (signature[0] == '@') {
                            id (*func)(id, SEL, id, id, id, id) = imp;
                            return func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3]);
                        }
                    } else if (signature[7] == '@') {
                        if (signature[8] == 0) {
                            if (signature[0] == 'v') {
                                void (*func)(id, SEL, id, id, id, id, id) = imp;
                                func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3], [args nth:4]);
                                return target;
                            } else if (signature[0] == '@') {
                                id (*func)(id, SEL, id, id, id, id, id) = imp;
                                return func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3], [args nth:4]);
                            }
                        } else if (signature[8] == '@') {
                            if (signature[9] == '@') {
                                if (signature[10] == 0) {
                                    if (signature[0] == '@') {
                                        id (*func)(id, SEL, id, id, id, id, id, id, id) = imp;
                                        return func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3], [args nth:4], [args nth:5], [args nth:6]);
                                    }
                                }
                            }
                        }
                    } else if (signature[7] == 'i') {
                        if (signature[8] == 0) {
                            if (signature[0] == 'v') {
                                void (*func)(id, SEL, id, id, id, id, int) = imp;
                                func(target, sel, [args nth:0], [args nth:1], [args nth:2], [args nth:3], [[args nth:4] intValue]);
                                return target;
                            }
                        }
                    }
                } else if (signature[6] == 'i') {
                    if (signature[7] == '@') {
                        if (signature[8] == '@') {
                            if (signature[9] == 0) {
                                if (signature[0] == '@') {
                                    id (*func)(id, SEL, id, id, id, int, id, id) = imp;
                                    return func(target, sel, [args nth:0], [args nth:1], [args nth:2], [[args nth:3] intValue], [args nth:4], [args nth:5]);
                                }
                            }
                        }
                    }
                }
            } else if (signature[5] == 'i') {
                if (signature[6] == 0) {
                    if (signature[0] == 'v') {
                        void (*func)(id, SEL, id, id, int) = imp;
                        func(target, sel, [args nth:0], [args nth:1], [[args nth:2] intValue]);
                        return target;
                    } else if (signature[0] == '@') {
                        id (*func)(id, SEL, id, id, int) = imp;
                        return func(target, sel, [args nth:0], [args nth:1], [[args nth:2] intValue]);
                    }
                } else if (signature[6] == '@') {
                    if (signature[7] == '@') {
                        if (signature[8] == '@') {
                            if (signature[9] == '@') {
                                if (signature[10] == 0) {
                                    if (signature[0] == '@') {
                                        id (*func)(id, SEL, id, id, int, id, id, id, id) = imp;
                                        return func(target, sel, [args nth:0], [args nth:1], [[args nth:2] intValue], [args nth:3], [args nth:4], [args nth:5], [args nth:6]);
                                    }
                                }
                            }
                        }
                    }
                } else if (signature[6] == 'i') {
                    if (signature[7] == 'i') {
                        if (signature[8] == 0) {
                            if (signature[0] == '@') {
                                id (*func)(id, SEL, id, id, int, int, int) = imp;
                                return func(target, sel, [args nth:0], [args nth:1], [[args nth:2] intValue], [[args nth:3] intValue], [[args nth:4] intValue]);
                            }
                        }
                    }
                }
            } else if (signature[5] == 'C') {
                if (signature[6] == 0) {
                    if (signature[0] == '@') {
                        id (*func)(id, SEL, id, id, unsigned char) = imp;
                        return func(target, sel, [args nth:0], [args nth:1], [[args nth:2] unsignedCharValue]);
                    }
                }
            }
        } else if (signature[4] == 'i') {
            if (signature[5] == 0) {
                if (signature[0] == 'v') {
                    void (*func)(id, SEL, id, int) = imp;
                    func(target, sel, [args nth:0], [[args nth:1] intValue]);
                    return target;
                } else if (signature[0] == '@') {
                    id (*func)(id, SEL, id, int) = imp;
                    return func(target, sel, [args nth:0], [[args nth:1] intValue]);
                }
            } else if (signature[5] == 'i') {
                if (signature[6] == 0) {
                    if (signature[0] == 'v') {
                        void (*func)(id, SEL, id, int, int) = imp;
                        func(target, sel, [args nth:0], [[args nth:1] intValue], [[args nth:2] intValue]);
                        return target;
                    } else if (signature[0] == 'L') {
                        unsigned long (*func)(id, SEL, id, int, int) = imp;
                        unsigned long val = func(target, sel, [args nth:0], [[args nth:1] intValue], [[args nth:2] intValue]);
                        return nsfmt(@"%lu", val);
                    }
                } else if (signature[6] == 'i') {
                    if (signature[7] == 'i') {
                        if (signature[8] == 0) {
                            if (signature[0] == 'v') {
                                void (*func)(id, SEL, id, int, int, int, int) = imp;
                                func(target, sel, [args nth:0], [[args nth:1] intValue], [[args nth:2] intValue], [[args nth:3] intValue], [[args nth:4] intValue]);
                                return target;
                            } else if (signature[0] == '@') {
                                id (*func)(id, SEL, id, int, int, int, int) = imp;
                                return func(target, sel, [args nth:0], [[args nth:1] intValue], [[args nth:2] intValue], [[args nth:3] intValue], [[args nth:4] intValue]);
                            }
                        }
                    }
                }
            } else if (signature[5] == '@') {
                if (signature[6] == '@') {
                    if (signature[7] == '@') {
                        if (signature[8] == '@') {
                            if (signature[9] == 0) {
                                if (signature[0] == '@') {
                                    id (*func)(id, SEL, id, int, id, id, id, id) = imp;
                                    return func(target, sel, [args nth:0], [[args nth:1] intValue], [args nth:2], [args nth:3], [args nth:4], [args nth:5]);
                                }
                            }
                        }
                    }
                }
            }
        } else if (signature[4] == 'd') {
            if (signature[5] == 0) {
                if (signature[0] == '@') {
                    id (*func)(id, SEL, id, double) = imp;
                    return func(target, sel, [args nth:0], [[args nth:1] doubleValue]);
                }
            }
        } else if (signature[4] == 'l') {
            if (signature[5] == 0) {
                if (signature[0] == 'c') {
                    char (*func)(id, SEL, id, long) = imp;
                    char val = func(target, sel, [args nth:0], [[args nth:1] longValue]);
                    return nsfmt(@"%d", val);
                }
            }
        } else if (signature[4] == 'q') {
            if (signature[5] == 0) {
                if (signature[0] == 'B') {
                    _Bool (*func)(id, SEL, id, long long) = imp;
                    _Bool val = func(target, sel, [args nth:0], [[args nth:1] longLongValue]);
                    return (val) ? @"1" : @"0";
                }
            }
        } else if (signature[4] == 'C') {
            if (signature[5] == 0) {
                if (signature[0] == '@') {
                    id (*func)(id, SEL, id, unsigned char) = imp;
                    return func(target, sel, [args nth:0], [[args nth:1] unsignedCharValue]);
                } else if (signature[0] == 'v') {
                    void (*func)(id, SEL, id, unsigned char) = imp;
                    func(target, sel, [args nth:0], [[args nth:1] unsignedCharValue]);
                    return target;
                }
            } else if (signature[5] == '@') {
                if (signature[6] == '@') {
                    if (signature[7] == 0) {
                        if (signature[0] == 'v') {
                            void (*func)(id, SEL, id, unsigned char, id, id) = imp;
                            func(target, sel, [args nth:0], [[args nth:1] unsignedCharValue], [args nth:2], [args nth:3]);
                            return target;
                        }
                    } else if (signature[7] == '@') {
                        if (signature[8] == 0) {
                            if (signature[0] == 'v') {
                                void (*func)(id, SEL, id, unsigned char, id, id, id) = imp;
                                func(target, sel, [args nth:0], [[args nth:1] unsignedCharValue], [args nth:2], [args nth:3], [args nth:4]);
                                return target;
                            }
                        }
                    }
                }
            }
        }
    } else if (signature[3] == 'i') {
        if (signature[4] == 0) {
            if (signature[0] == 'v') {
                void (*func)(id, SEL, int) = imp;
                func(target, sel, [[args nth:0] intValue]);
                return target;
            } else if (signature[0] == '@') {
                id (*func)(id, SEL, int) = imp;
                return func(target, sel, [[args nth:0] intValue]);
            } else if (signature[0] == 'C') {
                unsigned char (*func)(id, SEL, int) = imp;
                unsigned char val = func(target, sel, [[args nth:0] intValue]);
                return nsfmt(@"%u", val);
            } else if (signature[0] == 'i') {
                int (*func)(id, SEL, int) = imp;
                int val = func(target, sel, [[args nth:0] intValue]);
                return nsfmt(@"%d", val);
            }
        } else if (signature[4] == 'i') {
            if (signature[5] == 0) {
                if (signature[0] == '@') {
                    id (*func)(id, SEL, int, int) = imp;
                    return func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue]);
                } else if (signature[0] == 'v') {
                    void (*func)(id, SEL, int, int) = imp;
                    func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue]);
                    return target;
                } else if (signature[0] == 'C') {
                    unsigned char (*func)(id, SEL, int, int) = imp;
                    unsigned char val = func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue]);
                    return nsfmt(@"%d", val);
                }
            } else if (signature[5] == 'i') {
                if (signature[6] == 0) {
                    if (signature[0] == '@') {
                        id (*func)(id, SEL, int, int, int) = imp;
                        return func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue], [[args nth:2] intValue]);
                    }
                } else if (signature[6] == 'i') {
                    if (signature[7] == 0) {
                        if (signature[0] == 'v') {
                            void (*func)(id, SEL, int, int, int, int) = imp;
                            func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue], [[args nth:2] intValue], [[args nth:3] intValue]);
                            return target;
                        } else if (signature[0] == '@') {
                            id (*func)(id, SEL, int, int, int, int) = imp;
                            return func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue], [[args nth:2] intValue], [[args nth:3] intValue]);
                        }
                    }
                }
            } else if (signature[5] == '@') {
                if (signature[6] == 0) {
                    if (signature[0] == '@') {
                        id (*func)(id, SEL, int, int, id) = imp;
                        return func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue], [args nth:2]);
                    }
                } else if (signature[6] == '@') {
                    if (signature[7] == 0) {
                        if (signature[0] == '@') {
                            id (*func)(id, SEL, int, int, id, id) = imp;
                            return func(target, sel, [[args nth:0] intValue], [[args nth:1] intValue], [args nth:2], [args nth:3]);
                        }
                    }
                }
            }
        } else if (signature[4] == '@') {
            if (signature[5] == 0) {
                if (signature[0] == 'v') {
                    void (*func)(id, SEL, int, id) = imp;
                    func(target, sel, [[args nth:0] intValue], [args nth:1]);
                    return target;
                } else if (signature[0] == '@') {
                    id (*func)(id, SEL, int, id) = imp;
                    return func(target, sel, [[args nth:0] intValue], [args nth:1]);
                }
            } else if (signature[5] == '@') {
                if (signature[0] == '@') {
                    id (*func)(id, SEL, int, id, id) = imp;
                    return func(target, sel, [[args nth:0] intValue], [args nth:1], [args nth:2]);
                }
            }
        }
    } else if (signature[3] == 'L') {
        if (signature[4] == 0) {
            if (signature[0] == 'v') {
                void (*func)(id, SEL, unsigned long) = imp;
                func(target, sel, [[args nth:0] unsignedLongValue]);
                return target;
            }
        } else if (signature[4] == 'i') {
            if (signature[5] == 0) {
                if (signature[0] == 'v') {
                    void (*func)(id, SEL, unsigned long, int) = imp;
                    func(target, sel, [[args nth:0] unsignedLongValue], [[args nth:1] intValue]);
                    return target;
                }
            }
        }
    } else if (signature[3] == 'd') {
        if (signature[4] == 0) {
            if (signature[0] == '@') {
                id (*func)(id, SEL, double) = imp;
                return func(target, sel, [[args nth:0] doubleValue]);
            } else if (signature[0] == 'C') {
                unsigned char (*func)(id, SEL, double) = imp;
                unsigned char val = func(target, sel, [[args nth:0] doubleValue]);
                return nsfmt(@"%u", val);
            }
        } else if (signature[4] == 'd') {
            if (signature[5] == 0) {
                if (signature[0] == '@') {
                    id (*func)(id, SEL, double, double) = imp;
                    return func(target, sel, [[args nth:0] doubleValue], [[args nth:1] doubleValue]);
                } else if (signature[0] == 'd') {
                    double (*func)(id, SEL, double, double) = imp;
                    double val = func(target, sel, [[args nth:0] doubleValue], [[args nth:1] doubleValue]);
                    return nsfmt(@"%f", val);
                }
            }
        }
    }

    id err = nsfmt(@"unhandled signature '%s' selector '%s'", signature, selectorName);
NSLog(@"%@", err);
    [err showAlert];
    return nil;
}

//FIXME
// I am copy-pasting this section so that these methods will get copied to NSConstantString
// There should be a better way
// Probably these methods don't need to be in NSObject, but maybe should also be in another
// class, but I need to double-check first
@implementation NSObject(jfksdjkflsdkfj)
- (id)evaluateFile:(id)path
{
    id str = [path stringFromFile];
    return [self evaluateMessage:str];
}
- (id)evaluateAsMessage
{
    if (![self length]) {
        return nil;
    }
    return [self executeScript];
}
- (id)evaluateAsMessageWithContext:(id)context
{
    if (![self length]) {
        return nil;
    }
    return [self executeScriptWithContext:context];
}
- (id)evaluateMessage
{
    if (![self length]) {
        return nil;
    }
    return [self executeScript];
}
+ (id)evaluateMessage:(id)message
{
    if (![message length]) {
        return nil;
    }
    return [message executeScriptWithContext:self];
}
- (id)evaluateMessage:(id)message
{
    if (![message length]) {
        return nil;
    }
    return [message executeScriptWithContext:self];
}
- (id)evaluateMessageWithContext:(id)context
{
    if (![self length]) {
        return nil;
    }
    return [self executeScriptWithContext:context];
}
@end
@implementation NSString(jejskfjkdsfjkfksdjkflsdkfj)
- (id)evaluateFile:(id)path
{
    id str = [path stringFromFile];
    return [self evaluateMessage:str];
}
- (id)evaluateAsMessage
{
    if (![self length]) {
        return nil;
    }
    return [self executeScript];
}
- (id)evaluateAsMessageWithContext:(id)context
{
    if (![self length]) {
        return nil;
    }
    return [self executeScriptWithContext:context];
}
- (id)evaluateMessage
{
    if (![self length]) {
        return nil;
    }
    return [self executeScript];
}
+ (id)evaluateMessage:(id)message
{
    if (![message length]) {
        return nil;
    }
    return [message executeScriptWithContext:self];
}
- (id)evaluateMessage:(id)message
{
    if (![message length]) {
        return nil;
    }
    return [message executeScriptWithContext:self];
}
- (id)evaluateMessageWithContext:(id)context
{
    if (![self length]) {
        return nil;
    }
    return [self executeScriptWithContext:context];
}
@end
/// end FIXME

@implementation NSArray(fjkdlsjfklsdjf)
- (id)executeScript
{
    return [self executeScriptWithContext:[Definitions namespace]];
}
- (id)executeScriptWithContext:(id)initialObject
{
    id code = [self arrayByAddingObject:[[[objc_getClass("ScriptToken") alloc] init] autorelease]];
    id result = [code executeInstructionsWithContext:initialObject initialObject:initialObject];
    return result;
}
@end

@implementation NSString(jfksldjfk)
- (id)executeScript
{
    return [self executeScriptWithContext:[Definitions namespace]];
}
- (id)executeScriptWithContext:(id)initialObject
{
    id code = [self asScriptInstructions];
    id result = [code executeInstructionsWithContext:initialObject initialObject:initialObject];
    return result;
}
- (id)asScriptToken
{
    return [objc_getClass("ScriptToken") tokenWithText:self];
}
@end


@interface ScriptToken : IvarObject
{
    id _text;
}
@end
@implementation ScriptToken
+ (id)tokenWithText:(id)text
{
    id obj = [[[self alloc] init] autorelease];
    [obj setValue:text forKey:@"text"];
    return obj;
}

- (id)description
{
    return nsfmt(@"<%@ %@>", [self class], [_text description]);
}
- (id)evaluateWithContext:(id)context
{
    return self;
}
- (BOOL)isEqual:(id)obj
{
    if ([obj isKindOfClass:object_getClass(self)]) {
        if ([_text isEqual:[obj valueForKey:@"text"]]) {
            return YES;
        }
    }
    return NO;
}

@end

@interface ScriptParser : IvarObject
{
    id _input;
    id _cells;
    id _current;
    BOOL _stringIsQuoted;
    char *_p;
}
@end
@implementation ScriptParser
- (id)convertCStringToObject:(char *)cstring
{
    if (_stringIsQuoted) {
        _stringIsQuoted = NO;
        return nscstr(cstring);
    }
    if (!*cstring) {
        return nil;
    }
    char *endptr;
    long lvalue = strtol(cstring, &endptr, 10);
    if (*endptr == 0) {
        return nscstr(cstring);
    }
    double dvalue = strtod(cstring, &endptr);
    if (*endptr == 0) {
        return nscstr(cstring);
    }

    return [nscstr(cstring) asScriptToken];
}
- (void)parseQuote:(char)quote_char
{
    _stringIsQuoted = YES;
    _p++;
    while (*_p) {
        if (*_p == quote_char) {
            _p++;
            break;
        } else if (*_p == '\\') {
            _p++;
            if (*_p) {
                if (*_p == 'n') {
                    [_current addObject:@"\n"];
                } else {
                    [_current addObject:nsfmt(@"%c", *_p)];
                }
                _p++;
                continue;
            } else {
                /* parse error */
                break;
            }
        }
        [_current addObject:nsfmt(@"%c", *_p)];
        _p++;
    }
}
- (void)parseComment
{
    [self flush];
    _p++;
    while (*_p) {
        if (*_p == '\n') {
            _p++;
            break;
        }
        _p++;
    }
}
- (void)flush
{
    if ([_current count] || _stringIsQuoted) {
        id obj = [self convertCStringToObject:[[_current join:@""] UTF8String]];
        if (obj) {
            [_cells addObject:obj];
        }
        [_current removeAllObjects];
    }
}
- (void)parseWhitespace
{
    [self flush];
    _p++;
}
- (void)parseLF
{
    [self flush];
    _p++;
}
- (void)parseChar
{
    [_current addObject:nsfmt(@"%c", *_p)];
    _p++;
}
- (id)processString:(id)input
{
    [self setValue:input forKey:@"input"];
    [self setValue:nsarr() forKey:@"cells"];
    [self setValue:nsarr() forKey:@"current"];
    _stringIsQuoted = NO;
    _p = [input UTF8String];

    while (*_p) {
        if (*_p == '"') {
            [self parseQuote:'"'];
        } else if (*_p == '\'') {
            [self parseQuote:'\''];
        } else if (isspace(*_p)) {
            [self parseWhitespace];
        } else if (*_p == '#') {
            [self parseComment];
        } else if (*_p == ':') {
            [_cells addObject:[nsfmt(@"%@:", [_current join:@""]) asScriptToken]];
            [_current removeAllObjects];
            _p++;
        } else if (*_p == '|'
                   || *_p == ';') {
            [self flush];
            [_cells addObject:[nsfmt(@"%c", *_p) asScriptToken]];
            [_current removeAllObjects];
            _p++;
        } else if ((*_p == '[')
                   || (*_p == ']')
                   || (*_p == '(')
                   || (*_p == ')'))
        {
            [self flush];
            [_cells addObject:[nsfmt(@"%c", *_p) asScriptToken]];
            _p++;
        } else {
            [self parseChar];
        }
    }
    [self flush];
    [_cells addObject:[[[objc_getClass("ScriptToken") alloc] init] autorelease]];
    return _cells;
}
@end

@implementation NSString(sdfjklsdjkfljsdlfjsdkf)
- (id)asScriptInstructions
{
    id parser = [[[ScriptParser alloc] init] autorelease];
    return [parser processString:self];
}
@end

@implementation NSArray(jfkdlsfjk)
- (id)executeInstructionsWithContext:(id)context initialObject:(id)initialObject
{
    id cpu = [[[objc_getClass("ScriptInterpreter") alloc] init] autorelease];
    [cpu setValue:initialObject forKey:@"initialObject"];
    [cpu setValue:context forKey:@"contextualObject"];
    [cpu setValue:initialObject forKey:@"recipient"];
    id recipient = initialObject;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        [cpu executeInstruction:elt];
        recipient = [cpu valueForKey:@"recipient"];
        if (!recipient) {
            return nil;
        }
    }
    return recipient;
}

@end


@interface ScriptInterpreter : IvarObject
{
    id _initialObject;
    id _contextualObject;
    id _recipient;
    BOOL _ignoreReturnValue;
    id _selectorName;
    id _args;
    id _bracket;
    int _bracketDepth;
    id _parenthesis;
}
@end
@implementation ScriptInterpreter

- (id)init
{
    self = [super init];
    if (self) {
        [self resetState];
    }
    return self;
}

- (void)resetState
{
    _ignoreReturnValue = NO;
    [self setValue:@"" forKey:@"selectorName"];
    [self setValue:nsarr() forKey:@"args"];
}

- (id)executeInstruction:(id)instruction
{
    if ([instruction isKindOfClass:objc_getClass("ScriptToken")]) {
        id instructionText = [instruction valueForKey:@"text"];
        if (!instructionText) {
//            NSLog(@"empty instruction");
            id result = [self sendMessage];
//            NSLog(@"result %@", result);
            if (!_ignoreReturnValue) {
                [self setValue:result forKey:@"recipient"];
            }
            [self resetState];
            return nil;
        }
    }
    
    if (_parenthesis) {
        if ([_parenthesis valueForKey:@"parenthesis"]) {
            [_parenthesis executeInstruction:instruction];
        } else {
            id text = nil;
            if ([instruction isKindOfClass:objc_getClass("ScriptToken")]) {
                text = [instruction valueForKey:@"text"];
            }
            if ([text isEqual:@")"]) {
                [_parenthesis executeInstruction:[[[objc_getClass("ScriptToken") alloc] init] autorelease]];
                id result = [_parenthesis valueForKey:@"recipient"];
                if (result) {
                    [_args addObject:result];
                }
                [self setValue:nil forKey:@"parenthesis"];
            } else {
                [_parenthesis executeInstruction:instruction];
            }
        }
    } else if (_bracket) {
        if (_bracketDepth) {
            id text = nil;
            if ([instruction isKindOfClass:objc_getClass("ScriptToken")]) {
                text = [instruction valueForKey:@"text"];
            }
            if ([text isEqual:@"]"]) {
                _bracketDepth--;
                if (_bracketDepth) {
                    [_bracket addObject:instruction];
                } else {
                    [_args addObject:_bracket];
                    [self setValue:nil forKey:@"bracket"];
                }
            } else if ([text isEqual:@"["]) {
                _bracketDepth++;
                [_bracket addObject:instruction];
            } else {
                [_bracket addObject:instruction];
            }
        } else {
            NSLog(@"Error, this shouldn't happen: ScriptInterpreter %@ executeInstruction:%@", self, instruction);
        }
    } else {
        if ([instruction isKindOfClass:objc_getClass("ScriptToken")]) {
            id text = [instruction valueForKey:@"text"];
            if ([text hasSuffix:@":"]) {
                [self setValue:[_selectorName cat:text] forKey:@"selectorName"];
            } else if ([text isEqual:@"|"]) {
                id result = [self sendMessage];
                if (!_ignoreReturnValue) {
                    [self setValue:result forKey:@"recipient"];
                }
                [self resetState];
            } else if ([text isEqual:@";"]) {
                id result = [self sendMessage];
                [self setValue:_initialObject forKey:@"recipient"];
                [self resetState];
            } else if ([text isEqual:@"["]) {
                [self setValue:nsarr() forKey:@"bracket"];
                _bracketDepth = 1;
            } else if ([text isEqual:@"("]) {
                id cpu = [[[objc_getClass("ScriptInterpreter") alloc] init] autorelease];
                [cpu setValue:_initialObject forKey:@"initialObject"];
                [cpu setValue:_contextualObject forKey:@"contextualObject"];
                [cpu setValue:_initialObject forKey:@"recipient"];
                [self setValue:cpu forKey:@"parenthesis"];
            } else {
                if ([_selectorName length]) {
                    id result = [_contextualObject valueForKey:text];
                    if (!result) {
                        NSLog(@"unable to resolve argument selectorName %@ text %@ contextualObject %@", _selectorName, text, _contextualObject);
                        if (isnsdict(_contextualObject)) {
                            NSLog(@"contextualObject %@", [_contextualObject allKeysAndValues]);
                        }
                        return nil;
                    }
                    [_args addObject:result];
                } else {
//                    NSLog(@"text %@", text);
                    [self setValue:[_selectorName cat:text] forKey:@"selectorName"];
                }
            }
        } else {
            [_args addObject:instruction];
        }
    }
    return nil;
}

- (id)sendMessage
{
//    NSLog(@"sendMessage selectorName %@", _selectorName);
    if (!_recipient) {
        return nil;
    }

    if (![_selectorName length]) {
        int argc = [_args count];
        if (!argc) {
            return nil;
        } else if (argc == 1) {
            return [_args nth:0];
        } else {
            return _args;
        }
    }
    SEL sel = sel_registerName([_selectorName UTF8String]);
    struct objc_method *m = NULL;
#ifdef BUILD_FOUNDATION
    id cls = object_getClass(_recipient);;
    if (cls == objc_getClass("NSConstantString")) {
        cls = objc_getClass("NSString");
    }
    BOOL isClass = class_isMetaClass(cls);
    if (isClass) {
        m = class_getClassMethod(_recipient, sel);
    } else {
        m = class_getInstanceMethod(cls, sel);
    }
#else
    BOOL isClass = (_recipient == [_recipient class]) ? YES : NO;
    if (isClass) {
        m = class_getClassMethod(_recipient, sel);
        if (!m) {
            m = class_getInstanceMethod(_recipient, sel);
        }
    } else {
        m = class_getInstanceMethod(object_getClass(_recipient), sel);
    }
#endif
    
    if (m) {
//                NSLog(@"selectorName %@ args %@", selectorName, args);
        id result = callMethod(_recipient, m, _args);
//        NSLog(@"sendMessage result %@", result);
        return result;
    }
    
    id valueForKey = [_recipient valueForKey:_selectorName];
    if (valueForKey) {
        return valueForKey;
    }
    if ([_recipient hasKey:_selectorName]) {
        return nil;
    }
    
    {
        id defs = objc_getClass("Definitions");
        m = class_getClassMethod(defs, sel);
        if (m) {
            return callMethod(defs, m, _args);
        }
    }

    if ([_selectorName respondsToSelector:@selector(valueForKey)]) {
        id valueForKey = [_selectorName valueForKey];
        if (valueForKey) {
            return valueForKey;
        }
    }

//    NSLog(@"unable to resolve selector %@ sent to class %s", _selectorName, object_getClassName(_recipient));
    
    return nil;
}

@end

@implementation NSObject(fmeklwfmkldsmfkmsdklfm)
+ (id)callMethodName:(id)methodName args:(id)args
{
    SEL sel = sel_registerName([methodName UTF8String]);
    struct objc_method *m = class_getClassMethod(self, sel);
    if (m) {
        return callMethod(self, m, args);
    }
NSLog(@"method not found '%@'", methodName);
    return nil;
}
@end

