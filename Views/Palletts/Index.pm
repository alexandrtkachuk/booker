package Views::Palletts::Index;

use warnings;
use strict;
use System::Tools::Toolchain;
use Data::Dumper;

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless({
       'tools' => System::Tools::Toolchain->instance()
        },$class);
}
#chenge hash
sub createHash
{
    my ($self)=@_;
    $self->{'page'}=$self->{'tools'}->getCacheObject()->getCache('nextpage'); 
    return 1;
}
##viewdubug##
sub viewdebug
{    
    my($self)=@_;   
    my $d=$self->{'tools'}->getDebugObject()->getLog();
    return Dumper($d);
}

sub loginuser
{   
        return "";
}

sub AUTOLOAD
{
    return '';
}

1;
