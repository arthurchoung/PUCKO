#import "HOTDOG.h"

@implementation Definitions(jfkdlsjflkdsjkfljdsf)
+ (int *)arrayOfXSpacingsForC64Font
{
    static int xspacings[256];
    BOOL first = YES;
    if (first) {
        for (int i=0; i<256; i++) {
            xspacings[i] = 0;
        }
        first = NO;
    }
    return xspacings;
}
+ (int *)arrayOfWidthsForC64Font
{
    static int widths[256];
    BOOL first = YES;
    if (first) {
        char **bitmaps = [Definitions arrayOfCStringsForC64Font];
        [Definitions calculateWidths:widths forCStrings:bitmaps];
        first = NO;
    }
    return widths;
}
+ (int *)arrayOfHeightsForC64Font
{
    static int heights[256];
    BOOL first = YES;
    if (first) {
        char **bitmaps = [Definitions arrayOfCStringsForC64Font];
        [Definitions calculateHeights:heights forCStrings:bitmaps];
        first = NO;
    }
    return heights;
}
+ (char **)arrayOfCStringsForC64Font
{
    static char *bitmaps[256];
BOOL first = YES;
if (first) {
    memset(bitmaps, 0, sizeof(bitmaps));
    bitmaps[0] = 
"bb    bb\n"
"b  bb  b\n"
"b  b   b\n"
"b  b   b\n"
"b  bbbbb\n"
"b  bbb b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[1] = 
"bbb  bbb\n"
"bb    bb\n"
"b  bb  b\n"
"b      b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[2] = 
"b     bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b     bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b     bb\n"
"bbbbbbbb\n"
;
    bitmaps[3] = 
"bb    bb\n"
"b  bb  b\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[4] = 
"b    bbb\n"
"b  b  bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  b  bb\n"
"b    bbb\n"
"bbbbbbbb\n"
;
    bitmaps[5] = 
"b      b\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b    bbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b      b\n"
"bbbbbbbb\n"
;
    bitmaps[6] = 
"b      b\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b    bbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[7] = 
"bb    bb\n"
"b  bb  b\n"
"b  bbbbb\n"
"b  b   b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[8] = 
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b      b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[9] = 
"bb    bb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[10] = 
"bbb    b\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"b  b  bb\n"
"bb   bbb\n"
"bbbbbbbb\n"
;
    bitmaps[11] = 
"b  bb  b\n"
"b  b  bb\n"
"b    bbb\n"
"b   bbbb\n"
"b    bbb\n"
"b  b  bb\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[12] = 
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b      b\n"
"bbbbbbbb\n"
;
    bitmaps[13] = 
"b  bbb  \n"
"b   b   \n"
"b       \n"
"b  b b  \n"
"b  bbb  \n"
"b  bbb  \n"
"b  bbb  \n"
"bbbbbbbb\n"
;
    bitmaps[14] = 
"b  bb  b\n"
"b   b  b\n"
"b      b\n"
"b      b\n"
"b  b   b\n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[15] = 
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[16] = 
"b     bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b     bb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[17] = 
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbb   b\n"
"bbbbbbbb\n"
;
    bitmaps[18] = 
"b     bb\n"
"b  bb  b\n"
"b  bb  b\n"
"b     bb\n"
"b    bbb\n"
"b  b  bb\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[19] = 
"bb    bb\n"
"b  bb  b\n"
"b  bbbbb\n"
"bb    bb\n"
"bbbbb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[20] = 
"b      b\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[21] = 
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[22] = 
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[23] = 
"b  bbb  \n"
"b  bbb  \n"
"b  bbb  \n"
"b  b b  \n"
"b       \n"
"b   b   \n"
"b  bbb  \n"
"bbbbbbbb\n"
;
    bitmaps[24] = 
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbb  bbb\n"
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[25] = 
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[26] = 
"b      b\n"
"bbbbb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bb  bbbb\n"
"b  bbbbb\n"
"b      b\n"
"bbbbbbbb\n"
;
    bitmaps[27] = 
"bb    bb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[28] = 
"bbbb  bb\n"
"bbb bb b\n"
"bb  bbbb\n"
"b     bb\n"
"bb  bbbb\n"
"b  bbb b\n"
"      bb\n"
"bbbbbbbb\n"
;
    bitmaps[29] = 
"bb    bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[30] = 
"bbbbbbbb\n"
"bbb  bbb\n"
"bb    bb\n"
"b      b\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[31] = 
"bbbbbbbb\n"
"bbb bbbb\n"
"bb  bbbb\n"
"b       \n"
"b       \n"
"bb  bbbb\n"
"bbb bbbb\n"
"bbbbbbbb\n"
;
    bitmaps[32] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[33] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[34] = 
"b  bb  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[35] = 
"b  bb  b\n"
"b  bb  b\n"
"        \n"
"b  bb  b\n"
"        \n"
"b  bb  b\n"
"b  bb  b\n"
"bbbbbbbb\n"
;
    bitmaps[36] = 
"bbb  bbb\n"
"bb     b\n"
"b  bbbbb\n"
"bb    bb\n"
"bbbbb  b\n"
"b     bb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[37] = 
"b  bbb b\n"
"b  bb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bb  bbbb\n"
"b  bb  b\n"
"b bbb  b\n"
"bbbbbbbb\n"
;
    bitmaps[38] = 
"bb    bb\n"
"b  bb  b\n"
"bb    bb\n"
"bb   bbb\n"
"b  bb   \n"
"b  bb  b\n"
"bb      \n"
"bbbbbbbb\n"
;
    bitmaps[39] = 
"bbbbb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[40] = 
"bbbb  bb\n"
"bbb  bbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bbb  bbb\n"
"bbbb  bb\n"
"bbbbbbbb\n"
;
    bitmaps[41] = 
"bb  bbbb\n"
"bbb  bbb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bb  bbbb\n"
"bbbbbbbb\n"
;
    bitmaps[42] = 
"bbbbbbbb\n"
"b  bb  b\n"
"bb    bb\n"
"        \n"
"bb    bb\n"
"b  bb  b\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[43] = 
"bbbbbbbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"b      b\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[44] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bb  bbbb\n"
;
    bitmaps[45] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"b      b\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[46] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"   bb   \n"
"   bb   \n"
"        \n"
;
    bitmaps[47] = 
"bbbbbbbb\n"
"bbbbbb  \n"
"bbbbb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bb  bbbb\n"
"b  bbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[48] = 
"  bbbb  \n"
" bb  bb \n"
" bb bbb \n"
" bbb bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[49] = 
"   bb   \n"
"   bb   \n"
"  bbb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
" bbbbbb \n"
"        \n"
;
    bitmaps[50] = 
"  bbbb  \n"
" bb  bb \n"
"     bb \n"
"    bb  \n"
"  bb    \n"
" bb     \n"
" bbbbbb \n"
"        \n"
;
    bitmaps[51] = 
"  bbbb  \n"
" bb  bb \n"
"     bb \n"
"   bbb  \n"
"     bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[52] = 
"     bb \n"
"    bbb \n"
"   bbbb \n"
" bb  bb \n"
" bbbbbbb\n"
"     bb \n"
"     bb \n"
"        \n"
;
    bitmaps[53] = 
" bbbbbb \n"
" bb     \n"
" bbbbb  \n"
"     bb \n"
"     bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[54] = 
"  bbbb  \n"
" bb  bb \n"
" bb     \n"
" bbbbb  \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[55] = 
" bbbbbb \n"
" bb  bb \n"
"    bb  \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"        \n"
;
    bitmaps[56] = 
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[57] = 
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
"  bbbbb \n"
"     bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[58] = 
"        \n"
"        \n"
"   bb   \n"
"        \n"
"        \n"
"   bb   \n"
"        \n"
"        \n"
;
    bitmaps[59] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bb  bbbb\n"
;
    bitmaps[60] = 
"bbbb   b\n"
"bbb  bbb\n"
"bb  bbbb\n"
"b  bbbbb\n"
"bb  bbbb\n"
"bbb  bbb\n"
"bbbb   b\n"
"bbbbbbbb\n"
;
    bitmaps[61] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"b      b\n"
"bbbbbbbb\n"
"b      b\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[62] = 
"b   bbbb\n"
"bbb  bbb\n"
"bbbb  bb\n"
"bbbbb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"b   bbbb\n"
"bbbbbbbb\n"
;
    bitmaps[63] = 
"bb    bb\n"
"b  bb  b\n"
"bbbbb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[64] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[65] = 
"bbbb bbb\n"
"bbb   bb\n"
"bb     b\n"
"b       \n"
"b       \n"
"bbb   bb\n"
"bb     b\n"
"bbbbbbbb\n"
;
    bitmaps[66] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[67] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[68] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[69] = 
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[70] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[71] = 
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
;
    bitmaps[72] = 
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
"bbbb  bb\n"
;
    bitmaps[73] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"   bbbbb\n"
"    bbbb\n"
"bb   bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[74] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb   bb\n"
"bbbb    \n"
"bbbbb   \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[75] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bb   bbb\n"
"    bbbb\n"
"   bbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[76] = 
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"        \n"
"        \n"
;
    bitmaps[77] = 
"  bbbbbb\n"
"   bbbbb\n"
"b   bbbb\n"
"bb   bbb\n"
"bbb   bb\n"
"bbbb   b\n"
"bbbbb   \n"
"bbbbbb  \n"
;
    bitmaps[78] = 
"bbbbbb  \n"
"bbbbb   \n"
"bbbb   b\n"
"bbb   bb\n"
"bb   bbb\n"
"b   bbbb\n"
"   bbbbb\n"
"  bbbbbb\n"
;
    bitmaps[79] = 
"        \n"
"        \n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
;
    bitmaps[80] = 
"        \n"
"        \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
;
    bitmaps[81] = 
"bbbbbbbb\n"
"bb    bb\n"
"b      b\n"
"b      b\n"
"b      b\n"
"b      b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[82] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
;
    bitmaps[83] = 
"bb  b  b\n"
"b       \n"
"b       \n"
"b       \n"
"bb     b\n"
"bbb   bb\n"
"bbbb bbb\n"
"bbbbbbbb\n"
;
    bitmaps[84] = 
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
"b  bbbbb\n"
;
    bitmaps[85] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbb   \n"
"bbbb    \n"
"bbb   bb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[86] = 
"  bbbb  \n"
"   bb   \n"
"b      b\n"
"bb    bb\n"
"bb    bb\n"
"b      b\n"
"   bb   \n"
"  bbbb  \n"
;
    bitmaps[87] = 
"bbbbbbbb\n"
"bb    bb\n"
"b      b\n"
"b  bb  b\n"
"b  bb  b\n"
"b      b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[88] = 
"bbb  bbb\n"
"bbb  bbb\n"
"b  bb  b\n"
"b  bb  b\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[89] = 
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbb  b\n"
;
    bitmaps[90] = 
"bbbb bbb\n"
"bbb   bb\n"
"bb     b\n"
"b       \n"
"bb     b\n"
"bbb   bb\n"
"bbbb bbb\n"
"bbbbbbbb\n"
;
    bitmaps[91] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"        \n"
"        \n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[92] = 
"  bbbbbb\n"
"  bbbbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"bb  bbbb\n"
"bb  bbbb\n"
;
    bitmaps[93] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[94] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbb  \n"
"bb     b\n"
"b   b  b\n"
"bb  b  b\n"
"bb  b  b\n"
"bbbbbbbb\n"
;
    bitmaps[95] = 
"        \n"
"b       \n"
"bb      \n"
"bbb     \n"
"bbbb    \n"
"bbbbb   \n"
"bbbbbb  \n"
"bbbbbbb \n"
;
    bitmaps[96] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[97] = 
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
;
    bitmaps[98] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[99] = 
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[100] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
;
    bitmaps[101] = 
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
;
    bitmaps[102] = 
"  bb  bb\n"
"  bb  bb\n"
"bb  bb  \n"
"bb  bb  \n"
"  bb  bb\n"
"  bb  bb\n"
"bb  bb  \n"
"bb  bb  \n"
;
    bitmaps[103] = 
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
;
    bitmaps[104] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"  bb  bb\n"
"  bb  bb\n"
"bb  bb  \n"
"bb  bb  \n"
;
    bitmaps[105] = 
"        \n"
"       b\n"
"      bb\n"
"     bbb\n"
"    bbbb\n"
"   bbbbb\n"
"  bbbbbb\n"
" bbbbbbb\n"
;
    bitmaps[106] = 
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
;
    bitmaps[107] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb     \n"
"bbb     \n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[108] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
;
    bitmaps[109] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb     \n"
"bbb     \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[110] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"     bbb\n"
"     bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[111] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
;
    bitmaps[112] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb     \n"
"bbb     \n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[113] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[114] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[115] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"     bbb\n"
"     bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
;
    bitmaps[116] = 
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
"  bbbbbb\n"
;
    bitmaps[117] = 
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
"   bbbbb\n"
;
    bitmaps[118] = 
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
"bbbbb   \n"
;
    bitmaps[119] = 
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[120] = 
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[121] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[122] = 
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"bbbbbb  \n"
"        \n"
"        \n"
;
    bitmaps[123] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
;
    bitmaps[124] = 
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[125] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"     bbb\n"
"     bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[126] = 
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[127] = 
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
;
    bitmaps[128] = 
"  bbbb  \n"
" bb  bb \n"
" bb bbb \n"
" bb bbb \n"
" bb     \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[129] = 
"   bb   \n"
"  bbbb  \n"
" bb  bb \n"
" bbbbbb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"        \n"
;
    bitmaps[130] = 
" bbbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bbbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bbbbb  \n"
"        \n"
;
    bitmaps[131] = 
"  bbbb  \n"
" bb  bb \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[132] = 
" bbbb   \n"
" bb bb  \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb bb  \n"
" bbbb   \n"
"        \n"
;
    bitmaps[133] = 
" bbbbbb \n"
" bb     \n"
" bb     \n"
" bbbb   \n"
" bb     \n"
" bb     \n"
" bbbbbb \n"
"        \n"
;
    bitmaps[134] = 
" bbbbbb \n"
" bb     \n"
" bb     \n"
" bbbb   \n"
" bb     \n"
" bb     \n"
" bb     \n"
"        \n"
;
    bitmaps[135] = 
"  bbbb  \n"
" bb  bb \n"
" bb     \n"
" bb bbb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[136] = 
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bbbbbb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"        \n"
;
    bitmaps[137] = 
"  bbbb  \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[138] = 
"   bbbb \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
" bb bb  \n"
"  bbb   \n"
"        \n"
;
    bitmaps[139] = 
" bb  bb \n"
" bb bb  \n"
" bbbb   \n"
" bbb    \n"
" bbbb   \n"
" bb bb  \n"
" bb  bb \n"
"        \n"
;
    bitmaps[140] = 
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bbbbbb \n"
"        \n"
;
    bitmaps[141] = 
" bb   bb\n"
" bbb bbb\n"
" bbbbbbb\n"
" bb b bb\n"
" bb   bb\n"
" bb   bb\n"
" bb   bb\n"
"        \n"
;
    bitmaps[142] = 
" bb  bb \n"
" bbb bb \n"
" bbbbbb \n"
" bbbbbb \n"
" bb bbb \n"
" bb  bb \n"
" bb  bb \n"
"        \n"
;
    bitmaps[143] = 
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[144] = 
" bbbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bbbbb  \n"
" bb     \n"
" bb     \n"
" bb     \n"
"        \n"
;
    bitmaps[145] = 
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"    bbb \n"
"        \n"
;
    bitmaps[146] = 
" bbbbb  \n"
" bb  bb \n"
" bb  bb \n"
" bbbbb  \n"
" bbbb   \n"
" bb bb  \n"
" bb  bb \n"
"        \n"
;
    bitmaps[147] = 
"  bbbb  \n"
" bb  bb \n"
" bb     \n"
"  bbbb  \n"
"     bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[148] = 
" bbbbbb \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"        \n"
;
    bitmaps[149] = 
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[150] = 
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"   bb   \n"
"        \n"
;
    bitmaps[151] = 
" bb   bb\n"
" bb   bb\n"
" bb   bb\n"
" bb b bb\n"
" bbbbbbb\n"
" bbb bbb\n"
" bb   bb\n"
"        \n"
;
    bitmaps[152] = 
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"   bb   \n"
"  bbbb  \n"
" bb  bb \n"
" bb  bb \n"
"        \n"
;
    bitmaps[153] = 
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"  bbbb  \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"        \n"
;
    bitmaps[154] = 
" bbbbbb \n"
"     bb \n"
"    bb  \n"
"   bb   \n"
"  bb    \n"
" bb     \n"
" bbbbbb \n"
"        \n"
;
    bitmaps[155] = 
"  bbbb  \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[156] = 
"    bb  \n"
"   b  b \n"
"  bb    \n"
" bbbbb  \n"
"  bb    \n"
" bb   b \n"
"bbbbbb  \n"
"        \n"
;
    bitmaps[157] = 
"  bbbb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[158] = 
"        \n"
"   bb   \n"
"  bbbb  \n"
" bbbbbb \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[159] = 
"        \n"
"   b    \n"
"  bb    \n"
" bbbbbbb\n"
" bbbbbbb\n"
"  bb    \n"
"   b    \n"
"        \n"
;
    bitmaps[160] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[161] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"        \n"
"        \n"
"   bb   \n"
"        \n"
;
    bitmaps[162] = 
" bb  bb \n"
" bb  bb \n"
" bb  bb \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[163] = 
" bb  bb \n"
" bb  bb \n"
"bbbbbbbb\n"
" bb  bb \n"
"bbbbbbbb\n"
" bb  bb \n"
" bb  bb \n"
"        \n"
;
    bitmaps[164] = 
"   bb   \n"
"  bbbbb \n"
" bb     \n"
"  bbbb  \n"
"     bb \n"
" bbbbb  \n"
"   bb   \n"
"        \n"
;
    bitmaps[165] = 
" bb   b \n"
" bb  bb \n"
"    bb  \n"
"   bb   \n"
"  bb    \n"
" bb  bb \n"
" b   bb \n"
"        \n"
;
    bitmaps[166] = 
"  bbbb  \n"
" bb  bb \n"
"  bbbb  \n"
"  bbb   \n"
" bb  bbb\n"
" bb  bb \n"
"  bbbbbb\n"
"        \n"
;
    bitmaps[167] = 
"     bb \n"
"    bb  \n"
"   bb   \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[168] = 
"    bb  \n"
"   bb   \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"   bb   \n"
"    bb  \n"
"        \n"
;
    bitmaps[169] = 
"  bb    \n"
"   bb   \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"   bb   \n"
"  bb    \n"
"        \n"
;
    bitmaps[170] = 
"        \n"
" bb  bb \n"
"  bbbb  \n"
"bbbbbbbb\n"
"  bbbb  \n"
" bb  bb \n"
"        \n"
"        \n"
;
    bitmaps[171] = 
"        \n"
"   bb   \n"
"   bb   \n"
" bbbbbb \n"
"   bb   \n"
"   bb   \n"
"        \n"
"        \n"
;
    bitmaps[172] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"   bb   \n"
"   bb   \n"
"  bb    \n"
;
    bitmaps[173] = 
"        \n"
"        \n"
"        \n"
" bbbbbb \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[174] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[175] = 
"        \n"
"      bb\n"
"     bb \n"
"    bb  \n"
"   bb   \n"
"  bb    \n"
" bb     \n"
"        \n"
;
    bitmaps[176] = 
"bb    bb\n"
"b  bb  b\n"
"b  b   b\n"
"b   b  b\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[177] = 
"bbb  bbb\n"
"bbb  bbb\n"
"bb   bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"b      b\n"
"bbbbbbbb\n"
;
    bitmaps[178] = 
"bb    bb\n"
"b  bb  b\n"
"bbbbb  b\n"
"bbbb  bb\n"
"bb  bbbb\n"
"b  bbbbb\n"
"b      b\n"
"bbbbbbbb\n"
;
    bitmaps[179] = 
"bb    bb\n"
"b  bb  b\n"
"bbbbb  b\n"
"bbb   bb\n"
"bbbbb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[180] = 
"bbbbb  b\n"
"bbbb   b\n"
"bbb    b\n"
"b  bb  b\n"
"b       \n"
"bbbbb  b\n"
"bbbbb  b\n"
"bbbbbbbb\n"
;
    bitmaps[181] = 
"b      b\n"
"b  bbbbb\n"
"b     bb\n"
"bbbbb  b\n"
"bbbbb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[182] = 
"bb    bb\n"
"b  bb  b\n"
"b  bbbbb\n"
"b     bb\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[183] = 
"b      b\n"
"b  bb  b\n"
"bbbb  bb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
;
    bitmaps[184] = 
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[185] = 
"bb    bb\n"
"b  bb  b\n"
"b  bb  b\n"
"bb     b\n"
"bbbbb  b\n"
"b  bb  b\n"
"bb    bb\n"
"bbbbbbbb\n"
;
    bitmaps[186] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbb  bbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[187] = 
"        \n"
"        \n"
"   bb   \n"
"        \n"
"        \n"
"   bb   \n"
"   bb   \n"
"  bb    \n"
;
    bitmaps[188] = 
"    bbb \n"
"   bb   \n"
"  bb    \n"
" bb     \n"
"  bb    \n"
"   bb   \n"
"    bbb \n"
"        \n"
;
    bitmaps[189] = 
"        \n"
"        \n"
" bbbbbb \n"
"        \n"
" bbbbbb \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[190] = 
" bbb    \n"
"   bb   \n"
"    bb  \n"
"     bb \n"
"    bb  \n"
"   bb   \n"
" bbb    \n"
"        \n"
;
    bitmaps[191] = 
"  bbbb  \n"
" bb  bb \n"
"     bb \n"
"    bb  \n"
"   bb   \n"
"        \n"
"   bb   \n"
"        \n"
;
    bitmaps[192] = 
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[193] = 
"    b   \n"
"   bbb  \n"
"  bbbbb \n"
" bbbbbbb\n"
" bbbbbbb\n"
"   bbb  \n"
"  bbbbb \n"
"        \n"
;
    bitmaps[194] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[195] = 
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[196] = 
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[197] = 
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[198] = 
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
;
    bitmaps[199] = 
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
"  bb    \n"
;
    bitmaps[200] = 
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
"    bb  \n"
;
    bitmaps[201] = 
"        \n"
"        \n"
"        \n"
"bbb     \n"
"bbbb    \n"
"  bbb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[202] = 
"   bb   \n"
"   bb   \n"
"   bbb  \n"
"    bbbb\n"
"     bbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[203] = 
"   bb   \n"
"   bb   \n"
"  bbb   \n"
"bbbb    \n"
"bbb     \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[204] = 
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[205] = 
"bb      \n"
"bbb     \n"
" bbb    \n"
"  bbb   \n"
"   bbb  \n"
"    bbb \n"
"     bbb\n"
"      bb\n"
;
    bitmaps[206] = 
"      bb\n"
"     bbb\n"
"    bbb \n"
"   bbb  \n"
"  bbb   \n"
" bbb    \n"
"bbb     \n"
"bb      \n"
;
    bitmaps[207] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
;
    bitmaps[208] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
;
    bitmaps[209] = 
"        \n"
"  bbbb  \n"
" bbbbbb \n"
" bbbbbb \n"
" bbbbbb \n"
" bbbbbb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[210] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
;
    bitmaps[211] = 
"  bb bb \n"
" bbbbbbb\n"
" bbbbbbb\n"
" bbbbbbb\n"
"  bbbbb \n"
"   bbb  \n"
"    b   \n"
"        \n"
;
    bitmaps[212] = 
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
" bb     \n"
;
    bitmaps[213] = 
"        \n"
"        \n"
"        \n"
"     bbb\n"
"    bbbb\n"
"   bbb  \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[214] = 
"bb    bb\n"
"bbb  bbb\n"
" bbbbbb \n"
"  bbbb  \n"
"  bbbb  \n"
" bbbbbb \n"
"bbb  bbb\n"
"bb    bb\n"
;
    bitmaps[215] = 
"        \n"
"  bbbb  \n"
" bbbbbb \n"
" bb  bb \n"
" bb  bb \n"
" bbbbbb \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[216] = 
"   bb   \n"
"   bb   \n"
" bb  bb \n"
" bb  bb \n"
"   bb   \n"
"   bb   \n"
"  bbbb  \n"
"        \n"
;
    bitmaps[217] = 
"     bb \n"
"     bb \n"
"     bb \n"
"     bb \n"
"     bb \n"
"     bb \n"
"     bb \n"
"     bb \n"
;
    bitmaps[218] = 
"    b   \n"
"   bbb  \n"
"  bbbbb \n"
" bbbbbbb\n"
"  bbbbb \n"
"   bbb  \n"
"    b   \n"
"        \n"
;
    bitmaps[219] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[220] = 
"bb      \n"
"bb      \n"
"  bb    \n"
"  bb    \n"
"bb      \n"
"bb      \n"
"  bb    \n"
"  bb    \n"
;
    bitmaps[221] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[222] = 
"        \n"
"        \n"
"      bb\n"
"  bbbbb \n"
" bbb bb \n"
"  bb bb \n"
"  bb bb \n"
"        \n"
;
    bitmaps[223] = 
"bbbbbbbb\n"
" bbbbbbb\n"
"  bbbbbb\n"
"   bbbbb\n"
"    bbbb\n"
"     bbb\n"
"      bb\n"
"       b\n"
;
    bitmaps[224] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[225] = 
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
;
    bitmaps[226] = 
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[227] = 
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[228] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
;
    bitmaps[229] = 
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
;
    bitmaps[230] = 
"bb  bb  \n"
"bb  bb  \n"
"  bb  bb\n"
"  bb  bb\n"
"bb  bb  \n"
"bb  bb  \n"
"  bb  bb\n"
"  bb  bb\n"
;
    bitmaps[231] = 
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
;
    bitmaps[232] = 
"        \n"
"        \n"
"        \n"
"        \n"
"bb  bb  \n"
"bb  bb  \n"
"  bb  bb\n"
"  bb  bb\n"
;
    bitmaps[233] = 
"bbbbbbbb\n"
"bbbbbbb \n"
"bbbbbb  \n"
"bbbbb   \n"
"bbbb    \n"
"bbb     \n"
"bb      \n"
"b       \n"
;
    bitmaps[234] = 
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
;
    bitmaps[235] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bbbbb\n"
"   bbbbb\n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[236] = 
"        \n"
"        \n"
"        \n"
"        \n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
;
    bitmaps[237] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"   bbbbb\n"
"   bbbbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[238] = 
"        \n"
"        \n"
"        \n"
"bbbbb   \n"
"bbbbb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[239] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[240] = 
"        \n"
"        \n"
"        \n"
"   bbbbb\n"
"   bbbbb\n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[241] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[242] = 
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[243] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"bbbbb   \n"
"bbbbb   \n"
"   bb   \n"
"   bb   \n"
"   bb   \n"
;
    bitmaps[244] = 
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
"bb      \n"
;
    bitmaps[245] = 
"bbb     \n"
"bbb     \n"
"bbb     \n"
"bbb     \n"
"bbb     \n"
"bbb     \n"
"bbb     \n"
"bbb     \n"
;
    bitmaps[246] = 
"     bbb\n"
"     bbb\n"
"     bbb\n"
"     bbb\n"
"     bbb\n"
"     bbb\n"
"     bbb\n"
"     bbb\n"
;
    bitmaps[247] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[248] = 
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[249] = 
"        \n"
"        \n"
"        \n"
"        \n"
"        \n"
"bbbbbbbb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[250] = 
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"      bb\n"
"bbbbbbbb\n"
"bbbbbbbb\n"
;
    bitmaps[251] = 
"        \n"
"        \n"
"        \n"
"        \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
;
    bitmaps[252] = 
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[253] = 
"   bb   \n"
"   bb   \n"
"   bb   \n"
"bbbbb   \n"
"bbbbb   \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[254] = 
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"        \n"
"        \n"
"        \n"
"        \n"
;
    bitmaps[255] = 
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"bbbb    \n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
"    bbbb\n"
;
    for (int i=0; i<256; i++) {
        if (!bitmaps[i]) {
            bitmaps[i] = 0;
        }
    }
for (int i=0; i<26; i++) {
    bitmaps['A'+i] = bitmaps[129+i];
    bitmaps['a'+i] = bitmaps[129+i];
}
    first = NO;
}
    return bitmaps;
}
@end

