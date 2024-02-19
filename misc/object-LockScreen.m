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

@implementation Definitions(jfkdlsjfklsdjlkfjdsklfjlkdsfjkldsfewrwerwe)
+ (void)LockScreen
{
    id obj = [@"LockScreen" asInstance];
    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
@end

@interface LockScreen : IvarObject
{
    int _unlocked;
    int _mouseMoved;
    int _mouseX;
    int _mouseY;
    Int4 _knobRect;
    int _grabbedUnlockSliderX;
    int _minKnobX;
    int _maxKnobX;
}
@end
@implementation LockScreen
- (int)preferredWidth
{
    return 320;
}
- (int)preferredHeight
{
    return 480;
}

- (void)handleTouchesBegan:(id)event
{
NSLog(@"handleTouchesBegan");
    _mouseX = [event intValueForKey:@"touchX"];
    _mouseY = [event intValueForKey:@"touchY"];
NSLog(@"touchX %d Y %d", _mouseX, _mouseY);
    if ([Definitions isX:_mouseX y:_mouseY insideRect:_knobRect]) {
NSLog(@"check1");
        _grabbedUnlockSliderX = _mouseX - _knobRect.x;
    }
}

- (void)handleTouchesMoved:(id)event
{
NSLog(@"handleTouchesMoved");
    _mouseX = [event intValueForKey:@"touchX"];
    _mouseY = [event intValueForKey:@"touchY"];
NSLog(@"touchX %d Y %d", _mouseX, _mouseY);
    _mouseMoved = 1;
}

- (void)handleTouchesEnded:(id)event
{
NSLog(@"handleTouchesEnded");
    _mouseX = [event intValueForKey:@"touchX"];
    _mouseY = [event intValueForKey:@"touchY"];
NSLog(@"touchX %d Y %d", _mouseX, _mouseY);
    _grabbedUnlockSliderX = 0;
}

- (void)handleTouchesCancelled:(id)event
{
    [self handleTouchesEnded:event];
}

- (void)handleMouseDown:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    if ([Definitions isX:_mouseX y:_mouseY insideRect:_knobRect]) {
        _grabbedUnlockSliderX = _mouseX - _knobRect.x;
    }
}

- (void)handleMouseUp:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    _grabbedUnlockSliderX = 0;
}

- (void)handleMouseMoved:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    _mouseMoved = 1;
    if (_grabbedUnlockSliderX) {
        _knobRect.x = _mouseX - _grabbedUnlockSliderX;
        if (_knobRect.x >= _maxKnobX) {
            _unlocked = 1;
            _grabbedUnlockSliderX = 0;
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"black"];
    [bitmap fillRect:r];
    
    id obj = self;

    int earthX = r.x+(r.w-256)/2;
    int earthY = r.y+(r.h-256)/2;
    [bitmap drawCString:[Definitions cStringForEarthPixels] palette:[Definitions cStringForEarthPalette] x:earthX y:earthY];

    unsigned char *middle = [self cStringForBitmapUnlockSliderMiddle];
    int heightForMiddle = [Definitions heightForCString:middle];
    [bitmap setColor:@"white"];
    id str = @"slide to unlock";
    int strWidth = [bitmap bitmapWidthForText:str];
    [bitmap drawBitmapText:str x:r.x+(r.w-strWidth)/2 y:r.y+r.h-heightForMiddle*2+6];
    [self drawUnlockSliderInBitmap:bitmap rect:[Definitions rectWithX:r.x+20 y:r.y+r.h-heightForMiddle*2 w:r.w-40 h:heightForMiddle] knobX:_knobRect.x];

    time_t timestamp = time(NULL);
    struct tm *tmptr;
    tmptr = localtime(&timestamp);
    char timebuf[256];
    char datebuf[256];
    timebuf[0] = 0;
    datebuf[0] = 0;
    if (tmptr) {
        strftime(timebuf, 255, "%H:%M", tmptr);
        strftime(datebuf, 255, "%A, %B", tmptr);
    }
    [bitmap drawBitmapText:nsfmt(@"%s", timebuf) centeredAtX:r.x+r.w/2 y:r.y+r.h/8];
    [bitmap drawBitmapText:nsfmt(@"%s %d", datebuf, tmptr->tm_mday) centeredAtX:r.x+r.w/2 y:r.y+r.h/4-20];
}

- (void)drawUnlockSliderInBitmap:(id)bitmap rect:(Int4)r knobX:(int)knobX
{
    unsigned char *left = [self cStringForBitmapUnlockSliderLeft];
    unsigned char *middle = [self cStringForBitmapUnlockSliderMiddle];
    unsigned char *right = [self cStringForBitmapUnlockSliderRight];
    unsigned char *knob = [self cStringForBitmapUnlockSliderKnob];

    int widthForLeft = [Definitions widthForCString:left];
    int widthForMiddle = [Definitions widthForCString:middle];
    int widthForRight = [Definitions widthForCString:right];
    int widthForKnob = [Definitions widthForCString:knob];

    _minKnobX = r.x+widthForLeft;
    _maxKnobX = r.x+r.w-widthForRight-widthForKnob;
    if (knobX < _minKnobX) {
        knobX = _minKnobX;
    }
    if (knobX > _maxKnobX) {
        knobX = _maxKnobX;
    }
    _knobRect.x = knobX;
    _knobRect.y = r.y;
    _knobRect.w = r.w;
    _knobRect.h = r.h;

    int heightForMiddle = [Definitions heightForCString:middle];
    int heightForKnob = [Definitions heightForCString:knob];
    int middleYOffset = 0;//(r.h - heightForMiddle)/2.0;
    int knobYOffset = 0;//(r.h - heightForKnob)/2.0;

    unsigned char *palette = "b #ffffff\n. #000000\n";
    [bitmap drawCString:left palette:palette x:r.x y:r.y-middleYOffset];
    int x;
    for (x=widthForLeft; x<r.w-widthForRight; x+=widthForMiddle) {
        [bitmap drawCString:middle palette:palette x:r.x+x y:r.y-middleYOffset];
        if (x < knobX) {
            [bitmap drawCString:middle palette:"  #000000\n" x:r.x+x y:r.y-middleYOffset];
        }
    }
    [bitmap drawCString:right palette:palette x:r.x+x y:r.y-middleYOffset];
    [bitmap drawCString:knob palette:palette x:knobX y:r.y-knobYOffset];
}

- (unsigned char *)cStringForBitmapUnlockSliderLeft
{
    return
"   b\n"
"  b.\n"
" b..\n"
" b.b\n"
"b..b\n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b.b \n"
"b..b\n"
" b.b\n"
" b..\n"
"  b.\n"
"   b\n"
;
}

- (unsigned char *)cStringForBitmapUnlockSliderMiddle
{
    return
"bb\n"
"..\n"
"bb\n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"bb\n"
"..\n"
"bb\n"
;
}

- (unsigned char *)cStringForBitmapUnlockSliderRight
{
    return
"b   \n"
".b  \n"
"..b \n"
"b.b \n"
"b..b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
" b.b\n"
"b.b \n"
"..b \n"
".b  \n"
"b   \n"
;
}

- (unsigned char *)cStringForBitmapUnlockSliderKnob
{
    return
"                    \n"
"                    \n"
"                    \n"
"                    \n"
" bbbbbbbbbbbbbbbbbb \n"
"bbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbb.bbbbbbbbb\n"
"bbbbbbbbbb..bbbbbbbb\n"
"bbbbbbbbbb...bbbbbbb\n"
"bbbb..........bbbbbb\n"
"bbbb...........bbbbb\n"
"bbbb............bbbb\n"
"bbbb...........bbbbb\n"
"bbbb..........bbbbbb\n"
"bbbbbbbbbb...bbbbbbb\n"
"bbbbbbbbbb..bbbbbbbb\n"
"bbbbbbbbbb.bbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbb\n"
" bbbbbbbbbbbbbbbbbb \n"
"                    \n"
"                    \n"
"                    \n"
"                    \n"
;
}

- (BOOL)shouldAnimate
{
    if (_unlocked) {
        return YES;
    }
    if (!_grabbedUnlockSliderX) {
        if (_knobRect.x > _minKnobX) {
            if (_knobRect.x < _maxKnobX) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)beginIteration:(id)dict rect:(Int4)r
{
    if (_unlocked) {
        _unlocked++;
        if (_unlocked > 3) {
            exit(0);
        }
    } else if (!_grabbedUnlockSliderX) {
        if (_knobRect.x > _minKnobX) {
            if (_knobRect.x < _maxKnobX) {
                _knobRect.x -= 30;
                if (_knobRect.x < _minKnobX) {
                    _knobRect.x = _minKnobX;
                }
            }
        }
    }
    _mouseMoved = 0;
}
@end

@implementation Definitions(fjdkslfjlkdslfjldksjfdsfioewjfiowe)
+ (char *)cStringForEarthPalette
{
    return
". #111133\n"
"X #223333\n"
"o #333355\n"
"O #222255\n"
"+ #555566\n"
"@ #444444\n"
"# #998877\n"
"$ #334488\n"
"% #666699\n"
"& #333388\n"
"* #7788AA\n"
"= #9999AA\n"
"- #AAAACC\n"
"; #CCCCDD\n"
": #887766\n"
;
}

+ (char *)cStringForEarthPixels
{
    return
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                        . .  ..   . .                                                                                                                           \n"
"                                                                                                            .   . . .X. . .X ..X... ....... .. ..                                                                                                               \n"
"                                                                                                         .  . .. X......XXXXXXXXXXXXXXXX.......X.. ..                                                                                                           \n"
"                                                                                                    .  . ....X..XXoXX@X@@oXXoooooXooooXXX.XXXXXX... .... .    .                                                                                                 \n"
"                                                                                                     ....X.oXoo@o@o+o@@@oooo@o@oooo+o@ooXXXXXXoXo.oX....X..                                                                                                     \n"
"                                                                                               .....X.XXo@o@@@@o@o@o+o@o+o@+o@o+o@@o@o+o@oooXXXoXoXXXXX.X...X... .                                                                                              \n"
"                                                                                          .  .. .X.XXo@oo+ooooo+o+oooo@o+ooooo@o@oo@+oo@o@o@oo@oXooo@XXXX.X.XX......                                                                                            \n"
"                                                                                        . ....XXXoo+@oo@@oo+++oooo+oo+o+oo+o++oo+o+oo@@o@o@o+oo@ooooooooooXOXXXXXX. X.. .                                                                                       \n"
"                                                                                      .  ..XXXXoo@oooo+oo++oo+o+++@+o++oo++oo@o+ooo@ooo++oooo@+o@o@@@ooX.oXX.Xo.XooXX.....                                                                                      \n"
"                                                                                   .. ..XXXXoo@oo+o+++o+@&++o++o+o&++o+++o++o++o++o++o@oo@o+@oo@o@ooo@XX...XooXXXXXXoXo.. . .                                                                                   \n"
"                                                                                 . ...XXooo@o@&@++@+++&+o++&++++++$+++&++++o+&+++o+o+o+ooo+o+ooo@o@oo@o@oX.XooXXoXXXoXoXoXX.. .                                                                                 \n"
"                                                                                 ...XXXo@o@&$@+++&+&+%+++%+++++%++++++++&++++++o+++o+&+++++o+o+@o+oo@o@o@oXXXXooXoXX.Xo.XXXXX....                                                                               \n"
"                                                                             ....XXXoXXo@@++++++%+++++%++++%+%%+%++%+%%++++%+++++++++++++o+&oo+o+oo@+oooo@oXXXXoXXXX..XXXXXoX@X.. .                                                                             \n"
"                                                                            ...XXoXoXoo+$++++%$++++%+%++%%+++%+%++%++%+++%++%+$+$++%&++o+o+++@o+o@+o+o+@@oo@@ooXXoXXXX.oXXXoXXooX.. ..                                                                          \n"
"                                                                          ..XXXXXooooo+%+%+%%+%:%+:%+%:%%++%+*+:%:%:%+%:%%%++%%++%+++++$+$++++o+++o++o+oo+o+o@o@oXXX.X.XoXoooXoXXoX..                                                                           \n"
"                                                                        ...XXoXoooo+@++++%%+:+%++%%+%:%+%:*+*+%+:%%::%+%%++:%+:+:+%%+++:+++++++&+++oo+o++o@o@o+o+ooXXXXXXXXXXXXooXooX...                                                                        \n"
"                                                                     ....XXooooo@o@oo+%+%++%%*+%%%*%%%***%**+%*%%:%%%%:::%%%:%%%%+++++%++%%++&+++&+++&+o+o+o+ooo@o@oooXXXXXXXooXXoX.XXX. ..                                                                     \n"
"                                                                     ...XXooooo@o@o@&++%%++%++***::*:*:%*::%*::**%#%:%%%%::%%::*#%%:%$++++++++++++++++++++o+@o+@o@oo@ooXX.XXXX.XXXXoXXXX... .                                                                   \n"
"                                                                  ...XOXooooo@$@o++&@@%$+@$%%%+*:%:*%:*:********:*:**:****%**:*:%%%::%+++%++%+++++$%+++++++o@o++o@ooo@+@o@oXXXXXXXXXXoXXXX..                                                                    \n"
"                                                                 ...XXXoo@&+@$+++$+@@&$+%%%+%++%********:*:**:*:*******#::*:****%#:%*%%:++%:%oo&++++&++++$+++&+o+o++@ooooo@oXXXXXXoXXXXXXXX....                                                                 \n"
"                                                               ...XoOOo&o@++++%++%+++%*%%+$++******==****====*=**==*==*****=***:*****:%:%%:%+o+oo+@&@+o++++++++&o+o++o+o@@o@XXXXXXXoooooX...X..                                                                 \n"
"                                                               .Xoooooo++&++%+++++%****+%%++%%+**%#=*=#**=*#==*===#=*==**==*#*=*#*#**#%%:%%+++&+&+o++&+&Oo+$++++++o+@+oo+o+oooXXXXXXoXXXXX....X....                                                             \n"
"                                                            ....oo&@@@+++%+%+%+::***%%%:++%+%:***%*======*=========#====:*:********=**#%%+%:*++&$+oo&++++Oo+o++++++&+oo+ooo@ooXXXXXXXXXX..X..XX...                                                              \n"
"                                                          . ..Xo@@+$$+$+++++%*****%:%+%***%**=**:%:=============*=***==:=*+::*=#*=#**#=%#*+&+&ooooOo@&+%+++%+oO+&++++++o+++o@oXXoXXXXX.X.......XX...                                                            \n"
"                                                          ...ooo@$$+%++%$%:%%%**+%%%%+%:*:*::**:*%*%%*============*:+**:***===*==*********%++++%+OO+++++$+&oOoOo+o++++&++o+oo+oooXXoX..........XXXX..                                                           \n"
"                                                         ..Xooo&$++%%$+%%%%%+%:%+%***%*****==****:%**%%+*=======*:%+*:**+:***:===#%#*#*#%#:%+:+o++%+%%%+++o+ooooo++o+++++++o+@@XXXoXoX..X.....X...XX...                                                         \n"
"                                                       ..XXo&o$+++%%+$+%***%+**%%*====***=======#*:%+&+%+%*****=%+:*+%+:++%+=*==*:#++%#**#:%%:%+++%:%::%%:$+o+oOOoo+o+o+++++ooooXXXoXoX..XX........XX...                                                        \n"
"                                                      ...Oo$+%+$%+*%%******%****=======**=:======****+%*%@+%*%*=%+%%+*:**:=::**==*%%+$++%**#++%::%+%:***:%+ooo&++oO++o++++&++++oXXXXoXoX..X.X.X....X.X..X                                                       \n"
"                                                     ..Xoo$+%%%%%**%********+%**=====*:*****=**=**:=:**++***:+%*%&@+%:*=#==****===*#*:+&+**%:++++++:**#:%*%++&+oOooo+&++&++++++ooooXXoXoXXX....XX....XX.. .                                                     \n"
"                                                    .XOO&+%+%+%***%%*************===*:%*::=*:**==:**==*=***:***:++$%+*=**==::=#======*:%&#:***+oo+%%%+%%%:+%+@oooOOoo+&++++++++++@oXXoXXoXXXXX.XX.....XX... .                                                   \n"
"                                                  ..XXO@$%%%+%%**+%%%*===**%*==-===*#**#**==*++:+::=*=*=:******:%:+++*====**=**======**:+%=**#%++o&++&:%::+%:%+o+OOo+oo+o++++++$+&oooXXoXooXXXXX.......XX....                                                   \n"
"                                                  ..X&$%%+%+%%%*%%%+**-====*+*==-==*:***=*===**==*%*===#**:*::**:******====#**::*=*##=*+o:=*==:%+o+oo++%Ooo@@++%++oOo&ooooooo+++++@oXoXXoXoXXXXXXX......X.... .                                                 \n"
"                                                 ..X&++%%++*%%:%%*%**--==-=**=====*%%*:*:*==:=*==****==**:*++**:%**:+::*==:%+***%:***=#++#*#=**:++oOoo+ooo+oo@oo++ooo+oooo+oo+++++++oXoXXoXXXXXXX..X.....XX...                                                  \n"
"                                                .Xo&+$%+%*%%%**%%%%**-==-==========-=========*=:#*:=#*:**:++%:*++:*++++%*+**=:==**=*==*%+*=:%#*%*+++o&oOoo@+o@ooooo.Ooooooo+ooo%+++++oXXo@XoXoXXX..X. .XX.X.X...                                                \n"
"                                               ..OO$$%%%%*%*+*%%$******=-*=-==*=====-=---=-==*=#=%:*:*:=+++++*+@&@%%:%+**=::**==#**#==#*:*=*:*:+%:*++@oOo&@@@+@@oooOoo&@ooooOo.oo++++ooooXoXXoXXXXX.....XX.X....                                                \n"
"                                              .Xo+%+%*%%%%*%%%%o%%***-***-====*+=====-==--=-=:**:*:*===+++:=*+$@o@@@+++*==*+++++%+*:*===*::**#=%+**%$o&ooo@++o+++++ooo&oooo+oOO.XoooooooooXooXXXX.X.X.X..XX.X.X..                                               \n"
"                                            ..XO+%%%%%%%%***%%$$%%***%%*===*=*+*-====-=-======:*%:*===##==***++$@$++++*:==++@+@+::+*====*==**=*+%*=+&O@o+@o+++++:+%+oooXoOooooOOO&+oooooooooXXXXXXX.X....XXXX..X...                                             \n"
"                                            .Xo+%%+%%%******%%%+%%%****---===*=**:+#;===-===:==**:*====-==:+:%++:%:::**:+%@:+++:*+%##=#=#==*:*#*:*:*%+@&ooOoOo+%%@@ooo.OOoo+o+o+++o++o@oooXXXoXX.XXX.X.....XX.O.... .                                           \n"
"                                          ..XO$%%+%*%%*****%$%%%$*%****=*===*:*+*=====**;#:%#=**====;====**:*+%====#-=-==@@+*=++++++*:%=*==:=*%++:#*::+OooooO+++o@o++O..ooo$&+o+%+&+o@oooXXXXXXoXoXX........XX.X....                                            \n"
"                                           XO+%*%%%%**===*%$+%*%%*%****-****=+%*====*==:#-*+#=:=-==;-;===*:+*:==---;;-;-=+@@*+++:%:+++++*##===++%**+%**&oooO&%ooooooOXooooo+++%++++$+&+ooooooooX..XXXX...X.X.oX.XX....                                          \n"
"                                         .XO$%%*%%%%*==**%%$%**%%%%******%*%$+%==**%**;=---:==#=-===#=;;===::===;=====%@=-=:=+:+=*:++%:%%=#=#==*****:*:$oooo+@+ooOoooo+&o&oo+%%+:%++$++&+ooo@ooo.X.XXX..XX..XXO..XX.X.                                          \n"
"                                        ..X&%***%%+****=***%**%%*%***--*++@$%%***%%**%+=;;-*==-;#===;=#======#==##;=;=++@+@+:+++:@+++++:+@**+**=**:%%+*+%o+@+@+@+@ooo&+ooooo+%%:+++++++@oo++o+@ooX.ooXXXXXXXo.XX..X.....                                        \n"
"                                       .OOo%****%%%%***%%*****%%****-*%%%$%+%%%**++$*@%=;;=#==;-=#---=#*==-=#:+%=-;#+@@@@+@@@+++++%:+o++%%%++%%%:*+$+%%%%$@@@+@++@o@o+&oooo++%:%%:%+++o+oo&oo+oooX.XoXXooXXoXXXX..XX...                                         \n"
"                                       .O&%**********-*%%*%-***%***--****+$%*+**=%$**%=-=;----=#====-==-==-:@+@@=---=@@+%++++++++++++++:::%+%%+%+%%@+&%++@$o@++oo+++o+ooo@++&+%++%+%%++&++++oo@ooo..XXoXXoXXXXXXX..X......                                      \n"
"                                      .X$%****=***%**%%%*****--***********%**%%==%%*=*=-#-;-;-==--====--;=:+@::+=*--:@@:+*::+++++@++++@@+++++++%+++$@O+%*+@Oo@@o@@+++oooo+%++++%%::%%:++o%++oo.oooo..XoXoXoX.oX.XO.Xo....                                       \n"
"                                     ..O$%****=***-**%%$***--*-*%**-*%%-=*%**==---=*==--=-=;;==--===::++@@@@++**=:=+@++*=**:=:+@@+++:+:+@+o&$OOOo$%+&oo%*%oOoX@@oo+++@oX++++++o++%+%+%%+oo+++oO.XooX..XoXoXX.XX...o..X.X..                                      \n"
"                                    .XO+***********%%%*****-*-***%*=*%%*=**==-----------=-=-;-==#==#+:+@X@@@+=--:@+:@@=:#===#=#:+o@+:+@@o@&oOO.O&&+$+OOo%*+o@@@o@+++@Xo++++:+++++%%+%+%++++++o....oo..OooXXXXXX.X.X..XX...                                      \n"
"                                    .O$%****-***%%%%%%*-*--**********%$%***=-=-;;;----**=-;=-;#==-=#:+@@@@@+=-;;=:**+:===-=;#;;==:@o+++@@o.O.OOOO@o$$oXOo+%$$o@@@@+@@@+:+++++++++@+++%+o+%%o+oo........XXoXXX.XX...X..X..X..                                    \n"
"                                   .Oo%***-**%*%$$%%%--**--%*********%%%*--==;;;---*%*=*=--=;====#::+*::@@@@:===+=::==#===;;;=;;=:+@@++:+@oOOO.OOOo@@&XOO+%ooOX@@@+o@@++++oo++++%+o@o++%+%+++oX........XoXoXX..X.X.XX..X.X...                                   \n"
"                                 ...O%**$***-$$%**$**-***-%*-*******%*%*-*-==---===*%**%+===-;---**+@*:@@@@@@@:@:=*--:#;;;=;;-;;--=:+o@+++:+&ooOOoO$&ooOOo%ooXOo@+o@++:+++@@++++++@+@Xo+%+:%$+o........XXoXXXX...X.....XX.X..                                   \n"
"                                 .XO$*%%%=***&&&&+*--*----*==*%%%%%*%**====*----*--%%*%*%%==-;--==::+:+*@@@@+@+:*==;==;;;-;;;;;#;--:@+@X@+=*++@$%OXOO+$+$@%+OOOXo@X++:++++@@@@@@+++@+o@%%++++@o.........OOoXX.....X.X....X...                                   \n"
"                                 .XO%%$%==*%%$%$*****----==**%%**%%***==**----;-*-=%***%%%=-;;;;;-=:+++@@@+@++::*=--;#;;;;-=;#;;---=+@:@@@=:*%%:*OOOOoo%%%*$.XOOXX@@++++++@@@@+++@+oo@@++%++&&.OO.......O.XoX.X.........X.XX...                                 \n"
"                                .Xo$%+$***$$$$$***=--*--*%****%%%%$%--=**=--;;-;=--*==**#=---;;;;-:::@@@@:+:++++:=;;;=;;;=-;;=;=;;==#+@@@@@+@@::*@&XOXOOo@+OOOOoX@@@+++@+@@$+@++&@@@@+@@+++&o+o.O.O..O...OXXX..X...... ..X.X....                                \n"
"                               .Xo&+$%%%%%$%$$$*=-----*%$*-=*%*%%%*%*=--==--;;;--=*%==**%===;;;---*+@@@@@@++:*::==;-;;;=;-:==;;;;;;=+:@@X@@@@+@@:++@oOOXOOOOOXoO&@@@+@+++@@+++@@@@+o@+@@+@@oO@o.......O..OooXX..... .XX...XXX..                                 \n"
"                               .XO&$$%$$$$$%&$***---**%%****%*%%%%%%*--=-=;;;-----*%==%*%=*-;;;;;#=@+@@:@:::*+:=;;;;;;;##:==-;;;;;;:@:@@@@XXX@@@@@@@@X@XXoo$+@@@+@X+@+++@@$+:+++@o+++oo+@@oXo&XO.........Xoo@o.. ... ....XXXX...                                \n"
"                              .Oo&&&$+&+$$+$$%*---**%%%%$%%$%$$+$%*=%=--=--;;;;---=%%%=*++*=;;;=;-#@@:=:*:@+*::#-#;;;;;;==-###=;;;;#:@@@XXX@@XXX@@@+@X@@@+++++$@+@@+%++++@@@+++%++@o@@+ooooX@o.X.OO..OO..XooooX.......X.X..XX...X.                              \n"
"                              .Xo&&%$$&&%$$$%****--%%%%$$%%$**$$%%%%%**-=-;;-;--==*++%=+o=*=;;;#--*+@=-=:*::*==-;;;;;;;;;==#=:@@:=;=@:X@@XXXXXX@*:@@@X@@++@+%+++%++++:+++@@@@+:%*+++++@@oXXooX.X.O.......ooo@oX......XX..........                               \n"
"                             .OO&O$$+&&%%$%%*=**-**%%%%*%%+&%**-=%%%%%*-;;---;;-==%&$=*%*=*:=;;;=-=#:-;;======;-;;;;;;;;;===-*@XX@=;@@@XX@XX@XXX@+@@@@@@+++@+%%*++:++++++++++++++++++@++ooO.XXXX.....O....ooo@o... .. .X..X.X.o....                             \n"
"                            ..O&O$$+&&$%$$$**-*=*%$%%%$$%%$&$+*=*%%$%%=-;;;-;;-===%%**%%**++=;;--=#==;#;;;=;;;;;;;;;;;;;;;;#=#@@@X+;:@@@@@@XXXXX@XX@X@@@+:*@:++*%+*:+*+@@++++@@@++++o+o+OO...X@XXX...O.OOoooo@oX..........X..X.X..                              \n"
"                            .XOO&$&&&&%$%$%****%$$$%$%%%$++$$oO$*=%+%*=-;--;;--***%%%%%++%%%*--;-====;-;;;;#;#;;;;;;;;;;;#-;#:@@@X@#=:@XX@@@@X@XX@@@X@@@+:=++*+*+*+::+++@+++++@@@+@oOXXO...O.XXoXX......oo@ooooX... . ....XX...XX...                            \n"
"                           .XO&&$&&$o$$%%%***%%$&$%%&++&&+%$$$&&*%%%%*--;-----*%%*%%oO%%%%*+:;;;=#====;;;;;;;;;;;;;;;;;;;;;##@@@XX@:=:@@@@@@X@@X@X@X@@@:@@=:::**%*+=**@@@@@+@+@@@XoO.X.O.O.O.X@oX.OO.O..oXOooooo...... .X XXX......                             \n"
"                           .Oo&O$$&&$%%**--*%$%$&$$$&&O&&$%$&&O%===*%%---==-**+*=%%+OOO+%%*%+-;;-#=*#=#=#;;;;;;;;;;;;;;;-;=#@@@@@@X@=#@X@@@@@X@@@@@@@@@@@@:=++:++++*::+++++@+@@@X@oXOOX..O...oX....O.....oOo+o@o.. .....X.X .......X.                           \n"
"                          .OO&O&$$$$$%%---%$&$OO&OO&O&$$%oo&&oO%*-=%%=---==-%%&*%&+&%+$+o=%%*=-;;#:::+:##;-;;;=;;;;;;;;;#=:@@@@@@@@@=##@X@@@@@@@@X@@@@:@@@:=@:=:+++++:+++++@X@@X@ooo@+oO.O..O......O.....O.Oooo+X...... ...X........                            \n"
"                          .O&O&$$$$$%%--*%$&&&O$O&&OO&$&&&&O&&O%%%%%%---===-%$&&+%$+$=*%=%&+====--=::*:*;;;#;-;;;;;;#;;;##:@@:@@@@@@#=@@@@X@@X@@@@@@@@@@:@@*:+==::+:@@@++:+@XX@o@@o@+@oO.O.O..O.O...O..O....ooooo... ..... .XX........                          \n"
"                         .XOo&&$$$$$*--*%&&&O&&&&&OO&&&$o%$$+OO**%*%---=**=**=*=%%%%+%%%%%oO+==#-==:*::*#;=;=-:=#;;##-###:@@@:@@@@@@:-:@@@X@@@@+@@XX@@+@+@@@@+#=*++++@+@@+@@@X@@@@@@@@XX....O+oXO.O..........+ooo.........X.X .......X                          \n"
"                         .oO&o&$$%%%***%$O&&&O&O&OO&O&OOO%%%$OO%*$*=-=-%*****-*=+*%oo%===*+&@=-**-==:**::#=#==:=###:#::::@@::@:@@@@@:-#@@@X@@:@@@@@X@@@:@::@@@@:*::#=*::+:@@@X@@o@@+++++OO.O.+&XO.O..O.O..O..o+o@...... ..X .... ....                           \n"
"                        ..O&&o%$$%%**-%$&&O&O&&&O&OO%*OO$%*%%O$+%%=*--*******=*=*****%===**+$==-+*=====:*=:=#=*::#::@::@@:@::@@@@@@@:-:#@@@X@:@@@:@@@@@++@@@@:====#::==+::*@++@@@@@++++++@@@.@OO&o.O..O...O..O+o+O......... X.X........                         \n"
"                       ..OO&&&$$$%*--$&&&&O&&&O&&O&&$$&&*%*%%&O$%%--*-***-%**==**=*%**%:$%*=----=+*==#:*=:#=:=#@@:@:::@::@:@@@@:@@@@:;=##@X@@::@@@@@@@@@++:+##--=====#=:++:++@+:+@@@@@:+++%@o+OXoo.OO.O......Oo+oo....... ...X ... .....                        \n"
"                        XO&o&&&+%*--%$$&&O&&&OO&O&%$$&&&%%**%$&o$=-=-=*=-=***==**=*%*%*%%*=-;---*@*=::+:::=::==@:::@@::@@::@:@@@::@@:====:@@@:::@@@@@@@@@++:;;;=-=#=*=+:+@@:::@@@@:@@@@@@%+@oO..oOO..OO..O.O..OoooX.. .... . ....... ..                         \n"
"                       .OO&&o&$$%--*$$&&&&$&&O&O&%%%&o$$%=***+&o&----*--;-=*%*===%+%%:%%+$=;;-;;-%:=::+:*:*==#=::#:::::@:@:@:@@@@@@@@##==:@@@@=--=#:@:@@%+:=#;;--==::@+++@@@@+@@@@:@@@@@@@@@..OOoo...OO....oO.oo+o...........X... ....X .                       \n"
"                       XOo&@$&&&$**%%&&&&&$&&O&&O%&O$&$**-**=%O&&*=--*=----*%%*******%%%%%#;;=;;;=#:::::+::=*::=#-###:@:@@@:@@::@@@@@:#=#@@@@@@#;=;;=+++@o%=-;-;---#:@@@@@X@@@@@@@@@@o@ooX@O.....OO.OOO..O....oo+oO............... ......                       \n"
"                      .O&&&$&&&o&%%%&&&O&OO&O&O$&&&&$%%=*=-**%&$&&=--=--;;---==%%%%#*++%*==;;-;;;=#@:@:#=#======##;###:@:::@@:@:@@@@@@#;;@@XX@@:=;##++*#+*===---=;---=*::@@X@@@@X@@@@@+@oXXXO.O..O.....Oo.oOOO.o+oo....... .....X..... X                        \n"
"                      .OO$$&&&&&&%%$&&&&&OO$&&&&O&o$%%%-%*-*=$&$%+=--=--;;;--;--=*%%%O%%*=;-;;;;;=+#:+##::::::*:######:@@@@::@:@@@@@@@#;;@@@@@@:=;-*+*==*@o%=;===#;;;;:#@@@@@XX@XX@@X@oOXXX..O..O......OOo.O...++oo...... .. X X......... .                     \n"
"                     .XO&$$$o&&&$%$+$&O&&&&%%%$O&&$=%$***---**$%=%----=--;;;;---=%%%=*=**=#---;;;=:###;#:=:+@:::+::+#:@:::::@:@:@@@@@@=-;:@@X@@:#=====;=-+@-;#::=;=#==#::@@@XX@X@X@@XX.OOX.O...O.OO.OO.OoXoO..Oo$+.........X...X .........                      \n"
"                     .ooo$$&&&&&$$%$&&&&%$$&&&&&&%%$&%%*----*%%%%%*=-;=--;;-;---======-=%=;;;;;;;##;;##;;;;=#;-##::@:@@::#:::@@@@@@@@@#-#@@@X@@@@#=-#-#;-=+%**++*-**-+@:@@@@@@@@X@@X@XO..OO.O.O...O.&oXo+%o..O.o++o......................                       \n"
"                    .Xo&$$&&&&$o$%%&&$+&O$%OO&OO%*$%o***--*--*%$&&+*-;-*-;;;;----====;-==;;;;;;;;#;;;;;;;;;;;;;#:+@::::::::@:@:@@@@@@@-;#@@@@@@X@@#-=;;-;=@@@@:=@+*%==@+@@+@@+@@@@@@XX..O.......O.O.o%ooO+O.ooXo+$...O........ X.... X..X..                     \n"
"                    .Xo&&&@&&&$$%%$oo$&o$$O&&$$%%*&&&%=*-=---**%&%&%=--==--;;;-=-;-;;;---;;;;;;;;;;;;;;;;#-;;;#:+:+@@:@::@@:@@:@@@@@@:##:@@@@@@@@@@:;;;;;=%+@@**@@=+::++@@@@@@@@@@@XX......OO..O.O.O.+oOX&oo&o.oo+X............  .........X                     \n"
"                    .O&&&$&&O&$%%$$&$&&&$&%&o&%%&$OOO$=%=-------%oOO*-;;-=-------;;---;;;;;;;;;;;;;;;;;;;;####@::@@@@@:@:@:@:@@@:@@@@@@@@@@@@@@X@@@@##-;;-*+@++:+@++@@@@@@X@+@+@@+@@XXX.OOO.O.O..OOOoooo..o.o+o+o&................ ... ....                     \n"
"                   .XO&&&&&&&&$%&&&&$&O+&&%&&&%$&OO&&%**------;--+$&&=-;;--===%===--;;;;;;;;;;;;;;;##;###:@@::@:@@@@@:::@:::@:@:@:@@@@@@@@@@@@X@@X@@::==-;=@+:+:==%@@@X@@:+@@@:@@+@@o.OO.O.O.OOOOO++o+oO.O.oooo+o+.................... .....                    \n"
"                    Xo&$&$&&$&&&&&&&$&$&%O$%&%$&OO&O&$%%*---;;;;-$o&&%=;;;-=======-;;--;;;;;;;;;;;;;;##:#:@@@@:@:@@@@@::@@:@@@@@@@@@@@@@@@X@@@@X@@X@@@:+:=-++*:@:=%@@@@@==+==+@+@@@@@OO.O...O....o+==%@o.XOoo+&+oo.O........... X. ........                     \n"
"                   .o&&&&&&&&&$&&O&$%$$&%&&&%*&OO&&OO%=%*--;;;;;;=OOOO$--;---=-=--;-;;;;;;;;=;;;;;;;;#:@:@@@@:::@@@@@@:#:@:::@@@@@@@@@@@@@@@@XX@@@@@@:+::::*+::@::++@X@+==*#::::+:+ooO.OO.O.O..OOO%%=%+o..Oooo+ooo..............X  ......X...                   \n"
"                  .Xo&&&&+&+&$&&&&+$$%$$$$+%*%&&OO$O$%=**---;;;;;;=o&&O&*;;;;--;;;;;;;;;;;;===#;;##;##:@::::@:@@:@@@@:::@::@::@@::@:@@@@@X@@@@@@@@@@@@+@:%@=+:@:=+++@X@+=======#:++@OOOO.OO......+%+o.o&.OOooOOo+O..O................ ......                    \n"
"                  .OO&&o$$$&$&&&$$&$%$%%$$%%-%&&O&&&%=**-----;;;;;;-*$ooO%---;;----;;---*=;-;#;##::##:#::@:@:@:@@@@@:::#:::@:@:@@@@@@@@@@@@@X@:@@@@@@@@::@@=:++::*@@@@+=---==###:+@oo&+&oO..OOoooo%+O.O..ooo&++%$OO.O.....X........ ........                    \n"
"                  .XO$&&$$$&$%&$%$&=%%$$$$%*%$&&&&$%*===----;-;;;;;-=-=%%%*=-==#=;;;;=*++$&####@+@:##:::::::@::@:@@::@:#::@::@@@@@:@@@@@@@:@@@=#@@X@@@:@::@:*@:::=@@@%:=-;;;-#=#+@@@&@&+$O.ooooOo&+o.....O++:+&++O.............. ..... .....X                   \n"
"                 .XO&&&$+&&$$%%%%&%**$$$$$%*$&&O$$%%*-----;--;;;;;;***%***%%*%%*-;-*%%$%%O$@@@X@:+::::::@:@@@::@@@@#:::##:#@@::@@@@@:@@@::@@X@::@@@@@@@@@@@:++::#::@+:=#;#;==;;#=:+%*:**++&@%%Ooooo.....O+%%*+++O..........X......... ....X ..                  \n"
"                  Oo$$&$$&&$$*%%&&-*%%$*%%*$&&O&$%*-------;;;;;;;;-*%%+%===*%%%=-=%+%:*=+oXXXX@@@@##:::@:@::::::@::########::@:@::@:@:@:@@@@@@X@@@X@@@@@@@@@@+:++:#==-==##;;;;=;---===*=*+++:+oooO.OOO.Oo%:**+%+O..O............... .........                   \n"
"                 .o&$&$$$&$&+%$$&%*$$%%$%%*%$O&O%%**----;-;;--;;--%%%%*%-=%%#**==**=-==*OOXXX@@@@::#::::@:::##::@::#::#:::@##:#::@@::@@@@X@X@@@X@@@@@@@@@@@@@::+@::=;;#;;-#;;;;#-;;;======#*%+OooO.O+%%++*#*%*:oO.....O........................                 \n"
"                 .OO$&&$$$$$$$&$$*-$%%%$%$%$&&&$%%*------;-;*-;-**%%%==*%%%%%%*==-;-===+.OXX@:@@@::#::::::@:##:@@@@@::#:@@:#::#:@:@@@@@@@@@@X@X@X@@@X@@@@@@@@#@::@:-;;;;;;;;;;=;;;#=---====*%ooO+++o%*#%+***:+OO........O....... .... .....X..                  \n"
"                 .o&&$$$$$$&%$&$%-%*%$$%%%%%&$&&%-*-*--;;;;-=-;------=*-=***=*=;;;-=--=&O..X@@@@@::##:::::::##:@@@:@@:::@@:#:@:@:@@:@@@@@XX@@X@X@@@@@@@@@@@@@:#:@:#;#;;;;;;;-#;;;;=;;===-====@oo:==%*##*%%:=+&O+O..................  . X......                  \n"
"                .Xo&$$$$&$&&$$$$--%%%$$$%%+&o&$$%*-**--;;-----;*----=----;;;;;;;-----=%&.OOo@@@@X@:#::@::::###:@@@:::::@@#@@@:@::@@:@@@@@@@@@@@@@@@@@@@@@@@:@+*::#-#=;#;;;;;;;;;;#;-;-;=====*+.@===*=*%%#:%%ooo$...OO......OX..............XX X                 \n"
"                .XO$$$$$$&&$%$$$-*%%$$$%%%$$$$$$**-*---;---;;;--;--*--;;;-===----==**==+O..o@@:@@@:#:@:::@::##::@::::@@@@@@::::@@:@@:@@:@@@@@@@@@@@@@@@@@@@:@@:==#==-;;;;;;;;;;;;;-;;-#====#+Oo*=*#%==++:**+ooo+...O.........O..X.............                  \n"
"                .O&&$$%$$&&$**$$-***%%$%***$$$&%%*%%*--;-;;;-;----*-----;=*=**-====%$+$O.OO+:@:@@@:::::::::::#:@@::@:::@@::@@:@::@@:@@@@@@@@@@@::@:@@@@@:@@:@::#=::=;;#;;;;;#;;;;;;-=;;====:oO%*=*==*+o++**o+ooXO.....O...O..........  .X....X.                 \n"
"                .O&&$$%%&&$$**%-****%$$%%%%$&+$$****-----;--------;--;--===*%%*==*%+&oO.O.X#@:@@@::::#::#::::::@:##::@:@:@:@@::@@::@@::@@::@@@@@@@:@:@@@@:@:::::#:##;-;;;#;;;;;;;;;;=;;-=-=+oo+*#o*-*:%%+$o@Oo$o..O.........OO.... .....X..X. ..                \n"
"                OO&$$$$$&&$$%---****-$$%%**%&&$%$%-------;;;-;=-;-;;;-==****#=---=**%oOOOO+#@@:@@@@:##:::::@::@@:#:::@@::@:@@:@:::@::@::@@@@@@:@@@@@@::@@::@::=###;##;;;;;#;;;;#=;;#;-----=++&+=%o+-*%+++oO&oooo.....O..O.......X..... .X....X.                 \n"
"               ..O&$$$$%&&$$---***%%*$$%$*%%$+$%$%------;;;---*--;;--==*****==---=+%%+OO..$*@@:::@::::::::::::@:::::::@:@:@@@::::@:@:@:@:@@@@@@@@@@@@::::::@::++##;;;;;;##;;;=;;;;==----===+Oo+*+oo*%++%oOoOOOOO.............O..X.... ..X......                 \n"
"                O&&$$%$$&&$$%*$*%$$$%*%%***$&%$$%%*------;;*-=--;---=--=%%==---=****%$OOOO%-:@:@:@@::::::::::@:::#::@@@@@@:@:::@:::@@:@@@::@@@@:@@@@@@:::#:::*::##;;;;;;;;;;;;=;;#*=**==*:*@ooo%ooO:+++&O.XoOO...O..O..O.OO.o.......... .X.X....                \n"
"               .&&$$$$$$&&$$$-%*%$$%%%$$**=%$+%%%**=-=-;---*%==--=**======----===*%%%oOO.O%-::@@:@@#::::::::::::::###:@@@@:@##:::@:@@:@:@:@@:@:@@@@@@::::*:==#*:;;;;;;;;#;=;;#--==*%:+**+%%%oo@@oOo%+++&...OO.O.O..O...O...O.O........ ..X.XX.. .               \n"
"               .&$$%$$$$$&$$$**$$$$$%%$$%%**$$$%%****-;-;;;%%%---=----==------==-==$+%O.OO*-#:::::@:::::::::::::#:####::::#@#@@@@:@::@:@:@:@@@::@:@:@:=#==#==#--#;;;;;;;;#;;;=#=#::@%:++@+++&o&oOX%#&oooOO.XO...O....O....X.X.O..X.......XX.....                \n"
"               .O$$%$%$$$&&$$**$$$$%%%$%%**%%$$%***%-----;;*%%-=---------;--=======*++ooOO==-*:::::########:::@###:::##:#:@@#:@:::::::@::@:@@:#::@:@@:#:-#;=#;;;#;;;;;;;=#-;*#==+o+o**+o+%&:%Ooo.o=*+o.o...O...O.O..O..O..OOo.X...... .. XX....                 \n"
"               .O$$$$$%$&&&$%*%$&$%$%$%$$%****%%%**%%---;;;-=-%-----;;;;;------====*%%OoO+*+==+::@:########::::###:::###:::@:@::@@@@@@:@@:@@@#=::@@@@@:=-=#;;;;#;;==;#==::#:::*@OoOo:+oo++o%%:%o+%-#$+OOO....O...O.........O.O...........X....X..               \n"
"              ..&$$$$%$%$&$$%*$$&&$$%$%$$%**%%*--*%*%--;;--;--%*---;-;-;;-------==*%+&o&O%=%*=:@::##########::@@###:::##::::@::::::@::@::@:@:###:@:@:#=;===;;;#;;-:-#:::@::@@+@OXooo%++&+++*=#%++==%+.O.....O.O....OO.............X.... .X..X....               \n"
"               O&$$%$$$%$$$%%$%$&&$$$%$%$%**---*%%*%%=---;;;--%%*--;;;-----======-==*%++++%=-;;-:@::########@:@:####:@:##@:@:::::@:@:@@:@::@@:=:@:@@##=####=;;##=##=##+@@:@@@++o.Ooooo&+%&$:*%o+$#%o$.OO.O.O..O.O....O.OOO..OO..XXX...........X                 \n"
"              .X$$$$$$$$$$$%$%*$&&$&$%%%%*%*-----**%**----;--=%%$+=-------===**=-=-#===*%=;;;;;;;+:@:#######:@:::#####::#::::@::::@:@::::@:@:;;:@@@##==:#;;;;#;#::::@:@::@@@@@+&o+%oo+%:::**+&oo+%$o+OO....O...O.O..O.O....O.OO.oX......... ..X..               \n"
"               O&$$$$$%$$$$*$$$$&$$&$$$$%%$%*------**-*---;--***+$%*-;;;-==-====----=-==--;;;;;;;#:::####;###@:#:#####::::@:::::@::@::@:::::#;##@::=;#@:##;;;;##:::@@@@@:@@@@@@o+%*:#=-=---=+OXOO++oo....O...OO..O.O....O.......oo..... ...X.....               \n"
"              .o&$$%$$$$$$$-%$$$&$$&$$$$%%%%%*-------**------=*=%&&+*;;;--=**===#**%%%=-==;;;;;;;=#@##########;;-##::#::::::::#::@:::::#::#:#;#:@@#=::::#;=;-;#::@@:@:@:@@@@@XXX%--;-;=---#=%ooo+oooo...O..........O..O.......O..o.........X.....               \n"
"              .O&$$$$$$$$$$%$$$$&$$&&$$$%%%%*%*-;----*-**---=---==%%%%*-=-===----=%:%:%*==-;;;;;;;#::##;##;###;;;;#:#####:::::##:::::##::###;;;::@::@@:###;=-#::@:#:@@:@@@@@XXXX+#-*-=**#:%$+oO+OoooO..O...O.O.OO....O.O.O.OO..O.o..... ....X....               \n"
"              .o$$$$$$&$$$$$&&&$$$$%$&$$$%%%%$*--;---;----%**-=-==*%%%=**%%=--=---=%%*%%*%#-;;;;;;;#:#;#;;#;;;;;;;;;#;;#########::::#:##::##=;#::@:@@:###-=#=#:==;:@:@@:@@@o....o%oo%++o%ooOoOOoOO..O...O..O.O.O..O..O..O.Oooo.OO..X.....X....X..               \n"
"              .O$$%$$&$&&&$$&&&$$$%$$$%%$%$%-%*-;----;;--=-*--%=*---**=-***#==---=-==##**==-;;;;;;;-=#;;;;;;;;;;;;;;#;###;::####::#:::::::##:::@@@@@@:=##=####::#:@@:#:@@@@o....XX.oooX$+o.oo..oOO.O..O.O..O....O..O...O....oOX.X.o..... ......X.               \n"
"              .o$%%$$$$$$$$$&&&&$$%$$%$$%$$%*%*-----*-;;-----**%**%=-===*%$%*=#-;=---====--;;;;;;;;;;;;;;;;;;;;;;;####;##########::::@::::::@@@@@@@:::===-#@::@@:@@+::@@@@XX......oO.OOXooooO.Oo...O...O....O.O....OOO...OXO+O.OOo.......X..... .               \n"
"              X&$%$$$&$$$$$$&&&&$%$$$$&&%%&&%%**%%-*--------;-*%%*=*------#*%**#=;-=----;-;;;;;;;;;;;;;;;;;;;;;;;;;#####;###########:::::@:::@:@@@@@#=#=#@@::@:=::::@@@@@@@O.....O....O.o$ooo.oO..O..O.O.OO...O.O......O.X.Oo..X..O......X.......               \n"
"              .O$%$$$$$$$$$&&$&&%*$$$%&$*%&O%%***%%*=-*-;;-;----===---------==--=;;-;---=-;;;;;;;;;;;;;;;;;;;;;;;;##;##;###########:::@:@::@:@@@@@@::::::@+:@:::++++@@X@@@@@....O.O.O.O.O&ooO...O.O..O...O....O.O..OO.O.OOO.o.O..XXoX....X .......              \n"
"              X&$$$$$$$$$$$&&$&&&%%$$$&&$%&&%$%=%$%$$*-=-;;;;-;---------;;;---=-----=-=:%=-;;;-;;;;;;;;;;;=;;;#;;;;################:::@::@@:@@::@:@::#:::@++++++o%oXXXX@@@@@X.........oOOOO..O.O..O....O..OOO.O...O..O.....X.oo..oOo......X...X..               \n"
"             ..O$$%%*$$$$$&&&&&&&%%%$$$&&%&O%%%%*%$$$$*--;;;;-;--;;;;;;=*=--;------=#---#*=-*---;;--;;;;;;=-;;;;;;####;;;#########:::::@@:@@:@@@@:##=-=*#:*:+$@X....XXX.X@@@XX.....OO..OO..OO.O..O...O.OO........O.OO..O..O.Oo.OOo......XX.......               \n"
"              .O$%%%-$$$&&&$&&&&%$%%$%%&$$&%*%$%%%*-=$%=;;;;;;;;-----=--=-------;-#*==-;;-=%+++%==:-;;;;;;==;;;;;######;;#########:::::@@:@:@:::#--====:+:@@%@XX...... XX@@@@o..o&....O...O..O.O...O.O...OO.OO.O.O..O...OO.O.OX..oX..... .........              \n"
"              .&$$$*-%$$$&$$&&$$*$$$&%%$$%&%%%%*%$$%*$$%-;-;;;;-=**---==-----=--=-====-;;---=++++++=;;;;;=:*#;;;###:@:::#########:#::@@@@@::@:#=-+=+O$%*+@o$@$X........O.OX@@@@XX.XO...O..OO....O.....O..OO.O..OO.OO..O.OO..Xoo.O.O.......X.......              \n"
"              .O$$$*-*$$&&$$&&&$%%&%&$&$%$&&=%%%+%%$%$+%*-;;;---***=--=-;;;;;----;-=---;;=;;;=%%%%+=;;;;;=*+;;;###:@@:::########:::#::@:@:@@@:#::@&@..OO@&.O&X.........O.O@@@@@X.XoOO....O...OO..O.OO..O.O...O.......O.O...Ooooo.X....... .....X                \n"
"             ..&$%$%--$$$&&&&&$*$$&$%$$$&&&&*%%$%%$+$+$%*---;----*-;;;;;-;-;;--;--;--:=;;=;;;==:%+:=;;;;;#;::#;###:@@:@:#########::@:::@@:::::::$ooX....X..............O..X@@@@+XO&XOO..O.O...O.O.O..OOO..OO.OO..O.OOO...OO.&ooXOo.........X..X X               \n"
"              Xo$%$$--$$$&&$$$$$$&&&$$$$$&&&%%%$$$%$$$+$%%-;;;;;;-;;-;;;;;;;;;-%**==-++-;-;;;-=**+=-;;;;;;-*%:;###@@@::::########:@::#::::@@::@@oO.X.......................X@@@@....O........O.O.O.O..O..OOO..O..O..O.O.X.OOo.O....OO.X...........              \n"
"             ..&$%%$--$$&&&&$%$$&&&&$%$%%&&O&%%%%$+&%$+%%%*;;;;;;-;-;;;;;;;;--#*==--;#*=-#=;;;-#+*=-;;;;;;;#++*=#:@@@@#@::::######@:#::::@::+%OOXX.........................Oo@@@XXo@O.O..O.O.O.O.OO.O....OOOO.O.O...XOoO.O.Oo.OOO..O..o.......X.                \n"
"              .o%%%$--$$$&&&&$$$&&&&&%%$$%$&&%$$%$$$$$$%%$%--;;;;;;;;;;;;;-----===----;-=+o=;;-++=-;;;;;;;##*+**#:@@@@@:::::######::#::::@:@@....O..........................O@+@.o&@.O&O.........O.O.OOO.O...OO...OOO.O.O.O.XO.X...........XXXX...              \n"
"              .O$$%$*-$$$$&&&&&&&*&&&%%&$%%O&%%$&+$+$+&$+$$%---;;-;;;;;;;;-;--=-==;;--;-;=%:;;;;=-#=;==-=;;:++:*##@@@@@@@:::######:#:#:#:::+O..O.O.OO.................O......$+o..&%o.X..O.O..O...O...O.OOOO...OOoXOoOXo..OXO.XO.o.OO....XX.XoX...              \n"
"              .o$%%$%-$$&&&&&$&&&&%$&&$&$*$&&%+$$&&&$&+&%%$$%%-;;;;;;;;;---;=**%*=-;;=*=;;;*-=;;#%+:*++:+###::**:#:@X@@:::::########:::##::+O..O.....................O.......OoXO.$%+.OOO....O..OOO.OO.OOO.OOOO..OOoO.ooOOoO.OO..OX.........XXX.                \n"
"              .O$%$$%-*$$$$$$$&&&&&$$$$&$%%OO%%&$&&&+&&++$%+%%=;;;;;;;;;*---*%:%==%-;-+=;;;;#%;;%++:%%:%:*==::*+:*=@@@@@@@::##;######::##:::@.O.........O..................OOOO..OO&%@X&@&XXOO..OOO.OOXO....OOOXo+%+ooo&OX.O.OoOo.O.O......XXoXX..              \n"
"              .o$%$$$**$$$$$$$&&$&$&&$%&&%$&&%%$&&&&&O&O$%%%*$*-;;;;;;-=-*===*%*=-*==;--;;;-%:;;;#+%+::+:==*#::%+*:@@@@@@@@:####;####:@:#:::+OOo.O.....O....O...............oO....O&$$oo&oXXooO.XooO..OO.OOOOOOo%=*%%+ooOOo.oOoX.o.O.......oo@XX                \n"
"              .O$%$$%*-$$$$$&&&$$%$&&%%&$$&&O&$$+o&o&o&o$$%**==;;;;;;--%=-%&%%+%*=*++=-;;;;--;;;;;-:%:%##==*=#:::%=::@@@@@@:#:##;;##:::##:::+XO..OO.........OO......O.......OOX..OOO&oOoO..OO.OO%oOOOoOOO.OOooo*=-=**%oo.O.OO.o.o.XO.X....XXoXXX.               \n"
"              .o$%$%$-**$$$$$$$&%$$$&%$&$&&&&O$$&&&&&&&&&$*=-;;;;;;;---*-;#++$&+%=%%+*-;;;;;;;;;;;;-:%#*==#*##:+%::=:@@@@@@:::###;###:@@:@::OO..............OO...........O....X@...XooOoOO.Oo.Oo&O.OO+OO.OOOooo**=#++%+oOoOoOXO.OXO.OX...X.ooXX .               \n"
"               O$%%%%-$*%%$$$*%$$&&$$&&&*%&&&O&$$$o&&&&&$%%=;;;;;;--;;;---+$++&++%#%$$-#-=;;;;;;;;;;=##=-#*==##:*++*::@@@@@@:######;##::@@:@X ..O...o..............O........@@@+@@+:+$XX.O.OOXOOooO.OoO...OO$$o*#=*&o$&+o&o+oOoo.O.X..oXX.XXoX..                \n"
"               O$%$%**$$%%$%*-%$&&&&%&&&%&&&&$&O&&&$$+&o$%%;;;;;;=--;-;;-*$+&&o&&$%%%:+$*;-=-;;;;;;;--#*=*#*#==::*:::=:::@@::#;####;###@:::@XX.OO..OO.ooOo.oOO............oO@@@@++@+@@@@O..XOOoOXOooooX.OOo*%:*+***++++$ooooOOoO.XO..OO...oXXo...               \n"
"              .X$%%%%-%$%$$%*-%$&&$%%$$$$*&%&O&&&++&o&&o$$-;;-**--**%&$*=$&+&+$oo+:%+=+&*;;-=--=-;;-=#===::=*=*:::*++**:@:@::###;###;##@@::@X.X.O..=+&.OOo.o%-.O.........@XoO$+.XX@o@@@+@@XoXOOX.o+:+++o.$%#o+*+%%%:+$++&Oooo@oOO.OO.....XoXXX...               \n"
"              .O$$%%*-%*$%$%*$%$&&$$%$%&%$&%%&o&&$&&%$$$$%-----*%%+&%**%+$+$+&ooo%*%*=%+:;;=*==-;;;---=##*=#*:==+::+*:++@:@@::;########:@@@@.ooo..O&.O....O.X$..........XX.oo&O..XOO@@@@@@@@oXo@@@@%+++oO+++&%-+++**+%%+++%+%+o..oX......XooXX..                \n"
"               .&$%**-**%$%%%$$$&$$$%%$&$&&&&%&&&$&&O&O&&$=--**%$Oo**=*%oooO%$ooo+$&*=%o-;#%%%=;;;;;;=##=#*#=*=#%#%::%%+%+@+:####;##::#:@@@@Xoo.OO.O.O......OO.................OOO..OOo@@ooXO...@@@++oO..&oo&+*%+++%:%%++%%%%@.O.OO..O...XXX....                \n"
"               .O&%**--*%$%%%$$%%$$$$$$&&&O&&$&&&$%&&O&&O&%--;-%&%*%&&%*&%%%OOOOooO+:=+&--=+:+#=-;;;;#==#=#**#**#*#%%::+:+:@:##:#####:::@@:@OO.o..oXoX..........XX+O........O.OO..OO.O+o.oo+o.OX@@@o..O..Ooo&+%++%*=*+%++%+++OOO.X.......XX......               \n"
"               .O&$%*---*%%%*%%%*-$$$%&&&&&&$%&OO&&&&&&OO&O*=-;%=*%%%oo&:*OOOOO&&&o+&-++--*%+%%::=;;--=#*###=##=*#%#:+%+:+@@@@@:########@@@@...Xo.+-&o.....&..OO+:;+......O....OO.O..OO.ooO&ooooooo..O.Ooo%++%%%%:%**+&++%+oOO..O..OO...XXX. X.                 \n"
"                &$%%*--;-****-*%**%*%$&&&&&&%%&OO&OOOOO&OO&$$+%*%%&%o&+$%OOOOOooo+&&&:&+-=%:%:%%%##---====*=#*=#*##%%::%+:@@@@@@@:####:#@:@@XO..X&;;+O.....Oo++@@:#@OOO...OOOoO.O..OO.OOO.OoOoO....OOO.OOOOO%+#***%+%&o+oo&oO.O..OO.....X.......                \n"
"                O&$%**-;-*----%-**%-*%$%$$&$%%$&OO&&&O&O&OO$%%$&$+%%&&%&$OOOOOOOO&oo&oO#-==%+%%#===;-#=##*#**==#=#%::%%++++@@@@:@:::::::#@:@@XXXo+*=OOO...Xo+@:@@::++oO+OOO.o%&..O.OO.oo+oOo..O...OoO.OO&.o+=:+**%*%:+oooOOOOXXOOoO.....X.... X                 \n"
"                .O$%%$------;;**--%---*$*$&$%%$&&&&$O&OO&OO&&&$Oo&*++%+$++&oOOoOoo+&&+&%;#*#%+:%%:%:#=*#*#*##*#*%##%%:+%+%@@@@@@@:@@:@::#:@@@@XX+.....O...OX+@@:=#=+&+$oOOoOO++oO.O.Oo@@+*+&O..OOOOO.O&oO.Oo%%oo%%#*%%+&OXoOo$OOooO....OX......                 \n"
"                O&$%$%*-;;;-;;--%--%$---%$$$$$$&&&$%$$&O&O&OO&&&&%$%*%%:&&&O&OOOo%&ooo+$=-:%+%+%+%:**%#%#*#**#*#**%#+:++%%+@@@@@@@:@@::@##:@@@@@....Ooo...X@:@@#-;=:=+oo.O+o+OOoOO......o%ooO.OOOOoOO+ooo.Oo&+&%:%*=%**%oOOOooXOOo...O.X.......                 \n"
"                O&$$$%%--;;;;;;;----%**-*%$$$$$$$$**%%$&O&OOO&O&OOO%=&&&OOOO%O.O&oo&o+&+%%=*%:%:%#%:%#%#*#**#*#*#-#%:%+%+%@@@@@@@@@@@@@@:@:@::@@&.O.o-+OO.@@:::;;;-==%+oOO-%O.OO....O.OOooOO.OOooOoOo&oOoOOOoO+*=*==:*:oOXOO.OOOo.O...X........                 \n"
"                .O&$%%*-;;;;;;;;-;**-**%*%%&$$$$$&+$%%%%&&&&O&&$&OOO&OOOO.OOOOOOoOO&ooo++%%$$##+#%%*#%:%*##**#%##**:%+%+$+@@:@@@:::@@@@@@:@:@:@@%@X@$oXX..X+:#=;;;;;;;==*%oO..O.O.O.OOOO..O..OXOoOO.OoOOOOooOoo++%*#%%@O.O.OXOOXo.O..O....... .                 \n"
"                 oo$$$%*;;;;;;;;;;-**-%$%$$$&&$$&&$&%$*%$&&&OOOOOOO&OOOOOOOO&O.OOOOOO+o&++++*%$%%:=#%:%--*%##%:%#%:%:%+++o++@@:@@::@@@@@@::@:@@:@.**+XX@&O++=#;;;;;;;;;-#=*OOOOOO.O.O...O.OO.OOOOo&oo%oo%o.OOO+&+%*%%oOXOO.OOO.OoO.......X.....                 \n"
"                 .&$$$%%*-;;;;;;;;;----%$$$$&&&&&&&&&o$+%$O&&OOOOOOOOOOOOOOO$&O&OOoo%*%+&+&+:$++%#%::%#--=###%%:%:%:+++++$+o@@@@@@@@@@@@@@@:@@@@@@-%Xo+==*::;;;;;;;;;;;=--*+oO..O.O...O.OO..OOoooooo&+oooOO.o+o+&+o$@OO.O.OOOXoooO.O.O... ....                  \n"
"                 .o$$%%%*-;;;;;;;;;;;-****%$&&&&&%&&&&$&$$&OOOO&$O&OOOOOOOOO+&OOOOO&$o+&+&+%++&+%%%:===*#%%%%%#%:%+++++$+oo@@@@@@@@@@:@@:#:@::@@@:#+*==###::#;;;;;;;;;;--;#*%ooo.OOOOO.OoOOO&oOO+&Ooo+&OOoOO&o$&+o&o&.OO.OoOoOOooOX..........                   \n"
"                 .O$$$$$%*;;;;;;;;;;-*$-*$$$&&&&&$$&O&&$&o&OOOO&$&OOOOOO&OO&OOO.ooo+%oo&o+&++&o+++***:*##%%::%:--#+++++++@ooo&oo@@X@@@@@:@@:@:::@#-==##::###-;;;;;+---;+*;=#*ooO.OOOOOOOo.o&+oOOOOooOoOO.Oo$o+o+$oo$+o$+OoO&XO&oooO..........                   \n"
"                  .O%%$%%*-*--;;;;;;-%%%--%$&&&OO&&O&O&&&&&%&O&&&OOOOOO&&&OOOOOO&o&%+o&+&+&o+&+&++%-*#*%*:%+%::-;--%+$oo&o+&oOooXXX@@@@@@@@@:=#=:-;;;-=:@#;;-;;;;-++:-=*=-==%+oOOOooOOOO&o%+O.OOOoOOOOO+&+%Oo$$++@@@+++&o$@&Oo@&OO..O.... ....                  \n"
"                 .O&$$$%$%*%*-;;;;;;-*-;----$$$&$&O&&O&&$$&OO&&OOOO&OOOOOOOOOOOO&$%=&oo&o&oo+o+++=#%%%%+%::%++%%=;-++&&+o+ooooooXoXX@@@@@@@@@@::#-##==#::#;;;#;;;;:++=##-;=--$oO.Oo.ooOO.OOOOOOOOOO+oo*%oOo+o&o++++o++o+oo&O@$@@oo.O.........                   \n"
"                  O$$$$$$$%%%*--;;;;--**-;;--*%$&&&&&OO&+%$&&&OOOO&O&OO&&OOOOOOO*--*:&o+&o&+oo&$+=*=#%++%+++%%+:%++++++o+&+ooooOOoXXX@@@@@::@@:#@@::::::#=;;##;;;-=+==-#;;;;;==*+O&o&oOOOo$+oOoOO.+*o%#*#oo%++++:+++ooo@@$@ooooXXoOOO........                   \n"
"                   O$$$$%%*-%**%*-;;;-*%$--;;;%%$$&&&&&O&%*%&&&O&OO&OOOOO&oO&O$$%+&+**$&+&o&++o&&o+%*++&++&++$+%;%*%:%=++o+ooooooOXO..O..O++#+:#+++oX@@+@:-;;;-=;##=##=;=;;;;;;-;=Oo+Ooo+++&OooO@+*+@***+++*+:+::++@XXo@@$@@o@@Xo@@oX... XXX                    \n"
"                   .&$$$%%$-*$*%%*-;;;*$$--;;;;-%$&$&&&&&$***&&&&&&&O&$%+&$+=-*&&oO*;;;*&o$+o&+o+o*+#%+&++++++++*#;;=+*+&oooooooooO.OO.O.O&%*+==%=$OO.o+:##-:-#;=#:=;=-;=#;;;#*#=%&oo$o&O&+&OOO.@+:++:++:*::*+++%+$+@@@o@@o@@o@ooo&@oX..... .                   \n"
"                   .O$%$%%%**%*%*%-;;--%$%---;;;;%$$&&&O&&$=%-*--*&&O&*;;*%*;;-*OO&o;;;--*oo&oooo+#%$+++++&++$%+%%*-%++&+ooo+*oo.O.OO.O.OOO*=%==-%+OO.Oo@:##::::::#-#=;-;==;%+@%OO+o&oooOo+OOOo+@+*:++:**++++++:+=+@@o@X@o@&oo@o@@ooOXXX.XX                     \n"
"                   .O$$$$%%$%$$$$%*-;-%%$$%%%%**-%%$&&&&O&O&%---;-%&&&=;--*%=-**&+&O=;;;;==&ooo&&o&++$%+$o&+++$++++%+%+ooooooOooOOO..O.O..O%**:=-%OoOoo.@@+@@+@@@@@::#===#;=*&XOOOOOoo&ooOOOO@++@**++:+:+:+*::+++:%+@@@@&@o@o@o@ooooX.X.XX..                    \n"
"                    OO$%%$%$*$$$%$%%-%%%$$$$$&$%*-%%&%%$&&O&&$*%-*=$&&%---*&&=*%&ooO%*-;--*+%&oooo&&+*%+++&+&++o+o+o+%ooooo&o.O..OO......OOo@%-=%$&OO%&.XXOO.oO@@@@@@:=--=;-+oOXOoOOXOOoO.OO+*:+++:+*++*++:*:+++%*:@$@@@+@$@@&oo@oXXXX..X ..                    \n"
"                    XO&%%%$%%%$$$%$%$$$$%%$$&&&$%*-$&$*$O&&&&&&&---*&&&o***OO+&oOO&&Oo+%==%&%oooo&oo+;%%+=#$+o&+ooo&o+:&oo%+Oo.oO.O..OO...O%%*%@OOoO.OOOXX......X@Xo@+::###=+&o&O++OOOX@%O++%:==****:*:++++:++++:*%@@++$++@@@oX@oXXX.X.XX.                      \n"
"                    .O&%$$*%*%$%$$$*$$$$$$$$&&&&$$*%%$%$&&O&O&&&$$**%$OOo&Oo$$&&$O&o&OO&ooO%%=%&ooo$&=-*%-%+&o+o&ooo:=&+&ooOoOoOOO....O...OOOOO..OOOOO.OO.....O.X...@+:+:==:OO%+oo&O.O@%++%&++++**:*:**:+@+:++*++%+@+@@@+$$@@oo@oXXXXXXX...                     \n"
"                     .&%*%$$%%$%*$$*%$*$$$$$&&&&&$$$%*-%$%$O&&O&&&%*$&$O&$*%*-%$%oOOoO&o&$=*=;=+$oooo%#&$++oo+&oooOooo-%o+$ooo%+..O.O..O.OOO....O.....O..O.OO.OOXXXOXo@+::=+oo+&o&+oo$%%*%+O+::**::**:=*:++*++**%++@@@$++@++@oXo@XX.XXX X.                      \n"
"                     .o$*$$%%%$$*$$%-%-*$&&&$$$$&&&&$$%--%$&&&&OOo%=$$$O&O%*;--%&O&oo$&Oo&*=;--=+&Ooo%++o++&OoOoooOooooo+**;-++*O.O.OoOOOOOO.O....OO.O.OO.....OOO.O..O+:--=#*==%%-;=*=*:++++:++:+:*=:*===+**:**++@@+++$@@+@@oXX@XXXXX.XX .                      \n"
"                      X&%%$$$$%$$$%%%$--*&&$$$&$&&&&$$$*%*%%&&&O&$%**$&&&oO$%=;%o+&&&Oo%ooO+%-;%OooOo%&%%&ooooOooOoOOOOoO+%=-o&oOO.OOoooOO.O...OO.....O-*OO.OOOOO.OOOO%*;==#=*-=*=;==**@+**++++@@==*:+:=:*=:*+:%++@$+@++&@$@@oXoXXXXXX.X.                       \n"
"                      .O$-$%%$$$$$%$$%%-%$$$$$$$$$&$$$$$$$$-%$&&$$%**%%&OO&%*%-%&O&O$oOOoO&%%$=%OOo&=*$%+o&oOOoO.OOOOoooO+o++&+oO.O..OOOOOOOO..OO..OO..OOOOOO$%&OOOOOO&+:#*=-;=*==**:++++*:++@@@@:=::++**::*++*++@+@@+@+&@@@XXXXXXXXX XX..                      \n"
"                      .O$*%$$$%$$$%$$$$%$$%%&$%$%$$$$&&&&&&$%*%%%%*%%*%$O$$+$%&$&OOo&O+&$+%*++&*%+%o$=+o&OOoOOOOOooOOoOO&OOOo&OO.OO..OOoOO..O.O...OOO&&&OOOOo-$&&OO&OOoo:*=;=-=:=*:+@$$*:**::+@+:+***:+*=*+:*::+@++@+@+$@@&XXo@oX.XX.X..                        \n"
"                       X$$*$$%%$$%$%$$$$$$-%$$$%*%$$$$$$&&O&&&--=-*-----*%$&*=$*+&oo$&o&%=%oOOO-;**%=%*++oooOOOOO..OOOOOooOOOo$oOO..O.OOOOOOOO.O&&.OO.OO..OOO%+%*$$&OoO*;;;;-;=#=+@o@$*-=:**:+@:+:=*:***:**===*+%++++++@@&o@XXooXXX.X.X                         \n"
"                       .&$%%$$%$$%$$$$$$$$$$$$$$$$$$$$$&&&&&$$%$%-;---;-;=$%-;-=$&o&OO%%%&+%OOo&--*==&o$%&o&OOOoOOOO.oo%+%+oo%+OOOOOOoOO.O.OO.OO.OOOOOOOO.O&%%%-;*%Oo$+%=;;===*++@+@o+=-=*=**+++:=*++:#**==*=*+@@++++$+++oXXoXoXXXX..X..                        \n"
"                        &&$*%$$$$%$$$$$*$$$$%%%$$$$$&$&&&O&&&&&&$%***;--*%---;*%%%&o$+$+&+%%%OOOOOOo%&&++&oOoOOOOOOOO%-;=+oOOOo-+OOOOOOOOOOO...O.OO.OO&O&OO$O%%-;*&X.&oOOO%%+&@@oo@oo$%+*==:@@@*===+@**==-=*+:++++*+++$+@o@XXXXXXX.XXX                          \n"
"                       ..O$%*%%$$$$$%%$$%%$$$$$$$$&&&$$&&&&&&&&&$$%%%---;---*%**=-+&+&&$%%%o&OOOOOOOO+oo$o&OOOO%*%ooO+**$&OO.OOOOo$+$OOOOOOOO&O..OOOOOOOOOOO.O%%%$&OOOOOOo+&ooo&OOOoo$$@+-=:+@+===++:::*==:**+@*=*+***%+@XooXXXXXXX.X .                         \n"
"                         O&%**%$%$$$%%$$$%$$$$%$&&&&&$&&&&$$&&%&&$%$$**--;;-*&%-;;--*&$*===%OOO$&OOOOOO$+oO&&&o+O&OOOO$%&OO..OO.O&$%++&+ooo&oo.O...O.OOOOOOO.OO$%*OOOOO.oO.OOOOo*%&+%&++===+:@+=*++**=====*:++****::**:%@XX@XoXXXXXXX .                         \n"
"                         .o$*--%$$$$$%$%$$$**$$$&&&&&&&&&&$&&%-$&&&$$%%--;-=+&%-;;--*--;;-%$OO%;-%O$$++&*&&+%*+oOOO..O.OO.OOO.OOo%+%%%%%%%oOOOO..OO.O..OOO.OO.O&$oO....OOOOOO.O%=%%=*o$*=*:@*@:=+::=:==*=:*:*****=**:**+@@XXXXXXXX.X..                          \n"
"                         .X&$*-%%$$$$%$$*$$%*%$$&$&&&&&&&&&&&%$&&&&%%&%**%-*&$+=----=----$&OO$-;;-%%*&+*=+%%%=+&O..OOOO.O.O.O..O+*==-*+*=*+$Oo..OO.OO.OOO..OO.OO..OOO.OOoo&+OOO:*%==%+%=%*++@@=++:*::===*:**===+*+*****%oXXXXXXX.X...                           \n"
"                          .O$%-**%%$$%$$$$%%$*$$&$&&&&&$*&$$&$&&$$&%%%%=*$%%%$&*---;;;;-%&oO&=;;;;;;;*%-*%%+==$oO&OOOOOO.O.O.OOO&%o-;==;;=%+OOO&O.O..OO.O.OOOOOOoOO.OOOOo&+&&o&%%%*=*%*%+*::@*=:+*:*==**=+*====+:**:*++@@@XoXXOXXXX..                           \n"
"                           O$$*-%*$$%$$$$%*%$**$&&$$$&&&%$$-%$$&%%&*%%*%*$&$%$&%%*;;;--&&&O&%---*=;;;---*$$%-;OOO&$Oo&+OOOOOOOO%%=**-%*;;*%ooOo&.OOOOOOO:&==OOoO+O.OOO$%%+=%+%%o&%:*+%=%+=**@==****====:=:*====*:*+%%++ooXoXXXXXXX...                           \n"
"                           .&$%%***$$$$$$$%%$$%$&&%-$&&&$$&%%%$&$&$%&%&O$%*%&&$$$*----=$OOO%-=-%*;;;;;;;;;*=%-**+=*+Oo**$OOOOO=-=%==*==;-%=%OOoOO.OoOOO$--+$oOOOOO&*OO-;=*=-=$OO&*==%$****+::==#*:=====****=*:***+***%@@oXXXXXXX.X.                             \n"
"                            &$$%%**$$%$%%$$$$$$%$$$*%$&&&&&$$$$$$%$%+&&&$$%%$%%%%%--%*%$$O$-*-==;-;---#=*%&%oo%===&Oo%=-=-$OOo%*=--*%-;;=%**&Xo+O.O&%$%--;=*%*%**%%-==*=*%=*%O&++*=*%%===:::=*=#*:====#====****::***+@oXXXXXoXXXXX.                             \n"
"                           ..&$$**-%%$$$%%$$$$$$$$$$%*&&&&$$$&$$%*%&&&O&&$$%%%*%%**%&&$%%%*;;*=*-=%%$*&&&OoOOoO&$o&%*%&%%%&$OOo%=-----;;;-==*-*=--==;;;-*%+%*-;;-**-;-$-*-=%o%$%$+%%%$=#=*==*===*===========:=*=**%%@oXoXoXoXXXX...                             \n"
"                            ..O$%*-*%$$$$$$$$$$$$$$$&$-%$&$&&&%%&$**%$&$$$&$%*&%$$O$%%**;--*;=%%*&O$+&OOOOOO&+&&$+%%=%o%==*=***-----=-==-=-=-#%*%=-;-*****=**-=;=$+%+%+*-%*%*%=*+$%%+%=*#======#-===========*=****+@oXoXXXoXXXXX. .                             \n"
"                             .o$$%*--$$$$$$$$$$$$$$$$$**$&&&&$$$%$$$$%$%&&O%%%*O&O&$$***;;=%%O&O&OO%+%&OOOOOOOoOO%-*%%%%=---*--=-==-;---=;--=*%$%=--=%*===*%%===*+%%%%%=*%===--*%*%%**=:=-====-======-========***%@XXoXXXoX..XX.X                               \n"
"                              .O$%%--*$$$$$$$$$$$$%$$$$$%%&&&$$$$*$$&$$$$$&$%$$&O&&&$%&*--%&OOOOOO%+$+OOO&OOO&*OOO%%%$o&%----=--;--=---=---=*%+%*-=%%%%***%++*=-=%=*%==%*=%+**=%%*****+:=--==--====--=========:+%@@X@XoooXXOoXX..                               \n"
"                              .o$$%*-**%$$$$$$$$$$$$$$$$$$&$$&&$*$%$$$$$$$&$%-*$&&$$$&&O$%O&&OOOO&$%%&O$&&O&*+&oOOO%+OooO%==***=====*%+**%%+%=%*-=%*=**==$+&&**=%%===%****&$**=%+**==*::==-==-=====-=======-=**+@oooXoX@oXXXXXX.                                \n"
"                               .O$%%--*-$$$$$$$$&$$$&&&&%$$$$&$%$%*%%$&%%&$$&$$%$&%oOO&OO&OOOOOOOO&%%$$$$$+*=%O%%&&OOOOO.OO%+$+$&%*%&oO%+$%%==%%%%+%**=*%%$+%*=-*&%**%*==%$%===%$%*==+====-==-===#=-=========*@@XoXXoXXoXXXXXX.                                 \n"
"                                .O$%%--*-$$$$$$$&&&$$$&&$$$$&$*$$$$$$%$%%&$*$&O&&&$&&&&&OO&OOO&OO&%$*%&&+*-=%%$**+*%%OOOOO&=;-;-=+%%ooOo$ooO%%+%$++&*$O$+$&+%*-*&+%*%%%*%%$+*=%$%$%#=--=#========;-=*===*==**+@@o@@oXoXoXOOXX. .                                \n"
"                                .O$$%----%$$$$$$$$$$$$&$$$%$$&$$-$%%%%$$*%%%%$$$&O%&&O&&&&&OOOOO$%%*&%%*-;==*-*%%&$*%OOOOOO%---%%$*oOOOOoO&+%%+&OOO%$O&+&%O$+%%%%&o+*$%$&+%*%+%%$%:==--===========#***=***%++$@@oXoXooXXoXXXX..                                 \n"
"                                .O$$%$--*%$%$$$$$&$$$$$$$$$$$$&&$---*%*%%%$%%%%$O&*$OO&O&O&%$&&$***==%**---==-=**;*=%*%&&O%=--=****oO%%%&+%*%&OOOOO$+OOOoOOOOO&+&+%%%OoOo&$%%$%&&+%=;==#=-#=:#==*+++:*%+X@@o@o@@oX@XoXooXoX...                                  \n"
"                                  .O$%%;-*$%$$$$%$$$$$$$$$$&$$$$&$$-%%$$*$%$$$%%$%**&&&&O&O$*$$%%%*%%**---=-%$$&O$%==-=***%**=---=+o%--;;-%$%OooOOO&%OOOOOOOo&$%&oOO&OOOoo&$%$%$+=#-;===-==*++***++++%+oX@X@ooo@ooXoXo@oXXXX.                                   \n"
"                                  .XO%%-;-%$%$$$$$$$$$$$$$$$&$*%$&$$$&$%*$%$$$%*$$$-$&O&OOOO$$%%$$$$O**%*==-%$&oO&$%%%%%&%%OO*=-=-*&%*--*%%%+o$$O=&+%O$&&OOo&%%%$O&&%$&Oo&%***%%=--;==-==+*+@@*:+@++%+@@ooo@@o@o@XXooXXooXX..                                   \n"
"                                   .&&$*-;-$$$$$$$$$$%$$$$$$&$%*$$&$&$%&&&%---%**-%%&&&%&&O&&%%*$&$$$%%=%%=%*&$oOOO$&O&OO&OOO%=-*%+$%---=***&O$$%%%%+&%&%****=%*%+%*==*&$%=--**----==--==:+@+@+%+$@@oooo@oooooo@ooX@ooooXX..                                    \n"
"                                   .O&$%*-;*$%$$$$$$$%$$$$$$$$$$*%$$&&$$&&&%%-*%%%%$$&$--$$&&&$%%&%%&%%%*$$&$OOOOO$$%&+&OOOO&$%=%%&&*%*--=-=O**=*%%*%%%&%**=-=-*-;-==---=---*%*--===-====%@+%%++@@@@@o@@o@@o@@ooXooo@XXXX..                                     \n"
"                                    ..O$%*-;*%$$$$$$$$$$$&&$&&$&$*%$$&&$&&&&&%&&&%*%$&%***%%$O&$&%*%O&O&OOOOOOO&O$=-=*-**%*$*%%%$+$%=**-=*==%%&*+$*=*-=-**-*=---;--------=-=**--=----==***++*+%%@@oo@o@o@Xooo@ooo@ooXoXX...                                     \n"
"                                     .O&$%----%$$$$$%$$$$$$$&&$$$$%%$$&&&&$$&&&$%&&&&&O&O&%%*%&&OO%%%%%%&OOOOOO$&%-=-%**&&%%&O+&&&%%%-*--*-%+&+%$O%-----=*-=-----;---*--=-*--------==-=#==*++++@@o@oo@o@@o@@oXo@XooXooX..                                       \n"
"                                      .o$$%---*$%$$%$$$$$$&$$$$&$$$$$%&&&$$$&&&&%&&O&&&OO&&&%**$%&O&$O&$$&%&&&&O$**%-%&OOOOOOOO&*%-=%%$&*---=%%&%%*=---*-*-=****=-**=*$---------=;-===*+===*=*o@o@o@o@oooooo@oXo@oooXoX. .                                      \n"
"                                       .$$$%-;-*%$$*-$$$$$$$$$$$$$$$$$&&&$%%$$$&&&&&&$%&&O&&&&*$&$&&$OO%$$%$$*$*$**%*%$%OO&&$&O&%*-=**=*==*=-*%%o&$%**-=--*==*%%%*==*=***--=**---;=-==*%==*:*+oo@o@o@oo@@o@ooXo@oXoXoX..                                        \n"
"                                        OO$%*;;*-%$*-*$$$$$$$$$$$$$$*$$$&&%%$$$$&&&$$$*%$&O&&O&*%&&&OO%&OOO****%&O%*+&OO&&$%**$$=**=---*==*%*%%%$+%%**%*-****%*-*=----=-*-*-*%$-=---===:*==%+o@oo@o@&@ooo@oo@@ooXoooX..                                         \n"
"                                         OO$$--;--%***$$$$$$$$$$$$%%%$$$$&$$%&&&&&O&&O&&&&&OOO&&$*$$&O&&$%*%$**$o%$&OOO&$**--****-=%%*=%%%%$&+*%$%$%%+%%*%*---;-;---=--=--***-****===*%*+==#@ooo@o@o@o@@@&@ooo@XooXXX..                                         \n"
"                                          O&$%-;-*%$--*$$$$$$$$$$$$-%$%%$$&&$&&&&&&&&&&&&OO&&&O&&%%*&&&%*$*$&%$$$%%O$%OO+%***--*=**-****---=*$%%%+&%$%**%**--;-----=-=---------%@%****:*%%==+o@Ooo@oo@@oo@o@o@oooXoX..                                          \n"
"                                          .O$$%---*%%%*$$$$%$$$$$%$$$$$%$$$$&&&$&&&&O&&&O&&&$O&OO&O&&O$--%*=&&%%&O&&%$*%%%&&&$%--=*$$%$%$$%%-%+=%&+$*=---------;-;------*-**--*$&$$$++*+:+**%+++@++%+ooo@o@&ooo@oo..                                            \n"
"                                          ..X&$%----$%$$$$$%*%$$$$%%$$%$$$$$$$$$&&&&&&&$&&&&$&&$$&OO&&O%-**%&%%%$$O&&=**%&&+%$***%*%%$$$$$%%%**%%$$$%%%**-*=-------=-*=--**--=*$$$$$$++%%:%++$+%*%:%+$@@ooo@ooooXX.                                             \n"
"                                            .o&$%---**%$$$$$$%$$$$$%%%%%$%&&$$$$&&&&&&&&&&&&&&&&$&O&OOO&%*=*%%%&&OO%%$%=%$$$%*-$$*--**%$%*%%*--=%+&%%*--=--=-*-***-----=-*--**=%%%$%%*+++*+%%++++$+@+&oo@o@o@ooX...                                             \n"
"                                             .o&$%----*$%$$%$%$$$%$$$%$$$$%&&&$%$&&&&&$%&$&&&&&OOO&O&&O&&$%*&$*%%&&+&&$&+&%$%$*-*$%*=%%%*%%**%****%*=----=-=%%*--*--------*-----****===++++++++++$&@@@$@&ooooooX..                                              \n"
"                                              .O$%%---*%$$%$$$$$$$$$$$$$%$$&$$$$%%&&*%$$$%&$&&$&&&&&&O&&&&O&&&%%*$%&o&&$%%&o&%--=***=*=-=%*$%%%%*=-----=-%%$$$%------------------=-***-=++&++++++@$+$+@@$@@oooXX..                                              \n"
"                                               .$$$*---*%$$%%%**$$$$$$$$$$*$$$$$$&&$$$*%-*%*$&%$&&O&&&O&&O&&&OO&$%$$&O&&$&&$$%*---;--;---**-%*-*-*------$$$$%*----------------------**--$%+++++++++%++&@oo+@oo..                                                \n"
"                                                OO$$*-;-*%%$$**%-%$$$$$$$$%$$$$*$&$$&$$$$$$$&&$$&&&&&$$&&&&O&&&O$$%*%%&O&%%%*$**-;;;-***%--------------*$%%---------------*----*--*-****%%+%%:%+++:%++ooo+&oX...                                                \n"
"                                                 .O&$*-;-*%$%$$$%$$$$$$$$$%$*-*%$$*$$$*$$$%%&$$%&&&&&&$&&&$$&&O&$$$%$$OO$$%**-*-*------*--*---*--**-**%%*----%%*--;----------*-*-**-**%%%%%**%%:%+*++o++%+oX..                                                  \n"
"                                                  Xo&$%--;-$$$$$$$%$%$%$%%$$$$%$%%%$*%%$$-*%$%$*&&&&&&&&&&$$&&&&$$&O&O&&$*%**%*$*%**---*%*%%%%%%%*-*%%***--%%----;-------*-------*-*-*-%%%%%%*%%+%++o+%%+oo..                                                   \n"
"                                                   .X&$%----*%$$%$$$$*%$%*$$$$$$*-$$**%*$%-%**%*$%$%%%%&&$%***$$%%%$&&$%******%%%*%--**%%%%%%%%%*%$$%*-*=**-*----------*-------*-*---*****%$%%%:+%++%%++oX..                                                    \n"
"                                                   ..X&$$----**%$%$%$%$$$%-%$$$$$$$%$%$*$%%$$$$*$%*$&$%**%$***%%$$%%**$*%%$$%%--*-**-***%%%$$$%*%%*%*----**---------**--**--*------**---**%%$+%++++*%%+o...                                                     \n"
"                                                     .X&$$*----%%$%$%$$$$$$$$$%%%%$%*$$%%$-$**%%$-%%*---*****%%**%%***-****%*-------*%*%***%%*-**%%*--*%$$%*---*-*-*--***-******-**--*-*=*%%%+%%%+%+%oo...                                                      \n"
"                                                       .$$$%----**%$%*%%$$$$$$$$$%$%$%%$%*$$$$$*%$%%$*$$-**-%-*-*-%%%%*-*--*--------*-----*--*--*%$%**-%%*-=*--*-----*-***-****%%%%%*%%-****%%:+%*%+oOX..                                                       \n"
"                                                       .OO&$$*-------%*$$$$$$$%-%$$$$$*%%$%%$$$$$%$$*%*$%*%*%****-****---------------*---*%%%%*-%$$$%%%%**------***-*-***--*****%**%*%%%**%%*++%%++oX...                                                        \n"
"                                                        .XOo$$$---;;;-*%%**$$$$$%%%%$$$$%%$$%$%$$$$*$%$***%%*%%%-%%-%-**------;-;-----------*%%**%*%%%%$$%*-**-------*-*****************%%%%++%%+oo...                                                          \n"
"                                                          .X&$$$*-;;;;;----*%*$$$$%%%$$$$$%$$%$%%%%$$$%%*$%**%%*%%%%***-------------**%%%%%*---*-****%%%%%**-*-**--**-*--*-*************%%%++%%ooOO..                                                           \n"
"                                                           ..O$$$%*;;-;;;---**%$$$%%$%$%$$$$$$$$$$$%%$%%%%*$%%%**%*%*---------*-------*-***%%*%%*%%**-****%$%$%*%%**-*-**************%%%%%+%++@ooX.                                                             \n"
"                                                            ..X&$$$%----;;;--**$$$$$$%%%%%$%%$$$$$$$$$$$$%%*%**%%$%%*--**----------*--%%***----*%%$$$$%$%***%%*%%**--*-**-*-*****%****%%%%+++OoO...                                                             \n"
"                                                               XO&$%%*---;;;----*%$$$$$$$$%$$$$$%$%$%$$$%%$%%**%%%%%%-----**%%**%%%%%%***---*-*-*--*****%%%%**%*******************%*%%%%:++&oOO..                                                               \n"
"                                                                XX&$$%**---;;-***-*%$$$$$$$$$$$%%******--*%%%$%$%$%%**********%%$$$%$%$$$$$$$$$%%*$*%$$%$$$$%%%$%********%%*****%%%%%%%+++&oX...                                                                \n"
"                                                                 .X$$$%**-------*----%$$$$$$$$$%*****-**-------*-********%******-*-***--*********%**%%%$%%%%%%$%%****-*-*****%*%%%%+%%$+&oo...                                                                  \n"
"                                                                   .OO&$%**-----**%%**%%$%$$$$%*%---*****---*---*-*-*-*-*****-*******-%***%%$%%%%$$%$$%%**%*********-***-****%%%$@$+$+$@o.X.                                                                    \n"
"                                                                    .Xo&$%***---*%%$$$$%%$$%%*********%%%%$*%%$%%%%***%**%--%$%%%%---%%%%**%%%&$$$$$$$$***-****-*--****-****%+&$$&&O+&ooO..                                                                     \n"
"                                                                      ..OO$%***-*%%%%%%$%$%$%*-*%$%$$%%%%%%$$$$%$$$%%$$$%%%$$$$%$$$$$&$$$$&$$$$$$$$%%%%%%**-******-*******%%$$$&&o&$oXXX.                                                                       \n"
"                                                                        .O&&$%****%$$$%-*%$%$%$$%$$$%%%*-%$$$$$$$%$$$$$$$$$$$$$$$$&&$$$$%$$%$$%%%%**%-***--*-**--***-*-%**%$%$o&o&@oO...                                                                        \n"
"                                                                         ..OO&$%**%%%$$%$%%%$$$$$%$$$%***-$%$%%$$%**$$$$$$$$$$%$$$$$$$$$%$%*%%***--*---**********-*-=*=*%$%%%&&oooOX..                                                                          \n"
"                                                                            .Xo&$$*%%%%*%%$$%%$$$$%%$$$%%---**%%$$$%%%%%$$$$%%$%$$$$$$%%$%$$%%%%%*********--***********%%%$$&OoXo...                                                                            \n"
"                                                                             ..O&&&$%*****%$$$$$$$$$$$$%%*%*-***%$$$%$%$%$$$$$$%$$$$$%%$%%%$%$%%$%%*%*%*******-*-******%%$$&OOO...                                                                              \n"
"                                                                                OO&$$$$*%*%%%%$$%%$%%$%%$%$$%*%%***%$$$%%$$%%$%$$$$$%$%%%$%%$%%%$$$$$****-**%%*******%%%$$&&XX..                                                                                \n"
"                                                                                 ...OO&$$%*%%$$$$$$%%%$$%%$%**%$%--*$$%$$%**$$$$$$%%%%%%$$%$$%$$&&+$$%%**$$$$%$$$%%%+%$&O.OX..                                                                                  \n"
"                                                                                    ..XOo$$%%%%$$$$$%%%*$%%%%**$*---%**%$$%%**%%$%$$%%%%*%%$$$$%&&&&$$$$$$$$$&$$+$&$&OOX...                                                                                     \n"
"                                                                                       ..XO&&$%%**$$$%$%*%%%**--*%%*--*-%$$$$$*$%%%$%$$$$%%%%$$$$$$&&&$$$$$$$%%%$$OOXX...                                                                                       \n"
"                                                                                         ...OO&o$$%**%%*%%%**-****%%$***--*-*---*%%%$$%$$$$%%%$$$$$$%%%%%%*%%%$&OoOX..                                                                                          \n"
"                                                                                           ....OOOo&$%%*****%**%******%$%%%$$%*-**-*%$$$$%$$$%$%%%$%%%%%%%$OOOOX...                                                                                             \n"
"                                                                                              . ..XO$&&$$$%%**%**%%%*****$%%%%%%%%%%%*%**%*%%%%%%%%%%$$oOOooX....                                                                                               \n"
"                                                                                                   ...OOOOO&$$$$$%%****%**%%%*%%%%*%%*%%%%%$%$$$$&oOoOOo....                                                                                                    \n"
"                                                                                                      .....OO&&&&$&$$$$$$%$%%$%%$$$%$$$$$&&&&&&OXOXO... .                                                                                                       \n"
"                                                                                                           . ....OXO.OoOOoOoO&oOOOOOOoOOoOOOX..... .                                                                                                            \n"
"                                                                                                                   . ......X....XX..X..... . .                                                                                                                  \n"
"                                                                                                                           ..    . .                                                                                                                            \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
"                                                                                                                                                                                                                                                                \n"
;
}
@end

