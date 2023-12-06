#!/usr/bin/perl

$path = shift @ARGV;
$part = shift @ARGV;
$mimeType = shift @ARGV;

if (not $path or not $part or not $mimeType) {
    die('no path, part or mimeType');
}

$str = "path $path part $part mimeType $mimeType";
if ($mimeType eq 'text/plain') {
    system("pucko-extractMailPart $path $part >/tmp/pucko.txt");
    system("chromium /tmp/pucko.txt");
} elsif ($mimeType eq 'text/html') {
    system("pucko-extractMailPart $path $part >/tmp/pucko.html");
    system("chromium /tmp/pucko.html");
} elsif ($mimeType eq 'application/pdf') {
    system("pucko-extractMailPart $path $part >/tmp/pucko.pdf");
    system("mupdf /tmp/pucko.pdf");
} elsif ($mimeType eq 'image/png') {
    system("pucko-extractMailPart $path $part >/tmp/pucko.png");
    system("chromium /tmp/pucko.png");
} else {
    system("pucko", "showAlert:", "$path $part $mimeType");
}

