package HopSpot::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

HopSpot::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	my $stage	= $c->req->param('stage');

#0 - AUTH_DENIED - User firewall users are deleted and the user removed.
#6 - AUTH_VALIDATION_FAILED - User email validation timeout has occured and user/firewall is deleted
#1 - AUTH_ALLOWED - User was valid, add firewall rules if not present
#5 - AUTH_VALIDATION - Permit user access to email to get validation email under default rules
#-1 - AUTH_ERROR - An error occurred during the validation process

	if ($stage eq 'login'){
	    $c->response->body('Auth: 1');
	}
	if ($stage eq 'counters') {
		$c->response->body('Auth: 1');
	}
	if ($stage eq 'logout') {
		$c->response->body('Auth: 0');
	}
}



=encoding utf8

=head1 AUTHOR

Nishant Sharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
