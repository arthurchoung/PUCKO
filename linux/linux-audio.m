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

@interface AudioOutput : IvarObject
{
    id _aplay;
    int _sampleRate;
    int _numberOfChannels;
    int _bitsPerChannel;
}
@end
@implementation AudioOutput

- (void)openAudioWithSampleRate:(int)sampleRate frameCount:(int)frameCount channels:(int)channels bitsPerChannel:(int)bitsPerChannel
{
    _sampleRate = sampleRate;
    _numberOfChannels = channels;
    _bitsPerChannel = bitsPerChannel;
    
    id cmd = nsarr();
    [cmd addObject:@"aplay"];
    [cmd addObject:@"-t"];
    [cmd addObject:@"raw"];
    [cmd addObject:@"-r"];
    [cmd addObject:nsfmt(@"%d", sampleRate)];
    [cmd addObject:@"-c"];
    [cmd addObject:nsfmt(@"%d", channels)];
    [cmd addObject:@"-f"];
    [cmd addObject:@"S16_LE"];
    [cmd addObject:@"-"];
    id aplay = [cmd runCommandAndReturnProcess];
    [self setValue:aplay forKey:@"aplay"];
}   

- (void)writeAudio:(uint16_t *)buffer frameCount:(int)frameCount
{
    [_aplay writeBytes:buffer length:_numberOfChannels*(_bitsPerChannel/8)*frameCount];
}

- (void)closeAudio
{
    [self setValue:nil forKey:@"aplay"];
}
@end

