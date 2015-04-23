package System::Tools::Toolchain;

use strict;
use vars qw(@ISA);
use System::Tools::Config;
use System::Tools::Debug;
use System::Tools::ObjectsPool;
use System::Tools::DataCache;
use System::Tools::Factory;
use System::Tools::Disk;
use System::Tools::Primitive;

@ISA = qw(System::Tools::Primitive);

my ($self, $inited,
	$configObj,
	$debugObj,
	$poolObj,
	$cacheObj,
	$factoryObj,
	$disk
);

sub instance($);
sub getPoolObject($);
sub getConfigObject($);
sub getCacheObject($);
sub getDebugObject($);
sub makeNewObject($$;$);
sub getDiskObject($);

my $initTools = sub($$) {

	my ($self, $baseDir) = @_;

	eval {
		$debugObj = System::Tools::Debug->instance();
		$configObj = System::Tools::Config->instance($baseDir);
		$poolObj = System::Tools::ObjectsPool->instance();
		$cacheObj = System::Tools::DataCache->new();
		$factoryObj = System::Tools::Factory->instance();
		$disk = System::Tools::Disk->instance();
		$inited = 1;
	};

	if($@)
	{
		$self->logIt(__LINE__, "ERROR: can't init Toolchain\n $@!");
		return undef;
	}

	return 1;
};

sub instance($)
{
	my $class = ref($_[0]) || $_[0];
	my $baseDir = $_[1];

	unless ($self)
	{
	 	$self = bless {}, $class;
		$self->logIt(__LINE__, "Toolchain preparing to use...");

		!$inited &&
		$self->$initTools($baseDir) &&
		$self->logIt(__LINE__, ref($self) . " instance redy to use.");
	}

	return $self;
}

sub getPoolObject($)
{
	return $poolObj;
}

sub getConfigObject($)
{
	return $configObj;
}

sub getCacheObject($)
{
	return $cacheObj;
}

sub getDebugObject($)
{
	return $debugObj;
}

sub makeNewObject($$;$)
{
	my ($self, $objType, $objParameters) = @_;
	return $factoryObj->getNewObject($objType, $objParameters);
}

sub getDiskObject($)
{
	return $disk;
}

sub getObject($$;$)
{
    my ($self, $objType, $objParameters) = @_;
    my $temp = $self->getPoolObject()->getObjectFromPool($objType);
    
    unless($temp)
    {
       $temp = $self->makeNewObject($objType, $objParameters);
    }

    $self->getPoolObject()->addObjectInPool($temp); 
    return $temp;
}

1;
