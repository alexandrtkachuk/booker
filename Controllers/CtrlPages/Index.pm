package Controllers::CtrlPages::Index;

use warnings;
use strict;
use System::Tools::Toolchain;
use Models::Utilits::Sessionme;

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
    my $session = $self->{'tools'}->getPoolObject()->getObjectFromPool('Models::Utilits::Sessionme');
    unless($session)
    {
        $session =  Models::Utilits::Sessionme->new();
        $self->{'tools'}->getPoolObject()->addObjectInPool($session);
    }
    
    #$self->{'tools'}->getCacheObject()->setCache('redirect','login'); 
   return 1; 

}



1;
