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

sub main
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


sub user
{
    my $info = $tools->getConfigObject()->getDataBaseConfig();
    print Dumper $info->dbname;
    print "\n", 
        md5_hex('admin'),
        "\n";
}

user();
###run to main
#main();
