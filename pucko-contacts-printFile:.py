#!/usr/bin/python3

import sys
import re
import vobject
import urllib.parse

path = ''
data = None
if len(sys.argv) < 2:
    data = sys.stdin.read()
else:
    path = sys.argv[1]
    f = open(path, 'r')
    data = f.read()
    f.close()

vcard = vobject.readOne(data)

try:
    for a in vcard.contents['fn']:
        text = urllib.parse.quote(a.value)
        print("fullName:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['org']:
        for b in a.value:
            text = urllib.parse.quote(b)
            print("company:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['photo']:
        text = a.value
        try:
            params = a.params['TYPE']
            params = ["(%s)" % (item) for item in params]
            text += ' '
            text += ' '.join(params)
        except:
            pass
        text = urllib.parse.quote(text)
        print("photo:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['bday']:
        text = urllib.parse.quote(a.value)
        print("birthday:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['tel']:
        text = a.value
        try:
            params = a.params['TYPE']
            params = ['(preferred)' if item == 'pref' else "(%s)" % (item) for item in params]
            text += ' '
            text += ' '.join(params)
        except:
            pass
        text = urllib.parse.quote(text)
        print("phone:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['adr']:
        text = "%s" % (a.value)
        try:
            params = a.params['TYPE']
            params = ['(preferred)' if item == 'pref' else "(%s)" % (item) for item in params]
            text += ' '
            text += ' '.join(params)
        except:
            pass
        text = urllib.parse.quote(text)
        print("address:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['email']:
        text = a.value
        try:
            params = a.params['TYPE']
            params = ['(preferred)' if item == 'pref' else "(%s)" % (item) for item in params]
            text += ' '
            text += ' '.join(params)
        except:
            pass
        text = urllib.parse.quote(text)
        print("email:%s" % (text))
except:
    pass

try:
    for a in vcard.contents['version']:
        text = urllib.parse.quote(a.value)
        print("version:%s" % (text))
except:
    pass

