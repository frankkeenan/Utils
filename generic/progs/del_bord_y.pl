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
    getopts('uf:L:IO');
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
	next line if (m|<entry[^>]* bord=\"y|io);
	# $h = &get_hdwd($_);	# fk1
	# $h = &get_hex_h($_, "hex", 1); # the 1 says to remove stress etc
	# $eid = &get_tag_attval($_, "entry", "eid");
	# $dps_eid = &get_dps_entry_id($_);
	# $_ = &reduce_idmids($_);
	# s|£|&\#x00A3;|g;
        # $_ = restructure::delabel($_);	
	if (m| bord=\"y|i)
	{
	    $_ = &del_bord_y($_);
	}
	$e = $_;
	print $_;
	if ($opt_O){
	    printf(bugout_fp "%s\n", $_); 
	}
    }
    &close_debug_files;
}

sub del_bord_y
{
    my($e) = @_;
    my($res, $eid);	
    while ($e =~ m|^.*?(<[^>]* bord=\"y[^>]*>)|i)
    {
	$bord = $1;
	$tagname = restructure::get_tagname($bord);    
	$e = restructure::del_tag_with_attrib($e, $tagname, "bord", "y");	
    }
    return $e;
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
