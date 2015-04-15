package Views::Palletts::Api;


use warnings;
use strict;
use JSON;
use Encode;

#три строчки которые делают наследие 
use vars qw(@ISA); 
our @ISA = qw(Views::Palletts::Index);
require Views::Palletts::Index;
use Config::Config;
my $data = Models::Utilits::Date->new();
use Models::Performers::Book;
use Models::Performers::User;
use Models::Utilits::Lang;
use Models::Utilits::File;
use XML::Simple qw(:strict);
use Models::Utilits::Debug;
my $debug = Models::Utilits::Debug->new();
use Data::Dumper;
use Models::Performers::Order;
use Models::Performers::Payment;
use Models::Performers::Authors;
use Models::Performers::Genre;


sub createHash
{
    
    my ($self)=@_;

    $self->{'title'}='Api';
    #print $data->{'pageparam'};
}


sub  getOut
{
    my ($self)=@_;

    if($data->{'pageparam'} eq 'addauthor')
    {
        #return 'add author';
        return $self->getJSON();

    }
    elsif($data->{'pageparam'} eq 'addgenre' )
    {
        ##########################
        return $self->getJSON();

    }
    elsif($data->{'pageparam'} eq 'books' )
    {
        ##########################
        return $self->allbooks();

    }
    elsif($data->{'pageparam'} eq 'user')
    {
        return $self->user();
    }
    elsif($data->{'pageparam'} eq 'lang')
    {
        return $self->getLang();
    }
    elsif($data->{'pageparam'} eq 'addcart' )
    {
        return $self->addCart();
    }
    elsif($data->{'pageparam'} eq 'getcart' )
    {
        
        return $self->getCart();
    }
    elsif($data->{'pageparam'} eq 'payment')
    {
      return return $self->getPayment();
    }
    elsif($data->{'pageparam'} eq 'warings')
    {
      return return $self->getJSON;
    }
    elsif($data->{'pageparam'} eq 'getorders' )
    {   
        return $self->getOrders();
    }
    elsif($data->{'pageparam'} eq 'getauthors')
    {
        #   return 1;
      return $self->getAuthors(); 
    }
    elsif($data->{'pageparam'} eq 'getgenres')
    {
        return $self->getGenres(); 
        #return 1; 
    }
    elsif($data->{'pageparam'} eq 'getbookforauthor')
    {
    return $self->getBookForAuthor();
      return 1; 
    }
     elsif($data->{'pageparam'} eq 'getbookforgenre')
    {
        return $self->getBookForGenre();
      return 1; 
    }

    

    return '';

}



sub getBookForGenre
{
    my $book =  Models::Performers::Book->new();
    my $ref=$book->getForGenre($data->{'numpage'}); 
    my $res;
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
    
}


sub getBookForAuthor
{
    my $book =  Models::Performers::Book->new();
    my $ref=$book->getForAuthor($data->{'numpage'}); 
    my $res;
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
    
}



sub getGenres
{
    my $genre = Models::Performers::Genre->new();
    my $ref = $genre->getAll();
    my $res;
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
}


sub getAuthors
{
    my $author = Models::Performers::Authors->new();
    my $ref = $author->getAll();
    my $res;
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);

}

sub getOrders()
{
    my $order= Models::Performers::Order->new();
    my $user= Models::Performers::User->new();
    my $res;
    my $ref; 
    if($data->{'numpage'} )
    {
        $ref  =  $order->getInfo( $data->{'numpage'}, $user->getId());
    }
    else
    {
       $ref  =  $order->get($user->getId());
    }
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
}


sub getWarings
{
    unless($data->{'warnings'})
    {
        return '0';
    }
    
    return $data->{'warnings'};
} 


sub getJSON
{
    my $d=$debug->getMsg();

    my %hash = 
    (
        'warings'=>getWarings(),
        'debug' =>Dumper($d)
    );

    return  encode_json \%hash;
}


sub allbooks
{
    my $book =  Models::Performers::Book->new();
    my $res=$book->getAll();
    my $str;

    if($data->{'numpage'}) 
    {
         $str =  encode_json $$res[ $data->{'numpage'} - 1];
    }
    else
    {
         $str =  encode_json $res;
    }

    return  decode('utf8',$str);
}

sub user
{
    my $user= Models::Performers::User->new();
    
    my %hash = 
    (
        'name'=>$user->getName(),
        'id' =>$user->getId()
    );

    return  encode_json \%hash;
}

sub getLang
{

    my $lang = Models::Utilits::Lang->new();
    my $res;
    my $ref =  $lang->get();
    if($ref)
    {     
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
}


sub getCart
{
    ##nead return name , price and id book
    my $cart = Models::Performers::Cart->new();
    my $user= Models::Performers::User->new();
    my (@ref) = $cart->get( $user->getId());
    my $res;
    #my $var = @$ref;
    if(@ref)
    { 
        
        my %hash =
        (
            'user'=>$user->getId(),
            'cart'=>@ref,
            'sale'=>$user->getSale()
        );

        $res= encode_json \%hash;
    }

    return  decode('utf8',$res);
}


sub getPayment
{
    my $payment=Models::Performers::Payment->new();
    my $res;
    my $ref =  $payment->get();
    if($ref)
    { 
        
        $res= encode_json $ref;
    }

    return  decode('utf8',$res);
}

sub addCart
{
    return getJSON();
}

1;
