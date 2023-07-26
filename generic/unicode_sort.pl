#!/usr/local/bin/perl
#
# Input = 
# Result = 
# $Id$
# $Log$
#
use Getopt::Std;
require "/disk1/home/keenanf/perl/utils.pl";
require "/disk1/home/keenanf/perl/unicode_module.pl";

$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-o:\tOrder file\n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
#    printf(STDERR "\t-x:\t\n"); 
    exit;
}

&main;

sub main
{
    getopts('uf:o:');
#    getopts('a:bz:');
#    stores value of arguments in $opt_a and $opt_z and BOOLEAN $opt_b
#
    if ($opt_u)
    {
	&usage;
    }
    unless ($opt_o)
    {
	$opt_o = "sort_order.dat";
    }
    &load_sort_order($opt_o);
  line:    
    while (<>) 
    {
	chomp;       # strip record separator
	$sk = &get_sort_key($_);
	
	printf("%s#%s\n", $sk, $_); 
#	print $_;
    }
}

sub get_sort_key
{
    my($e) = @_;
    my(@BITS);
    my $res;
    my $bit;
    my $ct;
    $e = &do_exceptions($e);
    $punc_ct = &get_punc_count($e);
    $case_ct = &get_case_count($e);
    $e =~ tr|A-Z|a-z|;
    $e = &explode($e);
    @BITS = split(/ +/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($SORTNUM{$bit})
	{
	    if ($opt_d)
	    {
		$res = sprintf("%s%03d(%s)#", $res, $SORTNUM{$bit}, $bit);
	    }
	    else
	    {
		$res = sprintf("%s%03d#", $res, $SORTNUM{$bit});
	    }
	}
    }
    $res = sprintf("%s%s#%s", $res, $case_ct, $punc_ct);
    return $res;
}

sub get_case_count
{
    my($e) = @_;
    my $ct;
    # Values for case go in at the end of the string - they will just say how e.g. August sorts against eg. - alpha sort august - caps comes first
    if ($e =~ m|[A-Z]|)
    {
	$ct = 0;
    }
    else
    {
	$ct = 1;
    }
    return $ct;
}

sub get_punc_count
{
    my($e) = @_;
    my $ct;
    # Values for punc go in at the end of the string - they will just say how e.g. sorts against eg. - alpha sort comes first
    $ct = 0;
    $e =~ s|&apos;|&\#x0027;|go;
    $e =~ s|&laquo;|&\#x00AB;|go;
    $e =~ s|&ldquo;|&\#x201C;|go;
    $e =~ s|&ldquor;|&\#x201E;|go;
    $e =~ s|&lsqb;|&\#x005B;|go;
    $e =~ s|&lsquo;|&\#x2018;|go;
    $e =~ s|&lsquor;|&\#x201A;|go;
    $e =~ s|&quot;|&\#x0022;|go;
    $e =~ s|&raquo;|&\#x00BB;|go;
    $e =~ s|&rdquo;|&\#x201D;|go;
    $e =~ s|&rdquor;|&\#x201C;|go;
    $e =~ s|&rsquo;|&\#x2019;|go;
    $e =~ s|&rsquor;|&\#x2018;|go;

    $ct += ($e =~ s|(&\#x0027;)|$1|go);
    $ct += ($e =~ s|(&\#x00AB;)|$1|go);
    $ct += ($e =~ s|(&\#x201C;)|$1|go);
    $ct += ($e =~ s|(&\#x201E;)|$1|go);
    $ct += ($e =~ s|(&\#x005B;)|$1|go);
    $ct += ($e =~ s|(&\#x2018;)|$1|go);
    $ct += ($e =~ s|(&\#x201A;)|$1|go);
    $ct += ($e =~ s|(&\#x0022;)|$1|go);
    $ct += ($e =~ s|(&\#x00BB;)|$1|go);
    $ct += ($e =~ s|(&\#x201D;)|$1|go);
    $ct += ($e =~ s|(&\#x201C;)|$1|go);
    $ct += ($e =~ s|(&\#x2019;)|$1|go);
    $ct += ($e =~ s|(&\#x2018;)|$1|go);
    $ct += ($e =~ s|\.|$1|go);

    if ($ct)
    {
	return 1;
    }
    else
    {
	return 0;
    }
#    return $ct;
}

sub explode
{
    my($e) = @_;
    $e =~ s|(.)| $1 |g;
    $e = &lose_ent_spaces($e);
    return $e;
}

sub get_sort_key_ex
{
    my ($e) = @_;
    my $ct;
    $ct = 0;


    if ($e =~ s| +||g)
    {
	$ct++;
    }

#    if ($e =~ m|&\#|)
    {
	$e = &unicode2ents($e);
	$e2 = &lose_non_letter_ents($e);
	unless ($e2 eq $e)
	{
	    $ct += 2;
	    $e = $e2;
	}
	if ($e =~ tr|A-Z|a-z|)
	{
	    $ct += 4;
	}
	$e2 = &lose_ents($e);
	unless ($e2 eq $e)
	{
	    $ct += 8;
	    $e = $e2;
	}
	
	$e =~ s|(.)| $1 |gi;
	$e =~ s| +| |g;
#	$e =~ s|([a-z0-9])|$1  |gi;
	$e = &lose_ent_spaces($e);
    }

    
    $e = sprintf("%s%s", $e, $ct);

    return $e;
}

sub lose_ents
{
    my($e) = @_;
    $e =~ s|&(.).*?;|$1|gio;
    return $e;
}

sub lose_ent_spaces
{
    my($e) = @_;
    my @BITS;
    my $res, $bit;
    $e =~ s|(&.*?;)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($bit =~ s|&fk;||gio)
	{
	    $bit =~ s| +||g;
	    $bit =~ s|$| |;
	}
	$res .= $bit;
    }
    return $res;
}

sub do_exceptions
{
    my($e) = @_;
    $e =~ s|&\#x00C6;|&AElig;|go;
    $e =~ s|&\#x0132;|&IJlig;|go;
    $e =~ s|&\#x0152;|&OElig;|go;
    $e =~ s|&\#x00E6;|&aelig;|go;
    $e =~ s|&\#xFB03;|&ffilig;|go;
    $e =~ s|&\#xFB00;|&fflig;|go;
    $e =~ s|&\#xFB04;|&ffllig;|go;
    $e =~ s|&\#xFB01;|&filig;|go;
    $e =~ s|&\#xFB02;|&fllig;|go;
    $e =~ s|&\#x0133;|&ijlig;|go;
    $e =~ s|&\#x0153;|&oelig;|go;
    $e =~ s|&\#x00DF;|&szlig;|go;
    $e =~ s|\&#x0026;|&amp;|go;
    $e =~ s|&AElig;|AE|go;
    $e =~ s|&IJlig;|IJ|go;
    $e =~ s|&OElig;|OE|go;
    $e =~ s|&aelig;|ae|go;
    $e =~ s|&ffilig;|ffi|go;
    $e =~ s|&fflig;|ff|go;
    $e =~ s|&ffllig;|ffl|go;
    $e =~ s|&filig;|fi|go;
    $e =~ s|&fllig;|fl|go;
    $e =~ s|&ijlig;|ij|go;
    $e =~ s|&oelig;|oe|go;
    $e =~ s|&szlig;|sz|go;
    $e =~ s|&amp;|and|go;
    return $e;
}

sub load_sort_order
{
    my($f) = @_;
    my($lct);
    $lct = 0;
    open(in_fp, "$f") || die "Unable to open $f"; 
    while (<in_fp>)
    {
	chomp;
	if (m|[A-Z0-9]|i)
	{
	    $lct++;
	}

	@BITS = split(/ +/);
	$res = "";
	foreach $bit (@BITS)
	{
	    if ($bit =~ m|[A-Za-z0-9]|o)
	    {
		$SORTNUM{$bit} = $lct;
	    }
	}
    }
    close(in_fp);
} 
