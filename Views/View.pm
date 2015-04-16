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
    
    my $session = $self->{'tools'}->getPoolObject()->getObjectFromPool('Models::Utilits::Sessionme');
    unless($session)
    {
        $session =  Models::Utilits::Sessionme->new();
        $self->{'tools'}->getPoolObject()->addObjectInPool($session);
    }
    
    $self->{'tools'}->logIt(__LINE__, "test");

    my $cookie = $cgi->cookie(CGISESSID => $session->getId());

    if( $self->{'tools'}->getCacheObject()->getCache('redirect'))
    {
        print $cgi->redirect($self->{'tools'}->getCacheObject()->getCache('redirect'));
    } 

    my $templete='Resources/html/'.
    $self->{'tools'}->getCacheObject()->getCache('nextpage').
    '.html';

    $html = $self->{'tools'}->getDiskObject()->loadFileAsString($templete);

    if($html)
    {
        print $cgi->header( -cookie=>$cookie, -charset=>'utf-8');
        $self->{'pallett'}=$self->{'tools'}->makeNewObject(
            'Views::Palletts::'.
            $self->{'tools'}->getCacheObject()->getCache('nextpage')
        );    
        $html=$self->ReplaceH($html);
        $html=$self->ReplaceF($html);
        print $html; 
    }
    else
    {   
        $self->{'tools'}->getCacheObject()->setCache('nextpage','Error');
        $self->go();
    }
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

1;