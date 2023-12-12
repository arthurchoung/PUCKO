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

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <fcntl.h>
#include <termios.h>

#define DIGITCHARS "1234567890"

#define BUFSIZE 1024

static char _buf[BUFSIZE];
static FILE *_infp;
static FILE *_outfp;

static void die(char *fmt, ...)
{
    va_list args;
    fprintf(stderr, "Died: ");
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fprintf(stderr, "\n");
    exit(1);
}

static void debuglog(char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fprintf(stderr, "\n");
}

static void read_line()
{
    if (!fgets(_buf, BUFSIZE, _infp)) {
        die("Unable to read line");
    }
debuglog("recv '%s'", _buf);
}

static void write_string(char *fmt, ...)
{
    va_list args1;
    va_start(args1, fmt);
    vfprintf(_outfp, fmt, args1);
    va_end(args1);
    fflush(_outfp);

    fprintf(stderr, "send '");
    va_list args2;
    va_start(args2, fmt);
    vfprintf(stderr, fmt, args2);
    va_end(args2);
    fprintf(stderr, "'\n");
}

static int file_exists(char *path)
{
    struct stat statbuf;
    if (!stat(path, &statbuf)) {
        return 1;
    }
    return 0;
}

static FILE *open_file_for_writing(char *path)
{
    int fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0600);
    if (fd < 0) {
        return NULL;
    }
    FILE *fp = fdopen(fd, "w");
    return fp;
}

static char *string_prefix_endp(char *str, char *prefix)
{
    int len = strlen(prefix);
    if (!len) {
        return NULL;
    }
    if (!strncmp(str, prefix, len)) {
        return str + len;
    }
    return NULL;
}

static char *string_suffix(char *str, char *suffix)
{
    int suffixlen = strlen(suffix);
    if (!suffixlen) {
        return NULL;
    }
    int len = strlen(str);
    if (len < suffixlen) {
        return NULL;
    }
    char *p = str + len-suffixlen;
    if (!strcmp(p, suffix)) {
        return p;
    }
    return NULL;
}

static char *str_validchars_endchar(char *str, char *validchars, char endchar)
{
    char *p = str;
    for(;;) {
        if (*p == endchar) {
            if (p == str) {
                return NULL;
            }
            return p;
        }
        if (!*p) {
            return NULL;
        }
        if (!strchr(validchars, *p)) {
            return NULL;
        }
        p++;
    }
    // not reached
    return NULL;
}

static void chomp_string(char *str)
{
    int len = strlen(str);
    if (len > 0) {
        if (str[len-1] == '\n') {
            str[len-1] = 0;
        }
    }
}

static int is_number_in_range(char *numberstr, char *rangestr)
{
    char *str = rangestr;
    unsigned long number = strtoul(numberstr, NULL, 10);
//debuglog("number %lu", number);

    char *p = str;
    for(;;) {
        char *endp = NULL;
        unsigned long number1 = strtoul(p, &endp, 10);
        if (endp == p) {
            return 0;
        }
        if (*endp == ':') {
            p = endp+1;
            endp = NULL;
            unsigned long number2 = strtoul(p, &endp, 10);
            if (endp == p) {
//debuglog("missing second number of range %lu", number1);
                return 0;
            }
//debuglog("range from %lu to %lu", number1, number2);
            if ((number >= number1) && (number <= number2)) {
                return 1;
            }
            if (*endp == ',') {
                p = endp+1;
                continue;
            }
            return 0;
        } else if (*endp == ',') {
//debuglog("number %lu *", number1);
            if (number == number1) {
                return 1;
            }
            p = endp+1;
            continue;
        } else {
//debuglog("number %lu next char '%c'", number1, *endp);
            if (number == number1) {
                return 1;
            }
            return 0;
        }
    }
    // not reached
    return 0;
}

static int is_filename_uid(char *str)
{
    char *p = str;
    for(;;) {
        if (!*p) {
            return 0;
        }
        if ((*p >= '0') && (*p <= '9')) {
            p++;
            continue;
        }
        if (*p == '.') {
            if (p > str) {
                if (!strcmp(p+1, "eml")) {
                    return 1;
                }
            }
        }
        return 0;
    }
    return 0;
}

static char *move_string_backwards_and_add_suffix(char *src, char *suffix)
{
    int suffixlen = strlen(suffix);
    char *p = src;
    char *dst = src-suffixlen;
    char *q = dst;
    while (*p) {
        *q = *p;
        q++;
        p++;
    }
    p = suffix;
    while (*p) {
        *q = *p;
        q++;
        p++;
    }
    return dst;
}

static void unlink_files_in_range(char *range)
{
    DIR *dir = opendir(".");
    if (!dir) {
        die("Unable to open current directory");
    }
    for(;;) {
        struct dirent *ent = readdir(dir);
        if (!ent) {
            break;
        }
        char *p = ent->d_name;
//debuglog("dirent '%s' %d", p, is_filename_uid(p));
        if (is_filename_uid(p)) {
            if (is_number_in_range(p, range)) {
debuglog("'%s' in range '%s'", p, range);
                if (unlink(p) != 0) {
                    die("Unable to unlink '%s'", p);
                }
debuglog("unlinked '%s'", p);
            }
        }
    }
    closedir(dir);
}

static void read_first_line_from_file(char *filename, char *buf)
{
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        die("Unable to open '%s'", filename);
    }
    if (!fgets(buf, BUFSIZE, fp)) {
        die("Unable to read line from '%s'", filename);
    }
    fclose(fp);
    chomp_string(buf);
}

static void write_string_to_new_file(char *str, char *path)
{
    FILE *fp = open_file_for_writing(path);
    if (!fp) {
        die("Unable to create file '%s'", path);
    }
    fprintf(fp, "%s", str);
    fclose(fp);
}

static void wait_for_initial_ok()
{
    read_line();
    if (!string_prefix_endp(_buf, "* OK")) {
        die("Expecting OK but received '%s'", _buf);
    }
}

static void do_login(char *username, char *password)
{
    write_string("login login %s %s\r\n", username, password);
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "login OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "login NO")
         || string_prefix_endp(_buf, "login BAD"))
        {
            die("Unable to login '%s'", _buf);
        }
    }
}

static void do_logout()
{
    write_string("logout logout\r\n");
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "logout OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "logout NO")
         || string_prefix_endp(_buf, "logout BAD"))
        {
            debuglog("Unable to logout '%s'", _buf);
            break;
        }
    }
}

static void do_enable_qresync()
{
    write_string("qresync enable qresync\r\n");
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "qresync OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "qresync NO")
         || string_prefix_endp(_buf, "qresync BAD"))
        {
            die("Unable to enable qresync '%s'", _buf);
        }
    }
}

static void do_fetch(char *range)
{
    write_string("fetch uid fetch %s BODY.PEEK[]\r\n", range);
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "fetch OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "fetch NO")
         || string_prefix_endp(_buf, "fetch BAD"))
        {
            die("Unable to uid fetch %s '%s'", range, _buf);
        }
        char *p = string_prefix_endp(_buf, "* ");
        if (!p) {
debuglog("Error, '* ' not found");
            continue;
        }
        if (!strchr(DIGITCHARS, *p)) {
debuglog("Error, digit not found");
            continue;
        }
        p++;

        p = strstr(p, " FETCH ");
        if (!p) {
debuglog("Error, ' FETCH ' not found");
            continue;
        }
        p += 7;

        char *uid_p = strstr(p, "UID ");
        if (!uid_p) {
debuglog("Error, 'UID ' not found");
            continue;
        }
        uid_p += 4;
        char *uid_endp = NULL;
        strtoul(uid_p, &uid_endp, 10);
        if (uid_p == uid_endp) {
debuglog("Error, uid_endp not found");
            continue;
        }
        *uid_endp = 0;
debuglog("uid '%s'", uid_p);
        p = uid_endp+1;

        p = strstr(p, "BODY[] {");
        if (!p) {
debuglog("No 'BODY[] {'");
            continue;
        }
        p += 8;

        char *fetch_size_endp = NULL;
        int fetch_size = strtoul(p, &fetch_size_endp, 10);
        if (p == fetch_size_endp) {
debuglog("Error, fetch_size_endp not found");
            continue;
        }
        p = fetch_size_endp;
        if (strcmp(p, "}\r\n") != 0) {
debuglog("Error, '}\\r\\n' not found");
            continue;
        }

debuglog("uid '%s' fetch_size %d", uid_p, fetch_size);
        char *uidfile_p = move_string_backwards_and_add_suffix(uid_p, ".eml");
        {
            if (file_exists(uidfile_p)) {
                die("File '%s' already exists", uidfile_p);
            }

            int emailfd = open(uidfile_p, O_WRONLY|O_CREAT|O_TRUNC, 0600);
            FILE *emailfp = fdopen(emailfd, "w");
            if (!emailfp) {
                die("Unable to create file '%s'", uidfile_p);
            }

            int fetch_bytes_read = 0;
            for(;;) {
                if (fetch_bytes_read == fetch_size) {
debuglog("success");
                    break;
                }
                if (fetch_bytes_read >= fetch_size) {
                    die("Read too many bytes for file %s fetch_bytes_read %d fetch_size %d", uidfile_p, fetch_bytes_read, fetch_size);
                }

                if (!fgets(_buf, BUFSIZE, _infp)) {
                    die("fgets failed");
                }

                int len = strlen(_buf);

                fetch_bytes_read += len;

                if (len >= 2) {
                    if (_buf[len-1] == '\n') {
                        if (_buf[len-2] == '\r') {
                            _buf[len-2] = '\n';
                            _buf[len-1] = 0;
                            len--;
                        }
                    }
                }
                int n = fwrite(_buf, 1, len, emailfp);
                if (n != len) {
                    die("fwrite error n %d len %d", n, len);
                }

            }

            fclose(emailfp);
        }

        read_line();
        if (!string_suffix(_buf, ")\r\n")) {
            die("Expecting line ending with ')'");
        }
    }
}

static void process_qresync_fetch()
{
    FILE *fp = fopen("qresync.tmp", "r");
    if (!fp) {
debuglog("unable to open qresync.tmp");
        return;
    }
    for(;;) {
        if (!fgets(_buf, BUFSIZE, fp)) {
            break;
        }
        char *p = string_prefix_endp(_buf, "fetch ");
        if (!p) {
            continue;
        }
        char *q = str_validchars_endchar(p, DIGITCHARS, '\n');
        if (!q) {
debuglog("invalid fetch line '%s'", _buf);
            continue;
        }
        *q = 0;
debuglog("fetch '%s'", p);
        if (strlen(p) > 251) {
            die("Buffer overflow fetch uid '%s' too long", p);
        }
        char path[256];
        sprintf(path, "%s.eml", p);
debuglog("Checking file '%s'", path);
        if (file_exists(path)) {
debuglog("File '%s' exists, skipping fetch", path);
        } else {
debuglog("Performing fetch '%s'", p);
            do_fetch(p);
        }
    }
}

static void process_qresync_vanished()
{
    FILE *fp = fopen("qresync.tmp", "r");
    if (!fp) {
debuglog("unable to open qresync.tmp");
        return;
    }
    for(;;) {
        if (!fgets(_buf, BUFSIZE, fp)) {
            break;
        }
        char *p = string_prefix_endp(_buf, "vanished ");
        if (!p) {
            continue;
        }
        char *q = str_validchars_endchar(p, DIGITCHARS ":,", '\n');
        if (!q) {
debuglog("invalid vanished line '%s'", _buf);
            continue;
        }
        *q = 0;
debuglog("vanished '%s'", p);
        unlink_files_in_range(p);
    }
}

static void process_qresync_highestmodseq()
{
    FILE *fp = fopen("qresync.tmp", "r");
    if (!fp) {
debuglog("unable to open qresync.tmp");
        return;
    }
    for(;;) {
        if (!fgets(_buf, BUFSIZE, fp)) {
            break;
        }
        char *p = string_prefix_endp(_buf, "highestmodseq ");
        if (!p) {
            continue;
        }
        char *q = str_validchars_endchar(p, DIGITCHARS, '\n');
        if (!q) {
debuglog("invalid highestmodseq line '%s'", _buf);
            break;
        }
        *q = 0;
debuglog("highestmodseq '%s'", p);
        unlink("highestmodseq.dat");
        write_string_to_new_file(p, "highestmodseq.dat");
        return;
    }
}

static int is_directory_empty(char *path)
{
    DIR *dir = opendir(path);
    if (!dir) {
debuglog("Error, unable to open directory '%s'", path);
        return 0;
    }
    for(;;) {
        struct dirent *ent = readdir(dir);
        if (!ent) {
            break;
        }
        if (!strcmp(ent->d_name, ".")) {
            continue;
        }
        if (!strcmp(ent->d_name, "..")) {
            continue;
        }
        return 0;
    }
    closedir(dir);
    return 1;
}

static int is_directory_empty_except_for_init(char *path)
{
    DIR *dir = opendir(path);
    if (!dir) {
debuglog("Error, unable to open directory '%s'", path);
        return 0;
    }
    for(;;) {
        struct dirent *ent = readdir(dir);
        if (!ent) {
            break;
        }
        if (!strcmp(ent->d_name, ".")) {
            continue;
        }
        if (!strcmp(ent->d_name, "..")) {
            continue;
        }
        if (!strcmp(ent->d_name, "username.cfg")) {
            continue;
        }
        if (!strcmp(ent->d_name, "password.cfg")) {
            continue;
        }
        if (!strcmp(ent->d_name, "mailbox.cfg")) {
            continue;
        }
        if (!strcmp(ent->d_name, "initialDownload.sh")) {
            continue;
        }
        if (!strcmp(ent->d_name, "update.sh")) {
            continue;
        }
        if (!strcmp(ent->d_name, "idle.sh")) {
            continue;
        }
        if (!strcmp(ent->d_name, "list.sh")) {
            continue;
        }
        if (!strcmp(ent->d_name, "view.sh")) {
            continue;
        }
        if (!strcmp(ent->d_name, "log.txt")) {
            continue;
        }
        return 0;
    }
    closedir(dir);
    return 1;
}

static void imap_download()
{
    if (!is_directory_empty_except_for_init(".")) {
        die("Current directory is not empty (excluding username.cfg password.cfg mailbox.cfg initialDownload.sh update.sh idle.sh list.sh view.sh log.txt)");
    }

    char usernamebuf[BUFSIZE];
    char passwordbuf[BUFSIZE];
    char mailboxbuf[BUFSIZE];
    read_first_line_from_file("username.cfg", usernamebuf);
    read_first_line_from_file("password.cfg", passwordbuf);
    read_first_line_from_file("mailbox.cfg", mailboxbuf);

    _infp = stdin;
    _outfp = stdout;

    wait_for_initial_ok();

    do_login(usernamebuf, passwordbuf);

    do_enable_qresync();

    write_string("select select %s\r\n", mailboxbuf);
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "select OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "select NO")
         || string_prefix_endp(_buf, "select BAD"))
        {
            die("Unable to select mailbox %s '%s'", mailboxbuf, _buf);
        }

        char *p = string_prefix_endp(_buf, "* ");
        if (p) {
            char *q = str_validchars_endchar(p, DIGITCHARS, ' ');
            if (q) {
                if (!strcmp(q+1, "EXISTS\r\n")) {
                    int num_exists = strtoul(p, NULL, 10);
debuglog("num_exists %d", num_exists);
                    continue;
                }
            }
        }

        p = string_prefix_endp(_buf, "* OK [UIDVALIDITY ");
        if (p) {
            char *q = strchr(p, ']');
            if (q) {
                *q = 0;
debuglog("uidvalidity '%s'", p);
                write_string_to_new_file(p, "uidvalidity.dat");
                continue;
            }
        }
        p = string_prefix_endp(_buf, "* OK [HIGHESTMODSEQ ");
        if (p) {
            char *q = strchr(p, ']');
            if (q) {
                *q = 0;
debuglog("highestmodseq '%s'", p);
                write_string_to_new_file(p, "highestmodseq.dat");
                continue;
            }
        }
    }

    do_fetch("1:*");

    do_logout();

    exit(0);
}

static void imap_update()
{
    if (file_exists("qresync.tmp")) {
        die("qresync.tmp already exists");
    }

    int same_highestmodseq = 0;

    char usernamebuf[BUFSIZE];
    char passwordbuf[BUFSIZE];
    char mailboxbuf[BUFSIZE];
    char uidvaliditybuf[BUFSIZE];
    char highestmodseqbuf[BUFSIZE];
    read_first_line_from_file("username.cfg", usernamebuf);
    read_first_line_from_file("password.cfg", passwordbuf);
    read_first_line_from_file("mailbox.cfg", mailboxbuf);
    {
        read_first_line_from_file("uidvalidity.dat", uidvaliditybuf);
        char *q = str_validchars_endchar(uidvaliditybuf, DIGITCHARS, 0);
        if (!q) {
            die("Invalid uidvalidity.dat '%s'", uidvaliditybuf);
        }
        *q = 0;
    }
    {
        read_first_line_from_file("highestmodseq.dat", highestmodseqbuf);
        char *q = str_validchars_endchar(highestmodseqbuf, DIGITCHARS, 0);
        if (!q) {
            die("Invalid highestmodseq.dat '%s'", highestmodseqbuf);
        }
        *q = 0;
    }

    _infp = stdin;
    _outfp = stdout;

    wait_for_initial_ok();

    do_login(usernamebuf, passwordbuf);

    do_enable_qresync();

    FILE *qresyncfp = open_file_for_writing("qresync.tmp");
    if (!qresyncfp) {
        die("Unable to open qresync.tmp");
    }

    write_string("select select %s (qresync (%s %s))\r\n", mailboxbuf, uidvaliditybuf, highestmodseqbuf);
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "select OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "select NO")
         || string_prefix_endp(_buf, "select BAD"))
        {
            die("Unable to select mailbox %s uidvalidity %s highestmodseq %s '%s'", mailboxbuf, uidvaliditybuf, highestmodseqbuf, _buf);
        }
        char *p = string_prefix_endp(_buf, "* ");
        if (p) {
            char *q = str_validchars_endchar(p, DIGITCHARS, ' ');
            if (q) {
                if (!strcmp(q+1, "EXISTS\r\n")) {
                    int num_exists = strtoul(p, NULL, 10);
debuglog("num_exists %d", num_exists);
                    continue;
                }
            }
        }
        p = string_prefix_endp(_buf, "* OK [UIDVALIDITY ");
        if (p) {
            char *q = strchr(p, ']');
            if (q) {
                *q = 0;
                if (strcmp(p, uidvaliditybuf) != 0) {
                    die("UIDVALIDITY '%s' does not match uidvalidity.dat '%s', the mailbox may have changed", p, uidvaliditybuf);
                }
                fprintf(qresyncfp, "uidvalidity %s\n", p);
                continue;
            }
        }
        p = string_prefix_endp(_buf, "* OK [HIGHESTMODSEQ ");
        if (p) {
            char *q = strchr(p, ']');
            if (q) {
                *q = 0;
                if (!strcmp(p, highestmodseqbuf)) {
debuglog("HIGHESTMODSEQ '%s' is the same as before", p);
                    same_highestmodseq = 1;
                } else {
                    fprintf(qresyncfp, "highestmodseq %s\n", p);
                }
                continue;
            }
        }

        p = strstr(_buf, " FETCH ");
        if (p) {
            p += 7;

            char *uid_p = strstr(p, "UID ");
            if (!uid_p) {
debuglog("Error, 'UID ' not found");
                continue;
            }
            uid_p += 4;
            char *uid_endp = NULL;
            strtoul(uid_p, &uid_endp, 10);
            if (uid_p == uid_endp) {
debuglog("Error, uid_endp not found");
                continue;
            }
            *uid_endp = 0;
            fprintf(qresyncfp, "fetch %s\n", uid_p);
        }

        p = string_prefix_endp(_buf, "* VANISHED (EARLIER) ");
        if (p) {
            char *q = strchr(p, '\r');
            if (q) {
                *q = 0;
                fprintf(qresyncfp, "vanished %s\n", p);
                continue;
            }
        }
    }

    fclose(qresyncfp);

    if (!same_highestmodseq) {
        process_qresync_fetch();
    }

    do_logout();

    if (!same_highestmodseq) {
        process_qresync_vanished();
        process_qresync_highestmodseq();
    }

    unlink("qresync.tmp");

    exit(0);
}

static void imap_idle()
{
    char usernamebuf[BUFSIZE];
    char passwordbuf[BUFSIZE];
    char mailboxbuf[BUFSIZE];
    read_first_line_from_file("username.cfg", usernamebuf);
    read_first_line_from_file("password.cfg", passwordbuf);
    read_first_line_from_file("mailbox.cfg", mailboxbuf);
    _infp = stdin;
    _outfp = stdout;

    wait_for_initial_ok();

    do_login(usernamebuf, passwordbuf);

    write_string("select select %s\r\n", mailboxbuf);
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "select OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "select NO")
         || string_prefix_endp(_buf, "select BAD"))
        {
            die("Unable to select mailbox %s '%s'", mailboxbuf, _buf);
        }
    }

    write_string("idle idle\r\n");
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "+ ")) {
            break;
        }
    }
    for(;;) {
        read_line();
        char *p = string_prefix_endp(_buf, "* ");
        if (p) {
            char *q = str_validchars_endchar(p, DIGITCHARS, ' ');
            if (q) {
                if (!strcmp(q+1, "EXISTS\r\n")) {
                    int num_exists = strtoul(p, NULL, 10);
debuglog("num_exists %d", num_exists);
                    break;
                }
            }
        }
    }

    write_string("DONE\r\n");
    for(;;) {
        read_line();
        if (string_prefix_endp(_buf, "idle OK")) {
            break;
        }
        if (string_prefix_endp(_buf, "idle NO")
         || string_prefix_endp(_buf, "idle BAD")) {
            die("Somehow IDLE failed '%s'", _buf);
        }
    }

    do_logout();

    exit(0);
}

static char *input_password(char *buf)
{
    struct termios oldterm;
    struct termios newterm;

    tcgetattr(0, &oldterm);
    newterm = oldterm;
    newterm.c_lflag &= ~(ECHO);
    tcsetattr(0, TCSANOW, &newterm);

    char *result = fgets(buf, BUFSIZE, stdin);

    tcsetattr(0, TCSANOW, &oldterm);

    return result;
}

static void imap_init()
{
    if (!is_directory_empty(".")) {
        die("Current directory is not empty");
    }

    char usernamebuf[BUFSIZE];
    char passwordbuf[BUFSIZE];
    char mailboxbuf[BUFSIZE];

    printf("Enter IMAP username: ");
    if (!fgets(usernamebuf, BUFSIZE, stdin)) {
        die("Unable to read line");
    }
    chomp_string(usernamebuf);
    printf("Enter IMAP password: ");
    if (!input_password(passwordbuf)) {
        die("Unable to read line");
    }
    chomp_string(passwordbuf);
    printf("\n");
    printf("Enter IMAP mailbox (leave empty for 'inbox'): ");
    if (!fgets(mailboxbuf, BUFSIZE, stdin)) {
        die("Unable to read line");
    }
    chomp_string(mailboxbuf);
    if (!mailboxbuf[0]) {
        sprintf(mailboxbuf, "inbox");
    }

    char imapserverbuf[BUFSIZE/2];
    printf("\n");
    printf("Enter IMAP server hostname: ");
    if (!fgets(imapserverbuf, BUFSIZE/2, stdin)) {
        die("Unable to read line");
    }
    chomp_string(imapserverbuf);
    if (!imapserverbuf[0]) {
        sprintf(imapserverbuf, "localhost");
    }

    write_string_to_new_file(usernamebuf, "username.cfg");
    write_string_to_new_file(passwordbuf, "password.cfg");
    write_string_to_new_file(mailboxbuf, "mailbox.cfg");

    char downloadbuf[BUFSIZE];
    sprintf(downloadbuf,
"socat openssl:%s:993 system:'pucko-mail-imap download'\n"
"#socat openssl:%s:993,verify=0 system:'pucko-mail-imap download'\n",
imapserverbuf, imapserverbuf);
    write_string_to_new_file(downloadbuf, "initialDownload.sh");

    char updatebuf[BUFSIZE];
    sprintf(updatebuf,
"socat openssl:%s:993 system:'pucko-mail-imap update'\n"
"#socat openssl:%s:993,verify=0 system:'pucko-mail-imap update'\n",
imapserverbuf, imapserverbuf);
    write_string_to_new_file(updatebuf, "update.sh");

    char idlebuf[BUFSIZE];
    sprintf(idlebuf,
"socat openssl:%s:993 system:'pucko-mail-imap idle'\n"
"#socat openssl:%s:993,verify=0 system:'pucko-mail-imap idle'\n",
imapserverbuf, imapserverbuf);
    write_string_to_new_file(idlebuf, "idle.sh");

    write_string_to_new_file("ls -v *.eml | tac | pucko-mail-list\n", "list.sh");

    write_string_to_new_file("pucko MailInterface\n", "view.sh");

    write_string_to_new_file("Use 'log.txt' as a log file\n", "log.txt");

    exit(0);
}

int main(int argc, char **argv)
{
    if (argc == 2) {
        if (!strcmp(argv[1], "init")) {
            imap_init();
        }
        if (!strcmp(argv[1], "download")) {
            imap_download();
        }
        if (!strcmp(argv[1], "update")) {
            imap_update();
        }
        if (!strcmp(argv[1], "idle")) {
            imap_idle();
        }
    }
    fprintf(stderr, "Usage:\n");
    fprintf(stderr, "pucko-mail-imap init\n");
    fprintf(stderr, "socat openssl:example.com:993 system:'pucko-mail-imap download'\n");
    fprintf(stderr, "socat openssl:example.com:993 system:'pucko-mail-imap update'\n");
    fprintf(stderr, "socat openssl:example.com:993 system:'pucko-mail-imap idle'\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "To disable certificate verification:\n");
    fprintf(stderr, "socat openssl:example.com:993,verify=0 system:'pucko-mail-imap download'\n");
    fprintf(stderr, "socat openssl:example.com:993,verify=0 system:'pucko-mail-imap update'\n");
    fprintf(stderr, "socat openssl:example.com:993,verify=0 system:'pucko-mail-imap idle'\n");
    return 0;
}

