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

static int numberOfRows = 6;
static int numberOfColumns = 4;

static unsigned char *iconCalculatorName = "Calculator";
static unsigned char *iconCalculatorPalette =
". #000000\n"
"X #5555AA\n"
"o #55AAAA\n"
"O #868A8E\n"
"+ #ffffff\n"
;
static unsigned char *iconCalculatorPixels =
" ...........................   \n"
"..XXXXXXXXXXXXXXXXXXXXXXXXXX.  \n"
".XoooooooooooooooooooooooooX.O \n"
".Xooo...............oooooooX.OO\n"
".Xooo.+++++++++++++.oooooooX.OO\n"
".Xooo.+++++++++++++.oooooooX.OO\n"
".Xooo...............oooooooX.OO\n"
".XoooooooooooooooooooooooooX.OO\n"
".Xooo...o...o...o...o...oooX.OO\n"
".Xooo.+.o.+.o.+.o.+.o.+.oooX.OO\n"
".Xooo...o...o...o...o...oooX.OO\n"
".XoooooooooooooooooooooooooX.OO\n"
".Xooo...o...o...o...o...oooX.OO\n"
".Xooo.+.o.+.o.+.o.+.o.+.oooX.OO\n"
".Xooo...o...o...o...o...oooX.OO\n"
".XoooooooooooooooooooooooooX.OO\n"
".Xooo...o...o...o........ooX.OO\n"
".Xooo.+.o.+.o.+.o.++++++.ooX.OO\n"
".Xooo...o...o...o........ooX.OO\n"
".XoooooooooooooooooooooooooX.OO\n"
".XXXXXXXXXXXXXXXXXXXXXXXXXX..OO\n"
" ...........................OOO\n"
"  OOOOOOOOOOOOOOOOOOOOOOOOOOOOO\n"
"    OOOOOOOOOOOOOOOOOOOOOOOOOO \n"
;
static unsigned char *iconCalendarName = "Calendar";
static unsigned char *iconCalendarPalette =
". #000000\n"
"X #ffffff\n"
"o #868A8E\n"
"O #AA0055\n"
;
static unsigned char *iconCalendarPixels =
"..............................  \n"
"..............................  \n"
"...X.XXXXXXXXX..XXXXXXXXX.X...oo\n"
"..X.XXXXXXXXXX..XXXXXXXXXX.X..oo\n"
"..X.XXXXOOXXXX..XXXXOOOXXX.X..oo\n"
"..X.XXXOOOXXX.XX.XXOOOOOXX.X..oo\n"
"..X.XXXOOOXXX....XXOOXOOXX.X..oo\n"
"..X.XXXXOOXXXX..XXXXXOOOXX.X..oo\n"
"..X.XXXXOOXXXX..XXXXOOOXXX.X..oo\n"
"..X.XXXXOOXXXX..XXXOOOXXXX.X..oo\n"
"..X.XXXXOOXXXX..XXXOOXXXXX.X..oo\n"
"..X.XXXOOOOXXX..XXXOOOOOXX.X..oo\n"
"..X.XXXOOOOXXX..XXXOOOOOXX.X..oo\n"
"..X.XXXXXXXXXX..XXXXXXXXXX.X..oo\n"
"..X.XXXXXXXXXX..XXXXXXXXXX.X..oo\n"
"..X.X.......XX..XX.......X.X..oo\n"
"..X.XXXXXXXXX.XX.XXXXXXXXX.X..oo\n"
"..X.X.......X....X.......X.X..oo\n"
"..X.XXXXXXXXXX..XXXXXXXXXX.X..oo\n"
"..X.XXXXXXXXXX..XXXXXXXXXX.X..oo\n"
"...X.XXXXXXXXX..XXXXXXXXX.X...oo\n"
"..............................oo\n"
"..............................oo\n"
"  oooooooooooooooooooooooooooooo\n"
"  oooooooooooooooooooooooooooooo\n"
;
static unsigned char *iconCameraName = "Camera";
static unsigned char *iconCameraPalette =
". #000000\n"
"X #ffffff\n"
"o #C3C7CB\n"
"O #868A8E\n"
"+ #ffff00\n"
;
static unsigned char *iconCameraPixels =
".                              \n"
".. ......... .......           \n"
".X.ooooooooo.OOOOOOO.      .   \n"
".X.ooooooooo..........    .X.  \n"
".. ..........oooooooo.....XX.O \n"
".  .O.ooooooooooooooo.o.o.XX.OO\n"
"   .O.ooooooooooooooo.o.o.XX.OO\n"
"   .O.ooooooooooooooo.o.o.XX.OO\n"
"   .O.ooooooooooooooo.o.o.XX.OO\n"
"   .O.ooooooooooooooo.o.o.XX.OO\n"
"   .O.ooooooooooooooo.....XX.OO\n"
"    ..o..ooooo.o.o.oo.OOOO.X.OO\n"
"     .ooooooooooooooo.OOOOO.OOO\n"
"      ...............OOO    OO \n"
"       OOOOOOOOOOOOOOOOO       \n"
"        OOOOOOOOOOOOOOO        \n"
"    ...............            \n"
"    .+X+X+X+X+X+X+.O           \n"
"    .X+X+X+X+X+X+X.OO          \n"
"    .+X+X...............       \n"
"    .X+.+.+X+X+X+X+X+X+.O      \n"
"    .+.X..X+X+X+X+X+X+X.OO     \n"
"    .X+.+.+X.X+X+X+X.X+.OO     \n"
"    .+X+X.X.X.X...X.X.X.OO     \n"
"    .X+X+.+X.X+X+X+X.X+.OO     \n"
"    ......X+X+X+X+X+X+X.OO     \n"
"     OOOO.+X+X+X+X+X+X+.OO     \n"
"      OOO.X+X+X+X+X+X+X.OO     \n"
"         ...............OO     \n"
"          OOOOOOOOOOOOOOOO     \n"
"           OOOOOOOOOOOOOOO     \n"
;
static unsigned char *iconClockName = "Clock";
static unsigned char *iconClockPalette =
". #000000\n"
"X #ff0000\n"
"o #AA0055\n"
"O #C3C7CB\n"
"+ #ffffff\n"
;
static unsigned char *iconClockPixels =
" .............................. \n"
".XXXXXXXXXXXXXXXXXXXXXXXXXXXXXo.\n"
".XoooooooooooooooooooooooooooXo.\n"
".Xo..........................Xo.\n"
".Xo.OOOOOOOOOOOOOOOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOO+.OOOOOOOOOOOoXo.\n"
".Xo.OOOOOO+.OOO..OOO+.OOOOOOoXo.\n"
".Xo.OOOOOO..OOOOOOOO..OOOOOOoXo.\n"
".Xo.OOOOOOOOOOOOOOOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOOO.OOOOOOOOOOOoXo.\n"
".Xo.OO+.OOOOOOOO.OOOOOOO+.OOoXo.\n"
".Xo.OO..OOOOOOOO.OOOOOOO..OOoXo.\n"
".Xo.OOOOOOOOOOOO.OOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOOO.OOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOOO.O.OOOOOOOOOoXo.\n"
".Xo.O+.OOOOOOOOO..OOOOOOO+.OoXo.\n"
".Xo.O..OOOOOOO.........OO..OoXo.\n"
".Xo.OOOOOOOOOOO..OOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOO.O.OOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOO.OO.OOOOOOOOOOOoXo.\n"
".Xo.OO+.OOOOOOOOOOOOOOOO+.OOoXo.\n"
".Xo.OO..OOOOOOOOOOOOOOOO..OOoXo.\n"
".Xo.OOOOOOOOOOOOOOOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOOOOOOOOOOOOOOOoXo.\n"
".Xo.OOOOOO+.OOOOOOOO+.OOOOOOoXo.\n"
".Xo.OOOOOO..OOO+.OOO..OOOOOOoXo.\n"
".Xo.OOOOOOOOOOO..OOOOOOOOOOOoXo.\n"
".Xo.OOOOOOOOOOOOOOOOOOOOOOOOoXo.\n"
".Xo.oooooooooooooooooooooooooXo.\n"
".XXXXXXXXXXXXXXXXXXXXXXXXXXXXXo.\n"
".oooooooooooooooooooooooooooooo.\n"
" .............................. \n"
;
static unsigned char *iconContactsName = "Contacts";
static unsigned char *iconContactsPalette =
"w #ffffff\n"
". #000000\n"
"X #5555AA\n"
"o #0000ff\n"
"O #868A8E\n"
;
static unsigned char *iconContactsPixels =
"           ... XXX ..........   \n"
"          .wwwooooowwwwwwwwww.  \n"
"         ..........wXXXw...ww.OO\n"
"        .wwwwwwwwwwooooowww.w.OO\n"
"       ......wXXXw.......ww.w.OO\n"
"      .wwwwwwooooowwwwwww.w.w.OO\n"
"     ..wXXXw...........ww.w.w.OO\n"
"    .wwooooowwwwwwwwwww.w.w.w.OO\n"
"   ..................ww.w.w.w.OO\n"
"  .wwwwwwwwwwwwwwwwww.w.w.w.w.OO\n"
"  .ww..........wwwwww.w.w.w.w.OO\n"
"  .wwwwwwwwwwwwwwwwww.w.w.w.w.OO\n"
"  .ww...........wwwww.w.w.w.w.OO\n"
"  .wwwwwwwwwwwwwwwwww.w.w.w.oXOO\n"
"  .ww.........wwwwwww.w.w.w.XOOO\n"
"  .wwwwwwwwwwwwwwwwww.w.w.oXOOOO\n"
"  .wwwwwwwwwwwwwwwwww.w.w.XOOOO \n"
" XXXXXXXXXXXXXXXX.www.w.oXOOOO  \n"
".oooooooooooooooo.Xww.w.XOOOO   \n"
"..................XXw.oXOOOO    \n"
"  ooooooooooooooooooooXOOOO     \n"
"   XXXXXXXXXXXXXXXXXXXOOOO      \n"
"    OOOOOOOOOOOOOOOOOOOOO       \n"
"     OOOOOOOOOOOOOOOOOOO        \n"
;
static unsigned char *iconGameCenterName = "GameCenter";
static unsigned char *iconGameCenterPalette =
". #000000\n"
"X #ffffff\n"
"o #868A8E\n"
"O #AA0055\n"
"+ #C3C7CB\n"
"@ #5555AA\n"
;
static unsigned char *iconGameCenterPixels =
"     ...........        \n"
"    .XXXXXXXXXXX..      \n"
"    .XXXXXXXXXXXXX.     \n"
"     ...............    \n"
"      .XXXXXXXXXXXX.o   \n"
"    ............XXX.oo  \n"
"   .XXXXXXXXXXXX.XX.oo  \n"
"   .XXOXXXXXXOXX.XX.oo  \n"
"   .XOOOXXXXOOOX.XX.oo  \n"
"   .XOOOXXXXOOOX.X..oo  \n"
"   .XXOXXXXXXOXX..++.o  \n"
"  ......XX.......++++.  \n"
" ..++++.XX.+++++..++.oo \n"
".+.+...+..+....+.+..oooo\n"
".+.+.@@@@@@@@@.+.++.ooo \n"
" ..+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+.@@@@@@@@@.+.++.oo  \n"
"  .+...........+.+.ooo  \n"
"  .+++++++++++++..ooo   \n"
"  ...............ooo    \n"
"    ooooooooooooooo     \n"
"    oooooooooooooo      \n"
;
static unsigned char *iconMailName = "Mail";
static unsigned char *iconMailPalette =
"b #000000\n"
"X #5555AA\n"
"o #ffffff\n"
"O #C3C7CB\n"
"+ #868A8E\n"
;
static unsigned char *iconMailPixels =
"                             b  \n"
"                            bX  \n"
"                           bXX  \n"
"                          bXXo  \n"
"                         bXXoXX \n"
"                        bXXoXXX \n"
"                       bXXoXXXX \n"
"                       bXXXXXXX \n"
"                      bbbXXXXXXX\n"
"                     bbobbXXXXXX\n"
"                    bbobbbbXXXXX\n"
"                    bobbbbbbXXXX\n"
"                   bObbbbbbbbXXb\n"
"                  boOObbbbbbbbb+\n"
"                 boOOOObbbbbb+++\n"
"                boOOOOOObbbb+++ \n"
"               boOOOOOOOObb+++  \n"
"bb            boOOOOOOOOb++++   \n"
"bbb          boOOOOOOOOb+++     \n"
"bbbb        boOOOOOOOOb+++      \n"
"bbbbb      boOOOOOOOOb+++       \n"
"bb bbb    boObbbbbbbb+++        \n"
"bb  bbb  bobb++++++++++         \n"
"bb   bbbbbbO++++++++++          \n"
"bb    bbbOO++++                 \n"
"bb   bbbbb+++                   \n"
"bb bbbb bbb                     \n"
"bbbbb    bb                     \n"
"bbb                             \n"
"bb                              \n"
"bb                              \n"
"bb                              \n"
;
static unsigned char *iconMessagesName = "Messages";
static unsigned char *iconMessagesPalette =
". #000000\n"
"X #ffff00\n"
"o #ffffff\n"
"O #00ffff\n"
;
static unsigned char *iconMessagesPixels =
"       .....                   \n"
"     .....XX.                  \n"
"    .....XXXX.  ..             \n"
"   .....XX..XX..XX.            \n"
"   ....XX.XXXXXXXX.            \n"
"  ....XXX.XXXXXXX.             \n"
" ....XXXXXXXXXXXX.             \n"
" ....XXXXXXXXXXXXX.            \n"
"....XXXXXXXXXXXXXXX.   ..      \n"
"....XXXXXXXXXXX....   .oo.     \n"
"....XXXXXXXXXX.      . ..      \n"
".....XXXXXXXX.                 \n"
"......XXXXXX.               .. \n"
" ....XXXXXXX.             ..oo.\n"
"  ....XXXXXX.        .      .. \n"
"  .....XXXXXX.        ..       \n"
"   .....XXXXXX.    .. .o.      \n"
"    ....XXXXXXX....X.  ..      \n"
"     ..XXXXXXXXXXXXX.          \n"
"       ...XXX..XXX..      .    \n"
"          .X.  ...       .X.   \n"
"          .X.           .X.    \n"
"          .X..         .X.     \n"
"          .XXX.       .X.      \n"
"          .X..       .XXX.     \n"
"          .X.       .XXXXX.    \n"
"        .....      .O.XXXX.    \n"
"       .OOOOO..  ..OOO.XX.     \n"
"      .OOOOOOOO..OOOOOO..      \n"
"     .OOOOOOOO..OOOOOO.        \n"
"     .OOOOOOOOOOOOOOO.         \n"
"     ................          \n"
;
static unsigned char *iconMusicName = "Music";
static unsigned char *iconMusicPalette =
". #000000\n"
"X #868A8E\n"
"o #ffff00\n"
"O #C3C7CB\n"
"+ #ffffff\n"
;
static unsigned char *iconMusicPixels =
"          ..                   \n"
"          .        .X          \n"
"          .       .X           \n"
" ..       .      ..X           \n"
" .       ..     .o.X           \n"
" .             .oo.X           \n"
" .     ..     .ooo.X           \n"
" .   .. .    .oooo.X           \n"
"..   .  .   .ooooo.X           \n"
".    .  .  .oooooo.X           \n"
"     .  . .ooooooo.X           \n"
"     . . .ooooooooo.           \n"
"    .   .oooooooooo.X          \n"
"    .  .oooooooooooo.X         \n"
"      .oooooooooooooo.X        \n"
"     ........oooooooo.X        \n"
"    .        ....ooooo.X       \n"
"                 ...ooo.X      \n"
"                    ..oo.X     \n"
"                      .oo..    \n"
"                      .oo.X    \n"
"                     .ooo.X    \n"
"         ............ooo.X     \n"
"        .oooooooooooooo.X      \n"
" ............................. \n"
" .OOOOOOOOOOOOOOOOOOOOOOOOOOO.X\n"
" .OOO...OOO...OOOOOOOOOOOOOOO.X\n"
" .OOOOOOOOO...OOOOOOOOOOOOOOO.X\n"
" .OOO...OOO...OOOOOOOOOOOOOOO.X\n"
" .OOOOOOOOOOOOOOOOOOOOOOOOOOO.X\n"
" .............................X\n"
"  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n"
;
static unsigned char *iconNotesName = "Notes";
static unsigned char *iconNotesPalette =
". #000000\n"
"X #ffffff\n"
"o #55AAAA\n"
"O #868A8E\n"
;
static unsigned char *iconNotesPixels =
"          ..X..X..X..X..X..     \n"
"         .X..X..X..X..X..X....  \n"
"        .o.oo.oo.oo.oo.oo.oo..  \n"
"        .ooooooooooooooooooo..OO\n"
"       .ooooooooooooooooooo.X.OO\n"
"       .ooooooooooooooooooo.X.OO\n"
"      .ooooooooooooooooooo.XX.OO\n"
"      .oooo...........oooo.XX.OO\n"
"     .ooooooooooooooooooo.XXX.OO\n"
"     .ooo...........ooooo.XXX.OO\n"
"    .ooooooooooooooooooo.OOOO.OO\n"
"    .ooooooooooooooooooo.XXXX.OO\n"
"   .ooooooooooooooooooo.XXXXX.OO\n"
"   .ooooooooooooooooooo.OOOOO.OO\n"
"  .ooooooooooooooooooo.XXXXXX.OO\n"
"  .ooooooooooooooooooo.XXXXXX.OO\n"
" .ooooooooooooooooooo.OOOOOOO.OO\n"
" .ooooooooooooooooooo.XXXXXXX.OO\n"
".ooooooooooooooooooo.XXXXXXXX.OO\n"
".ooooooooooooooooooo.OOOOOOOO.OO\n"
".ooooooooooooooooo..XXXXXXXXX.OO\n"
" .................XXXXXXXXXXX.OO\n"
"         .OOOOOOOOOOOOOOOOOOO.OO\n"
"         .XXXXXXXXXXXXXXXXXXX.OO\n"
"         .XXXXXXXXXXXXXXXXXXX.OO\n"
"         .OOOOOOOOOOOOOOOOOOO.OO\n"
"         .XXXXXXXXXXXXXXXXXXX.OO\n"
"         .XXXXXXXXXXXXXXXXXXX.OO\n"
"          ...................OOO\n"
"           OOOOOOOOOOOOOOOOOOOOO\n"
"            OOOOOOOOOOOOOOOOOOO \n"
;
static unsigned char *iconPhotosName = "Photos";
static unsigned char *iconPhotosPalette =
". #000000\n"
"X #ffff00\n"
"o #ffffff\n"
"O #5555AA\n"
"+ #00ff00\n"
"@ #C3C7CB\n"
"# #ff0000\n"
"$ #868A8E\n"
"% #0000ff\n"
"m #ff00ff\n"
;
static unsigned char *iconPhotosPixels =
"        .......                 \n"
"      ..XoXoXoX..               \n"
"    ..oXoXoXoXoXo.              \n"
"   ..oXoXoXoXoXoXo.           . \n"
"  ..oXoXmmmmmmoXoXo.          ..\n"
"  .oXoXoXmmmmmmmXoX.          ..\n"
" .oXoXoXmmmmmmmmoXoX.        .o.\n"
" .XoXoXoXmmmmmmmmoXo.       .o..\n"
" .oXoXoXoXmmmmmmmXoXo.      ....\n"
".oXoXoXoXoXommmmXoXoXo.    O... \n"
".XoXo+++oXoXoXoXoXoXoXo.  OoO   \n"
".oXo++++++XoXoXoXoXoXoXo.OoO    \n"
".XoX+++++++XoXoXoXoXoXoXOoO.    \n"
".oX++++++++oXoXoXoXoXoXOOOXo.   \n"
".Xo++++++XoXoXoXoXo...OOOXoXo.  \n"
".oXo++++XoXoXoXoXo.@@OOO.oXoX.  \n"
".XoXoXoXoXoXoXoXoX.@OOO@.XoXoX. \n"
".oXoXoXo###oXoXoXo.OOO@@.oXoXo. \n"
".XoXoXo#####oXoXoXo.O@@.oXoXoX.$\n"
" .XoXo######XoXoXoXo...oXoXoXo.$\n"
" .oXoX#######XoXoXoXoXoXoXoXoX.$\n"
" .XoXo########XoXoXoXoXoXoXoXo.$\n"
"  .XoXo######XoXo%%%oXoXoXoXoX.$\n"
"  .oXoXo###oXoX%%%%%%%XoXoXoXo.$\n"
"   .oXoXoXoXoX%%%%%%%%%XoXoXoX.$\n"
"    .oXoXoXoXo%%%%%%%%%oXoXoX.$$\n"
"    ..oXoXoXoX%%%%%%%%oXoXoXo.$ \n"
"     ..oXoXoXoX%%%%%XoXoXoXo.$  \n"
"      $..XoXoXoXoXoXoXoXoX..$   \n"
"       .....XoXoXoXoXoXo..$$    \n"
"      ..$$$$............$$$     \n"
"           $$$$$$$$$$$$$$       \n"
;
static unsigned char *iconSafariName = "Safari";
static unsigned char *iconSafariPalette =
". #868A8E\n"
"X #000000\n"
"o #00AA55\n"
"O #55AAAA\n"
"+ #00ffff\n"
"@ #ffffff\n"
"# #C3C7CB\n"
"$ #AA55AA\n"
;
static unsigned char *iconSafariPixels =
"           .XXXXXXX.           \n"
"         XX.ooO+++O.XX         \n"
"       XX+@oo#oooO+oooXX       \n"
"      X@+@+oO+ooooooooooX      \n"
"     X@+@+@+O+oooooooooooX     \n"
"    X@+@o@+o+oooooooooooo.X    \n"
"   X@+o+o+ooooooooooooooooOX   \n"
"  X@+@+@+oooooooooooooooo.oOX  \n"
"  X+@+@+ooooooOOoOOoO+ooooOoX  \n"
" X+@+@+++ooO#O+#oO++O+oooooOoX \n"
" X@+@+oooOO++Oo+ooooooooooOo.X \n"
"..+@+@ooO+++++#+++#oO+oooooOoOX\n"
"X+@+@+OO#+ooo+++oooooO++OOOoOoX\n"
"X@+@+@++oooooooooO+oooOO+#OOoOX\n"
"X+@+@+#oooooooooooO+ooO+#+#OOoX\n"
"X@+@++oooooooooooooO#$+#+##Oo.X\n"
"X+@+@+ooooooooooooooO#O+###Oo.X\n"
"X@+@++oooooooooooooooOO#+###..X\n"
"X+@+@+ooooooooooooooooO+###...X\n"
"..+@+++OOOOOoooooooooO+#+#.#..X\n"
" Xo++++++++OooooooooO+###.#..X \n"
" Xoo++++++++oooooooO+#+###.#.X \n"
"  Xo++++++++oooooooO###.#.#.X  \n"
"  X+++++++++OooooooO+#o#.#..X  \n"
"   X++++++++ooooooOO##o.#..X   \n"
"    X+++++++oooooOO#.o.#..X    \n"
"     X+#+#+#OoOoOO#.#.#..X     \n"
"      X+#+#+#OoO.#.#.#..X      \n"
"       XX#.#..OO......XX       \n"
"         XX.........XX         \n"
"           .XXXXXXX.           \n"
;
static unsigned char *iconSettingsName = "Settings";
static unsigned char *iconSettingsPalette =
". #000000\n"
"X #C3C7CB\n"
"o #868A8E\n"
"O #ffffff\n"
"+ #ff00ff\n"
"@ #ffff00\n"
"# #00ffff\n"
;
static unsigned char *iconSettingsPixels =
"   ......                       \n"
"  .XXXXoo.                      \n"
" .OOOOOOXo.................     \n"
".OOOO.OOOo.XXXXXXXXXXXXXXOo.    \n"
".OOOO.OOO.OOOOOOOOOOOOOOOoo.    \n"
".OOOO.OO.XXXXXXXXXXXXXXXXoo.    \n"
".O.....O.XXooooooooooooXXoo.    \n"
".OOOO.OO.Xo............OXoo.    \n"
".OOOOOOO.Xo.+++++++.++.OXoo.    \n"
" .OOOOOO.Xo.++++++..++.OXoo.    \n"
"  .OOOOo.Xo.@@@@@.@.@@.OXoo.    \n"
"   ......Xo.@@@@....@@.OXoo.    \n"
"        .Xo.@@@.@@@.@@.OXoo.    \n"
"        .Xo.#...##...#.OXoo.    \n"
"        .Xo.##########.OXoo.    \n"
"        .Xo............OXoo.    \n"
"       ..XXOOOOOOOOOOOOXXoo.... \n"
"      .X.XXXXXXXXXXXXXXXXo.ooXo.\n"
"     .XXo.................ooXoo.\n"
"    .XXXXXXXXXXXXXXXXXXXXXXXooo.\n"
"   .OOOOOOOOOOOOOOOOOOOOOOOoooo.\n"
"   .OXXXXXXXXXXXXXXXXXXXXXXoooo.\n"
"   .o.Xo.Xo.Xo.Xo.Xo.Xo.XXXoooo.\n"
"   .Oo.Oo.Oo.Oo.Oo.Oo.Oo....... \n"
"  .Oo.Oo.Oo.Oo.Oo.Oo.Oo.OOO.OO..\n"
" .Oo.oo.oo.oo.oo.oo.oo........o.\n"
".OOOOOOOOOOOOOOOOOOOO.OOOOOOO.o.\n"
".XXXXXXXXXXXXXXXXXXX.OOOOOOO.oo.\n"
".....................XOOOOoooo. \n"
"                    .oooooooo.  \n"
"                    .XXXXXo..   \n"
"                     ......     \n"
;
static unsigned char *iconVideosName = "Videos";
static unsigned char *iconVideosPalette =
". #000000\n"
"X #AAAA55\n"
"o #ffffff\n"
"O #868A8E\n"
;
static unsigned char *iconVideosPixels =
"        ...........            \n"
"    ....Xooo.X.oooX....        \n"
"  ..Xoo......X......ooX..      \n"
" .Xoo..OOO...X...OOO..ooX.     \n"
"............XXX............    \n"
".XXXXXXXXX.XX.XX.XXXXXXXXX.    \n"
"............XXX............    \n"
" .Xoo..OOO...X...OOO..ooX...   \n"
" ...Xoo......X......ooX......  \n"
".o.O.....Xoo.X.oooX....O.o.o.  \n"
".o..OOOO...........OOOO..o.Oo. \n"
" .oo....OOOOOOOOOOO....oo...O. \n"
"  ..oooo...........oooo..OOO..O\n"
"  OO....ooooooooooo....OOOOO..O\n"
"   OOOOO...........OOOOOOOo.O.O\n"
"     OOOOOOOOOOOOOOOOOOOoo..o.O\n"
"         OOOOOOOOOOOO   ..OO..O\n"
"                       .OOooO.O\n"
"                     ..OoooOO.O\n"
"                   ..OO.ooOO.OO\n"
"                 ..OOooo.OO.OO \n"
"               ..OOoooooO..OO  \n"
"                .OoooooOO.OO   \n"
"                 .ooooOO.OO    \n"
"                  .ooOO.OO     \n"
"                   .OO.OO      \n"
"                    .. Oo      \n"
;
static unsigned char *iconVoiceMemoName = "VoiceMemo";
static unsigned char *iconVoiceMemoPalette =
"w #ffffff\n"
". #000000\n"
"X #00ffff\n"
"o #C3C7CB\n"
"O #55AAAA\n"
"+ #868A8E\n"
;
static unsigned char *iconVoiceMemoPixels =
"                     .....    \n"
"                   . .X.X..   \n"
"                    .ooOoO+.  \n"
"                  ..o.o.O.O.. \n"
"                  .Xoo.o+O++. \n"
"                  ..O.o.o.+..+\n"
"                  .XoO+o.o++.+\n"
"                  ..O.O.o.o..+\n"
"                 .X.+O+++o.+++\n"
"                .woO..+.+.+.++\n"
"               .XoO+O.....+++ \n"
"              .woO+O.++++++++ \n"
"             .XoO+O.+++++++   \n"
"            .wo....+++        \n"
"           .Xo....+++         \n"
"          .wo.....++          \n"
"         .Xo......+           \n"
"        .woO.......           \n"
"       .XoO+...........       \n"
"      .woO+O.+++...+.+..      \n"
"      .oO+O.+++  .+++++..     \n"
"     .+.+O.+++   ..+.+.+.+    \n"
"     .++..+++    .+++++..++   \n"
"    .+..++++     ..+.+.+.++   \n"
"   .+.+++++       ..+.+.+++   \n"
"   ..++++          ....++++   \n"
"  . +++            .o+.+++    \n"
" .  ++             .o+.++     \n"
" . +              ......+     \n"
".  +              .wo++.++    \n"
". +               .wo++.++    \n"
". +               ......++    \n"
;

static void handleClick(id name)
{
    if ([name isEqual:@"Safari"]) {
        id cmd = nsarr();
        [cmd addObject:@"chromium"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Contacts"]) {
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"ContactListNavigation"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Calculator"]) {
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"Calculator"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Calendar"]) {
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"CalendarInterface"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Camera"]) {
        BOOL exists = [@"/dev/video0" fileExists];
        if (exists) {
            id cmd = nsarr();
            [cmd addObject:@"ffplay"];
            [cmd addObject:@"/dev/video0"];
            [cmd runCommandInBackground];
            return;
        }
    } else if ([name isEqual:@"Clock"]) {
    } else if ([name isEqual:@"Mail"]) {
    } else if ([name isEqual:@"Messages"]) {
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"MessagesPlaceholder"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Music"]) {
        id cmd = nsarr();
        [cmd addObject:@"pucko"];
        [cmd addObject:@"AlbumListNavigation"];
        [cmd runCommandInBackground];
        return;
    } else if ([name isEqual:@"Notes"]) {
    } else if ([name isEqual:@"Videos"]) {
    } else if ([name isEqual:@"VoiceMemo"]) {
    }

    id cmd = nsarr();
    [cmd addObject:@"pucko"];
    [cmd addObject:@"showAlert:"];
    [cmd addObject:@"Nothing happened."];
    [cmd runCommandInBackground];
}

@implementation Definitions(iewofkdslmvkcxvbapdwppqppowdsdkskskskaj)
+ (void)HomeScreen
{
unsigned char *allIcons[] = {
    iconCalculatorName, iconCalculatorPalette, iconCalculatorPixels,
    iconCalendarName, iconCalendarPalette, iconCalendarPixels,
    iconCameraName, iconCameraPalette, iconCameraPixels,
    iconClockName, iconClockPalette, iconClockPixels,
    iconContactsName, iconContactsPalette, iconContactsPixels,
    iconGameCenterName, iconGameCenterPalette, iconGameCenterPixels,
    iconMailName, iconMailPalette, iconMailPixels,
    iconMessagesName, iconMessagesPalette, iconMessagesPixels,
    iconMusicName, iconMusicPalette, iconMusicPixels,
    iconNotesName, iconNotesPalette, iconNotesPixels,
    iconPhotosName, iconPhotosPalette, iconPhotosPixels,
    iconSafariName, iconSafariPalette, iconSafariPixels,
    iconSettingsName, iconSettingsPalette, iconSettingsPixels,
    iconVideosName, iconVideosPalette, iconVideosPixels,
    iconVoiceMemoName, iconVoiceMemoPalette, iconVoiceMemoPixels,
    0, 0, 0
};
    id obj = [@"HomeScreen" asInstance];
    id arr = nsarr();

    for (int i=0;; i+=3) {
        if (!allIcons[i]) {
            break;
        }
        id dict = nsdict();
        [dict setValue:nsfmt(@"%s", allIcons[i]) forKey:@"name"];
        [dict setValue:nsfmt(@"%s", allIcons[i+1]) forKey:@"palette"];
        [dict setValue:nsfmt(@"%s", allIcons[i+2]) forKey:@"pixels"];
        [arr addObject:dict];
    }

    [obj setValue:arr forKey:@"array"];

    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
@end

@interface HomeScreen : IvarObject
{
    id _array;
    Int4 _rects[6*4];
    int _mouseDownX;
    int _mouseDownY;
}
@end
@implementation HomeScreen
- (int)preferredWidth
{
    return 320;
}
- (int)preferredHeight
{
    return 480;
}

- (void)beginIteration:(id)event rect:(Int4)r
{
    int cellW = r.w / numberOfColumns;
    int cellH = r.h / numberOfRows;
    for (int j=0; j<numberOfRows; j++) {
        for (int i=0; i<numberOfColumns; i++) {
            int index = j*numberOfColumns+i;
            _rects[index].x = cellW*i + (cellW-60)/2;
            _rects[index].y = cellH*j + (cellH-60)/2;
            _rects[index].w = 60;
            _rects[index].h = 60;
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"#c3c7cb"];
    [bitmap fillRect:r];
    [bitmap setColor:@"black"];
    for (int j=0; j<numberOfRows; j++) {
        for (int i=0; i<numberOfColumns; i++) {
            int index = j*numberOfColumns+i;
            id elt = [_array nth:index];
            if (!elt) {
                break;
            }
            id pixels = [elt valueForKey:@"pixels"];
            id palette = [elt valueForKey:@"palette"];
            int iconWidth = 40;
            int iconHeight = 40;
            if (pixels) {
                iconWidth = [Definitions widthForCString:[pixels UTF8String]];
                iconHeight = [Definitions heightForCString:[pixels UTF8String]];
            }
            [bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:_rects[index].x+(_rects[index].w-iconWidth)/2 y:_rects[index].y+_rects[index].h-iconHeight];
            id text = [elt valueForKey:@"name"];
            int textWidth = [bitmap bitmapWidthForText:text];
            [bitmap drawBitmapText:text x:_rects[index].x+_rects[index].w/2-textWidth/2 y:_rects[index].y+_rects[index].h/2+40];
        }
    }
}

- (void)handleMouseDown:(id)event
{
    _mouseDownX = [event intValueForKey:@"mouseX"];
    _mouseDownY = [event intValueForKey:@"mouseY"];
}

- (void)handleMouseUp:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    for (int i=0; i<numberOfRows*numberOfColumns; i++) {
        if ([Definitions isX:_mouseDownX y:_mouseDownY insideRect:_rects[i]]) {
            if ([Definitions isX:mouseX y:mouseY insideRect:_rects[i]]) {
                id elt = [_array nth:i];
                id name = [elt valueForKey:@"name"];
                if (name) {
                    handleClick(name);
                }
            }
        }
    }
}

@end

