#!/usr/bin/perl 

#test  Models::Performers::Rooms
use warnings;
use strict;
use Data::Dumper;
use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Libs';
use lib  '../';
use lib TDIR;
use lib '.';
use base qw(Test::Class);
use Test::More 'no_plan';
use Test::MockObject;
use Fake::SQL;
use Fake::Session;
use Fake::Toolchain;
use Models::Performers::Rooms;

my ($rooms,$mockObj);
my $mockSQL = Fake::SQL->get(); 
my $mockT = Fake::Toolchain->get();


sub startup : Test(startup => 2)
{
    $rooms =Models::Performers::Rooms->new();
    $mockObj = Test::MockObject->new();
    ok($rooms,'Create class USER');
    isa_ok($rooms, 'Models::Performers::Rooms');
}

sub rooms_getToMounth : Test(13)
{
    $$mockSQL->mock( 'getResult',sub{1});
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );
    can_ok($rooms,'getToMounth');
    is($rooms->getToMounth(),0,'no param');
    is($rooms->getToMounth(1),0,'nead more options');
    is($rooms->getToMounth(1,time,time+1),1,'good params');
    is($rooms->getToMounth(1,time,time),0,'need timeEnd > timeStart');
    is($rooms->getToMounth(1,time,time-1),0,'need timeEnd > timeStart');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{0})  
    );
    is($rooms->getToMounth('id',time,time+1),0,'id not numeric');
    is($rooms->getToMounth(1,'time',time+1),0,'timeStart not numeric');
    is($rooms->getToMounth(1,time,'time+1'),0,'timeEnd not numeric');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );
    is($rooms->getToMounth(0,time,time+1),0,'nead id > 0');
    is($rooms->getToMounth(-1,time,time+1),0,'nead id > 0');
    is($rooms->getToMounth(1,0,time+1),0,'nead timeStart > 0');
    is($rooms->getToMounth(1,-100,time+1),0,'nead timeStart > 0');
}

Test::Class->runtests;
