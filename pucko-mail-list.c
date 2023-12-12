/*

 PUCKO Web

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Web.

 PUCKO Web is free software: you can redistribute it and/or modify
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

/*

 This file was originally basic-example.c from the GMime library,
 but has been modified.

*/

/* -*- Mode: C; tab-width: 8; indent-tabs-mode: t; c-basic-offset: 8 -*- */
/*  GMime
 *  Copyright (C) 2000-2020 Jeffrey Stedfast
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */


#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <glib.h>
#include <gmime/gmime.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#include <ctype.h>

static void normalize_whitespace(char *str)
{
    char *p = str;
    char *q = p;
    for(;;) {
        if (!*p) {
            *q = 0;
            break;
        }
        if ((*p != ' ') && isspace(*p)) {
            *q = ' ';
        } else {
            *q = *p;
        }
        p++;
        q++;
    }
}

static void shrink_whitespace(char *str)
{
    char *p = str;
    char *q = p;
    char prev = 0;
    for(;;) {
        if (!*p) {
            *q = 0;
            break;
        }
        if ((prev == ' ') && (*p == ' ')) {
            p++;
        } else {
            prev = *p;
            *q = *p;
            p++;
            q++;
        }
    }
}

static void strip_unprintable_chars(unsigned char *str)
{
    char *p = str;
    char *q = p;
    for(;;) {
        if (!*p) {
            *q = 0;
            break;
        }
        if (isprint(*p)) {
            *q = *p;
            p++;
            q++;
        } else {
            p++;
        }
    }
}

static void attachment_callback(GMimeObject *parent, GMimeObject *part, gpointer user_data)
{
	/* 'part' points to the current part node that
	 * g_mime_message_foreach() is iterating over */
	
	/* find out what class 'part' is... */
	if (GMIME_IS_MESSAGE_PART (part)) {
		/* message/rfc822 or message/news */
		GMimeMessage *message;
		
		/* g_mime_message_foreach() won't descend into
                   child message parts, so if we want to count any
                   subparts of this child message, we'll have to call
                   g_mime_message_foreach() again here. */
		
		message = g_mime_message_part_get_message ((GMimeMessagePart *) part);
		g_mime_message_foreach (message, attachment_callback, user_data);
	} else if (GMIME_IS_MESSAGE_PARTIAL (part)) {
		/* message/partial */
		
		/* this is an incomplete message part, probably a
                   large message that the sender has broken into
                   smaller parts and is sending us bit by bit. we
                   could save some info about it so that we could
                   piece this back together again once we get all the
                   parts? */
	} else if (GMIME_IS_MULTIPART (part)) {
		/* multipart/mixed, multipart/alternative,
		 * multipart/related, multipart/signed,
		 * multipart/encrypted, etc... */
		
		/* we'll get to finding out if this is a
		 * signed/encrypted multipart later... */
	} else if (GMIME_IS_PART (part)) {
		/* a normal leaf part, could be text/plain or
		 * image/jpeg etc */
        GMimeContentType *content_type = g_mime_object_get_content_type(part);
        char *mime_type = g_mime_content_type_get_mime_type(content_type);
        if (mime_type) {
            if (g_mime_part_is_attachment((GMimePart *)part)) {
                int *count = user_data;
                (*count)++;
            }
        }
	} else {
		g_assert_not_reached ();
	}
}
static void
foreach_callback (GMimeObject *parent, GMimeObject *part, gpointer user_data)
{
    int *result = user_data;
    if (*result) {
        return;
    }

	/* 'part' points to the current part node that
	 * g_mime_message_foreach() is iterating over */
	
	/* find out what class 'part' is... */
	if (GMIME_IS_MESSAGE_PART (part)) {
		/* message/rfc822 or message/news */
		GMimeMessage *message;
		
		/* g_mime_message_foreach() won't descend into
                   child message parts, so if we want to count any
                   subparts of this child message, we'll have to call
                   g_mime_message_foreach() again here. */
		
		message = g_mime_message_part_get_message ((GMimeMessagePart *) part);
		g_mime_message_foreach (message, foreach_callback, NULL);
	} else if (GMIME_IS_MESSAGE_PARTIAL (part)) {
		/* message/partial */
		
		/* this is an incomplete message part, probably a
                   large message that the sender has broken into
                   smaller parts and is sending us bit by bit. we
                   could save some info about it so that we could
                   piece this back together again once we get all the
                   parts? */
	} else if (GMIME_IS_MULTIPART (part)) {
		/* multipart/mixed, multipart/alternative,
		 * multipart/related, multipart/signed,
		 * multipart/encrypted, etc... */
		
		/* we'll get to finding out if this is a
		 * signed/encrypted multipart later... */
	} else if (GMIME_IS_PART (part)) {
		/* a normal leaf part, could be text/plain or
		 * image/jpeg etc */
        GMimeContentType *content_type = g_mime_object_get_content_type(part);
        char *mime_type = g_mime_content_type_get_mime_type(content_type);
        if (mime_type) {
            if (!strcasecmp(mime_type, "text/plain")) {
                GMimeDataWrapper *content = g_mime_part_get_content((GMimePart *)part);
                GMimeStreamMem *stream = (GMimeStreamMem *)g_mime_stream_mem_new();
                g_mime_data_wrapper_write_to_stream(content, (GMimeStream *)stream);
                GByteArray *bytearray = g_mime_stream_mem_get_byte_array(stream);
                char buf[161];
                int len = 0;
                if (bytearray->len > 0) {
                    if (bytearray->len > 160) {
                        len = 160;
                    } else {
                        len = bytearray->len;
                    }
                    memcpy(buf, bytearray->data, len);
                }
                buf[len] = 0;
                strip_unprintable_chars(buf);
                normalize_whitespace(buf);
                shrink_whitespace(buf);
                printf("preview:%s\n", buf);
                g_object_unref (stream);
                (*result)++;
            }
        }
	} else {
		g_assert_not_reached ();
	}
}

static GMimeMessage *parse_message(int fd)
{
	GMimeMessage *message;
	GMimeParser *parser;
	GMimeStream *stream;
	
	/* create a stream to read from the file descriptor */
	stream = g_mime_stream_fs_new (fd);
	
	/* create a new parser object to parse the stream */
	parser = g_mime_parser_new_with_stream (stream);
	
	/* unref the stream (parser owns a ref, so this object does not actually get free'd until we destroy the parser) */
	g_object_unref (stream);
	
	/* parse the message from the stream */
	message = g_mime_parser_construct_message (parser, NULL);
	
	/* free the parser (and the stream) */
	g_object_unref (parser);
	
	return message;
}

static int handle_path(char *path)
{
    int fd = open(path, O_RDONLY, 0);
    if (fd == -1) {
        fprintf(stderr, "Cannot open message `%s': %s\n", path, g_strerror(errno));
        return 0;
    }
    
    /* parse the message */
    GMimeMessage *message = parse_message (fd);
    if (message == NULL) {
        close(fd);
        fprintf(stderr, "Error parsing message\n");
        return 0;
    }
    
    InternetAddressList *from = g_mime_message_get_from(message);
    char *fromstr = NULL;
    if (from) {
        fromstr = internet_address_list_to_string(from, NULL, FALSE);
    }
    const char *subject = g_mime_message_get_subject(message);
    GDateTime *date = g_mime_message_get_date(message);
    char datebuf[1024];
    datebuf[0] = 0;
    if (date) {
        GDateTime *localdate = g_date_time_to_local(date);
        if (localdate) {
            int year = g_date_time_get_year(localdate);
            int month = g_date_time_get_month(localdate);
            int day = g_date_time_get_day_of_month(localdate);
            time_t timestamp;
            time(&timestamp);
            struct tm *tm = localtime(&timestamp);
            if (year == tm->tm_year+1900) {
                if (month == tm->tm_mon+1) {
                    if (day == tm->tm_mday) {
                        int hour = g_date_time_get_hour(localdate);
                        int minute = g_date_time_get_minute(localdate);
                        if (hour == 12) {
                            sprintf(datebuf, "12:%.2d PM", minute);
                        } else if (hour == 0) {
                            sprintf(datebuf, "12:%.2d AM", minute);
                        } else if (hour > 12) {
                            sprintf(datebuf, "%d:%.2d PM", hour%12, minute);
                        } else {
                            sprintf(datebuf, "%d:%.2d AM", hour, minute);
                        }
                    }
                }
            }
            if (!datebuf[0]) {
                sprintf(datebuf, "%d/%.2d/%.2d", day, month, year%100);
            }
            g_date_time_unref(localdate);
        }
    }
    printf("name:%s\n", path);
    printf("date:%s\n", datebuf);
    printf("from:%s\n", fromstr);
    if (subject) {
        char *subjectstr = strdup(subject);
        strip_unprintable_chars(subjectstr);
        normalize_whitespace(subjectstr);
        printf("subject:%s\n", subjectstr);
        free(subjectstr);
    } else {
        printf("subject:\n");
    }
    if (fromstr) {
        g_free(fromstr);
    }

    int attachments = 0;
    g_mime_message_foreach(message, attachment_callback, &attachments);
    printf("attachments:%d\n", attachments);

    printf("unseen:%d\n", (strtol(path, NULL, 10) % 2 == 0));

    int done = 0;
	g_mime_message_foreach(message, foreach_callback, &done);

    printf("\n");

    /* free the mesage */
    g_object_unref (message);

    return 1;
}

int main(int argc, char **argv)
{
	/* init the gmime library */
	g_mime_init ();

	if (argc >= 2) {
        for (int i=1; i<argc; i++) {
            handle_path(argv[i]);
        }
    } else {
        char buf[1024];
        while (fgets(buf, 1024, stdin)) {
            char *p = strchr(buf, '\n');
            if (p) {
                *p = 0;
            }
            if (buf[0]) {
                handle_path(buf);
            }
        }
    }
	
	return 0;
}
