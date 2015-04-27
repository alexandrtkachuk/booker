package Fake::SQL;

use warnings;
use strict;



use Test::MockObject;

my $mockSQL = Test::MockObject->new();

$mockSQL->fake_new( 'Models::Interfaces::Sql');


$mockSQL->mock( 'select', sub {1} );
$mockSQL->mock( 'connect', sub {1} );
$mockSQL->mock( 'getError', sub {1} );
$mockSQL->mock( 'select', sub {1} );
$mockSQL->mock( 'setTable', sub {1} );
$mockSQL->mock( 'where', sub {1} );
$mockSQL->mock( 'execute', sub {1} );
$mockSQL->mock( 'insert', sub {1} );
$mockSQL->mock( 'getSql', sub {1} );

$mockSQL->mock( 'test', sub {print "good";} );
my $sql = Models::Interfaces::Sql->new();


sub get
{
    return \$mockSQL;
}

1;
#Test::Class->runtests;
