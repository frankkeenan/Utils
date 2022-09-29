#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
use open qw(:std :utf8);
use utf8;
use Excel::Writer::XLSX;
use strict;
our ($LOG, $LOAD, $opt_u, $opt_D, $opt_I, $opt_O, $UTF8, %USED, @PTAGS, %LBLS, $workbook, $opt_r);
require "./utils.pl";
require "./restructure.pl";
$LOG = 0;
$LOAD = 0;
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator

&main;

sub main
{
    getopts('uf:L:IOr:');
    &usage if ($opt_u);
    my($e, $res, $bit, $row);
    my ($def_eng, $def_ml, $eid_eng, $eid_ml, $eid_msDict, $form, $hw, $lexid_msDict, $notes, $pos, $sensenum);
    my @flds;
    &open_debug_files;
    # Result file given at -r attribute - default output if not
    unless ($opt_r)
    {
	$opt_r = "excel_output.xlsx";
    }
    my $workbook  = Excel::Writer::XLSX->new( $opt_r );
    my $worksheet = $workbook->add_worksheet();

    # Create some format objects
    my $hidden   = $workbook->add_format(bg_color => '#C6EFCE');
    my $unlocked = $workbook->add_format( locked => 0 );
    my $locked = $workbook->add_format( locked => 1);
    my $locked_hidden   = $workbook->add_format(locked => 1, bg_color => '#C6EFCE');
#    my $locked_hidden   = $workbook->add_format(locked => 1, hidden => 1);
#    my $locked_hidden   = $workbook->add_format(hidden => 1);
    # Header row
    my $format1 = $workbook->add_format(bg_color => '#E6FFFF', color    => '#000000', bold => 1);
    # Normal
#    my $format2 = $workbook->add_format(bg_color => '#C6EFCE', color    => '#006100');
    my $format_wrap = $workbook->add_format(text_wrap => 1);
    
    # Format the columns
#    $worksheet->autofilter( 'A1:I9999' );
###    
    # Create the header row
    @flds = ("hw", "form", "pos", "sensenum", "def_ml", "def_ml_copy", "eid_ml", "def_eng", "def_eng_copy", "eid_eng", "Notes", "lexid_msDict", "eid_msDict");
    $worksheet->write_row( $row++, 0, \@flds, $format1);
#    my $fld = join("\t", @flds);
#    printf("%s\n", $fld); 
    
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){printf(bugin_fp "%s\n", $_);}
	$hw = restructure::get_tag_contents($_, "hw"); 
	$_ =~ s|(<msDict[ >].*?</msDict>)|&split;&fk;$1&split;|gi;
	my @SENSES = split(/&split;/, $_);
	my $sense;
	foreach $sense (@SENSES){
	    if ($sense =~ s|&fk;||gi){		
		# $sense will be <msDict ... </msDict>
		# Get the information for the sense
		$sensenum = restructure::get_tag_attval($sense, "msDict", "sensenum");
		$form = restructure::get_tag_attval($sense, "msDict", "form");
		$pos = restructure::get_tag_attval($sense, "msDict", "pos");
		#
		# rename the df tags - just to make them easier to deal with:
		$sense = restructure::rename_tag_with_attrib($sense, "df", "lang", "ml", "def_ml");
		$sense = restructure::rename_tag_with_attrib($sense, "df", "lang", "eng", "def_eng");
		# Get the contents of the tags
		$def_eng = restructure::get_tag_contents($sense, "def_eng");
		$def_ml = restructure::get_tag_contents($sense, "def_ml");
		# Get the identifiers
		$eid_eng = restructure::get_tag_attval($sense, "def_eng", "e:id");
		$eid_ml = restructure::get_tag_attval($sense, "def_ml", "e:id");
		$eid_msDict = restructure::get_tag_attval($sense, "msDict", "e:id");
		$lexid_msDict = restructure::get_tag_attval($sense, "msDict", "lexid");
		$notes = ""; # Just a placeholder
		# Print the contents out as tab-delimited content
		#
		# Put the required variables into a list
		@flds = ($hw, $form, $pos, $sensenum, $def_ml, $def_ml, $eid_ml, $def_eng, $def_eng, $eid_eng, $notes, $lexid_msDict, $eid_msDict);
		$worksheet->write_row( $row++, 0, \@flds, $format_wrap);
		#
		# Join the elements of the list with a tab
#		my $fld = join("\t", @flds);
		# Print the string
#		printf("%s\n", $fld); 
	    }
	}
	if ($opt_O){printf(bugout_fp "%s\n", $_);}
  }
    $worksheet->freeze_panes( 1 );    # Freeze the first row
    if (0)
    {
    $worksheet->set_column( 'A:D', 15, $locked );
    $worksheet->set_column( 'E:E', 45, $unlocked );
    $worksheet->set_column( 'F:F', 45, $locked );
    $worksheet->set_column( 'G:G', 15, $locked_hidden );
    $worksheet->set_column( 'H:H', 45, $unlocked );
    $worksheet->set_column( 'I:J', 25, $locked_hidden );
    $worksheet->set_column( 'L:M', 25, $locked_hidden );
    $worksheet->set_column( 'K:K', 45, $unlocked );

    } else {
	$worksheet->set_column( 'A:A', 15, $locked );
	$worksheet->set_column( 'C:M', 15, $locked );
	$worksheet->set_column( 'B:B', 45, $locked_hidden );
    }
    $workbook->close();
    
    &close_debug_files;
}

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n");
    printf(STDERR "\t-r result_file:\tThe XLSX file to create\n");
    #    printf(STDERR "\t-x:\t\n"); 
    exit;
}
