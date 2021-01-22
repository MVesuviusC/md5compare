#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;


##############################
# By Matt Cannon
# Date: 11/16/2020
# Last modified: 11/16/2020
# Title: md5compare.pl
# Purpose: compare the md5sums of files in two places
##############################

##############################
# Options
##############################


my $verbose;
my $help;
my $locOne;
my $locTwo;

# i = integer, s = string
GetOptions ("verbose"           => \$verbose,
            "help"              => \$help,
            "1=s"               => \$locOne,
            "2=s"               => \$locTwo
      ) or pod2usage(0) && exit;

pod2usage(1) && exit if ($help);


##############################
# Global variables
##############################
my %md5Hash;
my $problem = 0;
my $fileCount = 0;

##############################
# Code
##############################

##############################
### If provided a direcory, add "*"
if($locOne =~ /\/$/ || $locTwo =~ /\/$/) {
    print "Cannot provide only a directory!\n"
}

print STDERR "Calculating md5sums for ", $locOne, "\n";
my $locOneMd5 = `md5sum $locOne`;
my @locOneArray = split "\n", $locOneMd5;

print STDERR "Calculating md5sums for ", $locTwo, "\n";
my $locTwoMd5 = `md5sum $locTwo`;
my @locTwoArray = split "\n", $locTwoMd5;

for my $element1 (@locOneArray) {
    chomp $element1;
    my ($md5, $file) = split " +", $element1;
    $file =~ s/.+\///;
    $md5Hash{$file}{1} = $md5;
    print STDERR $file, "\t", $md5, "\n" if($verbose);
}

for my $element2 (@locTwoArray) {
    chomp $element2;
    my ($md5, $file) = split " +", $element2;
    $file =~ s/.+\///;
    $md5Hash{$file}{2} = $md5;
    print STDERR $file, "\t", $md5, "\n" if($verbose);
}

for my $file (keys %md5Hash) {
    if(exists $md5Hash{$file}{1} && exists $md5Hash{$file}{2}) {
        if($md5Hash{$file}{1} ne $md5Hash{$file}{2}) {
            print "\n!!!!!!!!!!!!!!!!!!!!! md5 values for $file do not match! !!!!!!!!!!!!!!!!!!!!!\n\n";
            $problem = 1;
        }
    } elsif(!exists $md5Hash{$file}{1}) {
        print $file, " not found in ", $locOne, "\n";
        $problem = 1;
    } elsif(!exists $md5Hash{$file}{2}) {
        print $file, " not found in ", $locTwo, "\n";
        $problem = 1;
    }
    $fileCount++;
}

print $fileCount, " files compared.";
if($problem == 0) {
    print "All good!\n";
}



##############################
# POD
##############################

#=pod
    
=head SYNOPSIS

Summary:    
    
    md5compare.pl - generates a consensus for a specified gene in a specified taxa

Usage:

    perl md5compare.pl -1 "dir1/*.txt" -2 "dir2/*.txt" 


=head OPTIONS

Options:

    --verbose
    --help
    -1 first list of files
    -2 second list of files

=cut
