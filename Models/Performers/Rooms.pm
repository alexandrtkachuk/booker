package Models::Performers::Rooms;

use warnings;
use strict;

use System::Tools::Toolchain;
use Time::Local;
use Time::Seconds;
use Time::Piece;

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


sub empryTime
{
    my($self,$idRoom,$timeStart,$timeEnd)=@_;
    # t1=>t<=t2
    #
    #

    my $start =localtime($timeStart);
    my $end=localtime($timeEnd);

    unless($start->year==$end->year && $start->mon==$end->mon &&
        $start->mday==$end->mday )
    {
        return 0;
    }
    
    if($start->_wday==0 || $start->_wday==6)
    {
        return 0;
    }

    unless($idRoom && $timeStart && $timeEnd)
    {
        return 0;
    }

       
    $self->{'sql'}->select(['id']);

    $self->{'sql'}->where('(( time_start',$timeStart,'<=');  
    $self->{'sql'}->where('time_end',$timeStart,'>=');

    $self->{'sql'}->where(') OR  ( time_start',$timeEnd,'<=',' ');
    $self->{'sql'}->where('time_end',$timeEnd,'>=');
    
    $self->{'sql'}->where(') OR ( time_start',$timeStart,'>=', ' ');  
    $self->{'sql'}->where('time_start',$timeEnd,'<=');

    $self->{'sql'}->where(') OR ( time_end',$timeStart,'>=',' ');
    $self->{'sql'}->where('time_end',$timeEnd,'<=');
    
    $self->{'sql'}->where(')) AND id_room',$idRoom,'=',' ');
    
    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }
    $self->{'tools'}->logIt('???! start='.$timeStart.'id room = '.$idRoom); 
    #print $self->{'sql'}->getSql();
    if($self->{'sql'}->getRows())
    {
        #return $self->{'sql'}->getResult();
        return 0;
    }
    
    return 1;


}


sub addOrder
{
    my($self,$idRoom,$timeStart,$timeEnd,$info,$idUser,$recurrence,$count)=@_;
    #recurrence:
    #1 = weekly
    #2 = be-weekly 
    #3 =mounthly
    
    unless(!$recurrence || ( $count < 5 && $count > 0))
    {
        return 0;
    }

    unless($idRoom && $timeStart && $timeEnd && $info && $idUser)
    {
        return 0;
    }
    
    my $time = time();
    my %hash=( 
            'id_room'=>$idRoom,
            'time_start'=>$timeStart,
            'time_end'=>$timeEnd,
            'info'=>$info, 
            'id_user'=>$idUser,
            'created'=>$time
        );
    
    
   
    unless($self->empryTime($idRoom,$timeStart,$timeEnd))
    {
        $self->{'tools'}->logIt(__LINE__, "is time no empry");
        return 0;
    }
    $self->{'tools'}->logIt('???');
    my $start =localtime($timeStart);
    my $end=localtime($timeEnd);

    if($count)
    {
        $count--;
    }
    else
    {
        $count =0;
    }
 
    for(my $i=0;$i<$count;$i++)
    {
        if(1==$recurrence)
        {
            $start+=(ONE_DAY*7);
            $end+=(ONE_DAY*7);
        }
        elsif(2==$recurrence)
        {
            $start+=(ONE_DAY*14);
            $end+=(ONE_DAY*14);
        }
        elsif(3==$recurrence)
        {
            $start= $start->add_months(1);
            $end=$end->add_months(1); 
        }
        else
        {
            return 0;
        }
        
        unless($self->empryTime($idRoom,$start->epoch,$end->epoch))
        {
            $self->{'tools'}->logIt(__LINE__, "is time no empry");
            return 0;
        }
    }
   
    unless($self->createOrder(\%hash))
    {
        return 0;
    }
    $start =localtime($timeStart);
    $end=localtime($timeEnd);

    for(my $i=0;$i<$count;$i++ )
    {

        if(1==$recurrence)
        {
            $start+=(ONE_DAY*7);
            $end+=(ONE_DAY*7);
        }
        elsif(2==$recurrence)
        {
            $start+=(ONE_DAY*14);
            $end+=(ONE_DAY*14);
        }
        elsif(3==$recurrence)
        {
            $start= $start->add_months(1);
            $end=$end->add_months(1); 
        }
        
        $hash{'time_start'}=$start->epoch;
        $hash{'time_end'}=$end->epoch;
    
        unless($self->createOrder(\%hash))
        {
            return 0;
        }
    }

    return 1;
}



sub createOrder
{
    my($self,$refHash)=@_;

    $self->{'sql'}->insert($refHash);

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
