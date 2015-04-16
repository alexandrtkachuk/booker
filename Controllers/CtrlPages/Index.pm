package Controllers::CtrlPages::Index;

use warnings;
use strict;
use System::Tools::Toolchain;

sub new
{
    
    my $class = ref($_[0])||$_[0];
    return bless({ 
            'tools' => System::Tools::Toolchain->instance()
        },$class);
}

sub go
{
    my($self)=@_;
    my $factory = $self->{'tools'}->makeNewObject('Controllers::Factory::CtrlPages');

    unless($factory->isUser())
    {
        return 0;
    }

   return 1; 
}



1;
