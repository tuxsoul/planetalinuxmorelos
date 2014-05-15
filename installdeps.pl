#!/usr/bin/env perl

use strict;
use warnings;

die "You better run this as root.\n"
	unless $< == 0;

my $modules = [qw!
	App::Cmd
	App::Build
	Capture::Tiny
	Config::IniFiles
	Data::Validate::Email
	DateTime
	File::MimeInfo::Simple
	File::Path
	File::Remove
	File::Slurp
	Text::Unaccent::PurePerl
	Modern::Perl
	Module::Build
	Net::Domain::ES::ccTLD
	Template
	WebService::Validator::Feed::W3C
	YAML::Syck
!];

for my $m (@$modules) {
	system("cpanm", $m) == 0
		or die "Couldn't run cpanm properly (is it installed?): $?";
}

# after that...
print ".. testing loading modules...\n";

for my $m (@$modules) {
	print "- $m\n";
	eval "require $m";
	die $@ if $@;
}

print "\n.. done. enjoy :)\n";
print "\n.. please make sure you have PerlMagick installed.\n";
print ".. the recommended way is: `port install p5-perlmagick` in Mac,\n";
print ".. ..or 'aptitude install perlmagick' in Debian/Ubuntu.\n\n";


