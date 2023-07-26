#!/usr/local/bin/perl
#
# creates an empty xml file for InDesign use from tc.pl output ...
#
#
##################################################

use Getopt::Std;
require "/data/dicts/generic/progs/generic_pnc.pl";

##################################################

&main;

##################################################

sub main
{

    &gen_xml_head;

line:

    while (<>)
    {
	next line unless (/</);
	&edit_input;
	print;
    }
    &gen_xml_tail;

}

##################################################

sub edit_input
{
    s|>([^<]*)<|><|g;
    s|></([^<]*)>#\n|/>\n|g;
    s|>([^<]*)\n|>\n|g;
    s|/+>|/>|g;

}

##################################################

