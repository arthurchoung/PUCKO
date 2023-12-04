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

@implementation NSString(Fewnklfnmdklsfmklsd)
- (id)urlAsValidFilename
{
    id str = [self find:@"/" replace:@"%2f"];
    return nsfmt(@"_%@", str);
}
@end

@implementation Definitions(mfeklwmfklsdmkflmskdf)
+ (void)downloadImgSrc:(id)node :(id)origURL
{
NSLog(@"downloadImgSrc");
    id name = [node valueForKey:@"name"];
NSLog(@"name %@", name);
    if ([name isEqual:@"img"]) {
        id attrs = [node valueForKey:@"attrs"];
        id src = [attrs valueForKey:@"src"];
NSLog(@"img src '%@'", src);
        if (!src) {
            goto end;
        }
        id url = [src resolveURLWithURL:origURL];
        id filename = [url urlAsValidFilename];
        if ([filename fileExists]) {
            goto end;
        }
        id output = [url downloadURLWithCurl];
        [output writeToFile:filename];
    }

end:
    id children = [node valueForKey:@"children"];
    for (int i=0; i<[children count]; i++) {
        id elt = [children nth:i];
        [Definitions downloadImgSrc:elt :origURL];
    }
}
@end


@implementation Definitions(fmeklwfmkldsmklfmksdlfmkl)
+ (void)downloadImgSrc:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    id document = [str parseHTML];
    [Definitions downloadImgSrc:document :url];
}
+ (void)downloadImgSrc
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    id document = [str parseHTML];
    [Definitions downloadImgSrc:document :nil];
}
@end

