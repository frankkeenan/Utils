#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
require "/usrdata3/dicts/NEWSTRUCTS/progs/utils.pl";
require "/NEWdata/dicts/generic/progs/restructure.pl";
#require "/NEWdata/dicts/generic/progs/xsl_lib_fk.pl";
$LOG = 0;
$LOAD = 0;
$UTF8 = 0;
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once
&main;

sub main
{
    getopts('uf:L:n:IO');
    &usage if ($opt_u);
    my($e, $res, $bit);
    my(@BITS);
#   $opt_L = ""; # name of file for the log_fp output to go to
    &open_debug_files;
    if ($LOAD){&load_file($opt_f, \%W);}
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){
	    printf(bugin_fp "%s\n", $_);
	}
	# s|<!--.*?-->||gio;
#	next line if (m|<entry[^>]*del=\"y|io);
#	next line if (m|<entry[^>]*sup=\"y|io);
	# $h = &get_hdwd($_);	# fk1
	$h = &get_hex_h($_, "hex", 1); # the 1 says to remove stress etc
	$_ = restructure::delabel($_);	
	$sup = 0;
	$bord = 0;
	if (m|<entry[^>]* sup=\"y|io)
	{
	    $sup = 1;
	    $h = sprintf("%s (sup=y)", $h);
	}
	if (m|<entry[^>]* bord=\"y|io)
	{
	    $bord = 1;
	    $h = sprintf("%s (bord=y)", $h);
	}
	&check_broken($_, $h);
	&check_discarded($_, $h);
	&check_xx($_, $h);
	if ($opt_O){
	    printf(bugout_fp "%s\n", $_); 
	}
    }
    printf("<html><body>\n<h1>Cross Ref Checks</h1>\n"); 
    &print_menu;
    if ($BROKEN_CT)
    {
	&print_broken;
    }
    if ($DISCARDED_CT)
    {
	&print_discarded;
    }
    if ($XX_CT)
    {
	&print_xx;
    }
    printf("</body>\n</html>\n"); 
    &close_debug_files;
}


sub print_menu
{
    printf("<h4>Links:</h4>\n<ul>\n"); 
    printf("<li><a href=\"\#broken\">Broken cross refs (ct=%d)</a></li>\n", $BROKEN_CT); 
    printf("<li><a href=\"\#discarded\">Elements with discarded targets (ct=%d)</a></li>\n", $DISCARDED_CT); 
    printf("<li><a href=\"\#xx\">Entries with xx (ct=%d)</a></li>\n", $XX_CT); 
    printf("</ul>\n"); 
}


sub print_xx
{
    my($e) = @_;
    my($res, $eid);	
    printf("<h2><a name=\"xx\" />Entries with xx xrefs</h2>\n"); 
    printf("<ul>\n"); 
    foreach $h (sort keys %XX)
    {
	printf("<li>%s</li>\n", $h); 
    }
    printf("</ul>\n"); 
}


sub print_broken
{
    my($e) = @_;
    my($res, $eid);	
    printf("<h2><a name=\"broken\" />Entries with BROKEN! xrefs</h2>\n"); 
    printf("<ul>\n"); 
    foreach $h (sort keys %BROKEN)
    {
	printf("<li>%s</li>\n", $h); 
    }
    printf("</ul>\n"); 
}


sub print_discarded
{
    my($e) = @_;
    my($res, $eid);	
    printf("<h2><a name=\"discarded\" />Entries with DISCARDED! xrefs</h2>\n"); 
    printf("<ul>\n"); 
    foreach $h (sort keys %DISCARDED)
    {
	printf("<li>%s</li>\n", $h); 
    }
    printf("</ul>\n"); 
}


sub check_xx
{
    my($e, $h) = @_;
    if ($e =~ m|xx|)
    {
	$e =~ s|<[^>]*>||gi;
	if ($e =~ m|xx|)
	{
	    $XX_CT++;
	    $XX{$h} = 1;
	}
    }
}

sub check_broken
{
    my($e, $h) = @_;
    if ($e =~ m|BROKEN!|)
    {
	$BROKEN_CT++;
	$BROKEN{$h} = 1;
    }
}

sub check_discarded
{
    my($e, $h) = @_;
    if ($e =~ m|TARGET *DISCARDED!|)
    {
	$DISCARDED_CT++;
	$DISCARDED{$h} = 1;
    }
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
    my($f, $W) = @_;
    my ($res, $bit, $info);
    my @BITS;
    open(in_fp, "$f") || die "Unable to open $f"; 
    if ($UTF8){
	binmode(in_fp, ":utf8");
    }
    while (<in_fp>){
	chomp;
	s|||g;
	# ($id, $info) = split(/\t/);
	$W->{$_} = 1;
    }
    close(in_fp);
} 
