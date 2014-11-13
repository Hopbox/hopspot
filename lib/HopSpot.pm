package HopSpot;
use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple

	Cache::FastMmap

	Session
	Session::Store::FastMmap
	Session::State::Stash
/;

extends 'Catalyst';

our $VERSION = '0.04';

# Configure the application.
#
# Note that settings in hopspot.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'HopSpot',

	## Configure Cache_FastMmap
	cache => {
		storage => '/tmp/hopspot_otp_cache_3',
		xpires	=> 300,
	},

	'Plugin::Session' => {
		expires	=> 900,
		storage => '/tmp/hopspot_session_3',
	},

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);



__PACKAGE__->log( Catalyst::Log->new());

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

HopSpot - Catalyst based application

=head1 SYNOPSIS

    script/hopspot_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<HopSpot::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Nishant Sharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
