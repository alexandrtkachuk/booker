package Controllers::Factory::CtrlPages;

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

sub isUser
{
    my($self)=@_;
    
    my  $user  = $self->{'tools'}->getObject('Models::Performers::User'); 

    unless($user->isLogin())
    {
        $self->{'tools'}->getCacheObject()->setCache('redirect','login');
        return 0;
    }
    
    return 1; 
}



1;
