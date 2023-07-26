#!/usr/local/bin/perl
#
# Input = 
# Result = 
# $Id$
# $Log$
#
use Getopt::Std;
require "/disk1/home/keenanf/perl/utils.pl";

$LOG = 0;
$LOAD = 0;
$UTF8 = 0;

$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-f:\tFull InDesign XML file to use as input\n"); 
#    printf(STDERR "\t-x:\t\n"); 
    exit;
}

&main;

sub main
{
    getopts('udf:IOsn:l:');
#    getopts('a:bz:');
#    stores value of arguments in $opt_a and $opt_z and BOOLEAN $opt_b
#
    getopts('dxpauf:sBn:');
    $t1 = time;
    $start_time = &gmt;
    unless ($opt_f)
    {
	&usage;
    }

    printf(STDERR "Started at %s\n", $start_time); 
    if ($opt_d)
    {
	$DBG = 1;
    }
    unless ($opt_n) # number of lines in data sample
    {
	$opt_n = 1000;
    }
    unless ($opt_l) # number of entries to show at the start of the sample
    {
	$opt_l = 500;
    }
    if ($opt_s)
    {
	$sample = sprintf("head -%s", $opt_n);
    }
    else
    {
	$sample = "cat";
    }
    # FOLDERS
    $indd_dir = $opt_f;
    $indd_dir =~ s|/[^/]*$||;
    if ($indd_dir =~ m|^ *$|)
    {
	$indd_dir = ".";
    }
    $tcfile = sprintf("%s.tc", $opt_f);
    $empty_tag_file  = sprintf("%s/empty_tag_file.xml", $indd_dir);
    $sample_tag_file  = sprintf("%s/samples_indd.xml", $indd_dir);
    $tc_comm = sprintf("$sample %s | /usr/local/bin/tc.pl  > %s", $opt_f, $tcfile);
    &mycomm($tc_comm, $DBG);
    $make_empty_tagfile = sprintf("$sample %s | /data/dicts/generic/progs/empty_xml_from_tc.pl > %s", $tcfile, $empty_tag_file);
    &mycomm($make_empty_tagfile, $DBG);
    $make_samples_file = sprintf("$sample %s | /data/dicts/generic/progs/get_tag_samples.pl -l %s > %s", $opt_f, $opt_l, $sample_tag_file);
    &mycomm($make_samples_file, $DBG);
    exit;
}

sub load_file
{
    my($f) = @_;
    my $res;
    my @BITS;
    my $bit;

    open(in_fp, "$f") || die "Unable to open $f"; 
    if ($UTF8){
	binmode(in_fp, ":utf8");
    }
    while (<in_fp>){
	chomp;
	s|||g;
	$W{$_} = 1;
    }
    close(in_fp);
} 
