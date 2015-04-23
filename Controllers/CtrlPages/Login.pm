package Controllers::CtrlPages::Login;

use warnings;
use strict;

use vars qw(@ISA); 
our @ISA = qw(Controllers::CtrlPages::Index);
require Controllers::CtrlPages::Index;

use vars qw(%in);
use Models::Utilits::Email::Valid;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);

ReadParse();

sub go
{
    my($self)=@_;
    my $user= $self->{'tools'}->getObject('Models::Performers::User');
    
    if($in{'login'} )
    {
        my $err=undef; 
        (
            ($in{'email'}) && ($in{'pass'} && Email::Valid->address($in{'email'}))

            &&(
                ($user->login($in{'email'},$in{'pass'}) )
                || ( $err=5)
            )
        )
        ||( $err=2 );

        if($err)
        {
            $self->{'tools'}->getCacheObject()->setCache('warings',$err);
            return 0;
        }
    }

    if ($user->isLogin())
    {
        $self->{'tools'}->getCacheObject()->setCache('redirect','index');
    }

    return 1;
}

1;
