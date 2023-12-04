#import "HOTDOG.h"

@implementation Definitions(fjdklsjfkldskjeuriwef)
+ (int *)arrayOfXSpacingsForGenevaFont
{
    static int xspacings[256];
    BOOL first = YES;
    if (first) {
        for (int i=0; i<256; i++) {
            xspacings[i] = 1;
        }
        first = NO;
    }
    return xspacings;
}
+ (int *)arrayOfWidthsForGenevaFont
{
    static int widths[256];
    BOOL first = YES;
    if (first) {
        char **bitmaps = [Definitions arrayOfCStringsForGenevaFont];
        [Definitions calculateWidths:widths forCStrings:bitmaps];
        first = NO;
    }
    return widths;
}
+ (int *)arrayOfHeightsForGenevaFont
{
    static int heights[256];
    BOOL first = YES;
    if (first) {
        char **bitmaps = [Definitions arrayOfCStringsForGenevaFont];
        [Definitions calculateHeights:heights forCStrings:bitmaps];
        first = NO;
    }
    return heights;
}
+ (char **)arrayOfCStringsForGenevaFont
{
    static char *default_bitmap = 
"bbbbbb\n"
"b    b\n"
"b    b\n"
"b    b\n"
"b    b\n"
"b    b\n"
"b    b\n"
"b    b\n"
"b    b\n"
"bbbbbb\n"
;

    static char *bitmaps[256];
    static BOOL first = YES;
    if (first) {
    memset(bitmaps, 0, sizeof(bitmaps));
    bitmaps[32] = 
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
;
    bitmaps[33] = 
"   \n"
" b \n"
" b \n"
" b \n"
" b \n"
" b \n"
"   \n"
" b \n"
"   \n"
"   \n"
;
    bitmaps[34] = 
"     \n"
" b b \n"
" b b \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
;
    bitmaps[35] = 
" b b \n"
"bbbbb\n"
" b b \n"
"bbbbb\n"
" b b \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
;
    bitmaps[36] = 
"  b  \n"
" bbb \n"
"b b b\n"
"b b  \n"
" bbb \n"
"  b b\n"
"b b b\n"
" bbb \n"
"  b  \n"
"     \n"
;
    bitmaps[37] = 
"        \n"
" bbbbbbb\n"
"b  b  b \n"
"b  b b  \n"
" bb bbb \n"
"   bb  b\n"
"  b b  b\n"
" b   bb \n"
"        \n"
"        \n"
;
    bitmaps[38] = 
"  bb   \n"
" b  b  \n"
" b b   \n"
"  b    \n"
" b b b \n"
"b   b  \n"
"b  b b \n"
" bb   b\n"
"       \n"
"       \n"
;
    bitmaps[39] = 
"   \n"
" b \n"
" b \n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
;
    bitmaps[40] = 
"  b\n"
" b \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
" b \n"
"  b\n"
"   \n"
;
    bitmaps[41] = 
"b  \n"
" b \n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
" b \n"
"b  \n"
"   \n"
;
    bitmaps[42] = 
"     \n"
" b b \n"
"  b  \n"
"bbbbb\n"
"  b  \n"
" b b \n"
"     \n"
"     \n"
"     \n"
"     \n"
;
    bitmaps[43] = 
"     \n"
"     \n"
"  b  \n"
"  b  \n"
"bbbbb\n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
"     \n"
;
    bitmaps[44] = 
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
" b\n"
" b\n"
"b \n"
;
    bitmaps[45] = 
"    \n"
"    \n"
"    \n"
"    \n"
"bbbb\n"
"    \n"
"    \n"
"    \n"
"    \n"
"    \n"
;
    bitmaps[46] = 
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
"b\n"
" \n"
" \n"
;
    bitmaps[47] = 
"   b\n"
"   b\n"
"  b \n"
"  b \n"
" b  \n"
" b  \n"
"b   \n"
"b   \n"
"    \n"
"    \n"
;
    bitmaps[48] = 
"     \n"
" bbb \n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[49] = 
"  \n"
" b\n"
"bb\n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
"  \n"
"  \n"
;
    bitmaps[50] = 
"     \n"
" bbb \n"
"b   b\n"
"    b\n"
"   b \n"
"  b  \n"
" b   \n"
"bbbbb\n"
"     \n"
"     \n"
;
    bitmaps[51] = 
"     \n"
"bbbbb\n"
"   b \n"
"  b  \n"
" bbb \n"
"    b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[52] = 
"     \n"
"   b \n"
"  bb \n"
" b b \n"
"b  b \n"
"bbbbb\n"
"   b \n"
"   b \n"
"     \n"
"     \n"
;
    bitmaps[53] = 
"     \n"
"bbbbb\n"
"b    \n"
"bbbb \n"
"    b\n"
"    b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[54] = 
"     \n"
"  bb \n"
" b   \n"
"b    \n"
"bbbb \n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[55] = 
"     \n"
"bbbbb\n"
"    b\n"
"   b \n"
"   b \n"
"  b  \n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
;
    bitmaps[56] = 
"     \n"
" bbb \n"
"b   b\n"
"b   b\n"
" bbb \n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[57] = 
"     \n"
" bbb \n"
"b   b\n"
"b   b\n"
" bbbb\n"
"    b\n"
"   b \n"
" bb  \n"
"     \n"
"     \n"
;
    bitmaps[58] = 
" \n"//FIXME
" \n"
" \n"
"b\n"
" \n"
" \n"
" \n"
"b\n"
" \n"
" \n"
;
    bitmaps[59] = 
"  \n"
"  \n"
"  \n"
" b\n"
"  \n"
"  \n"
"  \n"
" b\n"
" b\n"
"b \n"
;
    bitmaps[60] = 
"   \n"
"   \n"
"  b\n"
" b \n"
"b  \n"
" b \n"
"  b\n"
"   \n"
"   \n"
"   \n"
;
    bitmaps[61] = 
".....     \n"
".....     \n"
".....     \n"
"bbbbbbbbbb\n"
".....     \n"
"bbbbbbbbbb\n"
".....     \n"
".....     \n"
".....     \n"
".....     \n"
;
    bitmaps[62] = 
"   \n"
"   \n"
"b  \n"
" b \n"
"  b\n"
" b \n"
"b  \n"
"   \n"
"   \n"
"   \n"
;
    bitmaps[63] = 
"    \n"
" bb \n"
"b  b\n"
"   b\n"
"  b \n"
" b  \n"
"    \n"
" b  \n"
"    \n"
"    \n"
;
    bitmaps[64] = 
"       \n"
"  bbb  \n"
" b   b \n"
"b  bb b\n"
"b b b b\n"
"b b b b\n"
"b  bbb \n"
" b     \n"
"  bbb  \n"
"       \n"
;
    bitmaps[65] = 
"     \n"
"  b  \n"
"  b  \n"
" b b \n"
" b b \n"
"bbbbb\n"
"b   b\n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[66] = 
"     \n"
"bbbb \n"
"b   b\n"
"b   b\n"
"bbbb \n"
"b   b\n"
"b   b\n"
"bbbb \n"
"     \n"
"     \n"
;
    bitmaps[67] = 
"     \n"
" bbb \n"
"b   b\n"
"b    \n"
"b    \n"
"b    \n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[68] = 
"     \n"
"bbb  \n"
"b  b \n"
"b   b\n"
"b   b\n"
"b   b\n"
"b  b \n"
"bbb  \n"
"     \n"
"     \n"
;
    bitmaps[69] = 
"    \n"
"bbbb\n"
"b   \n"
"b   \n"
"bbb \n"
"b   \n"
"b   \n"
"bbbb\n"
"    \n"
"    \n"
;
    bitmaps[70] = 
"    \n"
"bbbb\n"
"b   \n"
"b   \n"
"bbb \n"
"b   \n"
"b   \n"
"b   \n"
"    \n"
"    \n"
;
    bitmaps[71] = 
"     \n"
" bbb \n"
"b   b\n"
"b    \n"
"b  bb\n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[72] = 
"     \n"
"b   b\n"
"b   b\n"
"b   b\n"
"bbbbb\n"
"b   b\n"
"b   b\n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[73] = 
"  \n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
"  \n"
"  \n"
;
    bitmaps[74] = 
"     \n"
"    b\n"
"    b\n"
"    b\n"
"    b\n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[75] = 
"     \n"
"b   b\n"
"b  b \n"
"b b  \n"
"bb   \n"
"b b  \n"
"b  b \n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[76] = 
"    \n"
"b   \n"
"b   \n"
"b   \n"
"b   \n"
"b   \n"
"b   \n"
"bbbb\n"
"    \n"
"    \n"
;
    bitmaps[77] = 
"       \n"
"b     b\n"
"bb   bb\n"
"b b b b\n"
"b  b  b\n"
"b     b\n"
"b     b\n"
"b     b\n"
"       \n"
"       \n"
;
    bitmaps[78] = 
"     \n"
"bb  b\n"
"bb  b\n"
"b b b\n"
"b b b\n"
"b  bb\n"
"b  bb\n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[79] = 
"     \n"
" bbb \n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[80] = 
"     \n"
"bbbb \n"
"b   b\n"
"b   b\n"
"bbbb \n"
"b    \n"
"b    \n"
"b    \n"
"     \n"
"     \n"
;
    bitmaps[81] = 
"     \n"
" bbb \n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
"b b b\n"
" bbb \n"
"   b \n"
"     \n"
;
    bitmaps[82] = 
"     \n"
"bbbb \n"
"b   b\n"
"b   b\n"
"bbbb \n"
"b b  \n"
"b  b \n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[83] = 
"     \n"
" bbb \n"
"b   b\n"
"b    \n"
" bbb \n"
"    b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[84] = 
"     \n"
"bbbbb\n"
"  b  \n"
"  b  \n"
"  b  \n"
"  b  \n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
;
    bitmaps[85] = 
"     \n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
"b   b\n"
" bbb \n"
"     \n"
"     \n"
;
    bitmaps[86] = 
"     \n"
"b   b\n"
"b   b\n"
"b   b\n"
" b b \n"
" b b \n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
;
    bitmaps[87] = 
"       \n"
"b     b\n"
"b     b\n"
" b b b \n"
" b b b \n"
"  b b  \n"
"  b b  \n"
"  b b  \n"
"       \n"
"       \n"
;
    bitmaps[88] = 
"     \n"
"b   b\n"
"b   b\n"
" b b \n"
"  b  \n"
" b b \n"
"b   b\n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[89] = 
"     \n"
"b   b\n"
"b   b\n"
" b b \n"
"  b  \n"
"  b  \n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
;
    bitmaps[90] = 
"    \n"
"bbbb\n"
"   b\n"
"  b \n"
" b  \n"
"b   \n"
"b   \n"
"bbbb\n"
"    \n"
"    \n"
;
    bitmaps[91] = 
"bb \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
"b  \n"
"bb \n"
"   \n"
;
    bitmaps[92] = 
"b   \n"
"b   \n"
" b  \n"
" b  \n"
"  b \n"
"  b \n"
"   b\n"
"   b\n"
"    \n"
"    \n"
;
    bitmaps[93] = 
" bb\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
" bb\n"
"   \n"
;
    bitmaps[94] = 
"   \n"
" b \n"
"b b\n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
"   \n"
;
    bitmaps[95] = 
"      \n"
"      \n"
"      \n"
"      \n"
"      \n"
"      \n"
"      \n"
"bbbbbb\n"
"      \n"
"      \n"
;
    bitmaps[96] = 
"  \n"
"b \n"
" b\n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
"  \n"
;
    bitmaps[97] = 
"    \n"
"    \n"
"    \n"
" bb \n"
"   b\n"
" bbb\n"
"b  b\n"
" bbb\n"
"    \n"
"    \n"
;
    bitmaps[98] = 
"    \n"
"b   \n"
"b   \n"
"bbb \n"
"b  b\n"
"b  b\n"
"b  b\n"
"bbb \n"
"    \n"
"    \n"
;
    bitmaps[99] = 
"    \n"
"    \n"
"    \n"
" bb \n"
"b  b\n"
"b   \n"
"b  b\n"
" bb \n"
"    \n"
"    \n"
;
    bitmaps[100] = 
"    \n"
"   b\n"
"   b\n"
" bbb\n"
"b  b\n"
"b  b\n"
"b  b\n"
" bbb\n"
"    \n"
"    \n"
;
    bitmaps[101] = 
"    \n"
"    \n"
"    \n"
" bb \n"
"b  b\n"
"bbbb\n"
"b   \n"
" bb \n"
"    \n"
"    \n"
;
    bitmaps[102] = 
"    \n"
"  bb\n"
" b  \n"
"bbb \n"
" b  \n"
" b  \n"
" b  \n"
" b  \n"
"    \n"
"    \n"
;
    bitmaps[103] = 
"    \n"
"    \n"
"    \n"
" bbb\n"
"b  b\n"
"b  b\n"
"b  b\n"
" bbb\n"
"   b\n"
" bb \n"
;
    bitmaps[104] = 
"    \n"
"b   \n"
"b   \n"
"bbb \n"
"b  b\n"
"b  b\n"
"b  b\n"
"b  b\n"
"    \n"
"    \n"
;
    bitmaps[105] = 
"  \n"
" b\n"
"  \n"
"bb\n"
" b\n"
" b\n"
" b\n"
" b\n"
"  \n"
"  \n"
;
    bitmaps[106] = 
"   \n"
"  b\n"
"   \n"
" bb\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"  b\n"
"bb \n"
;
    bitmaps[107] = 
"    \n"
"b   \n"
"b   \n"
"b  b\n"
"b b \n"
"bb  \n"
"b b \n"
"b  b\n"
"    \n"
"    \n"
;
    bitmaps[108] = 
"  \n"
"bb\n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
" b\n"
"  \n"
"  \n"
;
    bitmaps[109] = 
"       \n"
"       \n"
"       \n"
"bbb bb \n"
"b  b  b\n"
"b  b  b\n"
"b  b  b\n"
"b  b  b\n"
"       \n"
"       \n"
;
    bitmaps[110] = 
"    \n"
"    \n"
"    \n"
"bbb \n"
"b  b\n"
"b  b\n"
"b  b\n"
"b  b\n"
"    \n"
"    \n"
;
    bitmaps[111] = 
"    \n"
"    \n"
"    \n"
" bb \n"
"b  b\n"
"b  b\n"
"b  b\n"
" bb \n"
"    \n"
"    \n"
;
    bitmaps[112] = 
"    \n"
"    \n"
"    \n"
"bbb \n"
"b  b\n"
"b  b\n"
"b  b\n"
"bbb \n"
"b   \n"
"b   \n"
;
    bitmaps[113] = 
"    \n"
"    \n"
"    \n"
" bbb\n"
"b  b\n"
"b  b\n"
"b  b\n"
" bbb\n"
"   b\n"
"   b\n"
;
    bitmaps[114] = 
"    \n"
"    \n"
"    \n"
"b bb\n"
"bb  \n"
"b   \n"
"b   \n"
"b   \n"
"    \n"
"    \n"
;
    bitmaps[115] = 
"    \n"
"    \n"
"    \n"
" bbb\n"
"b   \n"
" bb \n"
"   b\n"
"bbb \n"
"    \n"
"    \n"
;
    bitmaps[116] = 
"   \n"
" b \n"
" b \n"
"bbb\n"
" b \n"
" b \n"
" b \n"
"  b\n"
"   \n"
"   \n"
;
    bitmaps[117] = 
"    \n"
"    \n"
"    \n"
"b  b\n"
"b  b\n"
"b  b\n"
"b  b\n"
" bbb\n"
"    \n"
"    \n"
;
    bitmaps[118] = 
"     \n"
"     \n"
"     \n"
"b   b\n"
" b b \n"
" b b \n"
"  b  \n"
"  b  \n"
"     \n"
"     \n"
;
    bitmaps[119] = 
"       \n"
"       \n"
"       \n"
"b     b\n"
" b b b \n"
" b b b \n"
"  b b  \n"
"  b b  \n"
"       \n"
"       \n"
;
    bitmaps[120] = 
"     \n"
"     \n"
"     \n"
"b   b\n"
" b b \n"
"  b  \n"
" b b \n"
"b   b\n"
"     \n"
"     \n"
;
    bitmaps[121] = 
"    \n"
"    \n"
"    \n"
"b  b\n"
"b  b\n"
"b  b\n"
"b  b\n"
" bbb\n"
"   b\n"
" bb \n"
;
    bitmaps[122] = 
"    \n"
"    \n"
"    \n"
"bbbb\n"
"  b \n"
" b  \n"
"b   \n"
"bbbb\n"
"    \n"
"    \n"
;
    bitmaps[123] = 
"  b\n"
" b \n"
" b \n"
" b \n"
"b  \n"
" b \n"
" b \n"
" b \n"
"  b\n"
"   \n"
;
    bitmaps[124] = 
"b\n"
"b\n"
"b\n"
"b\n"
"b\n"
"b\n"
"b\n"
"b\n"
"b\n"
" \n"
;
    bitmaps[125] = 
"b  \n"
" b \n"
" b \n"
" b \n"
"  b\n"
" b \n"
" b \n"
" b \n"
"b  \n"
"   \n"
;
    bitmaps[126] = 
"     \n"
" bb b\n"
"b bb \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
"     \n"
;
        for (int i=0; i<256; i++) {
            if (!bitmaps[i]) {
                bitmaps[i] = default_bitmap;
            }
        }
        first = NO;
    }
    return bitmaps;
}
@end

