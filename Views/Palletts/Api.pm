package Views::Palletts::Api;


use warnings;
use strict;
use JSON;
use Encode;

use vars qw(@ISA); 
our @ISA = qw(Views::Palletts::Index);
require Views::Palletts::Index;


sub createHash
{
    
    my ($self)=@_;

    $self->{'title'}='Api';
    #print $data->{'pageparam'};
}


sub  getOut
{
    my ($self)=@_;

       my $fun=$self->{'tools'}->getCacheObject()->getCache('pageparam');
       my $res = $self->$fun();
        
       return $res;
}



sub lang
{
    #return 'lang';
     my ($self)=@_;
    
     return 
        $self->getJSON($self->{'tools'}->getObject('Models::Utilits::Lang')->get());
}

sub getJSON
{
    my($self, $ref,$res)=@_;

    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
}


sub warings
{
    my ($self)=@_;

    my  $w =$self->{'tools'}->getCacheObject()->getCache('warings');

    unless($w)
    {
        $w='0';
    }

    my $d=$self->{'tools'}->getDebugObject()->getLog();

    return $self->getJSON  ( {'warings'=>  $w});

}

sub test
{
    #$ENV{'SCRIPT_NAME'};
    my ($self)=@_;
    #return $self->getJSON(/$ENV{'HTTP_COOKIE'});
    print $ENV{'HTTP_COOKIE'};
    return ''; 
}


sub getorders
{
    my($self)=@_;
    my $start= $self->{'tools'}->getCacheObject()->getCache('start');
    my $end= $self->{'tools'}->getCacheObject()->getCache('end'); 
    my  $rooms  = $self->{'tools'}->getObject('Models::Performers::Rooms');
    my $roomid= $self->{'tools'}->getCacheObject()->getCache('roomid');
    my $res = $rooms->getToMounth($roomid,$start,$end);
    return   $self->getJSON($res);
}


sub adduser
{
    my($self)=@_;
    return
    $self->getJSON
    ({
            'warings'=>  $self->{'tools'}->getCacheObject()->getCache('warings'),
            'pass'=>  $self->{'tools'}->getCacheObject()->getCache('pass')
    });
}

sub userlist
{
    my($self)=@_;
    my $res = $self->{'tools'}->getObject('Models::Performers::Admin')->userList();
    unless($res)
    {
        return $self->warings();
    }
    
    return   $self->getJSON($res);
}


sub rooms
{
    my($self)=@_;
    my $res = $self->{'tools'}->getObject('Models::Performers::Rooms')->getRooms();
    unless($res)
    {
        return $self->warings();
    }
    
    return   $self->getJSON($res);
}

1;
