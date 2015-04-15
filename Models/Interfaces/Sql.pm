package Models::Interfaces::Sql;


use warnings;
use strict;
use DBI; 
use Data::Dumper;
use Models::Validators::Varibles;

use Models::Utilits::Debug;
my $debug = Models::Utilits::Debug->new();

my($database, $host,$user, $pass,$dbh,$sth,$testmode );

#setQuery



#конструктор
sub new
{

    $database=$_[1]; 
    $host=$_[2];
    $user=$_[3];
    $pass=$_[4];
    $testmode=$_[5]; 
    unless( $database && $host && $user && $pass)
    {
        return 0;
    }

    my $class = ref($_[0])||$_[0];
    return bless(
        {
            'sql'=>undef, #string quvery
            'table'=>undef, #имя таблици 
            'where'=>undef,
            'DISTINCT'=>' ',
            'ORDERBY'=>undef,
            'GROUP_CONCAT'=>undef
        },$class);

}



sub getError
{   
    return 'error connrct to DB' unless($dbh);
    return 'error qerty string' unless($sth);
    return $dbh->errstr() || $sth->errstr() || undef ;   
    #return 0 || 1; 
}

sub connect
{
    unless($database &&  $host )
    {
        return 0;
    }

    my $data_source= "DBI:mysql:database=$database;host=$host";

    $dbh = DBI->connect($data_source, $user, $pass, 
        {PrintError=>0, RaiseError=>0} #отключаем принт ошибок
    );
    
    
    return 1 if($dbh);
    return 0;

}


sub OrederBy
{
   return 0 unless($dbh);
   my($self,$val , $param) = @_;

   unless($val)
   {
        return 0;
   }

   unless($param)
   {
        $param='ASC';
   }

    $self->{'ORDERBY'}=$val.' '.$param;

    return 1;
 
}

sub where
{
    return 0 unless($dbh);
    my($self,$val1,$val2,$sign, $union) = @_;
    
    unless($sign)
    {
        $sign='=';
    }
    
    unless($union)
    {
        $union='AND';
    }

     
    unless($val1)
    {
        return 0;
    }

    if($self->{'where'})    
    {
        if($val2)
        {
            $self->{'where'}.=" $union $val1 $sign ".$dbh->quote($val2).' ';
        }
        else
        {
            $self->{'where'}.=" $union $val1 ";
        }
    }
    else
    {
        if($val2)
        {
            $self->{'where'}.=" $val1 $sign ".$dbh->quote($val2).' ';
        }
        else
        {
            $self->{'where'}.=" $val1 ";
        }

    
    }
    
    return 1;


}


sub select
{
    return 0 unless($dbh);
    my($self,$arr) = @_;
   
   unless($arr)
   {
        return 0;
   } 
    $self->{'sql'}='SELECT  %DISTINCT% '; 
    
    for(@$arr){
         $self->{'sql'}.= $_;
        if(\$_ != \$$arr[-1])
        {
             $self->{'sql'}.= ', ';
        }

    }

    $self->{'sql'}.=' FROM %tabname% ';
    return 1;
    

}

sub update
{
   return 0 unless($dbh);
    my($self,$hash) = @_;
    

    #print Dumper $hash;
    #my %t=%$hash;
    

    $self->{'sql'}='UPDATE %tabname% SET   ';
    my $left= keys %$hash; 
    foreach my  $k (keys %$hash )
    {
        #print   $$hash{$ky};
        $self->{'sql'}.= $k.'= '.$dbh->quote($$hash{$k});
        if(0 < --$left  )
        {
            $self->{'sql'}.=', ';

        }    
    }
    
    


    return 1;
}




sub insert
{

    return 0 unless($dbh);
    my($self,$hash) = @_;
    

    #print Dumper $hash;
    #my %t=%$hash;
    

    $self->{'sql'}='INSERT INTO %tabname%  (';
    my $left= keys %$hash; 
    foreach my  $k (keys %$hash )
    {
        #print   $$hash{$ky};
        $self->{'sql'}.= $k;
        if(0 < --$left  )
        {
            $self->{'sql'}.=', ';

        }    
    }
    
    $self->{'sql'}.=')   VALUES (';
    $left= keys %$hash;
    foreach my  $k (keys %$hash )
    {
        #print   $$hash{$ky};
        $self->{'sql'}.= $dbh->quote($$hash{$k});
        if(0 < --$left  )
        {
            $self->{'sql'}.=', ';

        }    
    }

    $self->{'sql'}.=')   ';



    #Models::Validators::Varibles->isNumeric();
    
    #print $self->{'sql'};
    return 1;
    
}


sub setTable
{
    return 0 unless($dbh);

    my($self,$name) = @_;
    unless($name)
    {
        return 0;
    }
    
    $self->{'table'} = $name;
    return 1;
}



sub setQuery
{   
    return 0 unless($dbh);
    my($self,$str) = @_;
    return 0  unless($str);
    $self->{'sql'}=$str;
    return 1;
    
    
}


sub getLastId
{
    my($self) = @_;
    return 0 unless($dbh);

    return $dbh->last_insert_id( undef, undef, undef, undef );

}




sub setDISTINCT
{
    my($self,$value) = @_;
    if($value)
    {
        $self->{'DISTINCT'} = 'DISTINCT';
    }
    else
    {
        $self->{'DISTINCT'} = ' ';
    }
    
    return 1;
}


sub GROUP_CONCAT
{
    
    return 0 unless($dbh);
    my($self,$val1,$val2) = @_;
    
    $self->{'sql'}="SELECT GROUP_CONCAT( $val1 ) as  $val2"; 
  
    
    $self->{'sql'}.=' FROM %tabname% ';
    
    return 1;

}


sub getSql
{

    my($self) = @_;
    unless($self->{'sql'})
    {
        return 0;
    }
    
    #$self->{'sql'}= $dbh->quote( $self->{'sql'});

    
    unless($self->{'table'})
    {
        return 0;
    }    
    
    $self->{'sql'} =~s/%tabname%/$self->{'table'}/;
    
    $self->{'sql'} =~s/%DISTINCT%/$self->{'DISTINCT'}/;


    if($self->{'where'} )
    {
        $self->{'sql'}.=' WHERE '.$self->{'where'};
        $self->{'where'}=undef; #clear 
    }

    if($self->{'ORDERBY'})
    {
         $self->{'sql'}.= ' ORDER BY '.$self->{'ORDERBY'};
    }

    #print $self->{'sql'};
    #$debug->setMsg( $self->{'sql'}); 
    return  $self->{'sql'};

}


sub execute
{   

    my($self) = @_;
    
    
    unless($self->getSql())
    {
        return 0;
    }
    ########################### 
    unless($sth = $dbh->prepare($self->{'sql'} ))
    {
        return 0;
    }
    
    return 0 unless($sth);
    
    if($testmode)
    {
          return 1;
    }

    return $sth->execute();
}

sub getRows
{
    return 0 unless($sth);
    return $sth->rows;
}

sub getResult
{
    return 0 unless($sth);
    #выходные данные
    my @arr; 

    while (my $row = $sth->fetchrow_hashref()) 
    {    
        push @arr , $row;
       
    }     

    $sth->finish();
    
    return \@arr;

}


sub delete
{
    return 0 unless($dbh);
    my($self) = @_;

    $self->{'sql'}='DELETE '; 

    $self->{'sql'}.=' FROM %tabname% ';
    return 1;


}


sub DESTROY 
{
    my($self) = @_;
    if($dbh ){
        $dbh->disconnect();
    }

}

1;
