package System::Tools::ObjectsPool;

use strict;
use vars qw(@ISA);
use System::Tools::Primitive;
@ISA = qw(System::Tools::Primitive);
my ($self, $objectsPool, $maxObjectsInPool);

sub instance($);
sub setMaxPoolDepth($$);
sub getMaxPoolDepth($);
sub getPoolDepth($);
sub isPoolFull($);
sub addObjectInPool($$);
sub updateObjectInPool($$);
sub getObjectFromPool($$);

my $isObjectInPool = sub($$) {

	my ($self, $objName) = @_;

	return 1 if (exists($objectsPool->{$objName}));
	return undef;
};

my $destroyObject = sub($$) {

	my ($self, $objName) = @_;

	if (exists($objectsPool->{$objName}))
	{
		delete($objectsPool->{$objName});
		return 1;
	}

	return undef;
};

sub instance($)
{
	my $class = ref($_[0]) || $_[0];

	unless ($self)
	{
		$self = bless {}, $class;
		$objectsPool = {};
		$maxObjectsInPool = 0;
		$self->logIt(__LINE__, ref($self) . " instance redy to use.");
	}

	return $self;
}

sub setMaxPoolDepth($$)
{
	my ($self, $maxObjects) = @_;

	unless ($maxObjects =~ /^\d+$/)
	{
		$self->logIt(__LINE__, "ERROR: max objects pool depth"
			." should be digit!");
		return undef;
	}

	if ($maxObjects < scalar(keys %$objectsPool))
	{
		$self->logIt(__LINE__, "ERROR: can't set new pool depth"
			. " because current pool deept gt than new depth!");
	}

	$self->logIt(__LINE__, "Set new objects pool deept as $maxObjects.");

	return ! ! ($maxObjectsInPool = $maxObjects);
}

sub getMaxPoolDepth($)
{
	my ($self) = @_;

	$self->logIt(__LINE__, "Max setted objects pool depth"
		. " is $maxObjectsInPool.");

	return $maxObjectsInPool;
}

sub getPoolDepth($)
{
	my ($self) = @_;

	my $currentDepth = scalar(keys %$objectsPool);
	$self->logIt(__LINE__, "Current objects in pool: $currentDepth.");

	return $currentDepth;
}

sub isPoolFull($)
{

        my ($self) = @_;

        if ($maxObjectsInPool == $self->getPoolDepth())
	{
		$self->logIt(__LINE__, "Objects pool is full!");
		return 1;
	}

	$self->logIt(__LINE__, "Objects pool is not full!");

        return undef;
}

sub addObjectInPool($$)
{
	my ($self, $object) = @_;

	!$self->isPoolFull() &&
	! $self->$isObjectInPool(ref($object)) &&
	($objectsPool->{ref($object)} = $object) &&
	$self->logIt(__LINE__, ref($object)
		. " bject added in objects pool.") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't add " . ref($object)
		. " in objects pool, the pool overfloved or"
		. " the object alredy exists!");

	return undef;
}

sub updateObjectInPool($$)
{
	my ($self, $object) = @_;

	$self->$isObjectInPool(ref($object)) &&
	($objectsPool->{ref($object)} = $object) &&
	$self->logIt(__LINE__, ref($object) . " updated in objects pool.") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't update " . ref($object)
		. " in objects pool because the object isn't in pool!");

	return undef;
}

sub getObjectFromPool($$)
{
	my ($self, $objName) = @_;

	my $obj = undef;

	$self->$isObjectInPool($objName) &&
	($obj = $objectsPool->{$objName}) &&
	$self->$destroyObject($objName) &&
	$self->logIt(__LINE__, "Returning $objName from objects pool.") &&
	return $obj;

	$self->logIt(__LINE__, "ERROR: can't returnin $objName"
		. " from objects pool because the object isn't"
		. " exists in the pool!");

	return undef;
}

sub DESTROY
{
	$self->logIt(__LINE__, "DESTROING objects pool.");
	$objectsPool = undef;
	$maxObjectsInPool = undef;
	return 1;
}
1;
