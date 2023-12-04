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

@implementation NSString(fjewiojfiosdjfkdsjlkfj)
- (BOOL)moveToTrash
{
    id trashPath = [Definitions homeDir:@"Trash"];
    if (![trashPath fileExists]) {
        [trashPath makeDirectory];
    } else {
        if ([trashPath isFile]) {
            id tempTrashPath = [nsfmt(@"%@~temp", trashPath) asUniquePath];
            [trashPath moveToFile:tempTrashPath];
            [trashPath makeDirectory];
            [tempTrashPath moveToFile:nsfmt(@"%@/Trash", trashPath)];
        }
    }
    if (![trashPath isDirectory]) {
        id str = nsfmt(@"Unable to move '%@' to trash, '%@' is not a directory.", self, trashPath);
        [str showAlert];
        return NO;
    }

    id name = [self lastPathComponent];
    id dst = nsfmt(@"%@/%@", trashPath, name);
    if ([dst fileExists]) {
        int i = 0;
        for(;;) {
            id path = [NSString stringWithFormat:@"%@.%d", dst, i];
            if (![path fileExists]) {
                dst = path;
                break;
            }
            i++;
        }
    }
    id cmd = nsarr();
    [cmd addObject:@"mv"];
    [cmd addObject:self];
    [cmd addObject:dst];
    id result = [cmd runCommandAndReturnExitStatus];
    if (result && ([result intValue] == 0)) {
//        id str = nsfmt(@"Moved '%@' to trash.", self);
        return YES;
    } else {
        id str = nsfmt(@"Unable to move '%@' to trash.", self);
        [str showAlert];
        return NO;
    }
}
@end

