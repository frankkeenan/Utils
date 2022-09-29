#!/usr/bin/perl
use Text::Iconv;
use Getopt::Std;
no warnings 'uninitialized';
use strict;
our ($LOG, $LOAD, $opt_f, $opt_u, $opt_D, $opt_I, $opt_O, $UTF8, %USED, @PTAGS, %LBLS);

my $converter = Text::Iconv -> new ("utf-8", "utf-8");

# Text::Iconv is not really required.
# This can be any object with the convert method. Or nothing.

use Spreadsheet::XLSX;

getopts('uf:L:IO');
my $infile = $opt_f;
if ($infile =~ m|^ *$|)
{
    printf(STDERR "USAGE: $0 -f fname.xlsx\n");
    exit;
}
#my $excel = Spreadsheet::XLSX -> new ('infile.xlsx', $converter);
my $excel = Spreadsheet::XLSX -> new ($infile, $converter);

printf("<xlsx>\n"); 
foreach my $sheet (@{$excel -> {Worksheet}})
{    
    printf("<Worksheet name=\"%s\">\n", $sheet->{Name});
    
    $sheet -> {MaxRow} ||= $sheet -> {MinRow};
    
    foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow})
    {

	printf("<row row=\"%s\">", $row); 
	$sheet -> {MaxCol} ||= $sheet -> {MinCol};	
	foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol})
	{
	    
	    my $cell = $sheet -> {Cells} [$row] [$col];
	    
	    if ($cell)
	    {
		printf("<col col=\"%s\">%s</col>", $col, $cell -> {Val});
	    }	    
	}
	printf("</row>\n"); 	
    }
    printf("</Worksheet>\n");    
}
printf("</xlsx>\n");
