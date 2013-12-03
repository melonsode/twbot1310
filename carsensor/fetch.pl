#!/usr/bin/perl

use strict;
use warnings;

#use LWP::UserAgent;
use utf8;
use Encode 'encode', 'decode';
use LWP::Simple qw/get/;
use CGI qw/:standard *ul *li/;
use JSON qw/encode_json decode_json/;
#use Data::Dumper::AutoEncode;

my $config = require 'config.pl';

binmode STDOUT, $config->{encoding}; # ex. :encoding(cp932)
#binmode STDOUT, ":urf8"; 

my $query = {};
my $req_url = 'http://webservice.recruit.co.jp/carsensor/usedcar/v1/';
my $api_key = $config->{key};

 $query = {
 	key => $api_key,
 	format => 'json', #format JSON ( jsonp xml)
 	pref => 11, #saitama 11
 	count => 20,
 	lat => 35.893905,
 	lng => 139.75706,
 	range => 1
 };

my $url = get_url( $req_url, $query);
my $content = get($url);
my $res = decode_json( encode( 'utf8', $content) );

#$Data::Dumper::Indent = 1;
my $stock = $res->{results}{usedcar};

my $count = 1;
for(@$stock){
	next if $_->{shop}{name} !~ m/$config->{shop_name}/;
	#print $count++,"::: ";
	to_htmltag($_);
}



sub to_htmltag{
	my $a = shift;

	#my $enc = 'cp932';
	my ($year, $price, $brand, $model, $img_url, $img_cap, $url_pc, $url_m) =
	 	( $a->{year}, $a->{price},  $a->{brand}{name}, 
	 		 $a->{model}, $a->{photo}{main}{s}, 
	 		 $a->{photo}{main}{caption} , $a->{urls}{pc}, $a->{urls}{mobile});
	print start_ul({ class => 'item'}), "\n";
	print li({ class => 'title' }, $brand. ' '. $model ), "\n";
	print li({}, a({ href => $url_pc, target => '_blank' }, img({ src => $img_url, alt => $brand.', '.$model.', '.$img_cap }) ) ), "\n";
	print li({}, '価格： '.$price.' 円'), "\n";
	print li({}, '年式： '.$year.'年'), "\n";
	print li({}, a( { href => $url_pc, target => '_blank' }, '商品詳細(PC)') ), "\n";
	print end_ul();
	print "\n";


}


sub get_url{
	my ($req_url, $query) = @_;

	my $url = $req_url.'?';
	for my $k ( keys %$query){
		$url .= $k . '=' . $query->{$k} . '&';
	}

	return $url;
}