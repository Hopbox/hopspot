use strict;
use warnings;

use HopSpot;

my $app = HopSpot->apply_default_middlewares(HopSpot->psgi_app);
$app;

