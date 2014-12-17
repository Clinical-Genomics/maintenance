#!/usr/bin/perl - w

use strict;
use warnings;

###Show more info on SLURM jobs including dependencies

###Copyright 2014 Henrik Stranneheim 

use Getopt::Long;

use vars qw($USAGE);

BEGIN {
    
    $USAGE =
	qq{jobinfo.pl - > 
           -u/--user Limit jobinfo to user
           -j/--jobId Limit jobinfo to jobID
           -h/--help Display this help message
           -v/--version Display version
          };
}

my %line;
my @orderHeaders = ("JobId", "Name", "JobState", "RunTime", "TimeLimit", "Dependency");
my ($infile, $user, $jobId) = ("", "noInfo", "noInfo");
my ($help, $version) = (0, 0);

if (defined($ARGV) && $ARGV[0]!~/^-/) { #Collect potential infile - otherwise read from STDIN
    $infile = $ARGV[0];
}

###User Options
GetOptions('u|user:s' => \$user,
	   'j|jobId:s' => \$jobId,
	   'h|help' => \$help, #Display help text
	   'v|version' => \$version, #Display version number
    );

if($help) {

    print STDOUT "\n".$USAGE, "\n";
    exit;
}
my $jobInfoVersion = "1.0.0";

if($version) {

    print STDOUT "\njobinfo.pl v".$jobInfoVersion, "\n\n";
    exit
}
    
print "#";
for (my $elementCounter=0;$elementCounter<scalar(@orderHeaders);$elementCounter++) {
    
    my $key = \$orderHeaders[$elementCounter];
    if ($$key eq "Name") {
	
	printf "%-50s",$$key;
    }
    elsif($$key eq "Dependency") {
	
	print $$key;
    }
    else {
	
	if ($elementCounter==0) {

	    printf "%-10s",$$key;
	}
	else {

	    printf "%-11s",$$key;
	}
    }
}
print "\n";

my $printStatus = 0;

while (<>) {    

    if ($jobId ne "noInfo") {
	
	if($_=~/JobId=(\S+)/) {
	  
	    my $currentJobId = $1;
	    if ($currentJobId eq $jobId) {
	
		$printStatus = 1;
	    }
	}
    }
    elsif ($user ne "noInfo") {
	
	if($_=~/UserId=(\w+.\w+)/) {
	    
	    my $currentUser = $1;
	    if ($currentUser eq $user) {
		
		$printStatus = 1;
	    }
	}
    }
    foreach my $key (@orderHeaders) {
	
	if($_=~/$key=(\S+)/) { 
	    
	    $line{$key} = $1
	} 
    }
    if($_=~/^\s+$/) {
	
	if( ($jobId eq "noInfo") && ($user eq "noInfo") ) {
	    
	    $printStatus = 1;
	}
	if($printStatus == 1) {
	    
	    for (my $elementCounter=0;$elementCounter<scalar(@orderHeaders);$elementCounter++) {
		
		my $key = \$orderHeaders[$elementCounter];
		if ($$key eq "Name") {
		    
		    printf "%-50s",$line{$$key};
		}
		elsif($$key eq "Dependency") {
		    
		    print $line{$$key};
		}
		else {
		    
		    printf "%-11s",$line{$$key};
		}
	    }
	    print "\n";
	}
	$printStatus = 0;  #Reset for next block
    }
}
