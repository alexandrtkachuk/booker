package System::Tools::Primitive;

use strict;
use Data::Dumper;
use System::Tools::Debug;

sub new($);
sub getClassName($);
sub set($$;$);
sub get($$);
sub delete($$);
sub logIt($;$$);

sub new($)
{
	my $class = ref($_[0]) || $_[0];

	return bless {}, $class;
}

sub getClassName($)
{
	my ($self) = @_;

	return ref($self);
}

sub set($$;$)
{
	my ($self, $key, $value) = @_;

	return undef unless ($key);

	$self->{$key} = $value;

	return 1;
}

sub get($$)
{
	my ($self, $key) = @_;

	return undef unless ($key);

	return $self->{$key};
}

sub delete($$)
{
	my ($self, $key) = @_;

	return undef if (!$key && !exists($self->{$key}));

	return ! ! delete($self->{$key});
}

sub logIt($;$$)
{
	my ($self, $line, $message) = @_;

	return System::Tools::Debug->logIt(ref($self), $line, $message);
}

1;
