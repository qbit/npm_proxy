#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use LWP::UserAgent;

my $debug = 0;
my $repo_host = "couchserver:5984";

# escape the .'s
$repo_host =~ s/\./\\./g;

my $ua = LWP::UserAgent->new;
$ua->agent( "NPM Proxy/0.1 " );

my $logfile = "/var/log/squid3/npm_proxy.log";

$|=1;
while(<>) {
  chomp;
  my @x = split;
  my $url = $x[0];

  open( LF, ">>$logfile" ) if $debug;

  # Only rewrite failed requests that are for npmjs.org
  if ( $url =~ m/registry\.npmjs\.org/ ) {
    my $req = HTTP::Request->new( GET => $url );
    my $resp = $ua->request( $req );

    if ( $resp->is_success ) {
      # public npm repo has our package
      print $x[0]." \n";
    } else {
      # public npm repo doesn't have our package.. check our internal repo.
      print LF "redirecting to $repo_host\n" if $debug;
      $url =~ s/registry\.npmjs\.org/$repo_host/;

      print LF "new url: $url\n" if $debug;
      print $x[0]." 302:$url\n";
    }
  } else {
    # pass the url through
    print $x[0]." \n";
  }

  close LF if $debug;
}
