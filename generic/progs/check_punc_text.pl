#!/usr/local/bin/perl
use Getopt::Std;
use autodie qw(:all);
require "/usrdata3/dicts/NEWSTRUCTS/progs/utils.pl";
require "/NEWdata/dicts/generic/progs/restructure.pl";
#require "/NEWdata/dicts/generic/progs/xsl_lib_fk.pl";
$LOG = 0;
$LOAD = 0;
$UTF8 = 0;
$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
#undef $/; # read in the whole file at once
&main;

sub main
{
    getopts('uf:L:IO');
    &usage if ($opt_u);
    my($e, $res, $bit);
    my(@BITS);
#   $opt_L = ""; # name of file for the log_fp output to go to
    &open_debug_files;
    printf("<html><head><title>Checks on data for typesetting</title><style>\n.red {font-size: 200%; color: red}\n</style>\n</head><body><h1>Checks on data for typesetting</h1>"); 
    if ($LOAD){&load_file($opt_f, \%W);}
  line:    
    while (<>){
	chomp;       # strip record separator
	s|||g;
	if ($opt_I){
	    printf(bugin_fp "%s\n", $_);
	}
	s|<!--.*?-->||gio;
#	next line if (m|<entry[^>]*del=\"y|io);
#	next line if (m|<entry[^>]*sup=\"y|io);
	# $h = &get_hdwd($_);	# fk1
	# $h = &get_hex_h($_, "hex", 1); # the 1 says to remove stress etc
	# $eid = &get_tag_attval($_, "entry", "eid");
	# $dps_eid = &get_dps_entry_id($_);
	# $_ = &reduce_idmids($_);
	# s|£|&\#x00A3;|g;
        # $_ = restructure::delabel($_);	
	$_ = restructure::tag_delete($_, "runhd"); 
	s|&\#x2009;| |g;
	s|<z_[^>]*sym>.</z_[^>]*sym>|:|g;
	&check_spaces($_);
	&check_brackets($_);
	&check_duplicate_words($_);
	$e = $_;
#	print $_;
	if ($opt_O){
	    printf(bugout_fp "%s\n", $_); 
	}
    }
    &print_menu;
    if ($DUPE_WDS_CT)
    {
	printf("<h2><a name=\"dupe_wds\"/>Repeated words</h2>\n"); 
	printf("<ul>\n"); 
	foreach $e (@DUPE_WDS)
	{
	    printf("<li>%s</li>\n", $e); 
	}
	printf("</ul>\n"); 
    }
    if ($EXTRA_SPACES_CT)
    {
	printf("<h2><a name=\"extra_spaces\"/>Extra spaces</h2>\n"); 
	printf("<ul>\n"); 
	foreach $e (@EXTRA_SPACES)
	{
	    printf("<li>%s</li>\n", $e); 
	}
	printf("</ul>\n"); 
    }
    if ($UNBALANCED_CT)
    {
	printf("<h2><a name=\"unbalanced\"/>Unbalanced parentheses</h2>\n"); 
	printf("<ul>\n"); 
	foreach $e (@UNBALANCED)
	{
	    printf("<li>%s</li>\n", $e); 
	}
	printf("</ul>\n"); 
    }
    if ($SP_PRE_BRA_CT)
    {
	printf("<h2><a name=\"sp_pre_bra\"/>Spaces before closing brackets</h2>\n"); 
	printf("<ul>\n"); 
	foreach $e (@SP_PRE_BRA)
	{
	    printf("<li>%s</li>\n", $e); 
	}
	printf("</ul>\n"); 
    }
    if ($NO_SPACE_PRE_BRA_CT)
    {
	printf("<h2><a name=\"no_space_pre_bra\"/>No spaces before opening bracket</h2>\n"); 
	printf("<ul>\n"); 
	foreach $e (@NO_SPACE_PRE_BRA)
	{
	    printf("<li>%s</li>\n", $e); 
	}
	printf("</ul>\n"); 
    }
    printf("</body></html>\n"); 
    &close_debug_files;
}

sub print_menu
{
    printf("<h3>Links</h3>\n<ul>\n"); 
    if ($DUPE_WDS_CT)
    {
	printf("<li><a href=\"#dupe_wds\">Repeated words [ct=%d]</a></li>\n", $DUPE_WDS_CT); 
    }
    if ($EXTRA_SPACES_CT)
    {
	printf("<li><a href=\"#extra_spaces\">Extra spaces [ct=%d]</a></li>\n", $EXTRA_SPACES_CT); 
    }
    if ($UNBALANCED_CT)
    {
	printf("<li><a href=\"#unbalanced\">Unbalanced parentheses [ct=%d]</a></li>\n", $UNBALANCED_CT); 
    }
    if ($SP_PRE_BRA_CT)
    {
	printf("<li><a href=\"#sp_pre_bra\">Spaces before closing brackets [ct=%d]</a></li>\n", $SP_PRE_BRA_CT); 
    }
    if ($NO_SPACE_PRE_BRA_CT)
    {
	printf("<li><a href=\"#no_space_pre_bra\">No spaces before opening bracket [ct=%d]</a></li>\n", $NO_SPACE_PRE_BRA_CT); 
    }
    printf("</ul>\n"); 
}

sub check_spaces
{
    my($e) = @_;
    my($res, $eid);	
    $e =~ s|<[^>]*>||gi;
    if ($e =~ s|  +|<span class=\"red\">&\#x00A3;</span>|)
    {
	$EXTRA_SPACES[$EXTRA_SPACES_CT++] = $e;
    }
    elsif ($e =~ s| +([,\.\!\?])|<span class=\"red\">&\#x00A3;</span>\1|)
    {
	$EXTRA_SPACES[$EXTRA_SPACES_CT++] = $e;
    }
}

sub check_duplicate_words
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $last_bit);
    my(@BITS);
    $e =~ s|<pron-gs.*?</pron-gs>|£|g;
    $e =~ s|(<ts.*?>)|:\1|g;
    $e =~ s|(<tx.*?>)|:\1|g;
    $e =~ s|<.*?>| |gi;
    $e =~ s|([\.:?!\"\' ])|£\1£|gi;
    $e =~ tr|A-Z|a-z|;
    my $err = 0;
    @BITS = split(/£+/, $e);
    foreach $bit (@BITS){
	if ($bit =~ m|[a-z]|)
	{
	    if ($bit eq $last_bit)
	    {		
		$bit = sprintf("<span class=\"red\">%s</span>", $bit); 
		$err = 1;
	    }
	}
	if ($bit =~ m|[a-z0-9\=\(\)\.,:\\;\~!\?\]\[]|i)
	{
	    $last_bit = $bit;
	}
	$res .= $bit;
    }    
    if ($err)
    {
	$res =~ s| +| |g;
	$DUPE_WDS[$DUPE_WDS_CT++] = $res;
    }
}

sub check_brackets
{
    my($e) = @_;
    my($res, $eid);	
    $e =~ s|<subentry-g [^>]*>| |gi;
    $e =~ s|<[^>]*>||gi;
    $oct = ($e =~ s|\(|\(|g);
    $cct = ($e =~ s|\)|\)|g);
    unless ($oct == $cct)
    {	
	$e =~ s|\(([^\(]*)\)|\{\1\}|gi;
	$e =~ s|\(|<span class="red">\(</span>|gi;
	$e =~ s|\)|<span class="red">\)</span>|gi;
	$UNBALANCED[$UNBALANCED_CT++] = $e;
#	printf("Unbalanced brackets [%s]\n", $e); 
    }
    if ($e =~ s| +\)|&\#x00A3;<span class="red">\)</span>|g)
    {
	$SP_PRE_BRA[$SP_PRE_BRA_CT++] = $e;;
#	printf("Space before bracket: %s\n", $e); 
    }
    if ($e =~ s|\( |<span class="red">\(</span>£|g)
    {
	$SP_POST_BRA[$SP_POST_BRA_CT++] = $e;
#	printf("Space after bracket: %s\n", $e); 
    }
    $e = &lose_brackets_in_prons($e);
#    $e = restructure::tag_delete($e, "pron-gs"); 
    $e =~ s|\([aensor]\)|\{\1\}|g;
    $e =~ s|\(es\)|\{es\}|g;
    $e =~ s|\(r,s\)|\{r,s\}|g;
    $e =~ s|\(in\)|\{in\}|g;
    $e =~ s|\(en\)|\{en\}|g;
    $e =~ s|\(se\)|\{se\}|g;
    if ($e =~ s|([a-z0-9\.\,])\(|\1<span class="red">&#x00A3;</span>\(|g)
    {
	$NO_SPACE_PRE_BRA[$NO_SPACE_PRE_BRA_CT++] = $e;
#	printf("Missing space before bracket: %s\n", $e); 
    }
}

sub lose_brackets_in_prons
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
	    $bit =~ s|\(||g;
	    $bit =~ s|\)||g;
	}
	$res .= $bit;
    }    
    return $res;
}

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
#    printf(STDERR "\t-x:\t\n"); 
    exit;
}


sub load_file
{
    my($f, $W) = @_;
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
	$W->{$_} = 1;
    }
    close(in_fp);
} 
