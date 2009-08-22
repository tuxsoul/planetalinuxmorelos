#!/usr/bin/perl

# Copyright (c) 2009 David Moreno <david@axiombox.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use Modern::Perl;
use File::Basename;
use Config::IniFiles;
use Data::Dumper;
use Template;

die "No instance specified\n" unless $ARGV[0];
my $instance_code = lc $ARGV[0];

my $config = dirname(__FILE__).'/../proc/'.$instance_code.'/config.ini';
die "Instance $instance_code doesn't exist\n" unless -f $config;

my $cfg = Config::IniFiles->new(-file => $config);
my $instance_name = $cfg->val('Planet', 'country');

die "Couldn't find code name for $instance_code\n" unless $instance_name;

opendir my $dir, dirname(__FILE__).'/../proc' or die "Couldn't open proc dir: $!";
my @instances = sort grep {
	!/^\./ and $_ ne 'test' and $_ ne 'universo' and -f dirname(__FILE__).'/../proc/'.$_.'/config.ini';
} readdir $dir;
close $dir;

my $html = qq{\t<li id="home"><a href="http://www.planetalinux.org" title="Planeta Linux | Página Principal">home</a></li>\n};

for my $i ( @instances ) {
	$html .= qq{\t<li id="$i"};
	if($i eq $instance_code) {
		$html .= qq{ class="current">};
	} else {
		$html .= qq{>};
	}
	
	my $i_config = dirname(__FILE__).'/../proc/'.$i.'/config.ini';
	my $i_cfg = Config::IniFiles->new(-file => $i_config);
	my $i_name = $i_cfg->val('Planet', 'country');
	$html .= qq{<a href="http://$i.planetalinux.org/" title="Planeta Linux | $i_name">$i_name</a></li>\n};
}

my $t = Template->new;

$t->process(\*DATA, {
	adsense_id => $cfg->val('Planet', 'adsense_id'),
	instance_name => $instance_name,
	instance_name_pure => normalize_name($instance_name),
	instance_code => $instance_code,
	instances_list => $html,
}, dirname(__FILE__).'/../proc/'.$instance_code.'/index.html.tmpl');


# please, somebody fix this stupidity
# i'm in a hurry, fix later.
sub normalize_name {
	my $x = $_[0];
	$x =~ s/á/a/;
	$x =~ s/é/e/;
	$x =~ s/í/i/;
	$x =~ s/ó/o/;
	$x =~ s/ú/u/;
	$x =~ s/ñ/n/;
	$x;
}

__END__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es">
<head>
<title><TMPL_VAR name></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="http://planetalinux.org/css/main.css" type="text/css" />
<link rel="shortcut icon" type="image/png" href="http://planetalinux.org/favicon.png" />
<link rel="alternate" type="application/rss+xml" title="Planeta Linux | [% instance_name %]" href="http://feedproxy.google.com/PlanetaLinux[% instance_name_pure.remove('\s+') %]" />
</head>

<body>
<div id="header">
  <div id="inside">
    <h1 id="header-title"><a href="http://[% instance_code %].planetalinux.org/" title="Planeta Linux | [% instance_name %]"><TMPL_VAR name></a></h1>
    <p id="goto-content"><a href="#entry-wrap" title="Ir al contenido">Ir al Contenido</a></p>
    <div id="menu">
      <ul id="navbar">
[% instances_list %]
      </ul>
    </div><!--/menu-->
  </div><!--/inside-->
</div><!--/header-->

<TMPL_INCLUDE trunk.tmpl>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("[% adsense_id %]");
pageTracker._trackPageview();
</script>

</body>
</html>
