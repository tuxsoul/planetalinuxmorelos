#!/usr/bin/perl

use strict;
use warnings;

use CPAN;

die "You better run this as root.\n"
	unless $< == 0;

my $modules = [qw!
	App::Cmd
	App::PPBuild
	Config::IniFiles
	Data::Validate::Email
	DateTime
	File::MimeInfo::Simple
	File::Path
	Image::Magick
	Modern::Perl
	Net::Domain::ES::ccTLD
	Template
	WebService::Validator::Feed::W3C
	YAML::Syck
!];

for my $m (@$modules) {
	CPAN::Shell->install( $m );
}

# after that...
print ".. testing loading modules...\n";

for my $m (@$modules) {
	print "- $m\n";
	eval "require $m";
	die $@ if $@;
}

print "\n.. done. enjoy :)\n"

