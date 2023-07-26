#!/usr/local/bin/perl
#
# Input = 
# Result = 
# $Id$
# $Log$
#
use Getopt::Std;
require "/disk1/home/keenanf/perl/utils.pl";
require "/disk1/home/keenanf/perl/unicode_module.pl";

$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
#    printf(STDERR "\t-x:\t\n"); 
    exit;
}

&main;

sub main
{
    getopts('uf:');
#    getopts('a:bz:');
#    stores value of arguments in $opt_a and $opt_z and BOOLEAN $opt_b
#
    if ($opt_u)
    {
	&usage;
    }
  line:    
    while (<>) 
    {
	chomp;       # strip record separator
	$_ = &unicode2ents($_);
	s|&nbhyph;|-|g;
	s|&grslash;|/|g;
	print $_;
    }
}

sub load_file
{
    my($f) = @_;
    open(in_fp, "$f") || die "Unable to open $f"; 
    while (<in_fp>)
    {
	chomp;
	$W{$_} = 1;
    }
    close(in_fp);
} 
