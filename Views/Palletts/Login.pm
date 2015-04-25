package Views::Palletts::Login;


use warnings;
use strict;


#три строчки которые делают наследие 
use vars qw(@ISA); 
our @ISA = qw(Views::Palletts::Index);
require Views::Palletts::Index;



sub createHash
{
    
    my ($self)=@_;

    $self->{'title'}='Login form';
}

sub warings
{
    my ($self)=@_;
    my $mess='';
    my $warings = $self->{'tools'}->getCacheObject()->getCache('warings');
    
    if($warings ==5)
    {
         $mess = '%#warings5#%';
    }
    elsif($warings ==2 )
    {
        $mess = '%#warings2#%';
    }
    
    return $mess;
}

1;
