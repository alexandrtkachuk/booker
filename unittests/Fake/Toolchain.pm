package Fake::Toolchain;

use warnings;
use strict;



use Test::MockObject;

my $mockObj = Test::MockObject->new( );


$mockObj->fake_module(
    'System::Tools::Toolchain'=>( 'instance' => sub{return  $mockObj; })  
);

$mockObj->mock( 'testFake', sub {print "good Fake Toolchai \n";} );
$mockObj->mock( 'getCacheObject', sub {return $mockObj; } );
$mockObj->mock( 'setCache', sub {1} );
$mockObj->mock( 'getDebugObject', sub {1} );
$mockObj->mock( 'getConfigObject', sub {return $mockObj; } );

$mockObj->mock( 'getDataBaseConfig', sub {return $mockObj;} );
$mockObj->mock( 'dbuser', sub {1} );
$mockObj->mock( 'host', sub {1} );
$mockObj->mock( 'dbname', sub {1} );
$mockObj->mock( 'pass', sub {1} );

sub get
{
    return \$mockObj;
}

1;

