package HopSpot::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        HopSpot->path_to( 'root', 'src' ),
        HopSpot->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    render_die   => 1,
});

=head1 NAME

HopSpot::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<HopSpot>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Nishant Sharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

