#!/usr/bin/perl

use Modern::Perl;
use Config::IniFiles;
use Data::Dumper;
use File::Basename;
use File::Path qw!make_path!;

die "No valid config file"
	unless $ARGV[0] and -r $ARGV[0];

my $ini = $ARGV[0];

my $cfg = Config::IniFiles->new(-file => $ini);

for my $val ( $cfg->Sections ) {
	next unless $val =~ m!^http://!; # no https even
	my $person = $cfg->val($val, 'name');
	my $filename = lc $person;
	
	$filename =~ s!\W+!_!g;
	my $abbr = $filename; $abbr =~ s![^a-z]!!g; $abbr = substr $abbr, 0, 2;
		
	my $file_dir = dirname(__FILE__)."/../authors/".substr($abbr, 0, 1)."/".$abbr;
	
	next if -f $file_dir."/".$filename;
	make_path($file_dir);
	
	say "person: ".$cfg->val($val, 'name');
	say "abrv: ".$abbr;
	say "filename: $filename";
	say "file: $file";
	say "val: $val";
	
	print "\n";
	# say Dumper $cfg->Parameters($val);
}
