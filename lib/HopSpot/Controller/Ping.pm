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
	my $sys_load 		= $c->req->param('sys_load');
	my $sys_memfree 	= $c->req->param('sys_memfree');
	my $sys_uptime 		= $c->req->param('sys_uptime');
	my $cp_uptime 		= $c->req->param('wifidog_uptime');

	my $pgdb = $c->model('PgDB');

	### Check if GW already exists in the DB
	my $gw_db = $pgdb->resultset('Node')->find({'name' => $gw_id});
	
	if ($gw_db){
	$gw_db->update({
						'sys_load'		=>	$sys_load,
						'sys_memfree'	=>	$sys_memfree,
						'sys_uptime'	=>	$sys_uptime,
						'cp_uptime'		=>	$cp_uptime,
						'last_seen'		=>	"now()",
					});
	### If exists then update the information
	}
	else {
	### Else create the GW in the DB
		my $new_gw = $pgdb->resultset('Node')->create(
					{
						'name'			=>	$gw_id,
						'alias'			=>	$gw_id,
						'device_id'		=>	'HB' . $gw_id,
						'sys_load'		=>	$sys_load,
						'sys_memfree'	=>	$sys_memfree,
						'sys_uptime'	=>	$sys_uptime,
						'cp_uptime'		=>	$cp_uptime,
						'status'		=>  'AUTO_CREATED_ON_PING',
						'first_seen'	=>  "now()",
						'last_seen'		=>  "now()",
					}
					);
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
