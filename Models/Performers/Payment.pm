package Models::Performers::Payment;

use warnings;
use strict;



my $self;


sub new
{   
    my $class = ref($_[0])||$_[0];

    $self||=bless(
        {   
            'test'=>undef
        }   
        ,$class);

    return $self;

}



sub set
{
   my ($self,$test)=@_;
   $self->{'test'}=$test;
   return 1;
}


sub get
{
       return $self->{'test'};

}


1;
