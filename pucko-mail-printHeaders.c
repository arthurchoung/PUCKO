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

static GMimeMessage *
parse_message (int fd)
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


int main (int argc, char **argv)
{
	GMimeMessage *message;
	int fd;
	
	if (argc < 2) {
		fprintf(stderr, "Usage: %s <message file>\n", argv[0]);
		return 0;
	}

    char *path = argv[1];

	if ((fd = open (path, O_RDONLY, 0)) == -1) {
		fprintf(stderr, "Cannot open message `%s': %s\n", path, g_strerror (errno));
		return 0;
	}
	
	/* init the gmime library */
	g_mime_init ();
	
	/* parse the message */
	message = parse_message (fd);
	if (message == NULL) {
		fprintf(stderr, "Error parsing message\n");
		return 1;
	}
	
    InternetAddressList *from = g_mime_message_get_from(message);
    char *fromstr = NULL;
    if (from) {
        fromstr = internet_address_list_to_string(from, NULL, FALSE);
    }
    InternetAddressList *to = g_mime_message_get_to(message);
    char *tostr = NULL;
    if (to) {
        tostr = internet_address_list_to_string(to, NULL, FALSE);
    }
    const char *subject = g_mime_message_get_subject(message);
    GDateTime *date = g_mime_message_get_date(message);
    char *datestr = NULL;
    if (date) {
        datestr = g_date_time_format(date, "%c");
    }
    printf("File: %s\n", path);
    printf("Date: %s\n", datestr);
    printf("From: %s\n", fromstr);
    printf("To: %s\n", tostr);
    printf("Subject: %s\n", subject);
    if (fromstr) {
        g_free(fromstr);
    }
    if (datestr) {
        g_free(datestr);
    }

	/* free the mesage */
	g_object_unref (message);
	
	return 0;
}
