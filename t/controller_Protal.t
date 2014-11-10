use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HopSpot';
use HopSpot::Controller::Protal;

ok( request('/protal')->is_success, 'Request should succeed' );
done_testing();
