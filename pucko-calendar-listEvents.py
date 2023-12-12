#!/usr/bin/python3

import os
import sys
import vobject
import urllib.parse

for path in os.listdir('.'):
    if not path.lower().endswith('.ics'):
        continue
    cal = None
    try:
        with open(path, 'r') as f:
            cal = vobject.readOne(f.read())
    except:
        pass
    if not cal:
        continue
    summary = cal.vevent.summary.value
    summary = urllib.parse.quote(summary)

    dtstart = cal.vevent.dtstart.value
    day = dtstart.day
    month = dtstart.month
    year = dtstart.year
    print("year:%d month:%d day:%d color:yellow text:%s" % (year, month, day, summary))

