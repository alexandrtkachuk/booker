package System::Tools::DynamicItem;

use strict;
use vars qw(@ISA $AUTOLOAD);
use System::Tools::Primitive;
@ISA = qw(System::Tools::Primitive);

sub new($$)
{
	my $class = ref($_[0]) || $_[0];
	return bless {'config' => $_[1]}, $class;
}

sub AUTOLOAD
{
	my ($self) = @_;
	my $subName = $AUTOLOAD;

	return undef unless $subName =~ /^.*::\w+$/;
	$subName =~ s/^.*:://;
	no strict 'refs';
	my $sub = sub {
		my ($self) = shift;
		return $self->{'config'}->{$subName};
	};

	*{$AUTOLOAD} = $sub;
	use strict 'refs';

	goto &{$sub};
}

1;
