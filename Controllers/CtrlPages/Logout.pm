package Controllers::CtrlPages::Logout;

use warnings;
use strict;

use vars qw(@ISA); 
our @ISA = qw(Controllers::CtrlPages::Index);
require Controllers::CtrlPages::Index;



sub go
{
    my($self)=@_;
    my $factory = $self->{'tools'}->makeNewObject(
        'Controllers::Factory::CtrlPages');

    unless($factory->isUser())
    {

        return 0;
    }

    my  $user  = $self->{'tools'}->getObject('Models::Performers::User');
    
    
    $user->logout();

    
    $self->{'tools'}->getCacheObject()->setCache('redirect','login');

    return 0;


}


1;
