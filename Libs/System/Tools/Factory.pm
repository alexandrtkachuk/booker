package System::Tools::Factory;

use strict;
use vars qw(@ISA);
use System::Tools::Config;
use System::Tools::Primitive;
@ISA = qw(System::Tools::Primitive);

my $self;
my @codeDirs;

sub instance($);
sub getNewObject($$;$);


my $loadCodeDirs = sub ($) {

	my ($self) = @_;

	return 1 if (@codeDirs);

	eval {
		$self->logIt(__LINE__, "Loading code dirs from"
			. " system config file.");
		my $configObj = System::Tools::Config->instance();
		my $dirsConfigObj = $configObj->getDirsConfig();
		push @codeDirs, ($dirsConfigObj->coderoot,
			$dirsConfigObj->library);
		$self->logIt(__LINE__, "Code dirs was loaded:\n @codeDirs.");
	};

	$@ &&
	$self->logIt(__LINE__, "ERROR: $@") &&
	return undef;

	return 1;
};

my $requireFile = sub ($$) {

	my ($self, $objName) = @_;

	unless ($objName)
	{
		$self->logIt(__LINE__, "ERROR: empty object name!");
		return undef;
	}

	$objName =~ s/::/\//g;
	$objName .= '.pm';

	!$self->$loadCodeDirs() &&
	$self->logIt(__LINE__, "ERROR: can't load code dirs list!") &&
	return undef;

	my $fileFound = undef;

	foreach my $dir (@codeDirs)
	{
		my $file = $dir. '/' . $objName;
		next unless (-e $file && -r $file);

		eval {
			require $file;
			$fileFound = $file;
			last;
		};

		($@) && ($self->logIt(__LINE__, "ERROR: $@")) && (next);
	}

	if ($fileFound)
	{
		$self->logIt(__LINE__, "Required successfully: [$fileFound].");
		return ! ! $fileFound;
	}

	$self->logIt(__LINE__, "ERROR: required $objName not found"
		. " in system dirs!");
	return undef;
};

my $initObject = sub($$$) {

	my ($self, $objType, $initParametersArrRef) = @_;

	if ($objType->can('new'))
	{
		$self->logIt(__LINE__, "Making $objType as regular object.");
		return $objType->new(@$initParametersArrRef);
	}
	elsif ($objType->can('instance'))
	{
		$self->logIt(__LINE__, "Making $objType as singleton object.");
		return $objType->instance(@$initParametersArrRef);
	}

	$self->logIt(__LINE__, "ERROR: can't create $objType object,"
		. " because of undefined constructor name!");
	return undef;
};

sub instance($)
{
	my $class = ref($_[0]) || $_[0];
	$self ||= bless {}, $class;
	$self->logIt(__LINE__, ref($self) . " instance redy to use.");
	return $self;
}

sub getNewObject($$;$)
{
	my ($self, $objType, $initParametersArrRef) = @_;

	return undef unless ($self->$requireFile($objType));
	$initParametersArrRef ||= [];
	return $self->$initObject($objType, $initParametersArrRef);
}

1;
