#!/usr/bin/perl 

#test   Models::Validators::Varibles
use warnings;
use strict;
use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Libs';
use lib  '../';
use lib TDIR;
use lib '.';
use base qw(Test::Class);
use Test::More 'no_plan';
use Test::MockObject;
use Models::Validators::Varibles;

sub startup : Test(startup)
{

}


sub isNumeric : Test
{
    is(Models::Validators::Varibles->isNumeric(1),1,'1 is numeric');
    is(Models::Validators::Varibles->isNumeric(0),1,'0 is numeric');
    is(Models::Validators::Varibles->isNumeric(-10),1,'-10 is numeric');
    is(Models::Validators::Varibles->isNumeric(+10),1,'+10 is numeric');
    is(Models::Validators::Varibles->isNumeric('string'),0,'this is string');
    is(Models::Validators::Varibles->isNumeric('12test'),0,'this is string');
}

Test::Class->runtests;
