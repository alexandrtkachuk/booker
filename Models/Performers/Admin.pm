package Models::Performers::Admin;

use warnings;
use strict;
use Digest::MD5 qw(md5 md5_hex md5_base64) ;
use vars qw(@ISA); 
our @ISA = qw(Models::Performers::User);
require Models::Performers::User;

use Models::Validators::Varibles;
my $tabName='booker_users';

sub isAdmin
{
    my ($self)=@_;

    unless($self->isLogin())
    {
        return 0;
    }

    if($self->getRole())
    {
        return 0;
    }
    
    return 1;
}

sub userList
{
    my ($self)=@_;
    
    $self->{'sql'}->select(['name','id','email']);
    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('role',1);


    unless($self->{'sql'}->execute())
    {
        $self->{'tools'}->getDebugObject()->logIt(
            $self->{'sql'}->getError()
        );
        return 0;
    }

   my $r= $self->{'sql'}->getResult();
   return $r;
}

sub update
{
    my ($self,$id,$name,$email,$pass)=@_;
   
    unless($id && $name && $email 
        && Models::Validators::Varibles->isNumeric($id)
        && ($id > 0)
        && Email::Valid->address($email))
    {
        return 0;
    } 
    
    my %hash = 
    (
            'name'=>$name,
            'email'=>$email
    );
    
    if($pass)
    {
        $hash{'pass'}=md5_hex($pass);
    }
    $self->{'sql'}->update( \%hash);  

    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('role',1);
    $self->{'sql'}->where('id',$id);
    
    unless($self->{'sql'}->execute())
    {
        $self->{'tools'}->getDebugObject()->logIt(
            $self->{'sql'}->getError()
        );
        return 0;
    }

    return 1;
}

sub delete
{
    my ($self,$id)=@_;

    unless
    (   $id 
        && Models::Validators::Varibles->isNumeric($id)
        && ($id > 0)
    )
    {
        return 0;
    }

    $self->{'sql'}->delete();
    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('role',1);
    $self->{'sql'}->where('id',$id);
    
    unless($self->{'sql'}->execute())
    {
        $self->{'tools'}->getDebugObject()->logIt(
            $self->{'sql'}->getError()
        );
        return 0;
    }

    return 1;
}


1;
