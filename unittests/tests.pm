package Utilities::MaxmindUtilUnitTest;

use strict;
use base qw(Test::Class);
use Test::More;
use Test::MockObject;
use lib '/services/websoftware/wairs/perlmodules_el/';

my ($mockDBI, $mockDBM, $mockCCFD, $isSetQuery);
my $dbPresets = {
        'IsEnabledMaxMind' => 'YES',
        'MaxDistance' => 300.00,
        'MaxRiskScore' => 60.00,
        'Score' => 7.00,
        'IpFrom' => '0',#'69.49.114.10',
        'IpTo' => '0'#'69.49.114.10'
};

my $maxmindResponse = {
        'distance' => '453',
        'score' => '2.73',
        'riskScore' => '4.15'
};

sub testClass {return 'Utilities::MaxmindUtil';}

sub startup : Test(startup => 1)
{
        use_ok(testClass);

        $mockDBI = Test::MockObject->new();
        $mockDBI->fake_new('DBI');
        $mockDBI->mock('fetchrow_hashref', sub {
                if ($isSetQuery)
                {
                        $isSetQuery = undef;
                        return $dbPresets;
                }

                return undef;
        });

        $mockDBI->mock('finish', sub {1});

        $mockDBM = Test::MockObject->new();
        $mockDBM->fake_new('Managers::DbManager');
        $mockDBM->mock('loadConfigFile', sub {1});
        $mockDBM->mock('connect', sub {1});
        $mockDBM->mock('setDbquery', sub {1});
        $mockDBM->mock('executeSelectQuery', sub {$isSetQuery = 1 ; return $mockDBI});

        $mockCCFD = Test::MockObject->new();
$mockCCFD->fake_new('Business::MaxMind::CreditCardFraudDetection');
        $mockCCFD->mock('input', sub {1});
        $mockCCFD->mock('query', sub {1});
        $mockCCFD->mock('output', sub { return $maxmindResponse; });
};

sub construct : Test(1)
{
        my $testObj = testClass->instance();
        isa_ok($testObj, testClass, testClass);
};

sub debug : Tests(4)
{
        my $testObj = testClass->instance();
        can_ok($testObj, 'setDebug');
        can_ok($testObj, 'debugMode');
        $testObj->setDebug(1);
        is($testObj->debugMode(), 1, 'Debug mode ON');
        $testObj->setDebug(undef);
        isnt($testObj->debugMode(), 1, 'Debug mode OFF');
#       $testObj->setDebug(1);
};

sub isShowMaxmind : Tests(5)
{
        my $testObj = testClass->instance();
        can_ok($testObj, 'isShowMaxmind');
        isnt($testObj->isShowMaxmind(2422, ''), 1,
                "isShowMaxmind(2422, '') with empty application");
        isnt($testObj->isShowMaxmind('', 'AccountSignup'), 1,
                "isShowMaxmind('', 'AccountSignup') with empty hid");
        isnt($testObj->isShowMaxmind('', ''), 1,
                "isShowMaxmind('', '') with both empty");
        is($testObj->isShowMaxmind(2422, 'AccountSignup'), '1',
                "isShowMaxmind(2422, 'AccountSignup') use valid data");
};

sub doMaxMind : Tests(18)
{
        my $testData = {
                'in4bid'      => 2422,
                'objectType'  => 'AccountSignup',
                'max_city'    => 'test',
                'max_state'   => 'AL',
                'max_zip'     => '12345',
                'max_country' => 'US',
                'owner_email' => 'test@test.ts',
                'dname'       => 'dev-testing-domain',
                'tldSelect'   => '.com',
                'cc_num'      => '4444444444444448',
                'cc_holder'   => 'test',
                'passwd'      => 'temp123',
                'owner_phone' => 1111111111 };

        my $testObj = testClass->instance();
        can_ok($testObj, 'doMaxMind');
        is($testObj->doMaxMind({}), 1,
                "doMaxMind() TRUE for empty input data");

        $testData->{'in4bid'} = undef;
        is($testObj->doMaxMind($testData), 1,
                "doMaxMind() TRUE for non existing hid");

        $testData->{'in4bid'} = 2422;
        $testData->{'objectType'} = undef;
        is($testObj->doMaxMind($testData), 1,
                "doMaxMind() TRUE for undefined objectType");

        $testData->{'objectType'} = 'AccountSignup';
        $testData->{'cc_num'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined CC number");

        $testData->{'cc_num'} = 'asdasdasddfasdf';
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for invalid CC number");

        $testData->{'cc_num'} = '4444444444444448';
        $testData->{'cc_holder'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined CC holder");

        $testData->{'cc_holder'} = 'test';
        $testData->{'passwd'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined passwd");

        $testData->{'passwd'} = 'temp123';
        $testData->{'owner_phone'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined owner phone");

        $testData->{'owner_phone'} = 'kljweflkjhwerfoi';
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for invalid owner phone");

        $testData->{'owner_phone'} = 1111111111;
        $testData->{'max_city'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined city");

        $testData->{'max_city'} = 'test';
        $testData->{'max_state'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined state");

        $testData->{'max_state'} = 'AL';
        $testData->{'max_country'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined country");

        $testData->{'max_country'} = '12';
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for invalid country");

        $testData->{'max_country'} = 'US';
        $testData->{'owner_email'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined email");

        $testData->{'owner_email'} = 'test.test.ts';
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for invalid email");

        $testData->{'owner_email'} = 'test@test.ts';
        $testData->{'dname'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined domain name");

        $testData->{'dname'} = 'dev-testing-domain';
        $testData->{'tldSelect'} = undef;
        isnt($testObj->doMaxMind($testData), 1,
                "doMaxMind() FALSE for undefined tld selected");
};
1;
