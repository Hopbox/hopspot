package HopSpot::Controller::Ping;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

HopSpot::Controller::Ping - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	my $gw_id 			= $c->req->param('gw_id');
	my $controller_id	= 'HB' . $gw_id;
	my $sys_load 		= $c->req->param('sys_load');
	my $sys_memfree 	= $c->req->param('sys_memfree');
	my $sys_uptime 		= $c->req->param('sys_uptime');
	my $cp_uptime 		= $c->req->param('wifidog_uptime');

	my $pgdb = $c->model('PgDB');

	### Check if GW already exists in the DB. Create or Update.

	$c->log->debug("Searching if $controller_id exists in DB");

	my $gw_db = $pgdb->resultset('Gwcontroller')->find({'controller_id' => $controller_id});

	if($gw_db){

		$c->log->debug("Attempting to update Controller ID $controller_id");

		my $db_rs = $gw_db->update({
						'controller_id'	=>	$controller_id,
						'sys_load'		=>	$sys_load,
						'sys_memfree'	=>	$sys_memfree,
						'sys_uptime'	=>	$sys_uptime,
						'cp_uptime'		=>	$cp_uptime,
						'last_seen'		=>	"now()",
					});
	}
	else{
		$c->log->debug("Attemping to create controller ID $controller_id");
		my $db_rs = $pgdb->resultset('Gwcontroller')->create({
						'controller_id'	=>	$controller_id,
						'sys_load'		=>	$sys_load,
						'sys_memfree'	=>	$sys_memfree,
						'sys_uptime'	=>	$sys_uptime,
						'cp_uptime'		=>	$cp_uptime,
						'first_seen'	=>	"now()",
						'last_seen'		=>	"now()"
					});
	}

    $c->response->body('Pong');
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
