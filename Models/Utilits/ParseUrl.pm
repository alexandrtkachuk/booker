package Models::Utilits::ParseUrl;


use warnings;
use strict;

sub get 
{
    my @sname=split /\//, $ENV{'SCRIPT_NAME'} ;
    
    my $test= $ENV{'REQUEST_URI'} ;
    
   
    for(@sname)
    {   
        $test=~s/$_\///; 
    }
    my @rout = split /\//, $test;
 
    return @rout;
	
}



1;
