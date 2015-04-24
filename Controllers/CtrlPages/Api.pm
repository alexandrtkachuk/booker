package Controllers::CtrlPages::Api;

use warnings;
use strict;
use JSON;
use vars qw(@ISA); 
our @ISA = qw(Controllers::CtrlPages::Index);
require Controllers::CtrlPages::Index;

use vars qw(%in);
use Models::Utilits::Email::Valid;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use Data::Dumper;
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

    if( $in{'end'} )
    {
       $self->{'tools'}->getCacheObject()->setCache('end',$in{'end'});
    }
    
    if( $in{'start'} )
    {
       $self->{'tools'}->getCacheObject()->setCache('start',$in{'start'});
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

sub addroom
{
    my($self)=@_;
    my $admin = $self->{'tools'}->getObject('Models::Performers::Admin');
    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');
    
    unless($admin->isAdmin())
    {
        return 0;
    }

    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');
    
    unless($in{'name'})
    { 
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;
    }

    my $room = $self->{'tools'}->getObject('Models::Performers::Rooms');
    unless($room->addRoom($in{'name'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;    
    }
    
    $self->{'tools'}->getCacheObject()->setCache('warings',1);
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
    
    #$self->{'tools'}->logIt(__LINE__,'?????'.Dumper(\%in) );
    #return 2;
    unless( $in{'POSTDATA'})
    {
        return 0;
    }

    my $data =decode_json $in{'POSTDATA'};
    #$self->{'tools'}->logIt(__LINE__,'?????'.Dumper($data) );
    unless($data->{'email'} && $data->{id} &&
        ( Email::Valid->address($data->{'email'})  ) &&
        ($data->{'name'}))
    { 
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;
    }
    
    unless($admin->update($data->{id},$data->{'name'},$data->{'email'},$data->{'pass'}))
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
    my $admin=$self->{'tools'}->getObject('Models::Performers::Admin');
    $id=$in{'iduser'};
    
    if(!$admin->isAdmin()  ||  $in{'iduser'}==-1 || !$in{'iduser'})
    {
        $id=$admin->getId();
    }
    
    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless( 
        $room->addOrder($in{idroom},$in{start},$in{'end'},$in{'info'},
            $id, $in{'recurrence'},$in{'count'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;    
    }

    $self->{'tools'}->getCacheObject()->setCache('warings',5);

    return 1;
}

sub updateorder
{
    my($self)=@_;

    my $room = $self->{'tools'}->getObject('Models::Performers::Rooms');
    my $id ;
    my $admin=$self->{'tools'}->getObject('Models::Performers::Admin');
    $id=$in{'iduser'};
    
    if(!$admin->isAdmin()  ||  $in{'iduser'}==-1 || !$in{'iduser'})
    {
        $id=-1;
    }

    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless( 
        $room->updateOrder($in{id},$in{start},$in{'end'},$in{'info'},
            $in{'idroom'}, $id, $in{'all'}))
    {
        $self->{'tools'}->getCacheObject()->setCache('warings',2);
        return 2;    
    }

    $self->{'tools'}->getCacheObject()->setCache('warings',5);

    return 1;
}

sub deleteorders
{
    my($self)=@_;
    my $room = $self->{'tools'}->getObject('Models::Performers::Rooms');
    my $admin=$self->{'tools'}->getObject('Models::Performers::Admin');
    $self->{'tools'}->getCacheObject()->setCache('pageparam','warings');

    unless($room->deleteOrder($in{'id'},$in{'all'}))
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
