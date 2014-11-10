use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HopSpot';
use HopSpot::Controller::Potal;

ok( request('/potal')->is_success, 'Request should succeed' );
done_testing();
