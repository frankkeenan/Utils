#!/usr/local/bin/perl
#
# Input = 
# Result = 
# $Id: add_pracpron.pl,v 1.2 2014/11/03 12:38:12 keenanf Exp keenanf $
# $Log: add_pracpron.pl,v $
# Revision 1.2  2014/11/03 12:38:12  keenanf
# *** empty log message ***
#
# Revision 1.1  2014/03/15 14:04:53  keenanf
# Initial revision
#
#
use Getopt::Std;
require "/usrdata3/dicts/NEWSTRUCTS/progs/utils.pl";
require "/NEWdata/dicts/generic/progs/restructure.pl";

$LOG = 0;
$LOAD = 0;
$UTF8 = 0;
$SPOKEN_EXAMPLES = 0; # NOT WANTED FOR THE WEBSITE INITIALLY! - change to 1 when they are

$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once

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
    getopts('uf:L:IO');
#    getopts('a:bz:');
#    stores value of arguments in $opt_a and $opt_z and BOOLEAN $opt_b
#
    if ($opt_u){
	&usage;
    }
    &open_debug_files;
    if ($LOAD){
	&load_file($opt_f);
    }
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){
	    printf(bugin_fp "%s\n", $_);
	}
	# fk1
	# s|<!--.*?-->||gio;
#	next line if (m|<entry[^>]*del=\"y|io);
	# $h = &get_hdwd($_);
	# $eid = &get_tag_attval($_, "entry", "eid");
	# $dps_eid = &get_dps_entry_id($_);
	# $_ = &reduce_idmids($_);
	# s|£|&\#x00A3;|g;
	$_ = &mark_verb_form_label($_) if (m|<vp-gs|i);
	$cp = $_;
	$_ = &add_forms_to_audio($_);
	$prongs = &get_prongs($_);
	$spoken_examples = "";
	if ($SPOKEN_EXAMPLES)
	{
	    if (m|<rx-g|i)
	    {
		$spoken_examples = &get_spoken_examples($_);
	    }	
	}
	$prac_pron = sprintf("<pracpron >%s%s</pracpron>", $prongs, $spoken_examples);
	$prac_pron =~ s|<pracpron[^>]*> *</pracpron>||gi;
	$prac_pron = &remove_duplicates($prac_pron);
	$prac_pron =~ s| eid=\"| eid=\"pp_|gi;
	$_ = $cp;
	$_ =~ s|</top-g>|$prac_pron</top-g>|i;
	print $_;
	if ($opt_O){
	    printf(bugout_fp "%s\n", $_); 
	}
    }
    &close_debug_files;
}

sub remove_duplicates
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $cp);
    my(@BITS);
    my %LOSE;
    $cp = $e;
    $e =~ s|(<pron-gs[ >].*?</pron-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    unless ($bit =~ m|verbform=\"y|)
	    {
		$wd = restructure::get_tag_contents($bit, "wd"); 
		$LOSE{$wd} = 1;
	    }
	}
    }
    $res = "";
    $e = $cp;
    $e =~ s|(<pron-gs[ >].*?</pron-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    if ($bit =~ m|verbform=\"y|)
	    {
		$wd = restructure::get_tag_contents($bit, "wd"); 
		if ($LOSE{$wd})
		{
		    $bit = "";
		}
	    }
	}
	$res .= $bit;
    }
    return $res;
}

sub mark_verb_form_label
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<vp-gs[ >].*?</vp-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $bit =~ s|<pron-gs |<pron-gs verbform=\"y\" |gi;
	}
	$res .= $bit;
    }    
    return $res;
}

sub add_forms_to_audio
{
    my($e) = @_;
    my($res, $eid);	
    $e = &add_audio_form($e, "vp-g", "vp");
    $e = &add_audio_form($e, "v-g", "v");
    $e = &add_audio_form($e, "if-g", "if");
    $e = &add_audio_form($e, "x-g", "x");
    $e = &add_audio_form($e, "dr-g", "dr");
    $e = &add_audio_form($e, "id-g", "id");
    $e = &add_audio_form($e, "pv-g", "pv");
    $e = &add_audio_form($e, "entry", "h");
    return $e;
}

sub add_audio_form
{
    my($e, $grouptag, $boldtag) = @_;
    my($res, $eid);	
    my($bit, $res);
    unless ($e =~ m|<$grouptag|i)
    {
	return $e;
    }
    my(@BITS);
    $e =~ s|(<$grouptag[ >].*?</$grouptag>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    if ($bit =~ m|<pron-gs|i)
	    {
		$bit = &add_bold_to_audio($bit, $boldtag);
	    }
	}
	$res .= $bit;
    }
    return $res;
}

sub add_bold_to_audio
{
    my($e, $boldtag) = @_;
    my($res, $eid);	
    my($bit, $bold);
    my(@BITS);
    $e =~ s|(<$boldtag[ >].*?</$boldtag>)|&split;&fk2;$1&split;|gi;
    $e =~ s|(<pron-gs[ >].*?</pron-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk2;||gi){
	    $bold = restructure::get_tag_contents($bit, $boldtag); 
	    $bold = sprintf("<wd>%s</wd>", $bold);
	}
	if ($bit =~ s|&fk;||gi){
	    unless ($bit =~ m|<wd[ >]|i)
	    {
		$bit =~ s|>|>$bold|i;
	    }
	}
	$res .= $bit;
    }    
    return $res;
}

sub get_prongs
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<pron-gs[ >].*?</pron-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $res .= $bit;
	}
    }    
    return $res;
}

sub get_spoken_examples
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<x-g[ >].*?</x-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
  floop_rxg:
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    next floop_rxg unless ($bit =~ m|<xaudio|i);
	    $wd = restructure::get_tag_attval($bit, "x", "wd"); 
	    ($audio_gb, $audio_us) = &get_xaudio($bit);
	    $res = sprintf("%s<x-g><x>%s</x><audio-gb>%s</audio-gb><audio-us>%s</audio-us></x-g>", $res, $wd, $audio_gb, $audio_us); 
	}
    }    
    unless ($res =~ m|^ *$|)
    {
	$res = sprintf("<x-gs>%s</x-gs>", $res);
    }
    return $res;
}

sub get_xaudio
{
    my($e) = @_;
    my($res, $eid, $audio_gb, $audio_us);	
    my($bit, $geo);
    my(@BITS);
    $e =~ s|(<xaudio[ >].*?</xaudio>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $geo = restructure::get_tag_attval($bit, "xaudio", "geo"); 
	    if ($geo =~ m|n_am|i)
	    {
		$audio_us = restructure::get_tag_attval($bit, "xaudio", "name"); 
		$audio_us = sprintf("<Media type=\"sound\" resource=\"us_example\" topic=\"%s\"/>", $audio_us);
	    }
	    else
	    {
		$audio_gb = restructure::get_tag_attval($bit, "xaudio", "name"); 
		$audio_gb = sprintf("<Media type=\"sound\" resource=\"uk_example\" topic=\"%s\"/>", $audio_gb);
	    }
	}
	$res .= $bit;
    }    
    return($audio_gb, $audio_us);
}



sub load_file
{
    my($f) = @_;
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
	$W{$_} = 1;
    }
    close(in_fp);
} 
