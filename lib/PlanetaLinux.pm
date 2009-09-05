#!/usr/bin/perl

package PlanetaLinux;

use Modern::Perl;
use File::Basename;
use File::Find;
use YAML::Syck;
use Data::Dumper;

sub new {
	my $self = shift;
	return bless {}, $self;
}

sub does_feed_exist {
	my($self, $feed) = @_;
	
	for my $f ( @{ $self->feeds } ) {
		return 1 if $feed eq $f->{url};
	}
	
	0;
}

sub feeds {
	my($self) = @_;
	
	my $feeds = [];
	
	find sub {
		return unless -f $_;
		push @$feeds, LoadFile($_);

	}, dirname(__FILE__).'/../authors';
	
	$feeds;
}

1;