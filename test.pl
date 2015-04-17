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
use Time::Local;
use System::Tools::Toolchain;
my $tools = System::Tools::Toolchain->instance(TDIR);
use  Models::Utilits::Lang;
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
     my $lang = $tools->getObject('Models::Utilits::Lang');
     my $ref =  $lang->get();
     my $temp=$lang->getValue('more');  
     #print Dumper $ref->{'ISTRING'}{"LANG_$temp"}{'VALUE'};
        print $temp;
}

sub funroom
{
    my  $rooms  = $tools->getObject('Models::Performers::Rooms'); 
    #if($rooms->addRoom('Зал 1'))
    #{
    #    print "good add";
    #}
    #else
    #{
    #    print "error add";
    #}
    


    #print $rooms->addOrder(1,time(),time()+120,'text',1);
    print Dumper $rooms->getRooms();
    my $t=timelocal(0,0,0,1,3,115);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($t);
    #$year+=1900;
        
      print time()."\n";
      print $year."\n";
      print $mday."\n";#день месяца
      print $mon."\n";  
      #print  timelocal(0,0,0,1,0,115);
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

    
    #userfun();
    #funlang();
    funroom();

    my $d=  $tools->getDebugObject()->getLog();
    print Dumper $d;


    print "\nTDIR=".TDIR."\n";
}
###run to main
main();
