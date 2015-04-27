package Models::Performers::User;

use warnings;
use strict;

use Data::Dumper;
use Models::Interfaces::Sql;
use System::Tools::Toolchain;
use Email::Valid;
use Digest::MD5 qw(md5 md5_hex md5_base64) ;

my ($session,$tools, $self) ;
my $tabName='booker_users';

sub new
{   $tools = System::Tools::Toolchain->instance();
    my $db = $tools->getConfigObject()->getDataBaseConfig();
    my $sql =  Models::Interfaces::Sql->new(
        $db->dbuser,
        $db->host,
        $db->dbname,
        $db->pass);
    
    unless($self) 
    {
        unless($sql->connect())
        {
            $tools->getDebugObject()->logIt($self->{'sql'}->getError());
            return 0;
        }
       $session = $tools->getObject('Models::Utilits::Sessionme'); 
    }
    
    my $class = ref($_[0])||$_[0];

    $self||=bless(
        {   
            'sql'=>$sql,
            'name'=>undef,
            'email'=>undef,
            'id'=>undef,
            'role'=>undef 
        }   
        ,$class);

    return $self;
}

sub add
{
    my ($self,$name,$pass,$email)=@_;   
    my @arr= ( 'name' );
    $self->{'sql'}->select(\@arr);
    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('email',$email);

    unless($self->{'sql'}->execute())
    {
        $tools->getDebugObject()->logIt(
            $self->{'sql'}->getError()
        );
        return 0;
    }

    if($self->{'sql'}->getRows())
    {
        $tools->getCacheObject()->setCache('warings',3);
        return 0; #record exists 
    }

    my %hash=('name'=>$name, 
        'pass'=>md5_hex($pass),
        'email'=>$email,
        'role'=>1 # 0=admin , 1=user
    );
    
    $self->{'sql'}->insert(\%hash);
    $self->{'sql'}->setTable($tabName);

    unless($self->{'sql'}->execute())
    { 
       return 0;
    }
    
    return 1;
}

sub login
{

    my ($self,$email,$pass)=@_;
    unless($email  && $pass && Email::Valid->address($email))
    {
        return 0;
    }
    my @arr= ( 'name', 'id' ,'role', 'email' );
    $self->{'sql'}->select(\@arr);
    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('email',$email);
    $self->{'sql'}->where('pass',md5_hex($pass));

    unless($self->{'sql'}->execute())
    { 
        $tools->getDebugObject()->logIt($self->{'sql'}->getError() );
        return 0;
    }
    my $res = $self->{'sql'}->getResult();

    unless($self->{'sql'}->getRows())
    {
        return 0;
    }

    $self->{'name'} = $res->[0]{'name'};
    $self->{'email'} = $res->[0]{'email'};
    $self->{'id'} = $res->[0]{'id'};
    $self->{'role'} = $res->[0]{'role'};

    $session->setParam('email',$self->{'email'});
    $session->setParam('name',$self->{'name'});
    $session->setParam('id',$self->{'id'});
    $session->setParam('role',$self->{'role'});

    return 1;
}


sub isLogin
{
    my ($self)=@_;
    
    if($self->{'name'})
    {
        return 1;
    }

    if($session->getParam('email'))
    { 
        $self->{'email'} = $session->getParam('email');
        $self->{'id'} = $session->getParam('id');
        $self->{'name'} = $session->getParam('name');
        $self->{'role'} = $session->getParam('role');
        return 1;
    } 

    return 0;
}

sub logout
{
    $self->{'email'} = undef;
    $self->{'id'} = undef;
    $self->{'name'} = undef;
    $self->{'role'} = undef;
    $session->delete();

    return 1;
}

sub getName
{
    my ($self)=@_;
    return $self->{'name'};
}

sub getId
{
    my ($self)=@_;
    return $self->{'id'};
}

sub getEmail
{
    my ($self)=@_;
    return $self->{'email'};
}

sub getRole
{
    my ($self)=@_;
    return $self->{'role'};
}

sub getName4Id
{
    my ($self,$id)=@_;
    
    unless($id)
    {
        return 0;
    }

    $self->{'sql'}->select(['name']);
    $self->{'sql'}->setTable($tabName);
    $self->{'sql'}->where('id',$id);
    
    unless($self->{'sql'}->execute())
    { 
        $tools->getDebugObject()->logIt($self->{'sql'}->getError() );
        return 0;
    }

    unless($self->{'sql'}->getRows())
    {
        return 0;
    }
    
    my $res = $self->{'sql'}->getResult();
    return  $res->[0]{'name'};
}

1;
