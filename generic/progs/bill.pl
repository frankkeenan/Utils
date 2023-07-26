#!/usr/local/bin/perl

# checks all sense numbers as per generic_pnc.pl - doesn't attempt to differentiate pub="el" or other "conditional" senses ..

line:

while (<>)

{
    &gen_renumber_ng;
	
	next line unless (/<!--ng([^>]+)changed to-->/);
	
	s|<h .*?>|<h>|g;
	s|<h>.*?</h>|\n<<$&\n|g;
	s|<!--ng([^>]+)changed to--><n-g([^>]*)n=".*?"|\n\t<<$&>\n|g;
	
	print;
}

sub gen_renumber_ng
{
    my(@NGS);
    my($ng);
    my($res);
    $res = "";
    if (s|(<n-g)|&split;$1|gi)
    {
	$expected = 1;
	$res = "";
	@NGS = split(/&split;/);
	foreach $ng (@NGS)
	{
	    if ($ng =~ /<n-g([^>]*) n="([0-9]+)"/i)
	    {
		$num = $2;
		if ($num == 1)
		{
		    # always allowed
		    $expected = 1;
		}
		elsif ($num != $expected)
		{
		    $ng =~ s|(<n-g([^>]*) n=")[0-9]+|<!--ng $num changed to-->$1$expected|i unless ($NoNumChange);
		    $ng =~ s|<z_n>(.*?)</z_n>|<z_n>$expected</z_n>|i unless ($NoNumChange);
		}
		$expected++;
		if ($ng =~ /<(h-g|id-g|pv-g)/i)
		{
		    $expected = 1;
		}
	    }
	    $res = sprintf("%s%s", $res, $ng);
	}	
	$_ = $res;
    }
    else
    {
	return;
    }
}
