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
    #$self->{'baseurl'}=Config::Config->getBaseUrl() ;
    #$self->{'getHeader'}=$self->loadTemplate('Header');
    #$self->{'getFooter'}=$self->loadTemplate('Footer');
        #print $data->{'pageparam'};
}



sub warings
{
my ($self)=@_;
    my $mess='';

    my $warings = $self->{'tools'}->getCacheObject()->getCache('warings');
    if($warings ==5)
    {
         $mess = 'неверный логин или пароль при входе';
    }
    elsif($warings ==2 )
    {
        $mess = 'не все поля заполнены в форме';
    }
    
#print '???????????????';
    return $mess;

}

1;
