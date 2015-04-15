package Controllers::CommandCtrl::Router;

use warnings;
use strict;

use Models::Utilits::ParseUrl;
use System::Tools::Toolchain;

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless({},$class);
}

sub go
{   

    my ($self,$tdir)=@_;
    my @rout =Models::Utilits::ParseUrl->get() ;
    my $tools = System::Tools::Toolchain->instance();
    my $url=$rout[0];

    if(length($url)==0)
    {
        $url='Index';
    }
    else
    {
       $url=  ucfirst($url);
    }
    
    $tools->getCacheObject()->setCache('nextpage',$url);
    $tools->getCacheObject()->setCache('pageparam',$rout[1]);
    my $temp = $tools->makeNewObject('Controllers::CtrlPages::'.$url);

    return $temp;
}

1;
