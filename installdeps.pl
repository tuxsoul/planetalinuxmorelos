#!/usr/bin/perl

use strict;
use warnings;

use CPAN;

die "You better run this as root.\n"
	unless $< == 0;

my @modules = <DATA>;

for (@modules) {
	chomp;
	CPAN::Shell->install( $_ );
}

# after that...
print ".. testing loading modules...\n";

for (@modules) {
	chomp;
	print "- $_\n";
	eval "require $_";
	die $@ if $@;
}

print ".. done. enjoy :)\n"

__DATA__
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