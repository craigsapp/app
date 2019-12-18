#!/usr/bin/perl
#
# Programmer:    Craig Stuart Sapp <craig@ccrma.stanford.edu>
# Creation Date: Fri Jun 15 12:19:43 PDT 2012
# Last Modified: Sat Jun 16 17:02:16 PDT 2012
# Filename:      app
# URL:           https://raw.github.com/craigsapp/app/master/app
# Syntax:        Perl 5
#
# DOCUMENTATION:
#    app -- List and run OS X Applications from the command-line.
#
#    OPTIONS
#      -f        == display full pathes of Applications.
#      -l        == list all Applications which are available
#      -w regexp == list all Applications which string matches to.
#      -p        == display list in paragraph form.
#      -d        == deep search for apps
#
# EXAMPLES:
#    app
#       Show a list of all Applications.
#    app -l
#       Same as "app" with no options.
#    app string
#       Run the first Application (sorted alphabetically) found which
#       contains string.  Example: "app finder".  
#    app ^string
#        Run the first Applcation found which starts with "string".
#    app -f 
#       Show list of Applications, including full pathnames.
#    app -w ^t 
#       Show a list of Applications whcih start with the letter T.
#    app -p
#       Show list of all Applications in paragraph form
#    app -d
#       Search entire file structure for directories ending in ".app".
#

use strict;

# Set the list of directories to search, in the order that they will be searched
my @searchdirs = (
   "/Applications", 
   "/Applications/Utilities", 
   "/System/Applications", 
   "/System/Applications/Utilities"
);

##############################

use Getopt::Long; # http://perldoc.perl.org/Getopt/Long.html
Getopt::Long::Configure(qw(bundling no_getopt_compat));

my $fullQ;
my $listQ;
my $whichQ;
my $whichstring;
my $paraQ;
my $deepQ;

GetOptions(
   'l|list'     => \$listQ,        # list all apps which are available
   'p|paragraph'=> \$paraQ,        # list all apps in paragraph form
   'w|which=s'  => \$whichstring,  # list all apps matching given regex pattern
   'f|full'     => \$fullQ,        # display full address of applcations
   'd|deep'     => \$deepQ         # deep search for applications
);

if ($whichstring !~ /^\s*$/) {
   $whichQ = 1;
}

##############################

my @applist;
if ($deepQ) {
   @applist = split(/\n/, `locate *.app`);
   push(@applist, split(/\n/, `locate *.boxer`));
} else {
   @applist = getAppList(@searchdirs);
}

if ($listQ) {
   displayList(@applist);
} elsif ($whichQ) {
   printWhich($whichstring, @applist);
} elsif (@ARGV != 0) {
   runFirstMatch($ARGV[0], @applist);
} else {
   displayList(@applist);
}

exit(0);

###########################################################################


##############################
##
## displayList -- Display a list of all applications.
##

sub displayList {
   my @list = @_;

   if ($fullQ) {
      print join("\n", @applist), "\n";
      return;
   } 

   my @solo;
   my $item;
   foreach $item (@list) {
      if ($item =~ /([^\/]*)\.app$/) {
         $solo[@solo] = $1;
      } elsif ($item =~ /([^\/]*)\.boxer$/) {
         $solo[@solo] = $1;
      }
   }

   @solo = sort @solo;
   if ($paraQ) {
      open (PROC, "| sed 's/ /_/g' | fmt");
      print PROC join("\n", @solo), "\n";
      close PROC;
   } else {
      print join("\n", @solo), "\n";
   }
}



#############################
##
## runFirstMatch -- Open the first .app found in the match results
##

sub runFirstMatch {
   my ($string, @applist) = @_;
   $string =~ s/_/ /g; # allow underscores to represent spaces in the final name
   my $name;
   my $item;
   foreach $item (@applist) {
      if ($item =~ /([^\/]+)\.app$/) {
         $name = $1;
      } elsif ($item =~ /([^\/]+)\.boxer$/) {
         $name = $1;
      }
      if ($name =~ /$string/i) {
         `open "$item"`;
         last;
      }
   }
}



#############################
##
## printWhich -- Print a list of all applications whose names contain
##     the search query regular expression.
##

sub printWhich {
   my ($string, @list) = @_;

   my @apps;
   my $name;
   my $item;
   foreach $item (@list) {
      if ($item =~ /([^\/]+)\.app$/) {;
         $name = $1;
      } elsif ($item =~ /([^\/]+)\.boxer$/) {;
         $name = $1;
      }
      if ($name =~ /$string/i) {
         if ($fullQ) {
            $apps[@apps] = $item;
         } else {
            $apps[@apps] = $name;
         }
      }
   }
   @apps = sort @apps;
   print join("\n", @apps), "\n";
}



#############################
##
## getAppList -- Get a list of all Applications available in the search path.
##

sub getAppList {
   my (@dirs) = @_;
   my @output;
   my $dir;
   foreach $dir (@dirs) {
      push(@output, processDirectory($dir));
   }
   return @output;
}



##############################
##
## processDirectory -- Sort through all of the files in a directory, collecting
##    all directories when end in ".app".
## 

sub processDirectory {
   my ($dir) = @_;
   my @output;
   opendir (DIR, $dir) or return;
   my $file;
   while ($file = readdir(DIR)) {
      next if $file =~ /^\./;
      if (($file !~ /\.app$/) && ($file !~ /\.boxer$/)) {
         next;
      }
      next if !-d "$dir/$file";
      $output[@output] = "$dir/$file";
   }
   closedir DIR;
   return @output;
}


