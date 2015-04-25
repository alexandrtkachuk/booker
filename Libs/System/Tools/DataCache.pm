package System::Tools::DataCache;

use strict;
use vars qw(@ISA);
use System::Tools::Primitive;
@ISA = qw(System::Tools::Primitive);

sub new($);
sub setCache($$;$);
sub getCache($$);
sub unsetCache($$);
sub resetCache($);

sub new($)
{
	my $class = ref($_[0]) || $_[0];
	my $self = bless {'cache' => {}}, $class;
	$self->logIt(__LINE__, ref($self) . " object redy to use.");
	return $self;
}

sub setCache($$;$)
{
	my ($self, $key, $value) = @_;

	!$key &&
	$self->logIt(__LINE__, "ERROR: can't set new cache element because"
			. " no cache element name given!") &&
	return undef;

	$self->logIt(__LINE__, "New cache element named as $key saved.");
	return ! ! ($self->{'cache'}->{$key} = $value);
}

sub getCache($$)
{
	my ($self, $key) = @_;

	!$key &&
	$self->logIt(__LINE__, "ERROR: can't get cache element because"
			. " no cache element name given!") &&
	return undef;

	$self->logIt(__LINE__, "Returning cache element named as $key.");
	return $self->{'cache'}->{$key};
}

sub unsetCache($$)
{
	my ($self, $key) = @_;

	!$key &&
	$self->logIt(__LINE__, "ERROR: can't unset cache element because"
			. " no cache element name given!") &&
	return undef;

	!exists($self->{'cache'}->{$key}) &&
	$self->logIt(__LINE__, "ERROR: can't unset cache element $key"
			. " because it not exists!") &&
	return undef;

	delete($self->{'cache'}->{$key});
	return 1;
}

sub resetCache($)
{
	my ($self) = @_;

	$self->{'cache'} = {};
	$self->logIt(__LINE__, "Cache was cleaned successfully.");
	return 1;
}

sub DESTROY
{
	my ($self) = @_;
	$self->{'cache'} = undef;
	return 1;
}
1;
