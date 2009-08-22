#!/usr/bin/perl

use Modern::Perl;
use File::Basename;

$ARGV[0] and $ARGV[1]  or usage();
my($code, $name) = @ARGV;

-d dirname(__FILE__).'/../proc/'.$code and usage("proc directory `$code' already exists. aborting.");

say "Creating instance for $name (<$code>)...";

my $dir = dirname(__FILE__).'/../proc/'.$code;

say "Creating directory $dir...";

mkdir $dir or usage("proc directory `$dir', unable to be created: $!");

say "Populating config.ini...";

open my $fh, ">", $dir.'/config.ini'
	or usage("Couldn't write config.ini: $!");
print $fh config_ini($code, $name);
close $fh;

mkdir dirname(__FILE__).'/../cache/'.$code
	or die "Couldn't create cache directory: $!";
mkdir dirname(__FILE__).'/../output/'.$code.'.planetalinux.org/'
	or die "Couldn't create output directory: $!";

open my $cache_readme, ">", dirname(__FILE__).'/../cache/'.$code.'/README'
	or die "Couldn't open README: $!";
open my $output_readme, ">", dirname(__FILE__).'/../output/'.$code.'.planetalinux.org/README'
	or die "Couldn't open README: $!";

say $cache_readme 'Cache directory.';
say $output_readme 'Output directory.';

close $cache_readme; close $output_readme;

# now symlink
chdir $dir;
symlink '../inc', 'inc' or die "Couldn't symlink: $!";

say " done!";


sub usage {
	say "ERR: " . $_[0] if $_[0];
	die <<"";
Usage:
 \$ $0 <instance code> <instance name>
 
 Example:
 \$ $0 cu Cuba
 \$ $0 pg "Papua New Guinea"

}

sub config_ini {
	my($code, $name) = @_;
	return <<INI;
# NO DEBERIA SER NECESARIO EDITAR NADA DESDE AQUI
#################################################
#################################################
#################################################
[Planet]
name = Planeta Linux $name
link = http://$code.planetalinux.org/
owner_name = Planeta Linux administrators
owner_email = planetalinux\@googlegroups.com
country_tld = $code
country = $name

cache_directory = cache/$code
new_feed_items = 10
log_level = DEBUG

template_files = proc/$code/index.html.tmpl proc/rss20-new.xml.tmpl 

output_dir = output/$code.planetalinux.org

items_per_page = 150
date_format = %l:%M %P
new_date_format = %b %d, %Y
encoding = utf-8

[DEFAULT]
face = nobody.png

[http://blog.planetalinux.org/blog/feed/planeta-linux]
name = Planeta Linux - Anuncios
face = planeta.png

# NO DEBERIA SER NECESARIO EDITAR NADA HASTA AQUI
#################################################
#################################################
#################################################

# Ejemplos: 
#
# [http://someone.else/feed]
# name = Juanito González
# face = $code/juanito.png 

# [http://cofradia.sucks/?feed=rss2]
# name = Planeta Linux ownz
# face = $code/pl-pwns-it.jpg
# portal = 1

# [http://damog.net/rss]
# name = Lola La Trailera
# twitter = damog_lola




# Admin: El nuevo formato de config.ini incluye hackergotchis con un prefijo
# de la instancia en la que pertenecen. Por ejemplo, un hackergotchi en
# la instancia de México ahora tiene que colocarse así:
#  face = mx/foto.png
# De esa forma se pueden reusar los gotchis y es más sencillo utilizarlos
# desde los templates.
# Nota: Por favor deja esta nota hasta el final de este archivo.
INI
}