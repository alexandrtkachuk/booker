package Controllers::CtrlPages::Api;

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
    my $factory = $self->{'tools'}->makeNewObject('Controllers::Factory::CtrlPages');

    unless($factory->isUser())
    {

        return 0;
    }
    if($in{'start'})
    {
        $self->{'tools'}->getCacheObject()->setCache('numpage',$in{'start'});
    }

    if($in{'set'})
    {
        my $fun=$self->{'tools'}->getCacheObject()->getCache('pageparam');
        $self->$fun();
        $self->{'tools'}->getCacheObject()->setCache('pageparam','warings'); 
    }

    return 1; 
}




sub setlang
{
    my($self)=@_;

    if($self->{'tools'}->getObject('Models::Utilits::Lang')->set($in{'set'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',1);
    }
    else
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',4);
    }

    return 1;
}


1;
