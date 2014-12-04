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

	my $stage			= $c->req->param('stage');
	my $controller_id	= 'HB' . $c->req->param('gw_id');
	my $ip				= $c->req->param('ip');
	my $mac				= $c->req->param('mac');
	my $in_bytes		= $c->req->param('incoming');
	my $out_bytes		= $c->req->param('outgoing');
	my $token			= $c->req->param('token');

	my $pgdb = $c->model('PgDB');

#0 - AUTH_DENIED - User firewall users are deleted and the user removed.
#6 - AUTH_VALIDATION_FAILED - User email validation timeout has occured and user/firewall is deleted
#1 - AUTH_ALLOWED - User was valid, add firewall rules if not present
#5 - AUTH_VALIDATION - Permit user access to email to get validation email under default rules
#-1 - AUTH_ERROR - An error occurred during the validation process

### Check if session already exists. If not create else update.
### Identify session on the basis of token

	$c->log->debug("Finding controller $controller_id in DB");
	my $db_gw = $pgdb->resultset('Gwcontroller')->search({'controller_id' => $controller_id});
	my $db_gw_id = $db_gw->next->id;
	$c->log->debug("Controller found in DB:" . $db_gw_id);

	if (!$db_gw){
		### Controller doesn't exist in the DB. Auth request should be denied.
		$c->log->debug("Controller not found in DB. Rejecting Auth!");
		$c->response->body('Auth: 0');
		$c->detach;
	}

	$c->log->debug("Updating session $token");
	$pgdb->resultset('Session')->update_or_create(
		{
			'mac'		=>	$mac,
			'ip'		=>	$ip,
			'gw_id'		=>	$db_gw_id,
			'gw_name'	=>	$controller_id,
			'token'		=>	$token,
			'stage'		=>	$stage,
			'in_bytes'	=>  $in_bytes,
			'out_bytes'	=>  $out_bytes,
			'last_update'=>  'now()'
		},
		{	'key'	=>	'primary' }
		);

	if ($stage eq 'login'){
	    $c->response->body('Auth: 1');
	}
	if ($stage eq 'counters') {
# Check if total bytes used cross the daily limit
# Check if status is set to lock or force logout the user
# 
#
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
