use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HopSpot';
use HopSpot::Controller::Ping;

ok( request('/ping')->is_success, 'Request should succeed' );
done_testing();
