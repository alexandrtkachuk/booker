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
    my $factory = $self->{'tools'}->makeNewObject(
        'Controllers::Factory::CtrlPages');

    unless($factory->isUser())
    {

        return 0;
    }

    if($in{'roomid'})
    {
        $self->{'tools'}->getCacheObject()->setCache('roomid',$in{'roomid'});
    }

    if($in{'start'} &&  $in{'end'} )
    {
        $self->{'tools'}->getCacheObject()->setCache('start',$in{'start'});
        $self->{'tools'}->getCacheObject()->setCache('end',$in{'end'});
    }

    

    my $fun=$self->{'tools'}->getCacheObject()->getCache('pageparam');
    #$self->{'tools'}->getCacheObject()->setCache('pageparam','warings');
    
    unless($self->$fun())
    {
        $self->{'tools'}->getCacheObject()->
        setCache('pageparam','none');
    } 


    return 1; 
}

sub adduser
{
    my($self)=@_;
    
    my $admin = $self->{'tools'}->getObject('Models::Performers::Admin');
    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');
    unless($admin->isAdmin())
    {
        return 0;
    }

    unless($in{'email'} && 
        ( Email::Valid->address($in{'email'})  ) &&
        ($in{'name'}))
    { 
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;
    }

    my @chars = ("A".."Z", "a".."z", 0..9);
    my $pass;
    $pass .= $chars[rand @chars] for 1..8;
    
    unless($admin->add($in{'name'},$pass,$in{'email'}))
    {
        return 3;
    }

    $self->{'tools'}->getCacheObject()->setCache('pass',$pass);
    $self->{'tools'}->getCacheObject()->setCache('warings',1);
    $self->{'tools'}->getCacheObject()->setCache('pageparam','adduser');

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


sub userlist
{
    my($self)=@_;

    unless($self->{'tools'}->getObject('Models::Performers::Admin')->isAdmin())
    {
        return 0;
    }

    return 1;
}

sub updateuser
{
    my($self)=@_;
    my $admin = $self->{'tools'}->getObject('Models::Performers::Admin');
    
    unless($admin->isAdmin())
    {
        return 0;
    }

    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless($in{'email'} && $in{id} &&
        ( Email::Valid->address($in{'email'})  ) &&
        ($in{'name'}))
    { 
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;
    }
    
    unless($admin->update($in{id},$in{'name'},$in{'email'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 3;
    }

    return 1;
}


sub deleteuser
{
    
    my($self)=@_;
    my $admin = $self->{'tools'}->getObject('Models::Performers::Admin');
    
    unless($admin->isAdmin())
    {
        return 0;
    }

    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless($in{id} )
    { 
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;
    }
    
    unless($admin->delete($in{id}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 3;
    }

    return 1;
}

sub addorder
{
    my($self)=@_;
    #$idRoom,$timeStart,$timeEnd,$info,$idUser,$recurrence,$count
    my $room = $self->{'tools'}->getObject('Models::Performers::Rooms');
    my $id ;
    if($in{'id'}==-1 || !$in{'id'} )
    {
        $id=$self->{'tools'}->getObject('Models::Performers::User')->getId();
    }

    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless( 
        $room->addOrder($in{idroom},$in{start},$in{'end'},$in{'info'},
            $in{'iduser'}, $in{'recurrence'},$in{'count'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;    
    }

    $self->{'tools'}->getCacheObject()->setCache('warings',5);

    return 1;
}

sub AUTOLOAD
{
    return 1;
}


1;
