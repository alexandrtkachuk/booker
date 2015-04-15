package System::Tools::Debug;

use strict;

my ($self, $debug, $debugOn);

sub instance($);
sub logIt($;$$$);
sub getLog($);
sub clearLog($);

sub instance($)
{
	my $class = ref($_[0]) || $_[0];

	unless ($self)
	{
		$debug = [];
		$debugOn = 1;#undef;
		$self = bless {}, $class;
	}

	return $self;
}

sub logIt($;$$$)
{
	my ($self, $file, $line, $message) = @_;

	return 1 unless ($debugOn);
	push @$debug, "$file $line: $message";
	return 1;
}

sub getLog($)
{
	my ($self) = @_;

	return $debug;
}

sub clearLog($)
{
	my ($self) = @_;

	$debug = [];
	return 1;
}

1;
