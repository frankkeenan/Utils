#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
use open qw(:std :utf8);
use utf8;
use File::Path qw(make_path remove_tree);
use strict;
our ($LOG, $LOAD, $opt_b, $opt_f, $opt_u, $opt_D, $opt_I, $opt_O, $opt_r, $UTF8, %USED, @PTAGS, %LBLS, $BATCH_SIZE, $RESDIR);
require "./utils.pl";
require "./restructure.pl";
$LOG = 1;
$LOAD = 0;
$BATCH_SIZE = 15;
$RESDIR = "Batches";
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once
&main;

sub main
{
    getopts('uf:L:IODb:r:');
    &usage if ($opt_u);
    my($e, $res, $bit);
    my ($def_eng, $def_ml, $eid_eng, $eid_ml, $eid_msDict, $form, $hw, $lexid_msDict, $notes, $pos, $sensenum, $senses_in_block, $batch_num);
    my(@BITS);
#   $opt_L = ""; # name of file for the log_fp output to go to
    &open_debug_files;
    use open qw(:utf8 :std);
    if ($opt_D)
    {
	binmode DB::OUT,":utf8";
    }
    if ($opt_b)
    {
	$BATCH_SIZE = $opt_b;
    }
    if ($opt_r)
    {
	$RESDIR = $opt_b;
    }
    unless (-d $RESDIR)
    {
	mkpath($RESDIR);
    }
    if ($LOAD){&load_file($opt_f);}
    my $ect = 0;
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){printf(bugin_fp "%s\n", $_);}
	next line unless (m|<e |);
	if (($ect++ % $BATCH_SIZE) == 0)
	{
	    if ($ect > 1)
	    {
		close(out_fp);
		
	    }
	    my $outf = sprintf("$RESDIR/core_%03d", ++$batch_num); 
	    open(out_fp, ">$outf") || die "Unable to open >$outf"; 
	    binmode(out_fp, ":utf8");
	    printf(out_fp "HW\tWord\tPOS\tDef\tLabels\tCore\tSense Number\tSenses In Block\tDefs in Entry\tDef_cp\te e:id\tDef e:id\tmsDict lexid\tNotes\tChanged\tPeer Reviewer\tLanguage Consultant\n"); 	    
	}	
	my $e_eid = restructure::get_tag_attval($_, "e", "e:id"); 
	if ($_ =~ m|<hw|)
	{
	    $hw = restructure::get_tag_attval($_, "hw", "normalized"); 
	    if ($hw =~ m|^ *$|)
	    {
		$hw = restructure::get_tag_contents($_, "hw"); 
	    }
	}
	$_ =~ s|(<msDict[ >].*?</msDict>)|&split;&fk;$1&split;|gi;
	@BITS = split(/&split;/, $_);
	$res = "";
	foreach $bit (@BITS){
	    if ($bit =~ s|&fk;||gi){
		my $form = restructure::get_tag_attval($bit, "msDict", "form"); 
		my $def = restructure::get_tag_contents($bit, "df"); 
		my $plabel = restructure::get_tag_contents($bit, "plabels"); 
		my $label = restructure::get_tag_contents($bit, "label"); 
		my $def_id = restructure::get_tag_attval($bit, "df", "lexid");
		my $def_eid = restructure::get_tag_attval($bit, "df", "e:id");
		my $msdict_id = restructure::get_tag_attval($bit, "msDict", "lexid");
		my $pos = restructure::get_tag_attval($bit, "msDict", "pos"); 
		my $senses_in_block = restructure::get_tag_attval($bit, "msDict", "se2ct");
		my $sensenum = restructure::get_tag_attval($bit, "msDict", "sensenum");
		my $tot_defs = restructure::get_tag_attval($bit, "msDict", "defct"); 
		if ($def =~ m|<|)
		{
		    printf(log_fp "%s\n", $def); 
		}
		$def =~ s|<.*?>||gi;
		$plabel =~ s|<.*?>||gi;
		my $labels = sprintf("%s, %s", $plabel, $label);
		$labels =~ s|^[ ,]*||;
		$labels =~ s|[ ,]*$||;
		my $core = "";
		if ($tot_defs < 3)
		{
		    $core = "y";
		}
		printf(out_fp "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $hw, $form, $pos, $def, $labels, $core, $sensenum, $senses_in_block, $tot_defs, $def, $e_eid, $def_eid, $msdict_id); 
	    }
	    $res .= $bit;
	}		
	if ($opt_O){printf(bugout_fp "%s\n", $_);}
  }
    close(out_fp);
    &close_debug_files;
}

sub add_form_to_msdict
{
    my($e, $wd) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e = restructure::tag_delete($e, "eg"); 
    $e =~ s|(<msDict[ >].*?</msDict>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    my $form = restructure::get_tag_attval($bit, "msDict", "form"); 
	    if ($form =~ m|^ *$|)
	    {
		$bit = restructure::set_tag_attval($bit, "msDict", "form", $wd); 		
	    }
	    else {
#		$ct++;
	    }
	}
	$res .= $bit;
    }    
    return $res;
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
