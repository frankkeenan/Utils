#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
use open qw(:std :utf8);
use utf8;
use strict;
our ($LOG, $LOAD, $opt_f, $opt_u, $opt_D, $opt_I, $opt_O, $opt_x);
require "./utils.pl";
require "./restructure.pl";

$LOG = 0;
$LOAD = 0;
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once
&main;

sub main
{
    getopts('uf:L:IODx:');
    &usage if ($opt_u);
    my($e, $res, $bit, $top);
    my(@BITS);
    #   $opt_L = ""; # name of file for the log_fp output to go to
    &open_debug_files;
    use open qw(:utf8 :std);
    if ($opt_D)
    {
	binmode DB::OUT,":utf8";
    }
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){printf(bugin_fp "%s\n", $_);}
	if (m|<e |)
	{
	    $top = 0;
	}
	if ($top)
	{
	    print $_;
	    next line;
	}
	s|£|&\#x00A3;|g;
	s|\t| |gio;
	if (($opt_x =~ m|oxmono|) || ($opt_x =~ m|oxbi|))
	{
	    s|(<e )|£\1|g;
	    s|(</e>)|\1£|g;
	}
	elsif ($opt_x =~ m|lexml|)
	{
	    s|(<entryGroup )|£\1|g;
	    s|(</entryGroup>)|\1£|g;   
	}
	s| *£ *|£|go;
	s|£+|\n|g;
	printf("%s", $_);
	if ($opt_O){printf(bugout_fp "%s\n", $_);}
    }
    printf("\n"); 
    &close_debug_files;
}

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
    #    printf(STDERR "\t-x:\t\n"); 
    exit;
}


sub load_file
{
    my($f) = @_;
    my ($res, $bit, $info);
    my @BITS;
    open(in_fp, "$f") || die "Unable to open $f"; 
    binmode(in_fp, ":utf8");
    while (<in_fp>){
	chomp;
	s|||g;
	# my ($eid, $info) = split(/\t/);
	# $W{$_} = 1;
    }
    close(in_fp);
} 
