#!/usr/bin/python3

import functools
import os
import mutagen.mp4
import mutagen.mp3
import urllib.parse
import base64
import PIL.Image
import io
import sys


if len(sys.argv) < 2:
    print("specify album", file=sys.stderr)
    sys.exit(1)
matchAlbum = sys.argv[1]

allTracks = []
albumName = ''
albumArtist = ''
albumCoverart = ''
albumRelease = ''
albumDuration = 0.0

files = os.listdir()
for file in files:
    if not os.path.isfile(file):
        continue

    artist = ''
    album = ''
    name = ''
    track = ''
    coverart = ''
    duration = 0.0
    releasedate = ''

    lcfile = file.lower()
    if lcfile.endswith('.m4a'):
        try:
            obj = mutagen.mp4.MP4(file)
        except:
            continue
        keys = obj.keys()

        duration = obj.info.length
        if '\xa9ART' in keys:
            artist = obj['\xa9ART'][0]
        if '\xa9alb' in keys:
            album = obj['\xa9alb'][0]
        if '\xa9nam' in keys:
            name = obj['\xa9nam'][0]
        if 'trkn' in keys:
            track = str(obj['trkn'][0][0])
        if 'covr' in keys:
            coverart = obj['covr'][0]
        if '\xa9day' in keys:
            releasedate = obj['\xa9day'][0]
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

        duration = obj.info.length
        if 'TPE1' in keys:
            artist = str(obj['TPE1'])
        if 'TALB' in keys:
            album = str(obj['TALB'])
        if 'TIT2' in keys:
            name = str(obj['TIT2'])
        if 'TRCK' in keys:
            track = str(obj['TRCK'])
        if 'APIC:' in keys:
            coverart = obj['APIC:'].data
        if 'TDRC' in keys:
            releasedate = str(obj['TDRC'])

    if not artist:
        artist = "Unknown Artist"

    if not album:
        album = "Unknown Album"

    if not name:
        name = file

    if matchAlbum:
        if matchAlbum != album:
            continue

    albumName = album
    albumArtist = artist
    if coverart:
        albumCoverart = coverart
    if releasedate:
        albumRelease = releasedate
    albumDuration += duration

    elt = {}
    elt['artist'] = artist
    elt['album'] = album
    elt['name'] = name
    elt['track'] = track
    elt['file'] = file
    elt['releasedate'] = releasedate
    elt['duration'] = duration
    allTracks.append(elt)

def parseint(a):
    result = ''
    i = 0
    n = len(a)
    while i < n:
        if a[i].isdigit():
            result += a[i]
        elif a[i].isspace():
            if result:
                break
        else:
            break
        i += 1
    if not result:
        return 0
    return int(result)

def mycompare(a, b):
    tracka = parseint(a['track'])
    trackb = parseint(b['track'])
    if tracka < trackb:
        return -1
    elif tracka > trackb:
        return 1
    lca = a['name'].lower()
    lcb = b['name'].lower()
    if lca < lcb:
        return -1
    elif lca > lcb:
        return 1
    else:
        return 0


allTracks = sorted(allTracks, key=functools.cmp_to_key(mycompare))

coverart = ''
if albumCoverart:
    inputdata = io.BytesIO(albumCoverart)
    try:
        image = PIL.Image.open(inputdata)
        image = image.resize((120, 120))
        outputdata = io.BytesIO()
        image.save(outputdata, 'PPM')
        coverart = base64.b64encode(outputdata.getvalue()).decode('ascii')
    except:
        pass

albumRelease = parseint(albumRelease)
name = "%s\n%s" % (albumName, albumArtist)
numberOfSongs = ''
if len(allTracks) == 1:
    numberOfSongs = '1 Song'
else:
    numberOfSongs = '%d Songs' % (len(allTracks))
duration = ''
if int(albumDuration) < 60:
    duration = "%d Secs" % (int(albumDuration))
else:
    duration = "%d Mins" % ((int(albumDuration)+59)/60)
detail = ''
if albumRelease:
    detail += "Released %d\n" % (albumRelease)
detail += "%s, %s." % (numberOfSongs, duration)

name = urllib.parse.quote(name)
detail = urllib.parse.quote(detail)
print("name:%s detail:%s coverart:%s" % (name, detail, coverart))

for elt in allTracks:
    artist = elt['artist']
    album = elt['album']
    name = elt['name']
    track = str(parseint(elt['track']))
    file = elt['file']
    duration = '-:--'
    if track == '0':
        track = '-'
    if elt['duration']:
        duration = "%d:%.2d" % (int(elt['duration']) / 60, int(elt['duration']) % 60)

    track = urllib.parse.quote(track)
    name = urllib.parse.quote(name)
    duration = urllib.parse.quote(duration)
    file = urllib.parse.quote(file)

    print("track:%s name:%s duration:%s path:%s releasedate:%s" % (track, name, duration, file, releasedate))

