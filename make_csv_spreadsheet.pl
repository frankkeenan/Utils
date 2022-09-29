#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
use open qw(:std :utf8);
use utf8;
use strict;
our ($LOG, $LOAD, $opt_f, $opt_u, $opt_D, $opt_I, $opt_O, $UTF8, %USED, @PTAGS, %LBLS);

require "./utils.pl";
require "./restructure.pl";
$LOG = 0;
$LOAD = 0;
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator

&main;

sub main
{
    getopts('uf:L:IO');
    &usage if ($opt_u);
    my($e, $res, $bit);
    &open_debug_files;
    # Create the header row
    my @hdr_row = ("hw", "form", "pos", "sense_num", "def_ml", "def_ml_copy", "eid_ml", "def_eng", "def_eng_copy", "eid_eng", "Notes", "lexid_msDict", "eid_msDict");
    my $hdr_row = join("\t", @hdr_row);
    printf("%s\n", $hdr_row); 
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){printf(bugin_fp "%s\n", $_);}
	my $hw = restructure::get_tag_contents($_, "hw"); 
	$_ =~ s|(<msDict[ >].*?</msDict>)|&split;&fk;$1&split;|gi;
	my @SENSES = split(/&split;/, $_);
	my $sense;
	foreach $sense (@SENSES){
	    if ($sense =~ s|&fk;||gi){		
		# $sense will be <msDict ... </msDict>
		# Get the information for the sense
		my $sensenum = restructure::get_tag_attval($sense, "msDict", "sensenum");
		my $form = restructure::get_tag_attval($sense, "msDict", "form");
		my $pos = restructure::get_tag_attval($sense, "msDict", "pos");
		#
		# rename the df tags - just to make them easier to deal with:
		$sense = restructure::rename_tag_with_attrib($sense, "df", "lang", "ml", "def_ml");
		$sense = restructure::rename_tag_with_attrib($sense, "df", "lang", "eng", "def_eng");
		# Get the contents of the tags
		my $def_eng = restructure::get_tag_contents($sense, "def_eng");
		my $def_ml = restructure::get_tag_contents($sense, "def_ml");
		# Get the identifiers
		my $eid_eng = restructure::get_tag_attval($sense, "def_eng", "e:id");
		my $eid_ml = restructure::get_tag_attval($sense, "def_ml", "e:id");
		my $eid_msDict = restructure::get_tag_attval($sense, "msDict", "e:id");
		my $lexid_msDict = restructure::get_tag_attval($sense, "msDict", "lexid");
		my $notes = ""; # Just a placeholder
		# Print the contents out as tab-delimited content
		#
		# Put the required variables into a list
		my @row = ($hw, $form, $pos, $sensenum, $def_ml, $def_ml, $eid_ml, $def_eng, $def_eng, $eid_eng, $notes, $lexid_msDict, $eid_msDict);
		# Join the elements of the list with a tab
		my $row = join("\t", @row);
		# Print the string
		printf("%s\n", $row); 
	    }
	}
	if ($opt_O){printf(bugout_fp "%s\n", $_);}
    }
    &close_debug_files;
}

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
    #    printf(STDERR "\t-x:\t\n"); 
    exit;
}
