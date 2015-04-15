package Models::Utilits::Lang;

use warnings;
use strict;

use Models::Utilits::Sessionme;
my $session =  Models::Utilits::Sessionme->new();
use Config::Config;
use XML::Simple qw(:strict);
use Models::Utilits::File;
use Models::Utilits::Debug;
my $debug = Models::Utilits::Debug->new();

my $self;


sub new
{   

       my $class = ref($_[0])||$_[0];
        my $lang;

        unless($self )
        {
            $lang='ru';
        }

        if($session->getParam('lang'))
        {
           $lang=$session->getParam('lang');
            
        }



    $self||=bless(
        {   
            'lang'=>$lang,
            'value'=>undef
            
        }   
        ,$class);

    return $self;

}


sub get
{
    my ($self)=@_;
    unless($self->{'value'} )
    {
        $self->load();
    }
    #print  $self->{'lang'};
    return $self->{'value'};
}

sub set
{
    my ($self,$value)=@_;
    
    unless($value)
    {
        return 0;
    }

    $session->setParam('lang',$value);
    $self->{'lang'}=$value;
    $debug->setMsg('session id = '.$session->getId());
    return $value;
}


sub load
{
    my ($self)=@_;
    my $tdir = Config::Config->getDir();
    my $fullpath= $tdir.'/Resources/langs/'.$self->{'lang'}.'.strings';
    #print $fullpath; 
    my $file = Models::Utilits::File->new();
    my $xml = $file->getFile($fullpath); 

    #print $xml;
    my $ref;
    if($xml)
    { 
      $self->{'value'}=  XMLin($fullpath, forcearray => ['ISTRING'], keyattr => ['KEY'] );
      return 1;
    }

    return 0;
    
        

}


1;
