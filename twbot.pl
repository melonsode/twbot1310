use strict;
use warnings;
use Net::Twitter;


my $conf =  require 'config.pl' ;

my $nt = Net::Twitter->new(
   traits => ['API::RESTv1_1'],
   consumer_key => $conf->{ck},
   consumer_secret => $conf->{cs},
   access_token => $conf->{at},
   access_token_secret => $conf->{ats},
);

my $result = $nt->update('Yet another Hello, world!');