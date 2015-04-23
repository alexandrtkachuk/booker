#!/usr/bin/perl 

use warnings;
use strict;

use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Models/Utilits';
use lib  '../';
use lib  '../Models/Utilits/';
use lib TDIR;
use lib '.';
use System::Tools::Toolchain;
use base qw(Test::Class);
use Test::More 'no_plan';

use Test::MockObject;
use Fake::SQL;
use Models::Performers::User;

System::Tools::Toolchain->instance(TDIR);

my ($user);

my $mockSQL = faceSQL->get(); 

sub startup : Test(startup)
{
    $user  = Models::Performers::User->new();
    ok($user,'Create class USER');
    isa_ok($user, 'Models::Performers::User');
}


sub user_add : Test
{
    $$mockSQL->mock( 'getRows', sub {0} );
    is($user->add('name','pass','email@mail.ru'),
        1,
        'add new user');
    $$mockSQL->mock( 'getRows', sub {1} );
    is($user->add('name','pass','email@mail.ru'),
        0,
        'not add new user');
    is($user->add('name','','email@mail.ru'),
        0,
        'not add new user, no password');
    is($user->add('','password','email@mail.ru'),
        0,
        'not add new user, no name');

    is($user->add('','password','emailimail.ru'),
        0,
        'not add new user, invalid email');
    is($user->add('','password'),
        0,
        'not add new user, no params');
}

Test::Class->runtests;
