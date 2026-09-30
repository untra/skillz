#!/bin/sh
exec perl -x "$0" "$@"
#!perl

use strict;
use warnings;
use Encode qw(decode encode FB_CROAK LEAVE_SRC);
use Fcntl qw(:flock SEEK_SET);
use File::Basename qw(basename);
use File::Find qw(find);
use Getopt::Long qw(GetOptions);

use constant {
    EXIT_CLEAN          => 0,
    EXIT_CHANGES_NEEDED => 1,
    EXIT_ERROR          => 2,
};

my @REPLACEMENTS = (
    ["\x{2014}", '-'],
    ["\x{2013}", '-'],
    ["\x{2212}", '-'],
    ["\x{201C}", '"'],
    ["\x{201D}", '"'],
    ["\x{2018}", "'"],
    ["\x{2019}", "'"],
    ["\x{2026}", '...'],
    ["\x{00A0}", ' '],
    ["\x{202F}", ' '],
    ["\x{200B}", ' '],
    ["\x{2060}", ' '],
    ["\x{FEFF}", ''],
);

my $check = 0;
my $verbose = 0;
my $help = 0;
my @excluded_directories = ('.git');

GetOptions(
    'check'     => \$check,
    'verbose|v' => \$verbose,
    'exclude=s' => \@excluded_directories,
    'help|h'    => \$help,
) or usage(EXIT_ERROR);

usage(EXIT_CLEAN) if $help;
usage(EXIT_ERROR) if @ARGV > 1;

my $root = @ARGV ? $ARGV[0] : '.';
my %excluded = map { $_ => 1 } @excluded_directories;
my $changed_count = 0;
my $error_count = 0;

if (!-e $root) {
    warn "Path does not exist: $root\n";
    exit EXIT_ERROR;
}

if (-f $root && !-l $root) {
    process_file($root);
} elsif (-d $root) {
    find(
        {
            no_chdir => 1,
            wanted   => sub {
                my $path = $File::Find::name;

                if (-d $path) {
                    $File::Find::prune = 1
                        if $path ne $root && $excluded{basename($path)};
                    return;
                }

                process_file($path) if -f $path && !-l $path;
            },
        },
        $root,
    );
} else {
    warn "Path is not a regular file or directory: $root\n";
    exit EXIT_ERROR;
}

if ($error_count) {
    warn "Normalization failed for $error_count file(s).\n";
    exit EXIT_ERROR;
}

if ($check && $changed_count) {
    warn "$changed_count file(s) require normalization.\n";
    exit EXIT_CHANGES_NEEDED;
}

warn "Normalized $changed_count file(s).\n" if !$check;
exit EXIT_CLEAN;

sub process_file {
    my ($path) = @_;
    my $mode = $check ? '<:raw' : '+<:raw';
    my $handle;

    if (!open($handle, $mode, $path)) {
        warn "Cannot open $path: $!\n";
        ++$error_count;
        return;
    }

    if (!$check && !flock($handle, LOCK_EX)) {
        warn "Cannot lock $path: $!\n";
        close $handle;
        ++$error_count;
        return;
    }

    local $/;
    my $bytes = <$handle>;
    $bytes = '' if !defined $bytes;

    return close_file($handle, $path) if index($bytes, "\0") >= 0;

    my $text;
    if (!eval { $text = decode('UTF-8', $bytes, FB_CROAK | LEAVE_SRC); 1 }) {
        return close_file($handle, $path);
    }

    my $original = $text;
    for my $replacement (@REPLACEMENTS) {
        my ($from, $to) = @{$replacement};
        $text =~ s/\Q$from\E/$to/g;
    }

    return close_file($handle, $path) if $text eq $original;

    ++$changed_count;
    print "$path\n" if $check || $verbose;
    return close_file($handle, $path) if $check;

    my $output = encode('UTF-8', $text);
    if (!seek($handle, 0, SEEK_SET) || !truncate($handle, 0) || !print {$handle} $output) {
        warn "Cannot write $path: $!\n";
        ++$error_count;
    }

    close_file($handle, $path);
}

sub close_file {
    my ($handle, $path) = @_;
    if (!close($handle)) {
        warn "Cannot close $path: $!\n";
        ++$error_count;
    }
    return;
}

sub usage {
    my ($status) = @_;
    print <<'USAGE';
Usage: normalize-text.sh [--check] [--verbose] [--exclude NAME] [PATH]

Recursively normalize UTF-8 text under PATH (default: current directory).
  --check         List files that would change without writing; exits 1 if found
  --verbose, -v   List files as they are changed
  --exclude NAME  Skip directories with this name; repeat as needed
  --help, -h      Show this help
USAGE
    exit $status;
}
