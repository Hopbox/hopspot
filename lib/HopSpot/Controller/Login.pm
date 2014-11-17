package HopSpot::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

HopSpot::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
	my $req = $c->request;
	my $gw_id 		= $req->param('gw_id');
	my $gw_address 	= $req->param('gw_address');
	my $gw_port		= $req->param('gw_port');
	my $mac			= $req->param('mac');
	my $url			= $req->param('url');

	my %template_vars;
	$template_vars{gw_id} 		= $gw_id;
	$template_vars{gw_address} 	= $gw_address;
	$template_vars{gw_port}		= $gw_port;
	$template_vars{mac}			= $mac;
	$template_vars{url}			= $url;

	my $submit_url = "reqotp";

	$template_vars{submit_url}  = $submit_url;

	$template_vars{pagetitle} 	= 'HopSpot Login';
	$c->stash(\%template_vars);
	$c->stash(template => 'auth/login.tt2');
	$c->forward( $c->view('HTML'));
#    $c->response->body('Matched HopSpot::Controller::Login in Login.');
}

sub checkotp :Path('checkotp') :Args(0) {
	use Digest::MD5 qw (md5_hex);
	use Data::Uniqid qw (suniqid uniqid luniqid);

	my ( $self, $c ) = @_;
	my $req = $c->request;
	my $gw_id 		= $req->param('gw_id');
	my $gw_name		= 'HB' . $gw_id;
	my $gw_address 	= $req->param('gw_address');
	my $gw_port		= $req->param('gw_port');
	   $gw_port =~ tr/\\//;
	my $mac			= $req->param('mac');
	my $url			= $req->param('url');
	my $mobile		= $req->param('mobile');
	my $retry		= $req->param('retry');
	my $rcvd_otp	= $req->param('otp');

	my %template_vars;
	$template_vars{gw_id} 		= $gw_id;
	$template_vars{gw_address} 	= $gw_address;
	$template_vars{gw_port}		= $gw_port;
	$template_vars{mac}			= $mac;
	$template_vars{url}			= $url;
	$template_vars{mobile}		= $mobile;
	$template_vars{retry}		= $retry + 1;

	my $pgdb = $c->model('PgDB');
	my $otpcache = $pgdb->resultset('Otpcache');
	my $otp_rs = $otpcache->search({
					mac		=>	$mac,
					mobile	=>	$mobile,
					gw_name	=>	$gw_name	
				})->single;
	my $otp = $otp_rs->otp if $otp_rs;
	$c->log->debug("Retrieved OTP $otp from DB for $mac-$mobile-$gw_name");

	if ($otp eq $rcvd_otp){
		my $token = md5_hex(uniqid);
    	$c->log->debug("Generated Session TOKEN $token");
		$c->log->debug("OTP from cache is $otp. RCVD OTP is $rcvd_otp");
		$gw_port =~ tr/\\//;
		my $redir_url = "http://$gw_address:$gw_port/wifidog/auth?token=$token" . '&' . "url=$url";
		$c->log->debug("Redirecting user to $redir_url");
		$c->response->redirect($redir_url, 302);
	}
	else {
		#print "#### OTPs didn't match\n";

	#	$template_vars{submit_url}  = $submit_url;

		$template_vars{pagetitle} 	= 'HopSpot OTP Request';
		$c->stash(\%template_vars);
		$c->stash(template => 'auth/reqotp.tt2');
		$c->forward($c->view('HTML'));
	}
#
}

sub reqotp :Path('reqotp') :Args(0) {
	my ( $self, $c ) = @_;
	my $req = $c->request;
	my $gw_id 		= $req->param('gw_id');
	my $gw_name		= 'HB' . $gw_id;
	my $gw_address 	= $req->param('gw_address');
	my $gw_port		= $req->param('gw_port');
	my $mac			= $req->param('mac');
	my $url			= $req->param('url');
	my $mobile		= $req->param('mobile');
	my $retry 		= $req->param('retry');
	$retry = 0 if (!$retry);

	my %template_vars;
	$template_vars{gw_id} 		= $gw_id;
	$template_vars{gw_address} 	= $gw_address;
	$template_vars{gw_port}		= $gw_port;
	$template_vars{mac}			= $mac;
	$template_vars{url}			= $url;
	$template_vars{mobile}		= $mobile;
	$template_vars{retry}		= $retry + 1;

	$c->log->debug("Searching for id of GW $gw_name");
	my $pgdb = $c->model('PgDB');
	my $gw_db_rs = $pgdb->resultset('Gwcontroller')->find({'controller_id' => $gw_name});
	my $gw_db_id = $gw_db_rs->id;

	my $otp = genotp($mobile) if $retry == 0;
	my $res = sendotp ($mobile, $otp) if $retry == 0;

	my $otpcache = $pgdb->resultset('Otpcache');
	### Check if MAC-MOBILE-IP tuple exist in OTP Cache
	my $otp_rs = $otpcache->search({
					mac		=>	$mac,
					mobile	=>	$mobile,
					gw_id	=>	$gw_db_id
					})->single;
	if($otp_rs != 0){
		$c->log->debug("Found OTP entry for $mac, $mobile, $gw_name. Updating new OTP $otp on id " . $otp_rs->id);
		my $otp_up = $otp_rs->update({
					mac		=>	$mac,
					mobile	=>	$mobile,
					otp		=>	$otp,
					url		=>	$url,
					resent_count => $retry,
					last_resent_time => 'now()'
					});
	}
	else{
		$c->log->debug("OTP entry not found. Creating one for $mac, $mobile, $otp, $gw_name");
		my $otp_cr = $otpcache->create({
					mac		=>	$mac,
					mobile	=>	$mobile,
					otp		=>	$otp,
					url		=>	$url,
					gw_id	=>	$gw_db_id,
					gw_name => $gw_name,
					resent_count => $retry,
					last_resent_time => 'now()'
				});
	}

	$c->log->debug("SMS SEND Result is $res");

	my $submit_url = "checkotp";

	$template_vars{submit_url}  = $submit_url;

	$template_vars{pagetitle} 	= 'HopSpot OTP Request';
	$c->stash(\%template_vars);
	$c->stash(template => 'auth/reqotp.tt2');
	$c->forward( $c->view('HTML'));
#
}

sub genotp :Private {
	my ( $self, $c ) = @_;
	use Digest::MD5 qw (md5_hex);
	use Data::Uniqid qw (suniqid uniqid luniqid);

	my $mobile = shift;

	### Generating a 6 digit random number string
	my @digits = ('1'..'9');
	my $length = 6;
	my $otp;

	for (1..$length){
	    $otp .= $digits[int rand @digits];
	}

	#$c->log->debug("Generated OTP is $otp for $mobile");
	return $otp;
}

sub sendotp :Private {
	use LWP::UserAgent;
	my ( $self, $c ) = @_;

	my $ua = LWP::UserAgent->new;
	$ua->timeout(10);
	$ua->agent('HopSpot WiFi Authenticator/1.0');
	$ua->from('support@hopbox.in');
	$ua->cookie_jar({});
	$ua->ssl_opts('verify_hostname' => 0);

	my $mobile = shift;
	my $otp = shift;

  ### Send SMS 
  	my $apikey =	'71531AWVrHviH5407ec12';
	my $sender = 	'HOPBOX';
	my $route  =	4;
	my $msg    = 	'Your%20HopSpot%20WiFi%20login%20code%20is%20' . $otp; 
	#https://control.msg91.com/api/sendhttp.php?authkey=71531AWVrHviH5407ec12&mobiles=9560212277&message=Test%20message&sender=HOPBOX&route=4

	my $sms_url = 'https://control.msg91.com/api/sendhttp.php?authkey=' . $apikey . '&mobiles=' . $mobile;
	$sms_url .= '&message=' . $msg . '&sender=' . $sender . '&route=' . $route;

	#$c->log->debug("SMS URL is $sms_url");

	#### Currently Fire and Forget
	my $sms_res = $ua->get("$sms_url")->content;
	return $sms_res;
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
