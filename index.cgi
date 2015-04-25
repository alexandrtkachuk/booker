#!/usr/bin/perl 

use warnings;
use strict;
$|=1;

use File::Basename;;
use Data::Dumper;

use constant TDIR=>dirname(__FILE__);

use lib TDIR;
use lib TDIR.'/Libs';
use Views::View;
use System::Tools::Toolchain;
use Controllers::CommandCtrl::Router;

sub main
{    
    my $tools = System::Tools::Toolchain->instance(TDIR);
    $tools->getPoolObject()->setMaxPoolDepth(5);
    my $ctrlPage;
    ####ControlsPage#### 
    unless ($ctrlPage =  Controllers::CommandCtrl::Router->new()->go()) 
    {
        $tools->getCacheObject()->setCache('nextpage','Error');       
    }
    else
    {
        eval 
        { 
            $ctrlPage->go();   
        };
        if($@) 
        {  
            $tools->getDebugObject()->logIt($@);
            $tools->getCacheObject()->setCache('nextpage','Error');
        }     
    }
    ###VIEW######
    Views::View->new()->go();
    if($@) 
        {  
            $tools->getDebugObject()->logIt($@);
            $tools->getCacheObject()->setCache('nextpage','Error');
        }     

    my $d=$tools->getDebugObject()->getLog();
    #print  Dumper($d);

}
###run to main
main();
