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

static char *_backtitle = NULL;
static char *_title = NULL;
static char *_msgbox = NULL;
static char *_x = NULL;
static char *_y = NULL;
static char *_z = NULL;
static char *_infobox = NULL;
static char *_yes_label = NULL;
static char *_no_label = NULL;
static int _defaultno = 0;
static char *_yesno = NULL;
static int _stdout = 0;
static char *_checklist = NULL;
static char *_menu = NULL;
static char *_default_item = NULL;
static char *_ok_label = NULL;
static char *_cancel_label = NULL;
static int _clear = 0;
static char *_form = NULL;
static char *_height = NULL;
static char *_width = NULL;
static char *_formheight = NULL;
static int _no_cancel = 0;
static char *_passwordform = NULL;
static int _insecure = 0;
static char *_programbox = NULL;
static char *_tailbox = NULL;
static char *_textbox = NULL;
static char *_inputbox = NULL;
static char *_exit_label = NULL;
static int _item_help = 0;
static int _colors = 0;
static char *_extra_label = NULL;

static void unescape_newlines(char *str)
{
    char *p = str;
    char *q = p;
    for(;;) {
        if (!*p) {
            break;
        }
        if (*p == '\\') {
            p++;
            if (!*p) {
                break;
            } else if (*p == 'n') {
                p++;
                *q++ = '\n';
                continue;
            } else if (*p == '\\') {
                p++;
                *q++ = '\\';
                continue;
            } else {
                *q++ = '\\';
                *q++ = *p++;
                continue;
            }
        }
        *q++ = *p++;
    }
    *q = 0;
}

@implementation Definitions(fjkdlsjfkldsjflksdjfisdnmfilewv)
+ (void)dialog:(char *)classPrefix :(int)argc :(char **)argv
{
    int i = 0;
    while (i < argc) {
        if (!strcmp(argv[i], "--backtitle")) {
            if (i+1 < argc) {
                i++;
                _backtitle = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--title")) {
            if (i+1 < argc) {
                i++;
                _title = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--msgbox")) {
            if (i+3 < argc) {
                i++;
                _msgbox = argv[i++];
                _x = argv[i++];
                _y = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--infobox")) {
            if (i+3 < argc) {
                i++;
                _infobox = argv[i++];
                _x = argv[i++];
                _y = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--yes-label")) {
            if (i+1 < argc) {
                i++;
                _yes_label = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--no-label")) {
            if (i+1 < argc) {
                i++;
                _no_label = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--defaultno")) {
            _defaultno = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--yesno")) {
            if (i+3 < argc) {
                i++;
                _yesno = argv[i++];
                _x = argv[i++];
                _y = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--stdout")) {
            _stdout = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--checklist")) {
            if (i+4 < argc) {
                i++;
                _checklist = argv[i++];
                _x = argv[i++];
                _y = argv[i++];
                _z = argv[i++];
                break;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--menu")) {
            if (i+4 < argc) {
                i++;
                _menu = argv[i++];
                _x = argv[i++];
                _y = argv[i++];
                _z = argv[i++];
                break;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--default-item")) {
            if (i+1 < argc) {
                i++;
                _default_item = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--ok-label")) {
            if (i+1 < argc) {
                i++;
                _ok_label = argv[i++];
                continue;
            }
            goto error;
        }
        if (
            !strcmp(argv[i], "--cancel-label")
            || !strcmp(argv[i], "--cancel-button")
        ) {
            if (i+1 < argc) {
                i++;
                _cancel_label = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--extra-label")) {
            if (i+1 < argc) {
                i++;
                _extra_label = argv[i++];
                continue;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--clear")) {
            _clear = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--no-cancel")) {
            _no_cancel = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--form")) {
            if (i+4 < argc) {
                i++;
                _form = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                _formheight = argv[i++];
                break;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--passwordform")) {
            if (i+4 < argc) {
                i++;
                _passwordform = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                _formheight = argv[i++];
                break;
            }
            goto error;
        }
        if (!strcmp(argv[i], "--insecure")) {
            _insecure = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--programbox")) {
            if (i+3 < argc) {
                i++;
                _programbox = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                break;
            }
            if (i+2 < argc) {
                i++;
                _programbox = "";
                _height = argv[i++];
                _width = argv[i++];
                break;
            }
        }
        if (!strcmp(argv[i], "--tailbox")) {
            if (i+3 < argc) {
                i++;
                _tailbox = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                break;
            }
        }
        if (!strcmp(argv[i], "--textbox")) {
            if (i+3 < argc) {
                i++;
                _textbox = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                break;
            }
        }
        if (!strcmp(argv[i], "--inputbox")) {
            if (i+3 < argc) {
                i++;
                _inputbox = argv[i++];
                _height = argv[i++];
                _width = argv[i++];
                break;
            }
        }
        if (!strcmp(argv[i], "--exit-label")) {
            if (i+1 < argc) {
                i++;
                _exit_label = argv[i++];
                continue;
            }
        }
        if (!strcmp(argv[i], "--item-help")) {
            _item_help = 1;
            i++;
            continue;
        }
        if (!strcmp(argv[i], "--colors")) {
            _colors = 1;
            i++;
            continue;
        }

        goto error;
	}

    if (_msgbox) {
        unescape_newlines(_msgbox);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _msgbox)];
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sAlert", classPrefix) asInstance];
        [obj setValue:str forKey:@"text"];
        [obj setValue:@"OK" forKey:@"okText"];
        [obj setValue:@"1" forKey:@"dialogMode"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_infobox) {
        daemon(1, 0);

        unescape_newlines(_infobox);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _infobox)];
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sAlert", classPrefix) asInstance];
        [obj setValue:@"1" forKey:@"x11WaitForFocusOutThenClose"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:@"1" forKey:@"dialogMode"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }
    if (_yesno) {
        unescape_newlines(_yesno);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _yesno)];
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sAlert", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", 1) forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:nsfmt(@"%s", (_yes_label) ? _yes_label : "Yes") forKey:@"okText"];
        [obj setValue:nsfmt(@"%s", (_no_label) ? _no_label : "No") forKey:@"cancelText"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_checklist) {
        unescape_newlines(_checklist);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _checklist)];
        id str = [arr join:@"\n"];
        arr = nsarr();
        if (_item_help) {
            for (int j=i; j+3<argc; j+=4) {
                id elt = nsdict();
                [elt setValue:nsfmt(@"%s", argv[j]) forKey:@"tag"];
                [elt setValue:nsfmt(@"%s", argv[j+1]) forKey:@"text"];
                [elt setValue:nsfmt(@"%s", argv[j+2]) forKey:@"status"];
                [elt setValue:nsfmt(@"%s", argv[j+3]) forKey:@"help"];
                [arr addObject:elt];
            }
        } else {
            for (int j=i; j+2<argc; j+=3) {
                id elt = nsdict();
                [elt setValue:nsfmt(@"%s", argv[j]) forKey:@"tag"];
                [elt setValue:nsfmt(@"%s", argv[j+1]) forKey:@"text"];
                [elt setValue:nsfmt(@"%s", argv[j+2]) forKey:@"status"];
                [arr addObject:elt];
            }
        }
        id obj = [nsfmt(@"%sChecklist", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", (_stdout) ? 1 : 2) forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:arr forKey:@"array"];
        [obj setValue:@"OK" forKey:@"okText"];
        [obj setValue:@"Cancel" forKey:@"cancelText"];
        for (int i=0; i<[arr count]; i++) {
            id elt = [arr nth:i];
            if ([[[elt valueForKey:@"status"] lowercaseString] isEqual:@"on"]) {
                [obj setChecked:YES forIndex:i];
            }
        }
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_menu) {
        unescape_newlines(_menu);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _menu)];
        id str = [arr join:@"\n"];
        arr = nsarr();
        for (int j=i; j+1<argc; j+=2) {
            id elt = nsdict();
            [elt setValue:nsfmt(@"%s", argv[j]) forKey:@"tag"];
            [elt setValue:nsfmt(@"%s", argv[j+1]) forKey:@"text"];
            [arr addObject:elt];
        }
        id obj = [nsfmt(@"%sRadio", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", (_stdout) ? 1 : 2) forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:arr forKey:@"array"];
        [obj setValue:@"OK" forKey:@"okText"];
        [obj setValue:@"Cancel" forKey:@"cancelText"];
        if (_default_item) {
            id default_item = nsfmt(@"%s", _default_item);
            for (int j=0; j<[arr count]; j++) {
                id elt = [arr nth:j];
                id tag = [elt valueForKey:@"tag"];
                if ([tag isEqual:default_item]) {
                    [obj setValue:nsfmt(@"%d", j) forKey:@"selectedIndex"];
                    break;
                }
            }
        }
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_form) {
        unescape_newlines(_form);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _form)];
        id str = [arr join:@"\n"];
        id fields = nsarr();
        id buffers = nsarr();
        id readonly = nsarr();
        for (int j=i; j+7<argc; j+=8) {
            char *label = argv[j];
            char *labely = argv[j+1];
            char *labelx = argv[j+2];
            char *item = argv[j+3];
            char *itemy = argv[j+4];
            char *itemx = argv[j+5];
            int flen = atoi(argv[j+6]);
            int ilen = atoi(argv[j+7]);
            if (!ilen) {
                ilen = flen;
            }
            [fields addObject:nsfmt(@"%s", label)];
            [buffers addObject:nsfmt(@"%s", item)];
            [readonly addObject:nsfmt(@"%d", (flen <= 0) ? 1 : 0)];
        }
        id obj = [nsfmt(@"%sTextFields", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", (_stdout) ? 1 : 2) forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:@"OK" forKey:@"okText"];
        [obj setValue:fields forKey:@"fields"];
        [obj setValue:buffers forKey:@"buffers"];
        [obj setValue:readonly forKey:@"readonly"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_passwordform) {
        unescape_newlines(_passwordform);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _passwordform)];
        id str = [arr join:@"\n"];
        id fields = nsarr();
        id buffers = nsarr();
        id readonly = nsarr();
        for (int j=i; j+7<argc; j+=8) {
            char *label = argv[j];
            char *labely = argv[j+1];
            char *labelx = argv[j+2];
            char *item = argv[j+3];
            char *itemy = argv[j+4];
            char *itemx = argv[j+5];
            int flen = atoi(argv[j+6]);
            int ilen = atoi(argv[j+7]);
            if (!ilen) {
                ilen = flen;
            }
            [fields addObject:nsfmt(@"%s", label)];
            [buffers addObject:nsfmt(@"%s", item)];
            [readonly addObject:nsfmt(@"%d", (flen <= 0) ? 1 : 0)];
        }
        id obj = [nsfmt(@"%sTextFields", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", (_stdout) ? 1 : 2) forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:fields forKey:@"fields"];
        [obj setValue:buffers forKey:@"buffers"];
        [obj setValue:readonly forKey:@"readonly"];
        [obj setValue:@"1" forKey:@"hidden"];
        [obj setValue:@"OK" forKey:@"okText"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_programbox) {
        unescape_newlines(_programbox);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _programbox)];
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sProgramBox", classPrefix) asInstance];
        [obj setValue:@"1" forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:@"OK" forKey:@"okText"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_tailbox) {
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
        }
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sTailBox", classPrefix) asInstance];
        [obj setValue:@"1" forKey:@"dialogMode"];
        [obj setValue:str forKey:@"text"];
        [obj setValue:nsfmt(@"%s", _tailbox) forKey:@"path"];
        [obj setValue:@"OK" forKey:@"okText"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_textbox) {
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
        }
        id str = [arr join:@"\n"];
        id obj = [nsfmt(@"%sTailBox", classPrefix) asInstance];
        [obj setValue:str forKey:@"text"];
        [obj setValue:nsfmt(@"%s", _textbox) forKey:@"path"];
        [obj setValue:(_exit_label) ? nsfmt(@"%s", _exit_label) : @"OK" forKey:@"okText"];
        [obj setValue:@"1" forKey:@"dialogMode"];
        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

    if (_inputbox) {
        char *initial = NULL;
        if (i < argc) {
            initial = argv[i];
        }

        unescape_newlines(_inputbox);
        id arr = nsarr();
        if (_backtitle) {
            [arr addObject:nsfmt(@"%s", _backtitle)];
            [arr addObject:@""];
        }
        if (_title) {
            [arr addObject:nsfmt(@"%s", _title)];
            [arr addObject:@""];
        }
        [arr addObject:nsfmt(@"%s", _inputbox)];
        id str = [arr join:@"\n"];

        id obj = [nsfmt(@"%sTextFields", classPrefix) asInstance];
        [obj setValue:nsfmt(@"%d", (_stdout) ? 1 : 2) forKey:@"dialogMode"];

        [obj setValue:str forKey:@"text"];
        [obj setValue:@"OK" forKey:@"okText"];

        id fields = nsarr();
        [fields addObject:@""];
        [obj setValue:fields forKey:@"fields"];

        if (initial) {
            id buffers = nsarr();
            [buffers addObject:nsfmt(@"%s", initial)];
            [obj setValue:buffers forKey:@"buffers"];
        }

        [Definitions runWindowManagerForObject:obj];
        exit(-1);
    }

error:
    NSLog(@"invalid usage");
    for (; i<argc; i++) {
        NSLog(@"argv[%d] %s", i, argv[i]);
if (![Definitions confirmWithAlert:nsfmt(@"argv[%d] %s", i, argv[i])]) {
    break;
}
    }
    exit(-1);
}
@end
