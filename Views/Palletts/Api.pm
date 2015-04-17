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
    return
    $self->getJSON
    (
        {'warings'=>  $self->{'tools'}->getCacheObject()->getCache('warings')}
    );

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


    my $start= $self->{'tools'}->getCacheObject()->getCache('numpage');
 
    my  $rooms  = $self->{'tools'}->getObject('Models::Performers::Rooms');
    
    my $res = $rooms->getToMounth(1,$start);


    return 
        $self->getJSON($res);
   
}




1;
