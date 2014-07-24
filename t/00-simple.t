#!/usr/bin/perl
use strict;
use warnings;
no warnings 'redefine';
use Test::More;
use Data::Dumper;
use utf8;

use_ok( 'IRI' );

{
	my $i	= IRI->new();
	isa_ok($i, 'IRI');
	isa_ok($i->components, 'HASH');
}

{
	my $i	= IRI->new(value => 'foo');
	isa_ok($i, 'IRI');
	is($i->value, 'foo', 'IRI value');
	is($i->path, 'foo', 'relative path');
}

{
	my $i	= IRI->new(value => 'https://greg@example.org:80/index?foo=bar#frag');
	isa_ok($i, 'IRI');
	is($i->scheme, 'https', 'scheme');
	is($i->host, 'example.org', 'host');
	is($i->port, '80', 'port');
	is($i->user, 'greg', 'user');
	is($i->path, '/index', 'path');
	is($i->fragment, 'frag', 'fragment');
	is($i->query, 'foo=bar', 'query');
}

{
	my $i	= IRI->new(value => 'tag:example.com,2014:火星');
	isa_ok($i, 'IRI');
	is($i->scheme, 'tag', 'scheme');
	is($i->path, 'example.com,2014:火星', 'unicode path');
}

{
	my $b	= IRI->new(value => 'http://example.org/foo/bar');
	my $i	= IRI->new(value => 'baz/quux', base => $b);
	isa_ok($i, 'IRI');
	is($i->abs, 'http://example.org/foo/baz/quux', 'asbolute IRI string');
}

{
	my $b	= IRI->new(value => 'http://example.org/foo/bar');
	my $i	= IRI->new(value => '/baz/../quux', base => $b);
	isa_ok($i, 'IRI');
	is($i->abs, 'http://example.org/quux', 'absolute IRI string (removing dots)');
}

{
	my $base = IRI->new(value => "http://www.hestebedg\x{e5}rd.dk/");
	my $i	= IRI->new(value => '#frag', base => $base);
	is($i->abs, 'http://www.hestebedgård.dk/#frag', 'absolute unicode IRI string');
}

done_testing();

