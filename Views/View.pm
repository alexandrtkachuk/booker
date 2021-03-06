package Views::View;
use warnings;
use strict;

use System::Tools::Toolchain;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use CGI::Carp qw(fatalsToBrowser); # позволит выводить ошибки в браузер
use Models::Utilits::Sessionme;

$|=1;

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless({
            'pallett'=>undef,
            'tools' => System::Tools::Toolchain->instance()
        },$class);
}

sub go()
{   
    my ($self)=@_;
    my $html;
    my $cgi = CGI->new;   
    my $session =$self->{'tools'}->getObject('Models::Utilits::Sessionme');
        
    my @cookies; 
    push(@cookies, $cgi->cookie(CGISESSID => $session->getId()));
   
    my $user = $self->{'tools'}->getObject('Models::Performers::User');
    
    if($user->isLogin() )
    {
        push(@cookies, $cgi->cookie(
                -name =>'tai-userid',
                -value=>$user->getId()));
        
        push(@cookies, $cgi->cookie(
                -name =>'tai-username',
                -value=>$user->getName()));
        push(@cookies, $cgi->cookie(
                -name =>'tai-userrole',
                -value=>$user->getRole()));
    }
    
    if( $self->{'tools'}->getCacheObject()->getCache('redirect'))
    {
        print $cgi->redirect($self->{'tools'}->getCacheObject()
            ->getCache('redirect'));
    } 

    #load template path 
    my $dirs = $self->{'tools'}->getConfigObject()->getDirsConfig();
    my $templete=$dirs->templates.
    $self->{'tools'}->getCacheObject()->getCache('nextpage').
    '.html';

    $html = $self->{'tools'}->getDiskObject()->loadFileAsString($templete);

    if($html)
    {
        print $cgi->header( -cookie=> \@cookies, -charset=>'utf-8');
        if($cgi->cookie('tai-lang'))
        {
            $self->{'tools'}->getObject('Models::Utilits::Lang')
            ->set( $cgi->cookie('tai-lang'));
        }

        $self->{'pallett'}=$self->{'tools'}->makeNewObject(
            'Views::Palletts::'.
            $self->{'tools'}->getCacheObject()->getCache('nextpage')
        );    
        $html=$self->ReplaceH($html);
        $html=$self->ReplaceF($html);
        $html=$self->ReplaceL($html);
        print $html; 
    }
    else
    {   
        $self->{'tools'}->getCacheObject()->setCache('nextpage','Error');
        $self->go();
    }

    return 1;    
}

sub ReplaceH
{
    my($self,$text)=@_;

    unless( $self->{'pallett'})
    {
        return $text; #'no pallet';
    } 

    $self->{'pallett'}->createHash();

    $text=~s/%%(\w+)%%/$self->{'pallett'}->{$1}/ge;
    #для поодержки вложеностей 
    $text=~s/%%(\w+)%%/$self->{'pallett'}->{$1}/ge;

    return $text;
}


sub ReplaceF
{
    my($self,$text)=@_;

    unless( $self->{'pallett'})
    {
        return $text; #'no pallet';
    } 

    $text=~s/##(\w+)##/$self->{'pallett'}->$1()/ge;
    return $text;
}
#replace lang
sub ReplaceL
{
    my($self,$text)=@_;
    #$lang = Models::Utilits::Lang->new();
    my $lang =$self->{'tools'}->getObject('Models::Utilits::Lang');
    
    $text=~s/%#(\w+)#%/$lang->getValue($1)/ge;
    
    return $text;
}


1;
