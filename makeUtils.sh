#!/bin/bash

set -x
gcc -o pucko-imap pucko-imap.c

gcc -o pucko-listMail `pkg-config --cflags --libs gmime-3.0` pucko-listMail.c 
gcc -o pucko-extractMailPart `pkg-config --cflags --libs gmime-3.0` pucko-extractMailPart.c 
gcc -o pucko-printMailMessage `pkg-config --cflags --libs gmime-3.0` pucko-printMailMessage.c 
gcc -o pucko-printMailHeaders `pkg-config --cflags --libs gmime-3.0` pucko-printMailHeaders.c 
gcc -o pucko-printMailContentType `pkg-config --cflags --libs gmime-3.0` pucko-printMailContentType.c 

