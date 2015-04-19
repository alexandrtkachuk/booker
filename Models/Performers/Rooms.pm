package Models::Performers::Rooms;

use warnings;
use strict;

use System::Tools::Toolchain;
use Time::Local;

my ($self) ;
my $tabprefix = 'booker_';


sub new
{   my $tools = System::Tools::Toolchain->instance();
    my $db = $tools->getConfigObject()->getDataBaseConfig();
    my $sql =  Models::Interfaces::Sql->new(
        $db->dbuser,
        $db->host,
        $db->dbname,
        $db->pass);
    
    unless($self) 
    {
        unless($sql->connect())
        {
            $tools->getDebugObject()->logIt($self->{'sql'}->getError());
            return 0;
        }
    }
    
    my $class = ref($_[0])||$_[0];

    $self||=bless(
        {   
            'sql'=>$sql,
            'tools'=>$tools
        }   
        ,$class);

    return $self;
}

sub getToMounth
{
    my($self,$idRoom,$timeStart,$timeEnd)=@_;
    
    unless($idRoom && $timeStart && $timeEnd)
    {
        return 0;
    }
    #my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timeUnix);
       
    $self->{'sql'}->select([
            'id',
            'id_room',
            'id_user',
            'info',
            'time_start',
            'time_end',
            'created'
        ]);
    #print "time=$t \n mon=$mon \n";
    $self->{'sql'}->where('time_start',$timeStart,'>');  
    $self->{'sql'}->where('time_end',$timeEnd,'<');
    $self->{'sql'}->where('id_room',$idRoom);
    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }

    my $res = $self->{'sql'}->getResult();
    
    return $res;
}


sub addOrder
{
    my($self,$idRoom,$timeStart,$timeEnd,$info,$idUser)=@_;
    
    unless($idRoom && $timeStart && $timeEnd && $info && $idUser)
    {
        return 0;
    }

    $self->{'sql'}->insert({ 
            'id_room'=>$idRoom,
            'time_start'=>$timeStart,
            'time_end'=>$timeEnd,
            'info'=>$info, 
            'id_user'=>$idUser,
            'created'=>time()
        });

    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, "error to add Orede");
       return 0;
    }
    
    $self->{'tools'}->logIt(__LINE__, "Order is add");

    return 1;

}

sub getRooms
{
    my($self)=@_;

    $self->{'sql'}->select(['id','name']);
    $self->{'sql'}->setTable($tabprefix.'rooms');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, "error get name Rooms");
       return 0;
    }
    
    my $res = $self->{'sql'}->getResult();
    
    return $res;

}

sub addRoom
{
    my($self,$name)=@_;
    
    unless($name)
    {
        return 0;
    }    

    $self->{'sql'}->insert({'name'=>$name});
    $self->{'sql'}->setTable($tabprefix.'rooms');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, "error to add Rooms");
       return 0;
    }
    
    $self->{'tools'}->logIt(__LINE__, "Room $name is add");

    return 1;
}

















1;
