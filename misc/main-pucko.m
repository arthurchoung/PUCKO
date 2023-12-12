/*

 PUCKO Linux

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Linux.

 PUCKO Linux is free software: you can redistribute it and/or modify
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

static void signal_handler(int num)
{
NSLog(@"signal_handler %d", num);
}

int main(int argc, char **argv)
{
    if (signal(SIGPIPE, signal_handler) == SIG_ERR) {
NSLog(@"unable to set signal handler for SIGPIPE");
    }

#ifdef BUILD_FOR_ANDROID
    extern void HOTDOG_initialize_stdout(FILE *);
    extern void HOTDOG_initialize(FILE *);
    HOTDOG_initialize_stdout(stdout);
    HOTDOG_initialize(stderr);
#elif BUILD_FOR_OSX
#else
    extern void HOTDOG_initialize_stdout(FILE *);
    extern void HOTDOG_initialize(FILE *);
    HOTDOG_initialize_stdout(stdout);
    if ((argc >= 2) && !strcmp(argv[1], "dialog")) {
        FILE *fp = fopen("/dev/null", "w");
        if (!fp) {
            fprintf(stderr, "unable to open /dev/null\n");
            exit(1);
        }
        HOTDOG_initialize(fp);
    } else {
        HOTDOG_initialize(stderr);
    }
#endif



    id pool = [[NSAutoreleasePool alloc] init];

        id execDir = [Definitions execDir];

        /* If argv[0] contains a slash, then add the directory that the
           executable resides in to the PATH */
        if ((argc > 0) && strchr(argv[0], '/')) {
            char *pathcstr = getenv("PATH");
            id path = nil;
            if (pathcstr && strlen(pathcstr)) {
                path = nsfmt(@"%@:%s", execDir, pathcstr);
            } else {
                path = execDir;
            }
            if (setenv("PATH", [path UTF8String], 1) != 0) {
NSLog(@"Unable to set PATH");
            }
        }

        if (setenv("SUDO_ASKPASS", [[Definitions execDir:@"hotdog-getPassword.pl"] UTF8String], 1) != 0) {
NSLog(@"Unable to setenv SUDO_ASKPASS");
        }

        if (argc >= 2) {
            id args = nsarr();
            for (int i=2; i<argc; i++) {
                [args addObject:nsfmt(@"%s", argv[i])];
            }
NSLog(@"args '%@'", args);
            id result = [Definitions callMethodName:nsfmt(@"%s", argv[1]) args:args];
            if (!result) {
                exit(0);
            }
            if ([result class] == [Definitions class]) {
                exit(0);
            }
            if (isnsarr(result)) {
                NSOut(@"array with %d elements\n", [result count]);
                for (int i=0; i<[result count]; i++) {
                    id elt = [result nth:i];
                    NSOut(@"%@\n", elt);
                }
            } else {
NSOut(@"%@", result);
            }

            exit(0);
        }

NSLog(@"Usage: cat file.html | %s parseHTML", argv[0]);
NSLog(@"Usage: cat file.html | %s printText", argv[0]);
NSLog(@"Usage: cat file.html | %s printImgSrc", argv[0]);
NSLog(@"Usage: cat file.html | %s testAsRootURL", argv[0]);
NSLog(@"Usage: cat file.html | %s testAsBaseURL", argv[0]);
NSLog(@"Usage: cat file.html | %s testResolveURL: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.html | %s downloadImgSrc: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.html | %s ViewImgSrc: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.html | %s printAHref", argv[0]);
NSLog(@"Usage: cat file.html | %s ViewAHref: https://example.com/", argv[0]);
NSLog(@"Usage: %s ViewURL: https://example.com/", argv[0]);
NSLog(@"Usage: %s printStyleText: https://example.com/", argv[0]);
NSLog(@"Usage: %s printStyleAttribute: https://example.com/", argv[0]);
NSLog(@"Usage: %s printLinkHref: https://example.com/", argv[0]);
NSLog(@"Usage: %s downloadLinkHref: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.css | %s parseCSS", argv[0]);
NSLog(@"Usage: cat file.css | %s parseCSSProperty", argv[0]);
NSLog(@"Usage: cat file.html | %s printAttrs", argv[0]);
NSLog(@"Usage: %s printAttrs: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.html | %s parseStyleAttribute", argv[0]);
NSLog(@"Usage: %s parseStyleAttribute: https://example.com/", argv[0]);
NSLog(@"Usage: cat file.html | %s ViewHTMLTable", argv[0]);
NSLog(@"Usage: %s ViewHTMLTable: https://example.com/", argv[0]);

	[pool drain];

    return 0;
}
