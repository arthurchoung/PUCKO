#!/usr/bin/perl

use Email::MIME;
use Date::Parse;

#if (not scalar @ARGV) {
#    die('specify file');
#}

loop:

#$arg = shift @ARGV;
$arg = <STDIN>;
chomp $arg;
if (not $arg) {
    exit 0;
}

#$contents = `cat $arg`;
$contents = '';
if (not open(FH, $arg)) {
    goto loop;
}

@contents = <FH>;
$contents = join '', @contents;
close FH;

$email = Email::MIME->new($contents);

print <<EOF;
name:$arg
EOF

$origdate = $email->header('Date');
print <<EOF;
origdate:$origdate
EOF
$epoch = str2time($origdate);
@time = localtime($epoch);
@now = localtime;
$date = '';
if ($time[5] == $now[5]) { # year
    if ($time[4] == $now[4]) { # month
        if ($time[3] == $now[3]) { # day
            $hour = $time[2];
            $minute = $time[1];
            if ($hour == 12) {
                $date = sprintf('12:%.2d PM', $minute);
            } elsif ($hour == 0) {
                $date = sprintf('12:%.2d AM', $minute);
            } elsif ($hour > 12) {
                $date = sprintf('%d:%.2d PM', $hour%12, $minute);
            } else {
                $date = sprintf('%d:%.2d AM', $hour, $minute);
            }
        }
    }
}
if (not $date) {
    $date = sprintf('%d/%.2d/%.2d', $time[3], $time[4]+1, ($time[5]+1900)%100);
}

print <<EOF;
date:$date
EOF

$from = $email->header('From');
$from =~ s/[^[:ascii:]]//g;
print <<EOF;
from:$from
EOF

$subject = $email->header('Subject');
$subject =~ s/[^[:ascii:]]//g;
print <<EOF;
subject:$subject
EOF

$preview = '';
$numAttachments = 0;

$email->walk_parts(sub {
    my ($part) = @_;
    return if $part->subparts;

    $content_type = $part->content_type;
    if ($part->content_type =~ m[text/plain]i) {
        my $body = $part->body;
        $body =~ s/\s+/ /g;
        $body =~ s/^\s//;
        $body = substr($body, 0, 160);
        $preview = $body;
    } elsif ($part->content_type =~ m[text/html]i) {
        my $body = $part->body;
#        print <<EOF;
#
#$body
#EOF
    } else {
        $numAttachments++;
    }
});

print <<EOF;
attachments:$numAttachments
unseen:1
preview:$preview

EOF

goto loop;

