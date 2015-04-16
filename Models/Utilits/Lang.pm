package Models::Utilits::Lang;

use warnings;
use strict;

use XML::Simple qw(:strict);
use System::Tools::Toolchain;
my ($self, $session);
sub getValue($$);

sub new
{   

    my $class = ref($_[0])||$_[0];
    my ($lang, $tools);

    unless($self )
    {
        $lang='ru';
        $tools = System::Tools::Toolchain->instance();
        $session = $tools->getObject('Models::Utilits::Sessionme');
    }

    if($session->getParam('lang'))
    {
        $lang=$session->getParam('lang'); 
    }

    $self||=bless(
        {   
            'lang'=>$lang,
            'value'=>undef,
            'tools'=> $tools
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
    return $self->{'value'};
}

sub set
{
    my ($self,$value)=@_;
    
    unless($value)
    {
        return 0;
    }
    
    my $temp = $self->{'lang'};
    $self->{'lang'}=$value;
    
    unless($self->load())
    {
        $self->{'lang'}=$temp;
        return 0;
    }

    $session->setParam('lang',$value);
    $self->{'lang'}=$value;
    $self->{'tools'}->getDebugObject()->logIt(
        'session id = '.$session->getId()
    );
    return $value;
}


sub getValue($$)
{
    my ($self,$value)=@_;
    $self->get(); 
    return $self->{'value'}->{'ISTRING'}{"LANG_$value"}{'VALUE'};
}

sub load
{
    my ($self)=@_;
    my $fullpath= 'Resources/langs/'.$self->{'lang'}.'.strings';
    my $xml = $self->{'tools'}->getDiskObject()->loadFileAsString($fullpath );

    if($xml)
    { 
      $self->{'value'}=  XMLin(
          $fullpath, 
          forcearray => ['ISTRING'], keyattr => ['KEY'] );
      return 1;
    }

    return 0;
}

1;
