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

// linker flags -lGL

#include <stdio.h>

#include <GL/gl.h>
#include <GL/glx.h>

@implementation Definitions(fjkdsjflkjdsklfj)
+ (BOOL)hasOpenGL
{
    return YES;
}

+ (BOOL)setupOpenGLForDisplay:(void *)display window:(unsigned long)win visualInfo:(void *)visualInfo
{
    GLXContext glContext = glXCreateContext(display, visualInfo, 0, True);
    if (!glContext) {
NSLog(@"glXCreateContext failed");
        return NO;
    }
    
    glXMakeCurrent(display, win, glContext);

    PFNGLXSWAPINTERVALMESAPROC glXSwapIntervalMESA;
    glXSwapIntervalMESA = (PFNGLXSWAPINTERVALMESAPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalMESA");
    if (glXSwapIntervalMESA != NULL) {
NSLog(@"glXSwapIntervalMESA");
        glXSwapIntervalMESA(1);
        return YES;
    }

    PFNGLXSWAPINTERVALSGIPROC glXSwapIntervalSGI;
    glXSwapIntervalSGI = (PFNGLXSWAPINTERVALSGIPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalSGI");
    if (glXSwapIntervalSGI != NULL) {
NSLog(@"glXSwapIntervalSGI");
        glXSwapIntervalSGI(1);
        return YES;
    }

/*
    PFNGLXSWAPINTERVALEXTPROC glXSwapIntervalEXT;
    glXSwapIntervalEXT = (PFNGLXSWAPINTERVALEXTPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalEXT");
    if (glXSwapIntervalEXT != NULL) {
NSLog(@"glXSwapIntervalEXT");
        glXSwapIntervalEXT(display, win, 1);
        return YES;
    }
*/

NSLog(@"Unable to get glXSwapIntervalMESA or glXSwapIntervalSGI");
    return YES;
}
+ (void)clearOpenGLForWidth:(int)width height:(int)height
{
    glViewport(0, 0, width, height);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}
+ (void)drawUsingNearestFilterToOpenGLTextureID:(int)textureID pixels565:(uint16_t *)pixels width:(int)width height:(int)height
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels);
}
+ (void)drawToOpenGLTextureID:(int)textureID pixels565:(uint16_t *)pixels width:(int)width height:(int)height
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels);
}

+ (void)drawUsingNearestFilterToOpenGLTextureID:(int)textureID pixels:(uint32_t *)pixels width:(int)width height:(int)height
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
}
+ (void)drawToOpenGLTextureID:(int)textureID pixels:(uint32_t *)pixels width:(int)width height:(int)height
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
}

+ (void)drawUsingNearestFilterToOpenGLTextureID:(int)textureID bytes:(uint8_t *)pixels bitmapWidth:(int)bitmapWidth bitmapHeight:(int)bitmapHeight bitmapStride:(int)bitmapStride
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bitmapWidth, bitmapHeight, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, pixels);
}
+ (void)drawToOpenGLTextureID:(int)textureID bytes:(uint8_t *)pixels bitmapWidth:(int)bitmapWidth bitmapHeight:(int)bitmapHeight bitmapStride:(int)bitmapStride
{
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bitmapWidth, bitmapHeight, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, pixels);
}

+ (void)drawOpenGLTextureID:(int)textureID
{
    [self drawOpenGLTextureID:textureID llX:-1.0 llY:-1.0 urX:1.0 urY:1.0];
}
+ (void)drawFlippedOpenGLTextureID:(int)textureID x:(int)x y:(int)y w:(int)w h:(int)h inW:(int)inW h:(int)inH
{
    double llX = ((double)x / (double)(inW))*2.0-1.0;
    double llY = ((double)y / (double)(inH))*2.0-1.0;
    double urX = ((double)(x+w) / (double)(inW))*2.0-1.0;
    double urY = ((double)(y+h) / (double)(inH))*2.0-1.0;
    [Definitions drawOpenGLTextureID:textureID llX:llX llY:urY urX:urX urY:llY];
}
+ (void)drawOpenGLTextureID:(int)textureID x:(int)x y:(int)y w:(int)w h:(int)h inW:(int)inW h:(int)inH
{
    double llX = ((double)x / (double)(inW))*2.0-1.0;
    double llY = ((double)y / (double)(inH))*2.0-1.0;
    double urX = ((double)(x+w) / (double)(inW))*2.0-1.0;
    double urY = ((double)(y+h) / (double)(inH))*2.0-1.0;
    [Definitions drawOpenGLTextureID:textureID llX:llX llY:llY urX:urX urY:urY];
}
+ (void)drawFlippedOpenGLTextureID:(int)textureID
{
    [self drawOpenGLTextureID:textureID llX:-1.0 llY:1.0 urX:1.0 urY:-1.0];
}
+ (void)drawOpenGLTextureID:(int)textureID llX:(double)llX llY:(double)llY urX:(double)urX urY:(double)urY
{
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureID);

    glBegin(GL_QUADS);
    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(llX, urY, 0.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(urX, urY, 0.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(urX, llY, 0.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(llX, llY, 0.0f);
    glEnd();
}

/*
+ (void)drawTextureId:(int)textureID
{
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureID);

    glBegin(GL_QUADS);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, 1.0f, 0.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, 1.0f, 0.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, -1.0f, 0.0f);
    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, -1.0f, 0.0f);
    glEnd();

    glBegin(GL_QUADS);
    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, 0.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, 0.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, 0.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, 0.0f);
    glEnd();
}
*/

+ (void)openGLXSwapBuffersForDisplay:(void *)display window:(unsigned long)win
{
    glXSwapBuffers(display, win);
}

+ (void *)openGLXChooseVisual:(void *)display :(int)screen
{
static int      dblBuf[] = {    GLX_RGBA,
                                GLX_RED_SIZE, 1,
                                GLX_GREEN_SIZE, 1,
                                GLX_BLUE_SIZE, 1,
                                GLX_DEPTH_SIZE, 12,
                                GLX_DOUBLEBUFFER,
                                None };

    return glXChooseVisual(display, screen, dblBuf);
}

@end

@interface GLTexture : IvarObject
{
    GLuint _textureID;
}
@end
@implementation GLTexture
- (void)dealloc
{
    glDeleteTextures(1, &_textureID);
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        glGenTextures(1, &_textureID);
    }
    return self;
}
- (int)textureID;
{
    return _textureID;
}
@end

