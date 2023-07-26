#!/usr/local/bin/perl

require "/data/dicts/generic/progs/unicode_phons_with_partial.pl";

while (<>)


{
    $_ = &phon_ents($_);	
	print;
	
}