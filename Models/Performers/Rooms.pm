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
    $self->{'sql'}->setTable($tabprefix.'orders');
    $self->{'sql'}->select([
            'count(id)']);
    $self->{'sql'}->where('created = bo.created');
    my $q = $self->{'sql'}->getSql();

    $self->{'sql'}->select([
            'id',
            'id_room',
            'id_user',
            'info',
            'time_start',
            'time_end',
            'created',
            "($q) as count"
        ]);
    #print "time=$t \n mon=$mon \n";
    $self->{'sql'}->where('time_start',$timeStart,'>');  
    $self->{'sql'}->where('time_end',$timeEnd,'<');
    $self->{'sql'}->where('id_room',$idRoom);
    $self->{'sql'}->setTable($tabprefix.'orders bo');
    
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
    my($self,$idRoom,$timeStart,$timeEnd,$id,$timeCreated)=@_;

    my $start =localtime($timeStart);
    my $end=localtime($timeEnd);

    unless($start->year==$end->year && $start->mon==$end->mon &&
        $start->mday==$end->mday )
    {
        $self->{'tools'}->logIt(__LINE__, "not one day");
        return 0;
    }
    
    if($start->_wday==0 || $start->_wday==6)
    {
        $self->{'tools'}->logIt(__LINE__, "this is 0 or 6 day of weekly");
        return 0;
    }

    unless( $idRoom && $timeStart && $timeEnd)
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

    if($id && $id>0)
    {
        $self->{'sql'}->where('id',$id,'!=');
    }
    
    if($timeCreated)
    {
        $self->{'sql'}->where('created',$timeCreated,'!=');
    }

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
    $self->{'tools'}->logIt('??? sql ='.$self->{'sql'}->getSql()  );
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


sub updateOrder
{
    my($self,$idOrder,$timeStart,$timeEnd,$info,$idRoom,$idUser,$all)=@_;
    #timeStart and timeEnd not unix format (they have the format 00:00)
    unless($idOrder && $timeStart && $timeEnd && $info && $idRoom)
    {
        return 0;
    }
    
    $self->{'sql'}->select(['time_start','created','time_end','id_user' ]);
    $self->{'sql'}->where('id',$idOrder); 
    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }
    
    unless($self->{'sql'}->getRows())
    {
        return 0;
    }

    my $res =$self->{'sql'}->getResult();

    
    if($idUser<0 || !$idUser)
    {
        $idUser = $res->[0]{'id_user'};
    }

    unless($all)
    {
        my($start,$end) = $self->setTime2order($timeStart,
            $timeEnd,$res->[0]{'time_start'},$res->[0]{'time_end'});

        unless($self->empryTime($idRoom,$start,$end,$idOrder))
        {
            $self->{'tools'}->logIt(__LINE__, "is time no empry");
            return 0;
        }

        my %hash = (
            'time_start'=>$start,
            'time_end'=>$end,
            'info'=>$info,
            'id_user'=>$idUser
        );

        unless($self->update ($idOrder,\%hash) )  
        {
            return 0;
        }     

    }
    else
    {
        #nead all arderss for this time create             
        $self->{'sql'}->select(['id','time_start','created','time_end']);
        $self->{'sql'}->where('created',$res->[0]{'created'}); 
        $self->{'sql'}->setTable($tabprefix.'orders');

        unless($self->{'sql'}->execute())
        { 
            $self->{'tools'}->logIt(__LINE__, 
                "error to get Oredes".$self->{'sql'}->getError()
                ."\n script=".$self->{'sql'}->getSql()
            );
            return 0;
        }

        $res =$self->{'sql'}->getResult();

        for(@$res)
        {
            my($start,$end) = $self->setTime2order($timeStart,
                $timeEnd,$_->{'time_start'},$_->{'time_end'});
            unless($self->empryTime($idRoom,$start,$end,$_->{'id'}))
            {
                $self->{'tools'}->logIt(__LINE__, "is time no empry");
                return 0;
            }
        }#end for

        for(@$res)
        {
            my($start,$end) = $self->setTime2order($timeStart,
                $timeEnd,$_->{'time_start'},$_->{'time_end'});
            my %hash = (
                'time_start'=>$start,
                'time_end'=>$end,
                'info'=>$info,
                'id_user'=>$idUser
            );

            unless($self->update ($_->{'id'},\%hash))  
            {
                return 0;
            }     

        }#end for

    }#end else

    return 1;
}

sub setTime2order
{
    my($self,$timeStart,$timeEnd,$unixStart,$unixEnd)=@_;
    
    my $start = localtime($unixStart);
    my @time = split /:/,$timeStart;
    my $count = @time;

    if($count <2)
    {
        return 0;
    }

    my $start = timelocal(0,$time[1],$time[0],$start->mday,$start->_mon,
        $start->year-1900);
    my $end = localtime($unixEnd);
    @time = split /:/,$timeEnd;
    my $count = @time;
    
    if($count <2)
    {
        return 0;
    }
    #$self->{'tools'}->logIt(__LINE__,$time[1]);

    my $end = timelocal(0,$time[1],$time[0],$end->mday,$end->_mon,
        $end->year-1900);
    #my $t = localtime($end);

    #$self->{'tools'}->logIt(__LINE__, 
    #    "??? mih:".$t->min."  hour:".$t->hour."  \n  day:".
    #    $t->mday." month:".$t->mon." year:".$t->year."\n"
    #);

    return ($start,$end);
}

sub update
{
    my($self,$idOrder,$refhash)=@_;

    $self->{'sql'}->update( $refhash);
    $self->{'sql'}->where('id',$idOrder); 
    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }

    return 1;
}


sub deleteOrder
{
    my($self,$id,$all)=@_;

    unless($id)
    {
        return 0;
    }

    $self->{'sql'}->select(['time_start','created','time_end','id_user' ]);
    $self->{'sql'}->where('id',$id); 
    $self->{'sql'}->setTable($tabprefix.'orders');
    
    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }
    $self->{'tools'}->logIt(__LINE__, 'QQqqqq');
    unless($self->{'sql'}->getRows())
    {
        $self->{'tools'}->logIt(__LINE__, 
           "No rows!!??".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
        return 0;
    }

    my $res =$self->{'sql'}->getResult();    
    $self->{'sql'}->delete();
    
    if($all)
    {
         $self->{'sql'}->where('created',$res->[0]{'created'});
    }
    else
    {
        $self->{'sql'}->where('id',$id);
    }

    unless($self->{'sql'}->execute())
    { 
       $self->{'tools'}->logIt(__LINE__, 
           "error to get Oredes".$self->{'sql'}->getError()
           ."\n script=".$self->{'sql'}->getSql()
       );
       return 0;
    }
    
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
