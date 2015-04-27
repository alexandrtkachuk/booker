#!/usr/bin/perl 

#test Models::Interfaces::Sql
use warnings;
use strict;
use File::Basename;
use constant TDIR=>dirname(__FILE__);
use lib  './Libs';
use lib  '../';
use base qw(Test::Class);
use Test::MockObject;
use Test::More 'no_plan';
use Models::Interfaces::Sql;

my ($mockObj ,$sql, $dbh,$sth);

sub startup : Test(startup)
{
    $mockObj = Test::MockObject->new();
    $dbh = Test::MockObject->new();
    $sth =Test::MockObject->new();
    $sql =  Models::Interfaces::Sql->new();
    is($sql,0,'no create class, not params');
    $sql =  Models::Interfaces::Sql->new('bdname','host','user','pass');
    ok($sql,'Create class SQL');
    isa_ok($sql, 'Models::Interfaces::Sql');
}

sub sql_1_connect :Test
{
    can_ok($sql,'connect');
    $mockObj->fake_module(
        'DBI'=>( 'connect' => sub{0})  
    );
    is( $sql->connect(), 0, 'resul = 0 , param is wrong' );
    $dbh->mock( 'disconnect', sub {1} );
    $dbh->mock( 'quote', sub 
        {
            my ($self,$str)=@_;
            return "'$str'";
        } );

    $mockObj->fake_module(
        'DBI'=>( 'connect' => sub{return $dbh})  
    );
    is( $sql->connect(), 1, 'good connect' );
}

sub sql_2_select :Test
{
    can_ok($sql,'select');
    is( $sql->select( ),0, 'return 0, no param' );
    is($sql->select(['title','id','price'] ),1,' cearte select  ' );

}


sub sql_3_setTeble :Test
{
    can_ok($sql,'setTable');
    is($sql->setTable(),0, 'no param');
    is($sql->setTable('shop_books'),1, 'set table');
}

sub sql_4_where :Test
{
    can_ok($sql,'where');
    is($sql->where('id',3),1,"set WHERE id = '3'");
}

sub sql_5_execute :Test
{
    can_ok($sql,'execute');
    $sth->mock( 'execute', sub {1});
    $dbh->mock( 'prepare', sub {return $sth;});
    is($sql->execute(),1, 'query is create and is prepare  good');
}

sub sql_6_getSql :Test
{
    can_ok($sql,'getSql');
    like($sql->getSql(), 
        qr/^(SELECT *title, id, price *FROM shop_books *WHERE *id = '3') *$/, 
        'true my query');

}

Test::Class->runtests;
