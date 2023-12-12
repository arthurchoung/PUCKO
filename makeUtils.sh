#!/bin/bash

set -x
gcc -o pucko-mail-imap pucko-mail-imap.c

gcc -o pucko-mail-list `pkg-config --cflags --libs gmime-3.0` pucko-mail-list.c 
gcc -o pucko-mail-extractPart `pkg-config --cflags --libs gmime-3.0` pucko-mail-extractPart.c 
gcc -o pucko-mail-printMessage `pkg-config --cflags --libs gmime-3.0` pucko-mail-printMessage.c 
gcc -o pucko-mail-printHeaders `pkg-config --cflags --libs gmime-3.0` pucko-mail-printHeaders.c 
gcc -o pucko-mail-printContentType `pkg-config --cflags --libs gmime-3.0` pucko-mail-printContentType.c 

