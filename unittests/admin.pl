#!/usr/bin/perl 

#test  Models::Performers::Admin
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
use Test::More tests=>21;
use Test::MockObject;
use Fake::SQL;
use Fake::Session;
use Fake::Toolchain;
use Models::Performers::Admin;

my ($admin, $mockObj);
my $mockSQL = Fake::SQL->get(); 
my $mockSession = Fake::Session->get();
my $mockT = Fake::Toolchain->get();


sub startup : Test(startup =>2)
{
    $mockObj = Test::MockObject->new();
    $$mockT->mock( 'getObject', sub {
            return Models::Utilits::Sessionme->new();
        } );
    
    $admin  = Models::Performers::Admin->new();
     
    ok($admin,'Create class USER');
    isa_ok($admin, 'Models::Performers::Admin');
}

sub admin_isAdmin :Test(3)
{
    can_ok($admin,'isAdmin'); 
    $$mockSession->mock( 'getParam', sub {0} );
    is($admin->isAdmin(),0,'admin not login');
    $admin->{'name'}='test'; 
    is($admin->isAdmin(),1,'admin login');
}

sub admin_userList :Test(1)
{
    can_ok($admin,'userList');  
}

sub admin_update :Test(9)
{
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );

    can_ok($admin,'update'); 
    is($admin->update(),0,'not params');
    is($admin->update(1,'name','email'),0,'wrong email');
    $$mockSQL->mock( 'update',sub{1});
    is($admin->update(1,'name','email@mail.ru'),1,'good params');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{0})  
    );
    is($admin->update('id','name','email@mail.ru'),0,'id is not numeric');
    is($admin->update('id','name','email@mail.ru'),0,'id is not numeric');
    is($admin->update(0,'name','email@mail.ru'),0,'id < 1');
    is($admin->update(-21,'name','email@mail.ru'),0,'id < 1');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );
    is($admin->update(1,'name','email@mail.ru','pass'),1,
        'good params and pass');
}

sub admin_delete :Test(6)
{
    can_ok($admin,'delete'); 
    $$mockSQL->mock( 'delete',sub {1});
    is($admin->delete(),0,'not params');
    is($admin->delete(1),1,'good delete');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{0})  
    );
    is($admin->delete('id'),0,'id is not numeric');
    $mockObj->fake_module(
        'Models::Validators::Varibles'=>( 'isNumeric' => sub{1})  
    );
    is($admin->update(0,),0,'id < 1');
    is($admin->update(-21),0,'id < 1');

}

Test::Class->runtests;
