#!/usr/local/bin/perl

while (<>)

{
    m|(.+?)\t.+|;
	$tagchar=$1;
	
	unless ($tagchar eq $prev)
	{
        print;
	}

	$prev = $tagchar;
}
