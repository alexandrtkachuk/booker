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
    ok($rooms,'Create class Rooms');
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

sub rooms_empryTime : Test
{
    can_ok($rooms,'empryTime');
    $$mockSQL->mock( 'getResult',sub{1});
    $$mockSQL->mock( 'getRows',sub{0});
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );

    is($rooms->empryTime(1,time,time+1),1,'good params');
    is($rooms->empryTime(1,time,time),0,'need timeEnd > timeStart ');
    is($rooms->empryTime(),0,'no param');
    
}

sub room_addOrder : Test
{
    can_ok($rooms,'addOrder');
}

sub room_createOrder : Test
{
   can_ok($rooms,'createOrder');
}

sub room_updateOrder : Test
{
   can_ok($rooms,'updateOrder');
}

sub room_setTime2order : Test
{
    can_ok($rooms,'setTime2order');
}

sub room_update : Test
{
    can_ok($rooms,'update');
}

sub room_deleteOrder4user : Test
{
    can_ok($rooms,'deleteOrder4user');
}

sub room_deleteOrder : Test
{
    can_ok($rooms,'deleteOrder');
}

sub room_getRooms : Test
{
    can_ok($rooms, 'getRooms');
}

sub room_addRoom : Test
{
    can_ok($rooms,'addRoom');
}

Test::Class->runtests;
