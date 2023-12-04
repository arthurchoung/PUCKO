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

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <errno.h>

@interface ProcessWithError : IvarObject
{
    id _command;
    int _infd;
    int _outfd;
    int _errfd;
    int _pid;
    id _status;
    id _exitStatus;
    id _data;
    id _errdata;
}
@end
@implementation ProcessWithError

- (id)init
{
    self = [super init];
    if (self) {
        _infd = -1;
        _outfd = -1;
        _errfd = -1;
    }
    return self;
}

- (void)dealloc
{
NSLog(@"ProcessWithError dealloc pid %d getpid %d command %@", _pid, getpid(), _command);
    if (_infd != -1) {
        close(_infd);
        _infd = -1;
    }
    if (_outfd != -1) {
        close(_outfd);
        _outfd = -1;
    }
    if (_errfd != -1) {
        close(_errfd);
        _errfd = -1;
    }
    if (_pid) {
        kill(_pid, SIGTERM);
        _pid = 0;
    }
    [super dealloc];
}
- (void)sendSignal:(int)signal
{
    if (_pid) {
NSLog(@"sendSignal:%d pid %d", signal, _pid);
        kill(_pid, signal);
    }
}

- (int *)fileDescriptors
{
    static int fds[3];
    fds[0] = _outfd;
    fds[1] = _errfd;
    fds[2] = -1;
    return fds;
}
- (void)handleFileDescriptor:(int)fd
{
    if (fd == _outfd) {
        [self handleOutFileDescriptor];
    } else if (fd == _errfd) {
        [self handleErrFileDescriptor];
    }
}
- (void)handleOutFileDescriptor
{
    if (_outfd == -1) {
        return;
    }
    if (!_data) {
        [self setValue:[[[NSMutableData alloc] init] autorelease] forKey:@"data"];
    }
    char buf[4096];
    int result = read(_outfd, buf, sizeof(buf));
    if (result > 0) {
//NSLog(@"Received %d bytes", result);
        [_data appendBytes:buf length:result];
    } else if (result == 0) {
        close(_outfd);
        _outfd = -1;
        [self setValue:@"Success" forKey:@"status"];
    } else {
        close(_outfd);
        _outfd = -1;
        [self setValue:nsfmt(@"Error: %s", strerror(errno)) forKey:@"status"];
    }
}
- (void)handleErrFileDescriptor
{
    if (_errfd == -1) {
        return;
    }
    if (!_errdata) {
        [self setValue:[[[NSMutableData alloc] init] autorelease] forKey:@"errdata"];
    }
    char buf[4096];
    int result = read(_errfd, buf, sizeof(buf));
    if (result > 0) {
//NSLog(@"Received %d bytes", result);
        [_errdata appendBytes:buf length:result];
    } else if (result == 0) {
        close(_errfd);
        _errfd = -1;
    } else {
        close(_errfd);
        _errfd = -1;
    }
}
- (BOOL)writeString:(id)str
{
NSLog(@"writeString infd %d", _infd);
    if (_infd == -1) {
        return NO;
    }
    int len = [str length];
NSLog(@"writeString len %d", len);
    int result = write(_infd, [str UTF8String], len);
NSLog(@"writeString result %d", result);
    if (result == len) {
        return YES;
    }
    return NO;
}
- (void)writeDataAndClose:(id)data
{
    [self writeData:data];
    [self closeInput];
}
- (void)writeData:(id)data
{
    if (_infd == -1) {
        return;
    }
    int result = write(_infd, [data bytes], [data length]);
NSLog(@"write result %d", result);
}
- (void)writeBytes:(unsigned char *)bytes length:(int)length
{
    if (_infd == -1) {
        return;
    }
    int result = write(_infd, bytes, length);
//NSLog(@"write result %d", result);
}

- (void)closeInput
{
    if (_infd == -1) {
        return;
    }
    close(_infd);
    _infd = -1;
}

- (void)closeOutput
{
    if (_outfd == -1) {
        return;
    }
    close(_outfd);
    _outfd = -1;
}
- (void)closeError
{
    if (_errfd == -1) {
        return;
    }
    close(_errfd);
    _errfd = -1;
}

- (id)readAllDataFromOutputThenClose
{
    if (_outfd == -1) {
        return nil;
    }
    id data = [self readAllData:_outfd];
    [self closeOutput];
    return data;
}
- (id)readAllDataFromOutputThenCloseAndWait
{
    if (_outfd == -1) {
        return nil;
    }
    id data = [self readAllData:_outfd];
    [self closeOutput];
    [self waitForExitStatus];
    return data;
}

- (id)readDataFromOutput
{
    if (_outfd == -1) {
        return nil;
    }
    return [self readData:_outfd];
}

- (id)readData:(int)fd
{
    char readbuf[4096];
    int result = read(fd, readbuf, sizeof(readbuf));
    if (result > 0) {
        id data = [[[NSMutableData alloc] init] autorelease];
        [data appendBytes:readbuf length:result];
        return data;
    } else if (result == 0) {
        NSLog(@"EOF");
    } else {
        perror("Error");
    }
    return nil;
}
- (id)readAllData:(int)fd
{
    id data = [[[NSMutableData alloc] init] autorelease];
    char readbuf[4096];
    for(;;) {
        int result = read(fd, readbuf, sizeof(readbuf));
        if (result > 0) {
//NSLog(@"Received %d bytes", result);
            [data appendBytes:readbuf length:result];
        } else if (result == 0) {
            NSLog(@"EOF");
            break;
        } else {
            perror("Error");
            data = nil;
            break;
        }
    }
    return data;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    id str = [_data asString];
    if (_status) {
        str = nsfmt(@"%@*** %@ ***", str, _status);
    }
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    [bitmap setColorIntR:0 g:0 b:0 a:255];
    [bitmap drawBitmapText:str x:0+5 y:r.h-1-5];
}
- (id)waitForExitStatus
{
    if (_exitStatus) {
        return _exitStatus;
    }
    if (!_pid) {
        return nil;
    }
    int wstatus = 0;
    if (waitpid(_pid, &wstatus, 0) == _pid) {
        _pid = 0;
        if (WIFEXITED(wstatus)) {
            int status = WEXITSTATUS(wstatus);
            id str = nsfmt(@"%d", status);
            [self setValue:str forKey:@"exitStatus"];
            return str;
        }
    }
    return nil;
}

@end

@implementation NSArray(jfkldsjflksdkljffjkdsfjkds)
- (id)runCommandAndReturnProcessWithError
{
    NSLog(@"runCommandAndReturnProcessWithError: %@", self);
    if ([self count] < 1) {
        return nil;
    }
    
    int fdzero[2];
    int fdone[2];
    int fdtwo[2];
    pid_t   childpid;
    
    pipe(fdzero);
    pipe(fdone);
    pipe(fdtwo);
    
    if((childpid = fork()) == -1)
    {
        perror("fork");
        return nil;
    }
    
    if(childpid == 0)
    {

        close(fdzero[1]);
        dup2(fdzero[0], STDIN_FILENO);
        close(fdzero[0]);

        /* Child process closes up input side of pipe */
        close(fdone[0]);
        dup2(fdone[1], STDOUT_FILENO);
        close(fdone[1]);

        /* Child process closes up input side of pipe */
        close(fdtwo[0]);
        dup2(fdtwo[1], STDERR_FILENO);
        close(fdtwo[1]);

        int argc = [self count];
        char **argv = malloc(sizeof(char *)*(argc+1));
        for (int i=0; i<argc; i++) {
            if (i == 0) {
                id elt = [self nth:0];
                if ([elt hasPrefix:@"/"]) {
                    argv[0] = [elt UTF8String];
                    continue;
                }
                id path = [elt findInPath];
                if (path) {
                    argv[0] = [path UTF8String];
                } else {
                    argv[0] = [elt UTF8String];
                }
            } else {
                argv[i] = [[self nth:i] UTF8String];
            }
        }
        argv[argc] = 0;
        execv(argv[0], argv);
        [Definitions showAlert:nsfmt(@"Unable to run command '%s'", argv[0])];
        free(argv);
        _exit(0);
    }
    else
    {
        close(fdzero[0]);

        /* Parent process closes up output side of pipe */
        close(fdone[1]);

        /* Parent process closes up output side of pipe */
        close(fdtwo[1]);

        id process = [[[ProcessWithError alloc] init] autorelease];
        [process setValue:self forKey:@"command"];
        [process setValue:nsfmt(@"%d", childpid) forKey:@"pid"];
        [process setValue:nsfmt(@"%d", fdzero[1]) forKey:@"infd"];
        [process setValue:nsfmt(@"%d", fdone[0]) forKey:@"outfd"];
        [process setValue:nsfmt(@"%d", fdtwo[0]) forKey:@"errfd"];
        return process;
    }
}

@end
