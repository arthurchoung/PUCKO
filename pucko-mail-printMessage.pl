#!/usr/bin/perl

use strict;

use Email::MIME;

my $arg = shift @ARGV;
if (not $arg) {
    die('specify file');
}

my $contents = `cat $arg`;

my $email = Email::MIME->new($contents);

print <<EOF;
File: $arg
EOF

my $date = $email->header('Date');
print <<EOF;
Date: $date
EOF

my $from = $email->header('From');
print <<EOF;
From: $from
EOF

my $to = $email->header('To');
print <<EOF;
To: $to
EOF

my $subject = $email->header('Subject');
print <<EOF;
Subject: $subject
EOF

$email->walk_parts(sub {
    my ($part) = @_;
    return if $part->subparts;

    if ($part->content_type =~ m[text/plain]i) {
        my $body = $part->body;
        print <<EOF;

$body
EOF
    }
});

