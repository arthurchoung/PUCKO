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

@implementation NSString(fjkdlsjfklsdjf)
#ifdef BUILD_FOR_IOS
- (id)runFileHandler
{
    id handlers = [[Definitions configDir:@"Config/iosFileHandlers.csv"] parseCSVFile];
    for (int i=0; i<[handlers count]; i++) {
        id elt = [handlers nth:i];
        id suffix = [elt valueForKey:@"suffix"];
        if ([self hasSuffix:suffix]) {
            id message = [elt valueForKey:@"message"];
NSLog(@"message '%@'", message);
            return [self evaluateMessage:message];
        }
    }
    [nsfmt(@"Unknown file type for '%@'", self) showAlert];
    return nil;
}
#else
- (id)runFileHandler
{
    id cmd = nsarr();
    [cmd addObject:@"hotdog-open:.pl"];
    [cmd addObject:self];
    [cmd runCommandInBackground];
    return nil;   
}
#endif

@end

