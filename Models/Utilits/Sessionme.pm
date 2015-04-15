package Models::Utilits::Sessionme;

use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use CGI::Session;

use warnings;
use strict;

my $self; 

sub new
{   
    my $class = ref($_[0])||$_[0];
    my $session;
    unless($self)
    {
        $session = new CGI::Session(
            "driver:File",
            $_[1], 
            {Directory=>'/tmp'});
    }

    $self||=bless(
        {   
            'session'=>$session,
            'id'=>$session->id() 
        }   
        ,$class);

    return $self;
}

sub getId
{   
    my ($self)=@_;
    return $self->{'id'};
}

sub delete
{
    my ($self)=@_;
    $self->{'session'}->delete();

    return 1;
}

sub setParam($$)
{
    my ($self,$param,$value)=@_;
    $self->{'session'}->param($param,$value);
    
    return 1;
}

sub getParam($)
{
    my ($self,$param)=@_;
    return $self->{'session'}->param($param);
}

sub DESTROY
{

}

1;

