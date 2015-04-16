#!/usr/bin/perl 

use warnings;
use strict;

$|=1;

use Data::Dumper;
use File::Basename;;
use constant TDIR=>dirname(__FILE__);

use lib TDIR;
use lib TDIR.'/Models/Utilits';
use Digest::MD5 qw(md5 md5_hex md5_base64) ;

use System::Tools::Toolchain;
my $tools = System::Tools::Toolchain->instance(TDIR);

use Models::Performers::User;
sub test
{
    print "Content-type: text/html; encoding='utf-8'\n\n";
    print "test";

    
    
    if($tools)
    {
        print 'good';
    }

        
    my ($c)= $tools->getConfigObject();
    if($c)
    {
        print "\nyess\n";
    }
    my ($name) =  $c->getDirsConfig();
;
    print Dumper $name;
    
    my $d = $tools->getDebugObject();
    my $z =  $d->getLog();

    print "\n\n===============\n\n";

    my $p =$tools->makeNewObject('Models::Performers::Payment');

    $z =  $d->getLog();
    if($p)
    {
        print "zzzzzz!";
    }

    
$p->set(8900000000);
print $p->get();
    print Dumper $z;


}

sub funlang
{


}

sub userfun
{
    my $info = $tools->getConfigObject()->getDataBaseConfig();

    $tools->getDebugObject()->logIt(
            "db name=".$info->dbname     );

   my  $user  = $tools->getObject('Models::Performers::User'); 
   print "\n", 
        md5_hex('admin'),
        "\n";

    if($user->login('admin@mail.ru','admin'))
    {
        print "\nis login\n";
    }
    else
    {
        print "\nno login\n";
    }
}


sub main
{

    
    userfun();
    my $d=  $tools->getDebugObject()->getLog();
    print Dumper $d;


    print "\nTDIR=".TDIR."\n";
}
###run to main
main();
