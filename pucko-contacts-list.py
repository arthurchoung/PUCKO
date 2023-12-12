#!/usr/bin/python3

import os
import vobject
import urllib.parse

arr = []

for path in os.listdir('.'):
    if not path.lower().endswith('.vcf'):
        continue
    vcard = None
    try:
        with open(path, 'r') as f:
            vcard = vobject.readOne(f.read())
    except:
        pass
    if not vcard:
        continue
    elt = {}
    arr.append(elt)
    elt['path'] = path
    elt['fullName'] = ''
    try:
        elt['fullName'] = vcard.contents['fn'][0].value
    except:
        pass

#return {vcard.contents['fn'][0].value: [tel.value for tel in vcard.contents['tel']] }

def sortLettersBeforeNumbers(a):
    key = ''
    try:
        key = a['fullName']
    except:
        pass

    order = 'a'
    if len(key) > 0:
        if key[0].isdigit():
            order = 'b'
    else:
        order = 'c'
    return (order, key.lower())

arr = sorted(arr, key=sortLettersBeforeNumbers)

for elt in arr:
    fullName = urllib.parse.quote(elt['fullName'])
    path = urllib.parse.quote(elt['path'])
    print("name:%s path:%s" % (fullName, path))

