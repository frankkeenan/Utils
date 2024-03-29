#!/usr/local/bin/perl

line:

while (<>)

{
    s|\r||g;
    s| >|>|g;
    s|<!--.*?-->||g;
    s|<!DOCTYPE.*?>||g;
    s|<\?.*?>||g;
    s|&#x00B7;||g;
    s|&#x02C8;||g;
    s|&#x02CC;||g;

    s| ([^<> =]+)=".*?"||g;
    m|<h(_ox3000)?>.*?</h(_ox3000)?>|i;
    $head=$&;
    $head =~ s|<.*?>||g;
    $head =~ s| &#xE...;||g;

    s|</.*?>||g;

    next line unless (/<entry/i);

    s| ([^<> =]+)=".*?"||g;
    s|<([^ >]+)>|<$1 >|g;

    while (/<([^> ]+?) ([^>]*)>([^<]*)(&.*?;)/)
	{
	    s|<([^> ]+?) ([^>]*)>([^<]*)(&.*?;)|<$1$2>$3|;
		print "\n$4\t$head\n";
	}
}
