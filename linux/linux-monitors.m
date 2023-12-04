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


@implementation Definitions(fjkdlsjfklsdjklfjsdf)
+ (id)currentMonitor
{
    int x = [[@"windowManager" valueForKey] intValueForKey:@"mouseX"];
    return [Definitions monitorForX:x y:0];
}
+ (id)currentMonitorName
{
    int x = [[@"windowManager" valueForKey] intValueForKey:@"mouseX"];
    id result = [Definitions monitorForX:x y:0];
    return [result valueForKey:@"output"];
}
+ (int)currentMonitorIndex
{
    int x = [[@"windowManager" valueForKey] intValueForKey:@"mouseX"];
    return [Definitions monitorIndexForX:x y:0];
}
+ (id)currentMonitorIndexName
{
    int x = [[@"windowManager" valueForKey] intValueForKey:@"mouseX"];
    id result = [Definitions monitorIndexNameForX:x y:0];
    return result;
}
+ (void)setupMonitors
{
    id cmd = nsarr();
    [cmd addObject:@"hotdog-setupMonitors.pl"];
    [cmd runCommandInBackground];
}

+ (id)monitorIndexNameForX:(int)x y:(int)y
{
    id monitors = [Definitions monitorConfig];
    for (int index=0; index<[monitors count]; index++) {
        id elt = [monitors nth:index];
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return nsfmt(@"%d/%d", index+1, [monitors count]);;
        }
    }
    return nsfmt(@"%d/%d", 1, [monitors count]);
}
+ (int)monitorIndexForX:(int)x y:(int)y
{
    id monitors = [Definitions monitorConfig];
    for (int index=0; index<[monitors count]; index++) {
        id elt = [monitors nth:index];
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return index;
        }
    }
    return 0;
}
+ (id)monitorForX:(int)x y:(int)y
{
    id monitors = [Definitions monitorConfig];
    for (id elt in monitors) {
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return elt;
        }
    }
    return [monitors nth:0];
}
+ (id)monitorConfig
{
    static long lastTimestampPlusSize= 0;
    static id lastMonitors = nil;
    
    id path = [Definitions configDir:@"Temp/listMonitors.txt"];    
    if ([path fileExists]) {
        long timestampPlusSize = [path fileTimestampPlusSize];
        if (timestampPlusSize == lastTimestampPlusSize) {
            return lastMonitors;
        }
        id monitors = [path linesFromFile];
        if (monitors) {
            lastTimestampPlusSize = timestampPlusSize; 
            [lastMonitors autorelease];
            lastMonitors = monitors;
            [lastMonitors retain];
            return lastMonitors;
        }
    }
    lastTimestampPlusSize = 0;
    id arr = nsarr();
    [arr addObject:@"output:default width:1024 height:768"];
    lastMonitors = arr;
    [lastMonitors retain];
    return lastMonitors;
}
@end






