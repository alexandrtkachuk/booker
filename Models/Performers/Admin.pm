package Models::Performers::Admin;

use warnings;
use strict;




use vars qw(@ISA); 
our @ISA = qw(Models::Performers::User);
require Models::Performers::User;

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
    my ($self,$id,$name,$email)=@_;
   
    unless($id && $name && $email)
    {
        return 0;
    } 
    
    $self->{'sql'}->update(
        {
            'name'=>$name,
            'email'=>$email
        });  

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

    unless($id)
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
