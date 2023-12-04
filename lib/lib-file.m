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

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <dirent.h>

@implementation Definitions(jfkdlsjklfjsdklfljksdf)
+ (id)dataFromStandardInput
{
    id data = [NSMutableData data];
    for(;;) {
        char buf[4096];
        int n = read(0, buf, 4096);
        if (n <= 0) {
            return data;
        }
        [data appendBytes:buf length:n];
    }
}
+ (id)linesFromStandardInput
{
    id results = nsarr();
    char buf[16384];
    while (fgets(buf, 16384, stdin)) {
        id line = nsfmt(@"%s", buf);
            if (![line hasSuffix:@"\n"]) {
NSLog(@"ERROR: line too long");
exit(0);
            }
        [line destructiveChomp];
        [results addObject:line];
    }
//NSLog(@"results %@", [results join:@""]);
    return results;
}
+ (id)blocksFromStandardInput
{
    id results = nsarr();
    id dict = nsdict();
    char buf[16384];
    while (fgets(buf, 16384, stdin)) {
        int len = strlen(buf);
        if (!len) {
            break;
        }
        if (buf[len-1] != '\n') {
NSLog(@"ERROR: line too long");
exit(0);
        }
        buf[len-1] = 0;
        len--;
        if (!len) {
            // empty line
            if ([dict count]) {
                [results addObject:dict];
                dict = nsdict();
            }
        } else {
            char *p = strchr(buf, ':');
            if (p) {
                *p = 0;
                p++;
                [dict setValue:nsfmt(@"%s", p) forKey:nsfmt(@"%s", buf)];
            }
        }
    }
    if ([dict count]) {
        [results addObject:dict];
    }
    return results;
}
@end

@implementation Definitions(jfdosjfkldsjfklsdjklfjk)
+ (id)currentDirName
{
    return [[@"." asRealPath] lastPathComponent];
}
@end

@implementation Definitions(fjdkslfjklsdf)
+ (void)testFilePointer
{
    id path = [Definitions configDir:@"Config/menuBar.csv"];
    id fp = [@"FilePointer" asInstance];
    if ([fp openFile:path mode:@"r"]) {
        for(;;) {
            id line = [fp readLine];
            if (!line) {
                break;
            }
            NSLog(@"line '%@'", line);
            if ([line hasSuffix:@"\n"]) {
                NSLog(@"NEWLINE");
            }
        }
    }
}
@end


@interface FilePointer : IvarObject
{
    FILE *_fp;
}
@end
@implementation FilePointer
- (void)dealloc
{
    [self closeFile];
    [super dealloc];
}

- (void)closeFile
{
    if (_fp) {
        fclose(_fp);
        _fp = NULL;
    }
}

- (void)setFP:(void *)fp
{
    _fp = fp;
}
- (BOOL)openFile:(id)path mode:(id)mode
{
    [self closeFile];
    _fp = fopen([path UTF8String], [mode UTF8String]);
    return (_fp) ? YES : NO;
}

- (id)readLine
{
    if (!_fp) {
        return nil;
    }
    char buf[4096];
    char *p = fgets(buf, 4096, _fp);
    if (!p) {
        return nil;
    }
    return nscstr(buf);
}

- (BOOL)writeString:(id)str
{
    if (!_fp) {
        return nil;
    }
    char *cstr = [str UTF8String];
    int len = strlen(cstr);
    int result = fwrite(cstr, 1, len, _fp);
    if (result == len) {
        return YES;
    }
    return NO;
}
- (int)readBytes:(char *)buf size:(int)size
{
    if (!_fp) {
        return 0;
    }
    return fread(buf, 1, size, _fp);
}
- (int)writeBytes:(char *)buf size:(int)size
{
    if (!_fp) {
        return 0;
    }
    return fwrite(buf, 1, size, _fp);
}

@end

@implementation NSString(fjdklsjfklsdjfklj)
- (void)appendToFile:(id)path
{
    FILE *fp = fopen([path UTF8String], "a");
    if (!fp) {
        return;
    }
    fprintf(fp, "%s", [self UTF8String]);
    fclose(fp);
}

@end




@implementation NSArray(jfieowfjksdjfks)

- (BOOL)writeLinesToFile:(id)path
{
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
    BOOL result = YES;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (![elt respondsToSelector:@selector(UTF8String)]) {
            result = NO;
            break;
        }
        if (![elt respondsToSelector:@selector(length)]) {
            result = NO;
            break;
        }
        char *bytes = [elt UTF8String];
        int len = [elt length];
        if (len) {
            if (fwrite(bytes, 1, len, fp) != len) {
                result = NO;
                break;
            }
        }
        if (fwrite("\n", 1, 1, fp) != 1) {
            result = NO;
            break;
        }
    }

    fclose(fp);

    return result;
}

- (id)asFileArray
{
    id keepArr = nsarr();
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (![[elt lastPathComponent] hasPrefix:@"."]) {
            [keepArr addObject:elt];
        }
    }
    id arr = nsarr();
    for (int i=0; i<[keepArr count]; i++) {
        id filePath = [keepArr nth:i];
        id dict = nsdict();
        id displayName = [filePath lastPathComponent];
        if ([filePath isDirectory]) {
            displayName = [displayName cat:@"/"];
            [dict setValue:@"directory" forKey:@"fileType"];
        }
        if ([filePath isFile]) {
            [dict setValue:@"file" forKey:@"fileType"];
        }
        [dict setValue:displayName forKey:@"displayName"];
        [dict setValue:filePath forKey:@"filePath"];
        [dict setValue:[filePath fileModificationDate] forKey:@"fileModificationDate"];
        [dict setValue:nsfmt(@"%lu", [filePath fileSize]) forKey:@"fileSize"];
        [arr addObject:dict];
    }
    return arr;
}

- (id)joinAsPath
{
    id path = nil;
    for (int i=0; i<[self count]; i++) {
        id elt = [self nth:i];
        if (!path) {
            path = elt;
            continue;
        }
        path = [path stringByAppendingPathComponent:elt];
    }
    return path;
}





@end

@implementation NSString(cordsfjksdfjksdle)
- (id)contentsOfDirectory
{
    DIR *dirp = opendir([self UTF8String]);
    if (!dirp) {
        return nil;
    }
    id arr = nsarr();
    for(;;) {
        struct dirent entry;
        struct dirent *result;
        int retval = readdir_r(dirp, &entry, &result);
        if (retval) {
            arr = nil;
            break;
        }
        if (!result) {
            break;
        }
        if (entry.d_name[0] == '.') {
            if (!entry.d_name[1]) {
                continue;
            }
            if (entry.d_name[1] == '.') {
                if (!entry.d_name[2]) {
                    continue;
                }
            }
        }
        [arr addObject:nscstr(entry.d_name)];
    }
    closedir(dirp);
    return arr;
}
- (BOOL)isFile
{
    struct stat buf;
    if (!stat([self UTF8String], &buf)) {
        if (S_ISREG(buf.st_mode)) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isDirectory
{
    struct stat buf;
    if (!stat([self UTF8String], &buf)) {
        if (S_ISDIR(buf.st_mode)) {
            return YES;
        }
    }
    return NO;
}

- (void)changeDirectory
{
    chdir([self UTF8String]);
}

- (id)linesFromFile
{
    return [[[self stringFromFile] chomp] componentsSeparatedByString:@"\n"];
}
- (id)readAsLinesFromFile
{
    return [[[self stringFromFile] chomp] componentsSeparatedByString:@"\n"];
}

- (id)resolveSymlinks
{
    return [self stringByResolvingSymlinksInPath];
}

- (id)normalizePath
{
    id path = nil;
    if ([self fileExists]) {
        path = [self resolveSymlinks];
    } else {
        path = [[[self stringByDeletingLastPathComponent] resolveSymlinks] cat:@"/" cat:[self lastPathComponent]];
    }
    return path;
}

- (id)asRealPath
{
    char buf[PATH_MAX];
    if (realpath([self UTF8String], buf)) {
        return nscstr(buf);
    }
    return nil;
}

- (id)asUniquePath
{
    if (![self fileExists]) {
        return self;
    }
    int n = 0;
    for (;;) {
        id path = nsfmt(@"%@.%d", self, n);
        if (![path fileExists]) {
            return path;
        }
        n++;
    }
}

- (BOOL)makeDirectories
{
    id arr = nsarr();
    id str = self;
    for(;;) {
        if (![str length]) {
            break;
        }
        if ([str isEqual:@"/"]) {
            break;
        }
        [arr addObject:str];
        str = [str stringByDeletingLastPathComponent];
    }
    for (int i=[arr count]-1; i>=0; i--) {
        id elt = [arr nth:i];
        if ([elt isDirectory]) {
            continue;
        }
        if ([elt fileExists]) {
            return NO;
        }
        if (![elt makeDirectoryNoIntermediateDirectories]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)makeDirectory
{
    return [self makeDirectories];
}

- (BOOL)makeDirectory:(id)relativePath
{
    return [[self stringByAppendingPathComponent:relativePath] makeDirectory];
}


- (BOOL)makeDirectoryNoIntermediateDirectories
{
    if (!mkdir([self UTF8String], 0755)) {
        return YES;
    }
    return NO;
}


- (BOOL)makeDirectoriesForFile
{
    id path = [self stringByDeletingLastPathComponent];
    if ([path isDirectory]) {
        return YES;
    }
    return [path makeDirectories];
}

- (id)moveToDirectory:(id)path
{
    if (![path isDirectory]) {
        return nil;
    }
    id orig = [path stringByAppendingPathComponent:[self lastPathComponent]];
    id str = orig;
    int suffix = 0;
    while ([str fileExists]) {
        str = [orig stringByAppendingFormat:@".%d", suffix];
        suffix++;
    }
    if ([self moveToFile:str]) {
        return str;
    }
    return nil;
}


- (id)pathRelativeToString:(id)basePath
{
    id str = self;
    id private = @"/private";
    if ([str hasPrefix:private]) {
        str = [str substringFromIndex:[private length]];
    }
    if ([str hasPrefix:basePath]) {
        str = [str substringFromIndex:[basePath length]];
        if ([str hasPrefix:@"/"]) {
            str = [str substringFromIndex:1];
        }
    }
    return str;
}

- (id)allFilesInDirectory
{
    id contents = [self contentsOfDirectory];
    id results = nsarr();
    for (int i=0; i<[contents count]; i++) {
        id elt = [contents nth:i];
        id path = [self stringByAppendingPathComponent:elt];
        if ([path isDirectory]) {
            id arr = [path allFilesInDirectory];
            [results addObjectsFromArray:arr];
        } else if ([path isFile]) {
            [results addObject:path];
        }
    }
    return results;
}

- (id)contentsOfDirectoryWithFullPaths
{
    id arr = nsarr();
    id contents = [self contentsOfDirectory];
    for (int i=0; i<[contents count]; i++) {
        id obj = [contents nth:i];
        [arr addObject:[self stringByAppendingPathComponent:obj]];
    }
    return arr;
}

- (BOOL)moveToFile:(id)dst
{
    return [self moveToPath:dst];
}
- (BOOL)moveToPath:(id)dst
{
    if ([dst fileExists]) {
        return NO;
    }
    if (!rename([self UTF8String], [dst UTF8String])) {
        return YES;
    }
    return NO;
}

- (BOOL)fileExists
{
    struct stat buf;
    if (!stat([self UTF8String], &buf)) {
        return YES;
    }
    return NO;
}

- (unsigned long long)fileSize
{
    struct stat buf;
    if (!stat([self UTF8String], &buf)) {
        return buf.st_size;
    }
    return 0;
}
- (id)fileModificationDate
{
#ifdef BUILD_FOR_LINUX
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    struct tm *tm = localtime(&buf.st_mtim);
    return [Definitions year:1900+tm->tm_year month:tm->tm_mon+1 day:tm->tm_mday hour:tm->tm_hour minute:tm->tm_min second:tm->tm_sec];
#else
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    struct tm *tm = localtime(&buf.st_mtimespec.tv_sec);
    return [Definitions year:1900+tm->tm_year month:tm->tm_mon+1 day:tm->tm_mday hour:tm->tm_hour minute:tm->tm_min second:tm->tm_sec];
#endif

}

- (time_t)fileModificationTimestamp
{
#ifdef BUILD_FOR_LINUX
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    return buf.st_mtim.tv_sec;
#else
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    return buf.st_mtimespec.tv_sec;
#endif

}
#ifdef BUILD_FOR_LINUX
#include <utime.h>
- (BOOL)updateFileTimestamps:(time_t)timestamp
{
    struct utimbuf times;
    times.actime = timestamp;
    times.modtime = timestamp;
    int result = utime([self UTF8String], &times);
    if (result == 0) {
        return YES;
    }
    return NO;
}
#endif

- (long)fileTimestampPlusSize
{
#ifdef BUILD_FOR_LINUX
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    return buf.st_mtim.tv_sec + buf.st_size;
#else
    struct stat buf;
    if (stat([self UTF8String], &buf) != 0) {
        return nil;
    }
    return buf.st_mtimespec.tv_sec + buf.st_size;
#endif

}



@end

@implementation NSString(fmekwlfmkldsmfklsdmlkmf)
- (BOOL)unlinkFile
{
    int result = unlink([self UTF8String]);
    if (result == 0) {
        return YES;
    }
    return NO;
}
@end

