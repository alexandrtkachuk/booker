#!/usr/bin/perl 

use warnings;
use strict;

use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Models/Utilits';
use lib  '../';
use lib  '../Models/Utilits/';
use lib TDIR;

 use base qw(Test::Class);
use Test::Class;
use Test::More 'no_plan';
use Test::MockObject;

my $mockSQL = Test::MockObject->new();

$mockSQL->fake_new( 'Models::Interfaces::Sql');

#$mockSQL->mock( 'new',
#            sub {print 'good'; } );

$mockSQL->mock( 'select', sub {1} );
$mockSQL->mock( 'connect', sub {1} );

my $sql = Models::Interfaces::Sql->new();

$sql =  Models::Interfaces::Sql->new('bdname','host','user','pass');

#is( $sql->connect(), 1, 'good connect for new copy Class' );
#ok($sql,'Create class SQL');
#can_ok($sql,'select');
#can_ok($sql,'connect');

sub startup : Test(startup)
{
    # print 'start';
    #use_ok(1,'ffffffffff');
}

sub testSQL : Test 
{
    is( $sql->connect(), 1, 'good connect for new copy Class' );
    ok($sql,'Create class SQL');
    can_ok($sql,'select');
    can_ok($sql,'connect');
}


Test::Class->runtests;
