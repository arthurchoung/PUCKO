# PUCKO Email Client

Simple Email Client For IMAP Inspired By MH

## Overview

Download an IMAP mailbox to a local directory.

Emails are regular files, each file is an email.

IMAP configuration files are stored in the current directory.

Configuration files are text and human-readable.

Emails are basically text, but parts are often encoded in various ways.

Commands are run that operate on the current directory and files in that
directory.

There is no specified directory structure, emails are simply regular files
that can be stored anywhere.

'socat' is required for communicating over the network.

## How to compile

$ sh makeUtils.sh

## How to setup local directory

$ mkdir inbox

$ cd inbox

$ /path/to/pucko-imap init

Answer the prompts to enter your username, password, and mailbox. For the mailbox, enter 'inbox' unless you want a specific mailbox. The information will be saved in the dotfiles '.username', '.password', and '.mailbox' in the current directory. Please note that this saves the password to a file in plain text, which may be a security risk. Caution is advised.

To download all the messages in the specified mailbox:

$ socat openssl:example.com:993 system:'/path/to/pucko-imap download'

If there are problems with certificate verification, try:

$ socat openssl:example.com:993,verify=0 system:'/path/to/pucko-imap download'

The email messages should now be regular files in the current directory.

## How to update local directory

$ cd inbox

$ socat openssl:example.com:993 system:'/path/to/pucko-imap update'

If there are problems with certificate verification, try:

$ socat openssl:example.com:993,verify=0 system:'/path/to/pucko-imap update'

This uses IMAP QRESYNC to perform the update.

## How to wait for a change using IMAP IDLE

$ cd inbox

$ socat openssl:example.com:993 system:'/path/to/pucko-imap idle'

If there are problems with certificate verification, try:

$ socat openssl:example.com:993,verify=0 system:'/path/to/pucko-imap idle'

This uses IMAP IDLE, waits for an EXISTS message, then exits.

## GUI

There is a GUI inspired by the original versions of iOS.

$ perl build.pl

The final executable will be the file 'pucko'.

When running pucko, the other commands such as pucko-listMail, pucko-printMailHeaders, and so on need to be in your PATH.

Run the command from the directory containing the *.eml email files. It will read the *.eml files from the current directory and display a list.

$ pucko MailInterface

## Notes

This is a rather quick and dirty implementation.

## Legal

Copyright (c) 2021 Arthur Choung. All rights reserved.

Email: arthur -at- hotdoglinux.com

Released under the GNU General Public License, version 3.

For details on the license, refer to the LICENSE file.

