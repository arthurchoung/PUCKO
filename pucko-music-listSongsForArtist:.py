#!/usr/bin/python3

import functools
import os
import mutagen.mp4
import mutagen.mp3
import urllib.parse
import sys

if len(sys.argv) < 2:
    print("specify artist, or '' for all artists", file=sys.stderr)
    sys.exit(1)
matchArtist = sys.argv[1]

allSongs = []

files = os.listdir()
for file in files:
    if not os.path.isfile(file):
        continue

    artist = ''
    album = ''
    name = ''
    track = ''

    lcfile = file.lower()
    if lcfile.endswith('.m4a'):
        try:
            obj = mutagen.mp4.MP4(file)
        except:
            continue
        keys = obj.keys()

        if '\xa9ART' in keys:
            artist = obj['\xa9ART'][0]
        if '\xa9alb' in keys:
            album = obj['\xa9alb'][0]
        if '\xa9nam' in keys:
            name = obj['\xa9nam'][0]
        if 'trkn' in keys:
            track = str(obj['trkn'][0][0])
#        if 'covr' in keys:
#            coverart = obj['covr'][0]
#            imageformat = coverart.imageformat
#            if imageformat == mutagen.mp4.MP4Cover.FORMAT_JPEG:
#                coverartjpeg = base64.b64encode(coverart).decode('ascii')
#            elif imageformat == mutagen.mp4.MP4Cover.FORMAT_PNG:
#                coverartpng = base64.b64encode(coverart).decode('ascii')
    elif lcfile.endswith('.mp3'):
        try:
            obj = mutagen.mp3.MP3(file)
        except:
            continue
        keys = obj.keys()
        if 'TPE1' in keys:
            artist = str(obj['TPE1'])
        if 'TALB' in keys:
            album = str(obj['TALB'])
        if 'TIT2' in keys:
            name = str(obj['TIT2'])
        if 'TRCK' in keys:
            track = str(obj['TRCK'])
#        if 'APIC:' in keys:
#            coverart = obj['APIC:'].data

    if not artist:
        artist = "Unknown Artist"

    if not album:
        album = "Unknown Album"

    if matchArtist:
        if matchArtist != artist:
            continue

    if not name:
        name = file

    elt = {}
    elt['artist'] = artist
    elt['album'] = album
    elt['name'] = name
    elt['file'] = file
    allSongs.append(elt)

def mycompare(a, b):
    lca = a['name'].lower()
    lcb = b['name'].lower()
    if lca[0].isalpha() and lcb[0].isalpha():
        if lca < lcb:
            return -1
        elif lca > lcb:
            return 1
        else:
            return 0
    elif lca[0].isalpha():
        return -1
    elif lcb[0].isalpha():
        return 1
    else:
        if lca < lcb:
            return -1
        elif lca > lcb:
            return 1
        else:
            return 0

allSongs = sorted(allSongs, key=functools.cmp_to_key(mycompare))

for elt in allSongs:
    artist = elt['artist']
    album = elt['album']
    name = elt['name']
    file = elt['file']

    detail = ''
    if artist and album:
        detail = "%s - %s" % (artist, album)
    elif artist:
        detail = artist
    elif album:
        detail = album

    name = urllib.parse.quote(name)
    detail = urllib.parse.quote(detail)
    file = urllib.parse.quote(file)
    print("name:%s detail:%s path:%s" % (name, detail, file))

