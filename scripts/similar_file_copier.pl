#!/usr/bin/perl

use warnings;
use File::Copy;
use File::Copy::Recursive qw(dircopy);


#################################################################################################
# This scripts copies files from $copyFrom directory to $copyTo directory,
# choosing only files with names similar to the names of files in $takeFileNamesFrom directory
#################################################################################################


# copy files from this directory
$copyFrom = 'd:/a/plugins/';

# copy files to this directory
$copyTo = 'd:/test/';

# take a list of flies to copy from this directory
$takeFileNamesFrom = 'd:/b/plugins';


sub takeFilePrefixes {
    opendir(DIR, $takeFileNamesFrom) or die "Cannot open directory: $!";
    my @files = readdir(DIR);
    my @names = ();
    foreach my $fileName (@files) {
        unless($fileName  eq "." || $fileName eq ".." ) {
            my @parts = split('_', $fileName);
            my $name = $parts[0] . "_";
            push @names, $name;
        }
    }
    @names;
}


sub copyFiles {
    opendir(DIR, $copyFrom) or die "Cannot open directory: $!";
    my @files = readdir(DIR);
    foreach my $fileName (@files) {
        unless($fileName  eq "." || $fileName eq ".." ) {
            foreach my $startName (@filePrefixes) {
                if ($fileName =~ /^$startName/) {  # if ($fileName startsWith $startName)
                    my $fullPath = $copyFrom . $fileName;
                    if (-f $fullPath) {
                        copy($fullPath, $copyTo . $fileName) or die "Copy failed: $!";
                    }
                    if (-d $fullPath) {
                        dircopy($fullPath, $copyTo . $fileName) or die("$!\n");
                    }
                    last;
                }
            }
        }
    }
}


print "\nCopying files...\n";
@filePrefixes = takeFilePrefixes();
copyFiles();
print "Copied successfully\n";
