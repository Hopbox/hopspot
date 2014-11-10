use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HopSpot';
use HopSpot::Controller::Portal;

ok( request('/portal')->is_success, 'Request should succeed' );
done_testing();
