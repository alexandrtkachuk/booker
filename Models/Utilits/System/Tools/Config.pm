package System::Tools::Config;

use strict;
use vars qw(@ISA);
use System::Tools::Primitive;
use System::Tools::DynamicItem;
use XML::Simple qw(XMLin XMLout);
@ISA = qw(System::Tools::Primitive);

use Data::Dumper;

my ($self, $config);
my $coreConfigPath = '/CoreConfig.xml';

sub instance($);
sub getDataBase($;$);
sub getSession($;$);
sub buildConfigObjects($$$);
sub makeDynamicObject($;$);

my $loadConfig = sub($$;$) {

	my ($self, $file, $options) = @_;

	! -r $file &&
	$self->logIt(__LINE__, "ERROR: Can't load $file config file!") &&
	return undef;

	my $xmlRef = undef;

	eval {
		$xmlRef = XMLin($file, %$options);
	};

	$@ &&
	$self->logIt(__LINE__, "ERROR: Can't parse $file config file!") &&
	$self->logIt(__LINE__, "$@") &&
	return undef;

	$self->logIt(__LINE__, "Config file $file was loaded and parsed.") &&
	return $xmlRef;
};

sub instance($)
{
	my $class = ref($_[0]) || $_[0];

	unless ($self)
	{
		my $options = {'ForceArray' =>
			['directory', 'session', 'debug', 'database']};
		$self = bless {}, $class;
		$coreConfigPath = $_[1] . $coreConfigPath;
		my $xmlConfig = $self->$loadConfig($coreConfigPath, $options);
        $config = {};
        $self->buildConfigObjects($config, $xmlConfig);
		$self->logIt(__LINE__, ref($self) . " instance redy to use.");
	}

	return $self;
}

sub getDirsConfig($;$)
{
	my ($self, $dirStatus) = @_;

	! $dirStatus &&
	($dirStatus = 'system');

	! exists($config->{'directory'}{$dirStatus}) &&
	return undef;

	return $config->{'directory'}{$dirStatus};
}

sub getDataBaseConfig($;$)
{
	my ($self, $dbStatus) = @_;

	! $dbStatus &&
	($dbStatus = 'main');

	! exists($config->{'database'}{$dbStatus}) &&
	return undef;

	return $config->{'database'}{$dbStatus};
}

sub getSessionConfig($;$)
{
	my ($self, $sessionStatus) = @_;

	! $sessionStatus &&
	($sessionStatus = 'default');

	! exists($config->{'session'}{$sessionStatus}) &&
	return undef;

	return $config->{'session'}{$sessionStatus};
}

sub getDebugConfig($;$)
{
	my ($self, $debugStatus) = @_;

	! $debugStatus &&
	($debugStatus = 'default');

	! exists($config->{'debug'}{$debugStatus}) &&
	return undef;

	return $config->{'debug'}{$debugStatus};
}

sub makeDynamicObject($;$)
{

	my ($self, $parametersHash) = @_;

	my $object;

	eval {
		$object = System::Tools::DynamicItem->new($parametersHash);
	};

	$@ && $self->logIt(__LINE__, "ERROR: $@") && return undef;

	return $object;
}

sub buildConfigObjects($$$)
{

	my ($self, $conf, $struct) = @_;

	! $struct &&
	$self->logIt(__LINE__, "ERROR: Config informaition is empty!") &&
	return undef;

	my $object = undef;

	if (ref($struct) eq 'ARRAY')
	{
		foreach $object (@$struct)
		{
			$self->buildConfigObjects($conf, $object);
		}
	}
	elsif (ref($struct) eq 'HASH' && !exists($struct->{'status'}))
	{
		foreach $object (keys %$struct)
		{
			$conf->{$object} = {};
			$self->buildConfigObjects($conf->{$object}, $struct->{$object});
		}
	}
	elsif (ref($struct) eq 'HASH' && exists($struct->{'status'}))
	{
		my $dynaItem = $self->makeDynamicObject($struct);
		$conf->{$dynaItem->status} = $dynaItem;
	}
    
    return 1;
}

sub DESTROY
{
	$self->logIt(__LINE__, "DESTROING system config object.");
	$config = undef;
	return 1;
}

1;
