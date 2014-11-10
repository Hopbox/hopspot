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
	my $gw_address 	= $req->param('gw_address');
	my $gw_port		= $req->param('gw_port');
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

	#print "##### Retrieving from session\n";

	my $user_key = $gw_id . $mac . $mobile;
	$user_key =~ s/\:/_/g;

	my $otp = $c->cache->get($user_key);

### Generate token

	my $token = md5_hex(uniqid);
    #print "*********** TOKEN $token \n";

	if ($otp eq $rcvd_otp){
		#print "#### OTP from cache is $otp. RCVD OTP is $rcvd_otp\n";
		$gw_port =~ tr/\\//;
		my $redir_url = "http://$gw_address:$gw_port/wifidog/auth?token=$token" . '&' . "url=$url";
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
	my $gw_address 	= $req->param('gw_address');
	my $gw_port		= $req->param('gw_port');
	my $mac			= $req->param('mac');
	my $url			= $req->param('url');
	my $mobile		= $req->param('mobile');
	my $retry 		= $req->param('retry');

	my %template_vars;
	$template_vars{gw_id} 		= $gw_id;
	$template_vars{gw_address} 	= $gw_address;
	$template_vars{gw_port}		= $gw_port;
	$template_vars{mac}			= $mac;
	$template_vars{url}			= $url;
	$template_vars{mobile}		= $mobile;
	$template_vars{retry}		= $retry + 1;

	my $user_key = $gw_id . $mac . $mobile;
	$user_key =~ s/\:/_/g;

	my $otp = genotp($user_key, $mobile) if $retry == 0;

	my $res = sendotp ($user_key, $mobile, $otp) if $retry == 0;

	$c->cache->set($user_key, $otp);

	#print "SMS SEND Result is $res <<<<<<<<<<<<<<<<<<<<<<<<<\n";

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

	my $user_key = shift;
	my $mobile = shift;

	### Generating a 6 digit random number string
	my @digits = ('1'..'9');
	my $length = 6;
	my $otp;

	for (1..$length){
	    $otp .= $digits[int rand @digits];
	}

	#print "****** Generated OTP is $otp for USER_KEY $user_key ...\n";
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

	my $user_key = shift;
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

	#print "************* SMS URL is $sms_url\n";

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
