package Fake::Session;

use warnings;
use strict;



use Test::MockObject;

my $mockObj = Test::MockObject->new();

$mockObj->fake_new('Models::Utilits::Sessionme');
$mockObj->mock( 'setParam', sub {
        
        return 1;
    } );

$mockObj->mock( 'testFake', sub {print "goodSession";} );
sub get
{
    return \$mockObj;
}

1;

