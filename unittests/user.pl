#!/usr/bin/perl 

use warnings;
use strict;
use Data::Dumper;
use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Models/Utilits';
use lib  '../';
use lib  '../Models/Utilits/';
use lib TDIR;
use lib '.';
#use System::Tools::Toolchain;
use base qw(Test::Class);
use Test::More 'no_plan';

use Test::MockObject;
use Fake::SQL;
use Fake::Session;
use Fake::Toolchain;

use Models::Performers::User;

#System::Tools::Toolchain->instance(TDIR);

my ($user);

my $mockSQL = Fake::SQL->get(); 
my $mockSession = Fake::Session->get();
my $mockT = Fake::Toolchain->get();

#my $test = System::Tools::Toolchain->instance();
#$test->testFake();
#my $temp = $test->getConfigObject()->getDataBaseConfig();
#print Dumper($temp->dbuser);

sub startup : Test(startup)
{
    $$mockT->mock( 'getObject', sub {
            return Models::Utilits::Sessionme->new();
        } );
    
    $user  = Models::Performers::User->new();
     
    ok($user,'Create class USER');
    isa_ok($user, 'Models::Performers::User');
    can_ok($user, $_) for qw(
    add 
    login 
    isLogin
    logout
    getName
    getId
    getEmail
    getRole
    );
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



sub user_login : Test
{

    $$mockSQL->mock( 'getResult', 
        sub 
        {
           return 
           [{
                   'name'=>'name',
                   'id'=>1,
                   'role'=>0,
                   'email'=>'mail@mail.ru'
            }];
           
        } );

    is($user->login('name','pass','email@mail.ru'),
        1,
        'user is login');


}

Test::Class->runtests;
