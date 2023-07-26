#!/usr/local/bin/perl
#
# generic punctuation subroutines (not book or CD specific) ...
#
# START TAGS are all referred to as "<tag "
# in this program - see subroutine gen_pre_tweak
#
# project specific changes can go in here if they are likely to apply universally
# but please comment these with a mantis issue number in case they need to be moved
# to punc_PROJECT.pl ...

use Getopt::Std;
#use Smart::Comments '###';
require "/data/dicts/generic/progs/ents_to_unicode2.pl";
#
if (0){
    $e = &add_space_before($e, "alt");
    $e = &add_space_between($e, "alt", "def-g");
    $e = &add_separator($e, "alt", "alt");
    $e = &add_para($e, "bf-g");
    $e = &add_para_between($e, "sd-g", "c-g");
    $e = &add_brackets_around($e, "dlf");
    $e = &add_brackets_and_sym($e, "dlf");

}

##################################################


sub load_config_options {
    my($f) = @_;
    my $res;
    my @BITS;
    my $bit, $var;
    open(in_fp, "$f") || die "Unable to open $f"; 
    while (<in_fp>){
	chomp;
	s|||g;
	if (m|<variable>(.*?)</variable>|i)
	{
	    $var = $1;
	    $IS_DEFINED{$var} = 1;
	}
	if (m|<value>(.*?)</value>|i)
	{
	    $value = $1;
	    $VALUE{$var} = $value;
	    if ($value =~ m|^[0-9]+ *$|)
	    {
		$expr = sprintf("\$%s = %s", $var, $value);
	    }
	    else
	    {
		$expr = sprintf("\$%s = \"%s\"", $var, $value);
	    }
	    eval $expr;
	}
    }
    close(in_fp);
} 

##################################################
#   loads attribute expansions from XML file ...
sub gen_load_exp {
#   open the attval file ...
    unless ($ATTVAL)
    {
	$ATTVAL = "../dictfiles/_/_attval.xml";
    }
    open(ATTVAL, "$ATTVAL") || die "unable to open expansions file:\n$ATTVAL\n";
wloop:
    while (<ATTVAL>)
    {
#   look for <tag attribute="value">text</tag> ...
	chomp;
	if (m|<file_import file=\"(.*?)\"|i)
	{
	    $import_f = $1;
	    &gen_load_import($import_f);
	    next wloop;
	}
	while (s|<([^ >]+) ([^=]+)=\"([^\"]+)\">(.*?)</\1>||)
	{
#   key to ATT hash = tag_attribute_value ...
	    $key = "$1_$2_$3";
	    $text = "$4";
	    $ATT{$key} = "$text";
	}
    }
    close(ATTVAL);
}

sub gen_load_import {
    my($f) = @_;
    open(in_fp, "$f") || die "Unable to open $f";
    while (<in_fp>)
    {
	chomp;
	s|||g;
#   look for <tag attribute="value">text</tag> ...
	while (s|<([^ >]+) ([^=]+)="([^"]+)">(.*?)</\1>||)
	{
#   key to ATT hash = tag_attribute_value ...
	    $key = "$1_$2_$3";
	    $text = "$4";
	    $ATT{$key} = "$text";
	}
    }
   close(in_fp);
}

sub add_space_before {
    my($e, $a) = @_;
    $e =~ s|(<[a-z0-9]+)>|$1 >|gi;
    $e =~ s| *(<$a)( [^>]*>) *| \U\1\E\2|g;
    return $e;
}

sub add_para {
    my($e, $a) = @_;
    $e =~ s|(<[a-z0-9]+)>|$1 >|gi;
    $e =~ s| *(<$a) ([^>]*>) *|\U\1\E zp=\"y\" $2|g;
    return $e;
}

sub add_para_between {
    my($e, $a, $b) = @_;
    $e =~ s|(<[a-z0-9\-]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *(<$b) ([^>]*>) *|\U\1\E \U\2\E zp=\"y\" \3|g;
    return $e;
}

sub add_space_between {
    my($e, $a, $b) = @_;
    $e =~ s|(<[a-z0-9\-]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *(<$b)( [^>]*>) *|\U\1\E \U\2\E\3|g;
    return $e;
}

sub add_separator {
    my($e, $a, $b) = @_;
    my($var_name, $separator);
    unless ($e =~ m|</$a> *<$b[ >]|i)
    {
	return $e;
    }
    $var_name = sprintf("%s_%s_separator", $a, $b);
    $var_name =~ tr|a-z|A-Z|;
    if ($IS_DEFINED{$var_name})
    {
	$separator = $VALUE{$var_name};
    }
    else
    {
	$separator = ", ";
    }
    $e =~ s|(<[a-z0-9\-]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *(<$b)( [^>]*>) *|\U\1\E<z type=\"$var_name\">$separator</z>\U\2\E\3|g;
    return $e;
}

sub add_brackets_around {
    my($e, $tag) = @_;
    my($bit, $res);
    my(@BITS);
    my($var_name, $separator);
    $var_name = sprintf("%s_brackets", $tag);
    $var_name =~ tr|a-z|A-Z|;
    $e =~ s|(<$tag[ >].*?</$tag>)|&split;&fk;$1&split;|g;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($IS_DEFINED{$var_name})
	    {
		$var = $VALUE{$var_name};
		$bra_sym_name = sprintf("%s_brackets_sym", $tag);
		$bra_sym_name =~ tr|a-z|A-Z|;
		$bra_sym = $VALUE{$bra_sym_name};
		if ($var =~ m|ROUND|i)
		{
		    $bit =~ s| *<$tag ([^>]*>) *| <\U$tag\E \1<z type=\"$var_name\">\(</z>|i;
		    $bit =~ s| *</$tag> *|<z type=\"$var_name\">\)</z></\U$tag\E>|i;
#		    $bit =~ m| *<($tag) ([^>]*)>(.*) *(</$tag>) *| <\U$1\E $2><z type=\"$var_name\">\(</z>$3<z type=\"$var_name\">\)</z>\4|g;
		}
	    }
	}
	$res .= $bit;
    }    
    return $res;
}

##################################################

sub gen_a {
    my($e) = @_;
    $e = &add_separator($e, "a", "a");
    if ($A_ROUND_BRACKETS)
    {
	$e = &add_brackets_around($e, "a");
    }
    else
    {
	$e = &add_space_before($e, "a");
    }
    $e = &add_space_between($e, "a", "def-g");
    $e = &add_space_between($e, "a", "vs-g");
    return($e);
}

##################################################

sub gen_ab {
    my($e) = @_;
    $e = &add_space_between($e, "ab", "label-g");
    $e = &add_separator($e, "ab", "ab");
    $e =~ s|</ab><tg |<z>\)</z></AB><z>,</z><tg |g; # mantis 2020 ...
    $e =~ s|<(ab) ([^>]*)>| <\U\1\E $2><z>\(</z><z_ab>&z_abbr;</z_ab> |g;
    $e =~ s|</(ab)>|<z>\)</z></\U\1\E> |g;
    return($e);
}

##################################################

sub gen_adv {
    my($e) = @_;
    $e = &add_brackets_around($e, "adv");
    $e =~ s|<adv (.*?)</adv>(<i-g (.*?)</i-g>)?|<z> (</z><z_adv>&z_adv;</z_adv> <ADV $1</ADV>$2<z>)</z>|g;
    return($e);
}

##################################################

sub gen_alt {
    my($e) = @_;
    $e = &add_separator($e, "alt", "alt");    
    if ($A_ROUND_BRACKETS){
	$e = &add_brackets_around($e, "alt");
    }
    else {
	$e = &add_space_before($e, "alt");
    }
    $e = &add_space_between($e, "label-g", "alt");
#    $e = &add_space_between($e, "label-g", "alt");
    $e = &add_space_between($e, "alt", "def-g");
    $e = &add_space_between($e, "alt", "vs-g");
    return($e);
}

##################################################

sub gen_atpr {
    my($e) = @_;
    $e = &add_separator($e, "atpr", "p");
    $e = &add_space_before($e, "atpr");
    return($e);
}

##################################################

sub gen_audio_g {
    my($e) = @_;
    $e = &add_space_before($e, "audio-g");
    return($e);
}

##################################################

sub gen_bf {
    my($e) = @_;
    $e = &add_separator($e, "bf", "bf");
    $e = &add_space_between($e, "cm", "bf");
    return($e);
}

##################################################

sub gen_bf_g {
    my($e) = @_;
    $e = &add_para($e, "bf-g");
    return($e);
}

##################################################

sub gen_c {
    my($e) = @_;
    $e = &add_separator($e, "c", "c");
    $e = &add_separator($e, "fce", "c");
    $e = &add_separator($e, "c", "v");
    return($e);
}

##################################################

sub gen_c_g {
    my($e) = @_;
    $e = &add_space_between($e, "c-g", "c-g");
    if ($CSYM_NEWLINE){
	$e =~ s|<c-g ([^>]*)>|<C-G zp="y" $1><z>&csym; </z>|g;
    }
    else {
	$e =~ s|<c-g ([^>]*)>| <C-G $1><z>&csym; </z>|g;
    }
    $e = &add_para_between($e, "sd-g", "c-g");
    return($e);
}

##################################################

sub gen_cc {
    my($e) = @_;
    $e = &add_space_before($e, "cc");
    return($e);
}

##################################################

sub gen_cf {
    my($e) = @_;
    $e = &add_separator($e, "cf", "cf");
    $e = &add_separator($e, "tadv", "cf");
    $e = &add_space_before($e, "cf");
    $e = &add_space_between($e, "cf", "def-g");
    $e = &add_space_between($e, "cf", "x");
#    $e = &add_space_between($e, "cf", "x-g");
    return($e);
}

##################################################

sub gen_cfe {
    my($e) = @_;
    $e = &add_separator($e, "cfe", "cfe");
    return($e);
}

##################################################

sub gen_cfe_g {
    my($e) = @_;
    $e = &add_space_between($e, "cfe-g", "cfe-g");
    if ($IDSEP) {
	$e =~ s|</cfe-g> <cfe-g |</cfe-g><z> &cfesep; </z><cfe-g |gi;
    }
    return($e);
}

##################################################

sub gen_cfes_g {
    my($e) = @_;
    $e =~ s|<cfes-g ([^>]*>)| <CFES-G \1><z>&cfesym; </z>|g;
    return($e);
}

##################################################

sub gen_cl {
    my($e) = @_;
    $e = &add_separator($e, "cl", "cl");
    return($e);
}

##################################################

sub gen_cm {
    my($e) = @_;
    $e =~ s|</g><cm>([^<]*)</cm><g |</G> <CM>$1</cm><g |g;
    $e =~ s|</g><cm ([^<]*)</cm><g |</G> <CM $1</cm><g |g;
    $e =~ s|</g><cm>([^<]*)</cm><r |</G> <CM>$1</cm><r |g;
    $e =~ s|</g><cm ([^<]*)</cm><r |</G> <CM $1</cm><r |g;
    $e =~ s|</g><cm>([^<]*)</cm><s |</G> <CM>$1</cm><s |g;
    $e =~ s|</g><cm ([^<]*)</cm><s |</G> <CM $1</cm><s |g;
    $e =~ s|</a><cm>([^<]*)</cm><a |</A> <CM>$1</CM> <A |g;
    $e =~ s|</r><cm>([^<]*)</cm><r |</R> <CM>$1</cm> <R |g;
    $e =~ s|</s><cm ([^<]*)</cm><r |</S> <CM $1</cm> <R |g;
    $e =~ s|</s><cm ([^<]*)</cm><s |</S> <CM $1</cm><s |g;
    $e =~ s|</s><cm>([^<]*)</cm><s |</S> <CM>$1</cm><s |g;
    $e =~ s|</if-g><cm ([^<]*)</cm><if-g |</IF-G> <CM $1</cm> <IF-G |g;
    $e =~ s|</if-g><cm>([^<]*)</cm><if-g |</IF-G> <CM>$1</cm> <IF-G |g;
    $e =~ s|</cm><g |</CM> <G |g;
    $e =~ s|</cm><r |</CM> <R |g;
    $e =~ s|</cm><s |</CM> <S |g;
    $e =~ s|</cm><i |</CM> <I |g;
    $e =~ s|</cm><if |</CM> <IF |g;
    $e =~ s|</ei-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</ei-g></if-g></ifs-g> <CM $1</CM><ifs-g |g; # mantis 2564 ...
    $e =~ s|</i-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</i-g></if-g></ifs-g> <CM $1</CM><ifs-g |g; # mantis 2564 ...
    $e =~ s|</cm><ifs-g |</CM> <IFS-G |g; # mantis 2610 ...
    $e =~ s|</dtxt><cm |</dtxt> <CM |g; # mantis 2355 ...
    $e =~ s|</gr><cm |</gr> <CM |g; # mantis 2355 ...
    $e =~ s|</i-g><cm |</i-g> <CM |g; # mantis 2355 ...
    $e =~ s|</if><cm |</IF> <CM |g;
    $e =~ s|</il><cm |</IL> <CM |g; # mantis 1969 ...
    $e =~ s|</r><cm |</R> <CM |g; # mantis 1862 ...
    $e =~ s|</s><cm>([^<]*)</cm><s |</S> <CM>$1</cm><S |g;
    $e =~ s|</s><cm ([^<]*)</cm><s |</S> <CM $1</cm><S |g;
    $e =~ s|</y><cm |</Y><z>; </z><CM |g; # mantis 1982 ...
    $e =~ s|</xh><cm |</XH> <CM |g;
    $e =~ s|</cm><xh |</CM> <XH |g;
    $e =~ s|</a><cm |</A> <CM |g; 
    $e =~ s|(</cm>) *(<cm )|$1 $2|g; 
    $e =~ s|</ifs-g><cm |</IFS-G> <CM |g; # mantis 2610 ...
    return($e);
}

##################################################

sub gen_d {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    if ($D_NEWLINE) {
#	don't newline <d> within these contexts ...
	$splits ="(bf|id|n|pv|)-g"; # this based on AMESS requirements ...
	s/<$splits/&split;$&/goi;
	s/<\/$splits>/$&&split;/goi;
	@BITS = split(/&split;/);
	foreach $bit (@BITS) {
	    if ($bit =~ /<$splits/i) {
		$bit =~ s|<d | <D |g;
	    }
	    else {
		$bit = &add_para($e, "d");
	    }
	    $res .= $bit;
	}
	$e = $res;
    }
    else {
	$e =~ s|<d | <D |g;
    }
    return($e);
}


sub gen_def {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    $e =~ s|(</def>) *(<x-gs)|\1<z>:</z> \2|gi;
    return($e);
}

##################################################

sub gen_dacadv {
    my($e) = @_;
    $e = &add_brackets_around($e, "dacadv");
    return($e);
}

##################################################

sub gen_dc {
    my($e) = @_;
    $e = &add_brackets_around($e, "dc");
    return($e);
}


##################################################

sub gen_dhs {
    my($e) = @_;
    $e =~ s|</dhs>|</DHS><z>&rsquo;</z> |g;
    $e =~ s| ?<dhs | <z>&lsquo;</z><DHS |g;
    return($e);
}

##################################################

sub gen_discrim {
    my($e) = @_;
    $e = &add_separator($e, "discrim", "discrim");
    return($e);
}

##################################################

sub gen_discrim_g {
    my($e) = @_;
    $e = &add_separator($e, "tgr", "discrim-g");
    $e = &add_brackets_around($e, "discrim-g");
    return($e);
}

##################################################

sub gen_dlf {
    my($e) = @_;
    $e = &add_separator($e, "tgr", "dlf");
    $e = &add_brackets_around($e, "dlf");
    return($e);
}

##################################################

sub gen_dnca {
    my($e) = @_;
    $e = &add_brackets_around($e, "dnca");
    return($e);
}

##################################################

sub gen_dncn {
    my($e) = @_;
    $e = &add_brackets_around($e, "dncn");
    return($e);
}

##################################################

sub gen_dnov {
    my($e) = @_;
    $e = &add_brackets_around($e, "dnov");
    return($e);
}

##################################################

sub gen_dnsv {
    my($e) = @_;
    $e = &add_brackets_around($e, "dnsv");
    return($e);
}

##################################################

sub gen_dr {
    my($e) = @_;
    $e = &add_separator($e, "dr", "dr");
    return($e);
}

##################################################

sub gen_dr_g {
    my($e) = @_;
    $e = &add_drg_syms($e);
    if ($DRG_NEWLINE) {
	$e = &add_para($e, "dr-g");
    }
    else {
	$e = &add_space_between($e, "dr-g", "dr-g");
    }
    $e =~ s|<dr-g ([^>]*)>| <DR-G $1><z>&drsym; </z>|g;
    $e = &add_para_between($e, "sd-g", "dr-g");
    $e =~ s|(</sd-g>) *(<dr-g )|$1$2 zp=\"y\" |gi;
    $e =~ s|(<z[^>]*> *&drsym; *</z[^>]*>)(<top-g[^>]*>)|$2$1|gi;
    return($e);
}


sub add_drg_syms {
    my($e) = @_;
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<dr-g[ >].*?</dr-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<dr-g([^>]*)academic=\"y\"|i) {
		$bit =~ s|(</dr>)|$1<z> &awlsym; </z>|i;
	    }
	    if ($bit =~ m|<dr-g([^>]*)core=\"y\"|i) {
		if ($KEYSYM_POSITION =~ m|BEFORE|i) {
		    $bit =~ s|(<dr[ >])|<z>&small_coresym; </z>$1|i;
		}
		else {
		    $bit =~ s|(</dr>)|$1<z> &small_coresym; </z>|i;
		}
	    }
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_dre {
    my($e) = @_;
    $e =~ s|(<z> &awlsym; </z>)(<dre (.*?)</dre>)|$2$1|g;
    $e =~ s|<dre |<z>, </z>$&|g;
    return($e);
}

##################################################

sub gen_drp {
    my($e) = @_;
    $e =~ s|<drp |/<DRP |g;
    return($e);
}

##################################################

sub gen_ds {
    my($e) = @_;
    $e = &add_space_between($e, "ts", "ds");
    $e = &add_space_between($e, "tcf", "ds");
    $e = &add_space_between($e, "tgr", "ds");
    $e = &add_space_between($e, "treg", "ds");
    $e = &add_brackets_around($e, "ds");
    return($e);
}

##################################################

sub gen_dst {
    my($e) = @_;
    $e = &add_brackets_around($e, "dst");
    $e = &add_space_between($e, "label-g", "dst");
    return($e);
}

##################################################

sub gen_dsyn {
    my($e) = @_;
    $e = &add_brackets_around($e, "dsyn");
    return($e);
}

##################################################

sub gen_dtxt {
    my($e) = @_;
#   we should have used a ts-g here ...!
    $e =~ s|</tab><dtxt |</tab><z>;</z><dtxt |g; # mantis 1984 ...
    $e =~ s|</tadv><dtxt |</tadv><z>;</z><dtxt |g; # mantis 1847 ...
    $e =~ s|</tatpr><dtxt |</tatpr><z>;</z><dtxt |g;
    $e =~ s|</tceq><dtxt |</tceq><z>;</z><dtxt |g; # mantis 1995 ...
    $e =~ s|</tcf><dtxt |</tcf><z>;</z><dtxt |g; # mantis 1798 ...
    $e =~ s|</tcu><dtxt |</tcu><z>;</z><dtxt |g; # mantis 1992 ...
    $e =~ s|</tdef><dtxt |</tdef><z>;</z><dtxt |g; # mantis 1989 ...
    $e =~ s|</tev><dtxt |</tev><z>;</z><dtxt |g; # mantis 1854 ...
    $e =~ s|</tgr><dtxt |</tgr><z>;</z><dtxt |g; # mantis 1849 ...
    $e =~ s|</tid><dtxt |</tid><z>;</z><dtxt |g; # mantis 1778 ...
    $e =~ s|</treg><dtxt |</treg><z>;</z><dtxt |g; # mantis 1812 ...
    $e =~ s|</ts><dtxt |</ts><z>;</z><dtxt |g; # mantis 1815 ...
    $e =~ s|</tu><dtxt |</tu><z>;</z><dtxt |g; # mantis 2002 ...
    $e =~ s|</xr><dtxt |</xr><z>;</z><dtxt |g; # mantis 1997 ...
    $e =~ s|(<dtxt ([^>]*)type="gr"([^>]*)>)(.*?)(</dtxt>)| <z_gr_br>[</z_gr_br>\U$1\E<z_gr>$4</z_gr>\U$5\E<z_gr_br>]</z_gr_br>|gi; # as per engpor2e ...
    $e =~ s|<z_gr_br>\]</z_gr_br><z>, </z> <z_gr_br>\[</z_gr_br>|<z>, </z>|g;
    $e =~ s|</z_gr_br><z>, </z><DS |</z_gr_br><ds |g; # mantis 3178 ...
    $e =~ s|<dtxt ([^>]*)>| <DTXT $1><z>\(</z>|g;
    $e =~ s|</dtxt><t2 |</dtxt> <T2 |g; # mantis 2257 ...
    $e =~ s|</dtxt>|<z>\)</z></DTXT>|g;
    return($e);
}

##################################################

sub gen_dvcadv {
    my($e) = @_;
    $e = &add_brackets_around($e, "dvcadv");
    return($e);
}

##################################################

sub gen_ei_g {
    my($e) = @_;
    $e =~ s|<ei-g ([^>]*)>| <EI-G $1><z_ei-g>/</z_ei-g>|g;
    $e =~ s|</ei-g>|<z_ei-g>/</z_ei-g></EI-G>|g;
    return($e);
}

##################################################

sub gen_entry {
    my($e) = @_;
    $e =~ s|<entry([^>]*)academic="y"(.+)</h([em])?>|$&<z> &awlsym; </z>|g;
    $e =~ s|</entry>|$&\n|g;
    return($e);
}

##################################################

sub gen_eph {
    my($e) = @_;
    $e =~ s|<eph ([^>]*)> *| <EPH $1><z>/</z>|g;
    $e =~ s|</eph>|<z>/</z></EPH> |g;
    $e = &gen_cut_ipa_hyphens($e);
    return($e);
}

##################################################

sub gen_etym {
    my($e) = @_;
    $e =~ s|<etym ([^>]*)>| <ETYM $1><z>&etymsym; </z>|g;
    return($e);
}

##################################################

sub gen_fc {
#   z_fc tag allows blue punctuation ... 
    my($e) = @_;
    $e =~ s|<fc |<z_fc>, </z_fc><FC |g;
    return($e);
}

##################################################

sub gen_fe {
    my($e) = @_;
    if ($FE_BLUE_COMMA) {
	$e =~ s|<fe |<z_fe>, </z_fe><FE |g;
    }

    $e =~ s|<fe |<z>, </z><FE |g;
    return($e);
}

##################################################

sub gen_ff {
    my($e) = @_;
    if ($FF_NO_TEXT_OR_BRACKETS) {
	$e =~ s|<ff | <FF |g;
	$e =~ s|</ff>|</FF>|g;
    }
    else {
	$e =~ s|<ff ([^>]*)>| <FF $1><z>\(<z_ff>&z_abbr_of;</z_ff> </z>|g;
	$e =~ s|</ff>|<z>\)</z></FF>|g;
    }
    return($e);

}

##################################################

sub gen_fh {
#   z_fh tag allows blue punctuation ... 
    my($e) = @_;
    $e =~ s|<fh |<z_fh>, </z_fh><FH |g;
    return($e);
}

##################################################

sub gen_g {
    my($e) = @_;
    $e =~ s|</cf><g |</CF><z>;</z><g |g; # mantis 1941 ...
    $e =~ s|</g><g |</G><z>, </z><G |g;
    $e =~ s|</g><r |</G><z>, </z><R |g;
    $e =~ s|</g><s |</G><z>, </z><S |g;
    $e =~ s|</r><g |</R><z>, </z><G |g;
    $e =~ s|<g brackets="n"(.*?)</g>| <G $1</G>|g; # mantis 2699
    $e =~ s|</g>|<z>\)</z></G>|g;
    $e =~ s|<g ([^>]*)>| <G $1><z>\(</z>|g;
    return($e);
}

##################################################

sub gen_gl {
    my($e) = @_;
    my($equals);
    my($bit, $res);
    my(@BITS);
    $e = $e;
    $e =~ s|(<gl[ >].*?</gl>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    if ($GL_ADD_EQUALS) {
	$equals = "= ";
    }
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    if ($GL_ADD_BRACKETS) {
		unless ($bit =~ m|\(|) {
		    $bit =~ s|<gl ([^>]*)>|<GL $1><z>\($equals</z>|g;
		    $bit =~ s|</gl>|<z>\)</z></GL>|g;
		}
	    }
	    elsif ($GL_ADD_EQUALS) {
		unless ($bit =~ m|=|) {
		    $bit =~ s|<gl ([^>]*)>|<GL $1><z>=</z>|gi;
		}
	    }
	}
	$res .= $bit;
    }
    $e = $res;
    $e =~ s| *(</e[^>]*>) *(<gl)|$1 $2|gi;
    $e =~ s| *(<gl)| $1|gi;
    return($e);
}

##################################################

sub gen_gr {
    my($e) = @_;
    $e = &add_space_between($e, "gr", "cf");
    $e =~ s|</gr><p |</gr><z>,</z><p |g;
    $e =~ s|</gr><gr |</GR><z>,&nbthinsp;</z><GR |g;
    $e =~ s|</gr>|<z_gr_br>\]</z_gr_br></GR>|g;
    $e =~ s|<gr ([^>]*)>| <GR $1><z_gr_br>\[</z_gr_br>|g;
    $e =~ s| *(</gr>) *(<label-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<def-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<sn-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<vs-g)|$1 $2|gi;
    return($e);
}

sub gen_gram {
    my($e) = @_;
    $e = &add_brackets_around($e, "gram-g");
    $e = &add_space_between($e, "gr", "cf");
    $e =~ s|</gr><p |</gr><z>,</z><p |g;
    $e =~ s|</gram><gram |</GRAM><z>,&nbthinsp;</z><GRAM |g;
    $e =~ s|</gr>|<z_gr_br>\]</z_gr_br></GR>|g;
    $e =~ s|<gr ([^>]*)>| <GR $1><z_gr_br>\[</z_gr_br>|g;
    $e =~ s| *(</gr>) *(<label-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<def-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<sn-g)|$1 $2|gi;
    $e =~ s| *(</gr>) *(<vs-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_h {
    my($e) = @_;
    my($core2k, $core3k);
    $e = &add_space_between($e, "h", "pron-gs");
    $e = &add_space_between($e, "h", "xr-g");
    $e = &add_space_between($e, "h", "label-g");
    $core2k = restructure::get_tag_attval($e, "h", "ox2000"); 
    $core3k = restructure::get_tag_attval($e, "h", "ox2000"); 
    if (($core2k eq "y") || ($core3k eq "y")){
	if ($KEYSYM_POSITION =~ m|BEFORE|i) {
	    $e =~ s|(<h[ >])|<z>&coresym; </z>$1|i;
	}
	else {
	    $e =~ s|(</h>)|$1 <z>&coresym;</z>|i;
	}
    }
    return($e);
}

##################################################

sub gen_h2 {
    my($e) = @_;
    $e =~ s|<h2 |<z>, </z>$&|g;
    $e =~ s|(</h2>) *(<xr-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_he {
    my($e) = @_;
    $e =~ s|<he ([^>]*)>| <HE $1><z>\(<z_he>&z_gb;</z_he> &z_also; </z>|g;
    $e =~ s|</he>|<z>\)</z></HE>|g;
    $e =~ s|(</he>) *(<xr-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_help {
    my($e) = @_;
    if ($HELP_NEWLINE) {
	$e =~ s|<help (.*?)>|<HELP $1><z>&helpsym;&nbsp;</z>|g;
    }
    else {
	$e =~ s|<help ([^>]*)>| <HELP $1><z>&helpsym;&nbsp;</z>|g;
    }
    return($e);
}

##################################################

sub gen_hh {
    my($e) = @_;
    $e =~ s|</hh>|</HH> |g;
    return($e);
}

##################################################

sub gen_hm {
    my($e) = @_;
    $e =~ s|(</hm>) *(<xr-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_hp {
    my($e) = @_;
    $e =~ s|<hp |/<HP |g;
    return($e);
}

##################################################

sub gen_hs {
    my($e) = @_;
    $e =~ s|</hs>|$& |g;
    return($e);
}

##################################################

sub gen_i {
    my($e) = @_;
    $e =~ s|(<i-g ([^>]*)>)<g ([^<]*)</g><i |$1<G $3</G> <I |g; # mantis 2547 ...
    $e =~ s|</i><g ([^<]*)</g><i |</I><z_ig>; </z_ig><G $1</G> <I |g;
    $e =~ s|</i> *<g ([^<]*)</g><y |</I><z_ig>; </z_ig><G $1</G> <Y |g; # mantis 2530 ...
    $e =~ s|</y><g ([^<]*)</g><i |</Y><z_ig>; </z_ig><G $1</G> <I |g; # mantis 2585 ...
    $e =~ s|</i><cm |</I><z_ig>; </z_ig><CM |g; # mantis 1790 ...
    $e =~ s|</i><i |</I><z_ig>; </z_ig><I |g;
    $e =~ s|</i><il |</I><z_ig>; </z_ig><IL |g; # mantis 2515 ...
    $e =~ s|</il><i |</IL> <I |g;
    $e =~ s|</i><y |</I><z_ig>; </z_ig><z_y>&z_us; </z_y><Y |g;
    if ($US_IPA_FIRST) {
	$e =~ s|</y><i |</Y><z_ig>; </z_ig><z_i>&z_gb; </z_i><I |g;
    }
    else {
	$e =~ s|</y><i |</Y><z_ig>, </z_ig><I |g;
    }
    $e = &gen_cut_ipa_hyphens($e);
    return($e);
}

##################################################

sub gen_i_g {
    my($e) = @_;
    $e =~ s|<i-g ([^>]*)>| <I-G $1><z_i-g>/</z_i-g>|g;
    $e =~ s|</i-g><if |<z_i-g>/</z_i-g></I-G><z>, </z><IF |g;
    $e =~ s|</i-g><il |<z_i-g>/</z_i-g></I-G><z>, </z><IL |g;
    $e =~ s|</i-g><v |<z_i-g>/</z_i-g></I-G><z>, </z><V |g;
    $e =~ s|</i-g>|<z_i-g>/</z_i-g></I-G>|g;
    return($e);
}

##################################################

sub gen_id {
    my($e) = @_;
    if ($IDSEP_CHAR =~ m|^ *$|) {
	$IDSEP_CHAR = ";";
    }
    $e =~ s|</id><id |</ID><z>$IDSEP_CHAR </z><ID |g;
    $e =~ s|</id>(<g ([^>]*)></g>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    $e =~ s|</id>(<r ([^>]*)></r>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    $e =~ s|</id>(<s ([^>]*)></s>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    $e =~ s|(</id>)(<label-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_id_g {
    my($e) = @_;
    if ($IDG_NEWLINE) {
	$e =~ s|</id-g><id-g |</ID-G><ID-G zp=\"y\" |g;
    }
    else {
	$e =~ s|</id-g><id-g |</ID-G> &idsep; <ID-G |g;
    }
    if (($IDSYM_ICON) || ($IDG_SYMBOL_ALL)) {
	if ($IDSYM_NEWLINE) {
	    $e =~ s|<id-g ([^>]*multi=\"y[^>]*)>|<ID-G zp=\"y\" $1><z>&idsyms; </z>|g;
	    $e =~ s|<id-g ([^>]*)>|<ID-G zp=\"y\" $1><z>&idsym; </z>|g;
	}
	else {
	    $e =~ s|<id-g ([^>]*multi=\"y[^>]*)>| <ID-G $1><z>&idsyms; </z>|g;
	    $e =~ s|<id-g ([^>]*)>| <ID-G $1><z>&idsym; </z>|g;
	}
    }
    $e =~ s|(</sd-g>) *(<ids?-g) |$1$2 zp=\"y\" |g;
    if ($IDG_SEP){
	$e =~ s|</id-g> <id-g |</id-g><z> &idsep; </z><id-g |gi;
    }    
    return($e);
}

##################################################

sub gen_ids_g {
    my($e) = @_;
    if (($IDSYMS_ICON) || ($IDG_SYMBOL_FIRST)) {
	$e = &add_idsym_symbols($e);
    }    return($e);
}

sub add_idsym_symbols {
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<ids-g[ >].*?</ids-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<id[ >].*<id[ >]|i) {
		$bit =~ s|<ids-g ([^>]*)>| <IDS-G $1>&idsyms; |i;
	    }
	    else {
		$bit =~ s|<ids-g ([^>]*)>| <IDS-G $1>&idsym; |i;
	    }

	}
	$res .= $bit;
    }
    return $res;
}


##################################################

sub idxh {
    my($e) = @_;
    $e =~ s|<idxh .*?</idxh>( ?)||g;
    return($e);
}

##################################################

sub gen_if {
    my($e) = @_;
    $e =~ s|</g><if |</G> <IF |g;
    $e =~ s|</r><if |</R> <IF |g; # mantis 2560 ...
    $e =~ s|</s><if |</S> <IF |g; # mantis 2636 ...
    $e =~ s|</if><g |</IF><z>, </z><G |g; # mantis 1788 ...
    $e =~ s|</if><if |</IF><z>, </z><IF |g;
    $e =~ s|</il><if |</IL> <IF |g;
    $e =~ s|</if><il |</IF><z>, </z><IL |g;
    $e =~ s| *<if | <IF |g;
    return($e);
}

##################################################

sub gen_if_g {
    my($e) = @_;
    $e =~ s|(</if-g><if-g ([^>]*)>)<g |$1<G |g; # mantis 2561 ...
    $e =~ s|</if-g><if-g|</IF-G><z>, </z><IF-G|go;
    $e =~ s|</if-g><cm>or</cm><if-g|</IF-G> <CM>or</CM> <IF-G|g;
    $e =~ s|</if-g> *<or[^>]*> *<if-g|</IF-G> <CM>or</CM> <IF-G|g;
    return($e);
}

##################################################

sub gen_if_gs {
    my($e) = @_;
    $e =~ s|(<if-gs [^>]*>)| \1<z>\(</z>|gi;
    $e =~ s|(</if-gs>)|<z>\)</z>\1 |gi;
    return($e);
}

##################################################

sub gen_ifs_g {
    my($e) = @_;
#   no brackets if IFS-G within VS-G ...
    my(@BITS);
    my($bit);
    my($res);
    $e =~ s|(<vs-g[ >].*?</vs-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit =~ s|</ifs-g>|</IFS-G>|go;
	    $bit =~ s|<ifs-g | <IFS-G |go;
	}
	$res .= $bit;
    }
    $e = $res;
    $e =~ s|(<ifs-g[^>]*>) *<il |$1<IL |gi;

# I think the previous logic was wrong - FK
    $e =~ s|</ifs-g>|<z>\)</z></IFS-G>|g;
    $e =~ s|<ifs-g ([^>]*)>| <IFS-G $1><z>\(</z>|g;
    return($e);
}

##################################################

sub gen_il {
    my($e) = @_;
    $e =~ s|(/<\/[^>]*>)(<il )|$1<IL |gi;
    $e =~ s|</il><il |</IL><z>, </z><IL |g; # mantis 2352 ...
    $e =~ s|(<ifs-g ([^>]*)>)<il |$1<IL |gi;
    $e =~ s|</il> *|</IL> |gi;
    $e =~ s| *<il | <IL |g;
    return($e);
}

##################################################

sub gen_l_g {
    my($e) = @_;
    $e =~ s|<l-g([^>]*) l="([a-z])"(.*?)>|<z_spc_pre> </z_spc_pre>$&<z_l>\($2\)</z_l><z_spc_post> </z_spc_post>|g;
    return($e);
}


##################################################

sub gen_label_g {
    my($e) = @_;
    $e =~ s|(</label-g>) *(<v)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_n_g {
    my($e) = @_;
    if ($NG_NEWLINE) {
	$e =~ s|<n-g([^>]*) n="([0-9]+)"(.*?)>|$&<z_n>$2</z_n><z_spc_post> </z_spc_post>|g;
    }
    else {
	$e =~ s|<n-g([^>]*) n="([0-9]+)"(.*?)>|<z_spc_pre> </z_spc_pre>$&<z_n>$2</z_n><z_spc_post> </z_spc_post>|g;
    }    
    return($e);
}
##################################################

sub gen_opp {
    my($e) = @_;
    $e =~ s|</g><opp |</g> <OPP |g;
    $e =~ s|</r><opp |</r> <OPP |g;
    $e =~ s|</opp><opp |</OPP><z>, </z><OPP |g;
    $e =~ s|</opp><g |</OPP><z>,</z><g |g;
    $e =~ s|</opp><r |</OPP><z>,</z><r |g;
    return($e);
}

##################################################

sub gen_opp_g {
    my($e) = @_;
    $e =~ s|<opp-g ([^>]*)><([grs]) ([^>]*)></\2>|<opp-g $1> <\U$2\E $3></\U$2\E> |g;
    $e =~ s|<opp-g (.*?)>|<OPP-G $1><z>&oppsym; </z><z_opptext>OPP</z_opptext> |g;
    return($e);
}

##################################################

sub gen_pos {
    my($e) = @_;
    $e =~ s|</pos><pos |</POS><z>, </z><POS |g;
    $e =~ s|<pos | <POS |g;
    return($e);
}

##################################################

sub gen_pos_g {
    my($e) = @_;
    $e =~ s| *(</pos-g>) *(<label-g[^>]*>) *|$1 $2|gi;
    return($e);
}

sub gen_p {
    my($e) = @_;
    $e =~ s|</p><p |</P><z>, </z><P |g;
    $e =~ s|<p | <P |g;

#   spell out parts of speech in h-g in multi-pos entries ...

    if (/<p-g/i) {
	if ($POS_FULL) {
	    $e = &gen_pos_full($e);
	}
    }
    $e =~ s|(<p ([^>]*)p="(.*?))_FULL"|$1"|gi;
#   tag <z_p> within <p-g> ...
my(@BITS);
my($bit);
my($res);
$e =~ s|<p-g .*?</p-g>|&split;$&&split;|gio;
@BITS = split(/&split;/);
foreach $bit (@BITS) {
    if ($bit =~ m|<p-g|io) {
    $bit =~ s|<z_p>|<z_p_in_p-g>|gio;
    $bit =~ s|</z_p>|</z_p_in_p-g>|gio;
}
$res .= $bit;
}

#   but not in dr-g within p-g ...

$e = $res;
my(@BITS);
my($bit);
my($res);
$e =~ s|<dr-g .*?</dr-g>|&split;$&&split;|gio;
@BITS = split(/&split;/);
foreach $bit (@BITS) {
    if ($bit =~ m|<dr-g|io) {
    $bit =~ s|<z_p_in_p-g>|<z_p>|gio;
    $bit =~ s|</z_p_in_p-g>|</z_p>|gio;
}
$res .= $bit;
}
$e = $res;

return($e);
}

##################################################

sub gen_p_g {
    my($e) = @_;
    if ($IS_DEFINED{"PG_SYMBOL"}) {
	if ($PG_SYMBOL) {
	    $e =~ s|<p-g (.*?)>|<P-G $1><z>&psym; </z>|g;
	}
    }
    else {
	$e =~ s|<p-g (.*?)>|<P-G $1><z>&psym; </z>|g;
    }
    return unless ($HG_PSYM);
    my(@BITS);
    my($bit);
    my($res);
    $e =~ s|<h-g .*?</h-g>|&split;$&&split;|i;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ m|<h-g|) {
	    $bit =~ s|<h-g(.*?)<p |<h-g$1<z> &psym;</z><p |;
	}
	$res .= $bit;
    }
    $e = $res;
    return($e);
}


##################################################

sub gen_ph {
    my($e) = @_;
    $e =~ s|(<ph-g([^>]*)>)<ph |$1<PH |gi;
    $e =~ s|</ph><ph |</PH><z>; </z><PH |g;
    $e =~ s|<ph | <PH |g;
    return($e);
}

##################################################

sub gen_ph_g {
    my($e) = @_;
    $e =~ s|</ph-g><ph-g |</PH-G><z>; </z><PH-G |g;
    $e =~ s|<ph-g |<z>: </z><PH-G |g;
    return($e);
}

##################################################

sub gen_prongs {
    my($e) = @_;
    my($e) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<pron-gs[ >].*?</pron-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $bit =~ s|(<pron-gs[^>]*>)| \1<z>/</z>|gi;
	    $bit =~ s|(</pron-gs>)|<z>/</z>\1 |gi;
	    $bit =~ s|<phon [^>]*> *</phon>||gi;
	    $bit =~ s|(</pron-g>) *(<pron-g)[ >]|\1<z>;</z> \2|gi;
	}
	$res .= $bit;
    }
    return $res;
}


sub gen_phon_gb {
    my($e) = @_;
    $e =~ s|</phon-gb><g ([^<]*)</g><phon-gb |</PHON-GB><z>; </z><G $1</G> <PHON-GB |g;
    $e =~ s|</phon-gb><phon-gb |</PHON-GB><z>; </z><PHON-GB |g;
    $e =~ s|</phon-gb><il |</PHON-GB><z>; </z><IL |g; # mantis 2515 ...
    $e =~ s|</phon-gb><phon-us |</PHON-GB><z>; <z_phon-us>&z_us;</z_phon-us> </z><PHON-US |g;
    if ($US_IPA_FIRST) {
	$e =~ s|</phon-us><phon-gb |</PHON-US><z>; <z_phon-gb>&z_gb;</z_phon-gb> </z><PHON-GB |g;
    }
    else {
	$e =~ s|</phon-us><phon-gb |</PHON-US><z>, </z><PHON-GB |g;
    }
    return($e);
}

##################################################

sub gen_phon_us {
    my($e) = @_;
    $e =~ s|</phon-us><cm |</PHON-US><z>; </z><CM |g; # mantis 1982 ...
    $e =~ s|</phon-us><phon-us |</PHON-US><z>; </z><PHON-US |g;
    unless ($US_IPA_FIRST) {
	$e =~ s|<phon-us |<z> <z_phon-us>&z_us;</z_phon-us> </z><PHON-US |g;
    }
    return($e);
}

##################################################

sub gen_pre {
}

##################################################

sub gen_pt {
    my($e) = @_;
    $e =~ s|</pt><pt |</PT><z>,&nbthinsp;</z><PT |g;
    $e =~ s|</pt>|<z_pt_br>\]</z_pt_br></PT>|g;
    $e =~ s|<pt ([^>]*)>| <PT $1><z_pt_br>\[</z_pt_br>|g;
    return($e);
}

##################################################

sub gen_pv {
    my($e) = @_;
    $e =~ s|</tcf><pv |</TCF> <PV |g; # mantis 1973 ...
    $e =~ s|</pv><pv |</PV><z>; </z><PV |g;
    $e =~ s| *(</pv>) *(<def-g)|$1 $2|gi;
    return($e);
}

##################################################

sub gen_pv_g {
    my($e) = @_;
    if ($PVG_NEWLINE) {
	$e =~ s|</pv-g><pv-g |</PV-G><PV-G zp=\"y\" |g;
    }
    else {
	if ($PVG_SEP) {
	    $e =~ s|</pv-g><pv-g |</PV-G> &pvsep; <PV-G |g;
	}
    }
    $e =~ s|</pvp-g><pvp-g ([^>]*)>|</PVP-G><PVP-G  zp=\"y\" $1>|g; # should now be covered by the target_3b2.pl config file
    $e =~ s|</pv-g><np */><pv-g |</PV-G><PV-G  zp=\"y\" |g;
    if ($PVSYMS_ICON) {
	unless (m|<pvs-g|i) {
	    $e = &add_pvsym($e);
	}
    }
    $e =~ s|(</sd-g>) *(<pvs?-g) |$1 $2 zp=\"y\" |g;
    if ($PVG_SEP) {
	$e =~ s|</pv-g> *<pv-g |</pv-g><z> &pvsep; </z><pv-g |g;
    }
    return($e);
}


##################################################

sub gen_pvs_g {
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e = $e;
    $e =~ s|(<pvs-g[ >].*?</pvs-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS) {
	if ($bit =~ s|&fk;||gio) {
	    $ct = (s|(<pv-g)|$1|gi);
	    if (($PVSYMS_ICON) || ($PVG_SYMBOL_FIRST)) {
		if ($ct > 1) {
		    $bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsyms;</z>|;
		}
		else {
		    $bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsym;</z>|;
		}
	    }
	}
	$res .= $bit;
    }
    $e = $res;
    return($e);
}

sub add_pvsym {
    my($e) = @_;
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<pvs-g[ >].*?</pvs-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<pv[ >].*<pv[ >]|i) {
		$bit =~ s|(<pvs-g[^>]*>)| $1&pvsyms; |;
	    }
	    else {
		$bit =~ s|(<pvs-g[^>]*>)| $1&pvsym; |;
	    }	    
	    if ($PVSYM_NEWLINE) {
		$bit =~ s|(<pvs-g) |$1 zp=\"y\" |i;
	    }
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_pvp_g {
}

##################################################

sub gen_pvpt {
    my($e) = @_;
    $e =~ s|</pvpt><pvpt |</PVPT><z>,&nbthinsp;</z><PVPT |g;
    $e =~ s|</pvpt>|</PVPT><z>\]</z>|g;
    $e =~ s|<pvpt |<z> \[</z><PVPT |g;
    return($e);
}

##################################################

sub gen_r {
    my($e) = @_;
    $e =~ s|</r><g |</R><z>, </z><G |g;
    $e =~ s|</r><r |</R><z>, </z><R |g;
    $e =~ s|</r><s |</R><z>, </z><S |g;
    $e =~ s| *<r ([^>]*brackets="n".*?)</r>| <R $1</R>|g; 
    $e =~ s|</r>|<z>\)</z></R>|g;
    $e =~ s|<r ([^>]*)>| <R $1><z>\(</z>|g;
    return($e);
}

##################################################

sub gen_refl {
}

##################################################

sub gen_refl_g {
    my($e) = @_;
    $e =~ s|<refl-g ([^>]*)>|<REFL-G zp=\"y\" $1><z>&reflsym; </z>|g;
    return($e);
}

##################################################

sub gen_reflp {
    my($e) = @_;
    $e =~ s|<reflp |/<REFLP |g;
    return($e);
}

##################################################

sub gen_rv {
    my($e) = @_;
    $e =~ s|<rv | <RV |g;
    return($e);
}

##################################################

sub gen_s {
    my($e) = @_;
    $e =~ s|</s><g |</S><z>, </z><G |g;
    $e =~ s|</s><r |</S><z>, </z><R |g;
    $e =~ s|</s><s |</S><z>, </z><S |g;
    $e =~ s|</s>|<z>\)</z></S>|g;
    $e =~ s|<s ([^>]*)>| <S $1><z>\(</z>|g;
    return($e);
}

##################################################

sub gen_sd_g {
    my($e) = @_;
    if ($IS_DEFINED{"SD_SYMBOL"}) {
	if ($SD_SYMBOL) {
	    $e =~ s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym;&nbsp;</z>|g;
	}
    }
    else {
	$e =~ s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym;&nbsp;</z>|g;
    }
    return($e);
}

##################################################

sub gen_stem2 {
#   z_stem2 tag allows blue punctuation ... 
    my($e) = @_;
    $e =~ s|<stem2 |<z_stem2>, </z_stem2><STEM2 |g;
    return($e);
}

##################################################

sub gen_sym {
    my($e) = @_;
    $e =~ s|</sym>|<z>\)</z></SYM>|g;
    $e =~ s|<sym ([^>]*)>| <SYM $1><z>\(</z><z_sym>&z_symb;</z_sym> |g;
    return($e);
}

##################################################

sub gen_syn {
    my($e) = @_;
    $e =~ s|</syn><g |</SYN><z> &synsep2; </z><G |g;
    $e =~ s|</syn><r |</SYN><z> &synsep2; </z><R |g;
    $e =~ s|</syn><s |</SYN><z> &synsep2; </z><S |g;
    $e =~ s|</syn><u |</SYN><z> &synsep2;</z><u |g;
    $e =~ s|</g><syn |</G> <SYN |g;
    $e =~ s|</r><syn |</R> <SYN |g;
    $e =~ s|</s><syn |</S> <SYN |g;
    $e =~ s|</syn><syn |</SYN><z> &synsep; </z><SYN |g;
    $e =~ s|</label-g><syn |</LABEL-G> <SYN |g;
    return($e);
}

##################################################

sub gen_syn_g {
    my($e) = @_;
    $e =~ s|<syn-g ([^>]*)><([grs]) |<syn-g $1><\U$2\E |g;
    return($e);
}

##################################################

sub gen_t2 {
    my($e) = @_;
    $e =~ s|</tceq><t2 |</TCEQ><z>, </z><T2 |g; # mantis 2273 ...
    $e =~ s|</tcfe><t2 |</TCFE><z>, </z><T2 |g;
    $e =~ s|</tcf><t2 |</TCF><z>, </z><T2 |g; # mantis 2359 ...
    $e =~ s|</tab><t2 |</tab><z>, </z><T2 |g; # mantis 2274 ...
    $e =~ s|</tgr><t2 |</tgr><z>, </z><T2 |g;
    $e =~ s|</tid><t2 |</tid><z>, </z><T2 |g;
    $e =~ s|</treg><t2 |</treg><z>, </z><T2 |g; # mantis 2272 ...
    $e =~ s|</t2><t2 |</T2><z>, </z><T2 |g;
    $e =~ s|</ts><t2 |</TS><z>, </z><T2 |g;
    return($e);
}

##################################################

sub gen_t2_g {
    my($e) = @_;
    $e =~ s|<t2-g |<z>, </z><T2-G |g;
    return($e);
}

##################################################

sub gen_tab {
    my($e) = @_;
    $e =~ s|</tab><tg |</TAB><z>\),</z><tg |g; # mantis 2020 ...
    $e =~ s|<(tab) ([^>]*)>| <\U\1\E $2><z>\(</z><z_tab>&z_abbr;</z_tab> |g;
    $e =~ s|</(tab)>|<z>\)</z></\U\1\E>|g;
#    s|<tab ([^>]*)>| <TAB $1><z>\(</z><z_tab>&z_abbr;</z_tab> |g;
#    s|<z>)</z></tab>|</TAB> |g;
    return($e);
}


##################################################

sub gen_tadv {
    my($e) = @_;
    $e =~ s|</tadv><dlf |</tadv><z>;</z><dlf |g; # mantis 2008 ...
    $e =~ s|</tadv><tg |</tadv><z>,</z><tg |g; # mantis 1993 ...
    $e =~ s|</tadv><ts |</tadv><z>,</z><ts |g; # mantis 2015 ...
    $e =~ s|<tadv (.*?)</tadv>(<i-g (.*?)</i-g>)|<z> (</z><z_tadv>&z_adv;</z_tadv> <TADV $1</TADV>$2<z>)</z>|g;
    $e =~ s|<tadv (.*?)</tadv>|<z> (</z><z_tadv>&z_adv;</z_tadv> <TADV $1</TADV><z>)</z>|g; # mantis 1847 ...
    return($e);
}

##################################################

sub gen_tatpr {
    my($e) = @_;
    $e =~ s|<tatpr ([^>]*)>| <TATPR $1><z>\(</z>|g;
    $e =~ s|</tatpr>|<z>\)</z></TATPR>|g;
    return($e);
}

##################################################

sub gen_tceq {
    my($e) = @_;
    $e =~ s|</tceq><tg |</TCEQ><z>,</z><tg |g; # mantis 1817 ...
    $e =~ s|</tceq><tceq |</TCEQ><z>, </z><TCEQ |g; # mantis 1793 ...
    $e =~ s|<tceq |<z> &tceqsym; </z>$&|g;
    return($e);
}

##################################################

sub gen_tcf {
    my($e) = @_;
    $e =~ s|</treg><tcf |</treg><z>,</z><tcf |g;
    $e =~ s|</tgr><tcf |</tgr><z>,</z><tcf |g; # mantis 2017 ...
    $e =~ s|</tcf><tcf |</TCF><z>, </z><TCF |g;
    $e =~ s|</tcf><tg |</tcf><z>,</z><tg |g; # mantis 1983 ...
    $e =~ s|</tcf><ts |</TCF><z>, </z><TS |g; # mantis 1837 ...
##    s|</ts><tcf |</TS><z>, </z><TCF |g; # mantis 1990 ...
    $e =~ s|</ts><tcf |</TS><z> </z><TCF |g; # mantis 1990 ...
    $e =~ s|(<tcf ([^>]*)>)<ts |$1<TS |g;
    $e =~ s|<tcf | <TCF |g;
    return($e);
}

##################################################

sub gen_tcfe {
    my($e) = @_;
    $e =~ s|</tcfe><tcfe |</TCFE><z>, </z><TCFE |g; # mantis 3271 ...
    $e =~ s|<tcfe | <TCFE |g;
    return($e);
}

##################################################

sub gen_tcu {
    my($e) = @_;
    $e =~ s|</tcu><tev |</TCU><z>, </z><TEV |g;
    $e =~ s|</tcu>|<z>\)</z></TCU>|g;
    $e =~ s|<tcu ([^>]*)>| <TCU $1><z>\(</z>|g;
    return($e);
}

##################################################

sub gen_td {
#   use for HTML-style table data ONLY ...

    my($e) = @_;
}

##################################################

sub gen_tdef {
    my($e) = @_;
    $e =~ s|<tdef | <TDEF |g;
    return($e);
}

##################################################

sub gen_tel {
    my($e) = @_;
    $e =~ s|<(tel) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(tel)>|<z>\)</z></\U\1\E>|g;
#    s|<tel |<z> \(</z>$&|g;
#    s|</tel>|$&<z>\)</z>|g;
    return($e);
}

##################################################

sub gen_tev {
    my($e) = @_;
    $e =~ s|</treg><tev |</TREG><z>, </z><TEV |g;
    $e =~ s|</tev><tev |</TEV><z>, </z><TEV |g; # mantis 2016 ...
    $e =~ s|</tev><tg |</tev><z>,</z><tg |g; # mantis 2022 ...
    $e =~ s|<(tev) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(tev)>|<z>\)</z></\U\1\E>|g;
#    s|</tev>|</TEV><z>\)</z>|g;
#    s|<tev |<z> \(</z><TEV |g;
    return($e);
}

##################################################

sub gen_tg {
    my($e) = @_;
    $e =~ s|</tg><tg |</TG><z>, </z><TG |g;
    $e =~ s|</tg><treg |</TG><z>, </z><TREG |g;
    $e =~ s|</treg><tg |</TREG><z>, </z><TG |g; # mantis 1853 ...
    $e =~ s|<(tg) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(tg)>|<z>\)</z></\U\1\E>|g;
#    s|</tg>|</TG><z>\)</z>|g;
#    s|<tg |<z> \(</z><TG |g;
    return($e);
}
##################################################

sub gen_tgl {
    my($e) = @_;
    $e =~ s|<(tgl) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(tgl)>|<z>\)</z></\U\1\E>|g;
#    s|<tgl |<z> \(</z>$&|g;
#    s|</tgl>|$&<z>\)</z>|g;
    return($e);
}

##################################################

sub gen_tgr {
    my($e) = @_;
    $e =~ s|</tgr><tgr |</TGR><z>,&nbthinsp;</z><TGR |g;
    $e =~ s|</tgr>|</TGR><z_tgr_br>\]</z_tgr_br>|g;
    $e =~ s|<tgr | <z_tgr_br>\[</z_tgr_br><TGR |g;
    return($e);
}

##################################################

sub gen_th
#   for HTML-style table header ONLY ...
{
}

##################################################

sub gen_thm {
}

##################################################

sub gen_tid
{
    my($e) = @_;
    $e =~ s|</tid><tg |</TID><z>;</z><tg |g; # mantis 1851 ...
    $e =~ s|</tev><tid |</tev><z>, </z><TID |g; # mantis 2023 ...
    $e =~ s|</tid><tid |</TID><z>; </z><TID |g;
    $e =~ s|</tid><t2 |</tid><z>, </z><T2 |g;
    $e =~ s|<tid | <TID |g;
    return($e);
}

##################################################

sub gen_tif {
    my($e) = @_;
    $e =~ s|</tif><t2 |</TIF><z>, </z><T2 |g;
    $e =~ s|</tif><tif |</TIF><z>, </z><TIF |g;
    $e =~ s|</til><tif |</TIL> <TIF |g;
    $e =~ s|<tif(.*?)>(.*?)</tif>| <TIF$1><z>\[</z>$2<z>\]</z></TIF> |g;
    return($e);
}

##################################################

sub gen_til {
    my($e) = @_;
    $e =~ s|<til | <TIL |g;
    return($e);
}

##################################################

sub gen_title
{
}

##################################################

sub gen_top_g
{
}

##################################################

sub gen_tp {
    my($e) = @_;
    $e =~ s|<tp | <TP |g;
    return($e);
}

##################################################

sub gen_tph {
    my($e) = @_;
    $e =~ s|<tph | <TPH |g;
    return($e);
}

##################################################

sub gen_tr
#   use for HTML-style table row ONLY ...
{
}

##################################################

sub gen_treg {
    my($e) = @_;
    $e =~ s|</treg><treg |</TREG><z>, </z><TREG |g; # mantis 1976 ...
    $e =~ s|<(treg) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(treg)>|<z>\)</z></\U\1\E>|g;
#    s|</treg>|</TREG><z>\)</z>|g;
#    s|<treg |<z> \(</z><TREG |g;
    return($e);
}

##################################################

sub gen_ts {
    my($e) = @_;
    $e =~ s|</treg><ts |</treg><z>,</z><ts |g; # mantis 1822 ...
#    s|(<ts([^>]*) t="(.*?)"(.*?))</ts>|$1, -$3</ts>|g; # commented by mantis 2234 ...
    $e =~ s|(<ts([^>]*) t="([^"]+)"(.*?))(</ts>)|$1, -$3$5|gi; # mantis 2234 ...
$e =~ s|</ts><ts |</TS><z>, </z><TS |g; # requested for engpor2e ...
$e =~ s|<ts | <TS |g;
return($e);
}

##################################################

sub gen_ts_g {
    my($e) = @_;
    $e =~ s|</t2-g><ts-g |</T2-G><z>; </z><TS-G |g;
    $e =~ s|</ts-g><ts-g |</TS-G><z>; </z><TS-G |g;
    $e =~ s|<ts-g (.*?)>|<z> &tssym; </z><TS-G $1>|g;
    return($e);
}

##################################################

sub gen_tu {
    my($e) = @_;
    $e =~ s|<(tu) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    $e =~ s|</(tu)>|<z>\)</z></\U\1\E>|g;
#    s|<tu |<z> \(</z><TU |g;
#    s|</tu>|</TU><z>\)</z>|g;
    return($e);
}

##################################################

sub gen_tx {
    my($e) = @_;
    $e =~ s|</tx><x |</TX><z> &xsep; </z><X |g;
    $e =~ s|<tx | <TX |g;
    return($e);
}

##################################################

sub gen_u {
    my($e) = @_;
    if ($U_SQUARE_BRACKETS) {
	$e =~ s|<(u) ([^>]*)>| <\U\1\E $2><z>\[</z>|g;
	$e =~ s|</(u)>|<z>\]</z></\U\1\E>|g;
#	s|<u |<z> \[</z><U |g;
#	s|</u>|</U><z>\]</z>|g;
    }
    else {
	$e =~ s|<(u) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
	$e =~ s|</(u)>|<z>\)</z></\U\1\E>|g;
#	s|<u |<z> \(</z><U |g;
#	s|</u>|</U><z>\)</z>|g;
    }
    return($e);
}

##################################################

sub gen_ud {
    my($e) = @_;
    $e =~ s|<ud | <UD |g;
    return($e);
}

##################################################

sub gen_un {
#   for inline usage notes ...

    my($e) = @_;
    $e =~ s| *(<un) | $1 |g;
    return($e);
}

##################################################

sub gen_unbox
#   for boxed usage notes ...
{
}

sub gen_usage {
    my($e) = @_;
    if ($U_SQUARE_BRACKETS) {
	$e =~ s|<usage ([^>]*>)|<USAGE $1<z> \[</z>|g;
	$e =~ s|</usage>|<z>\]</z></USAGE>|g;
    }
    else {
	$e =~ s|<usage ([^>]*>)|<USAGE $1<z> \(</z>|g;
	$e =~ s|</usage>|<z>\)</z></USAGE>|g;
    }
    return($e);
}

##################################################

sub gen_uncl
{
}

##################################################

sub gen_uneb
{
}

##################################################

sub gen_unebi
{
}

##################################################

sub gen_unei
{
}

##################################################

sub gen_uner
{
}

##################################################

sub gen_unesu
{
}

##################################################

sub gen_uneul
{
}

##################################################

sub gen_unfm
{
}

##################################################

sub gen_ungi
{
}

##################################################

sub gen_ungl {
    my($e) = @_;
    if ($UNGL_ADD_BRACKETS) {
	$e =~ s|<ungl |<z>\(=</z><UNGL |g;
	$e =~ s|</ungl>|</UNGL><z>\)</z>|g;
    }
    $e =~ s| *(<ungl)| $1|gi;
    return($e);
}

##################################################

sub gen_unp {
}

##################################################

sub gen_unsyn
{
}

##################################################

sub gen_untitle
{
}

##################################################

sub gen_unwx
{
}

##################################################

sub gen_unx {
    my($e) = @_;
    $e =~ s|</unx><unx |</UNX><z> &xsep; </z><UNX |g;
    if ($UNX_COLON) {
	$e =~ s|<unx |<z>: </z><UNX |g;
    }
    $e =~ s|</unx><arbd1|</unx> <arbd1|g;

    return($e);
}

##################################################

sub gen_v {
    my($e) = @_;
    $e =~ s|</v><label-g |</V> <LABEL-G |g;
    $e =~ s|</vs><v |</VS><z>, </z><V |g; # mantis 2658 ...
    $e =~ s|</v><v |</V><z>, </z><V |g; # mantis 2296 ...
    $e =~ s|</fe><v |</FE><z>, </z><V |g; # mantis 2001 ...
    $e =~ s|</g><v |</G> <V |g;
    $e =~ s|</r><v |</R> <V |g;
    $e =~ s|</s><v |</S> <V |g;
    $e =~ s|</v><g |</V><z>, </z><G |g; # mantis 1779 ...
    $e =~ s|</v><r |</V><z>, </z><R |g; # mantis 1949 ...
    return($e);
}

##################################################

sub gen_vc {
    my($e) = @_;
    $e =~ s|</g><vc |</G> <VC |g;
    return($e);
}

##################################################

sub gen_vf {
    my($e) = @_;
    $e =~ s|</vf><vf |</VF><z>, </z><VF |g;
    $e =~ s|</vs><vf |</VS><z>, </z><VF |g; # mantis 3009 ...
    $e =~ s|</vf><vs |</VF><z>, </z><VS |g; # mantis 3009 ...
    $e =~ s|</g><vf |</G> <VF |g;
    $e =~ s|</r><vf |</R> <VF |g; # mantis 2842 ...
    return($e);
}

##################################################

sub gen_vs {
    my($e) = @_;
    $e =~ s|</vs><label-g |</VS> <LABEL-G |g;
    $e =~ s|</vs><g |</VS> <G |g;
    $e =~ s|</vs><vs |</VS><z>, </z><VS |g;
    $e =~ s|</g><vs |</G> <VS |g;
    $e =~ s|</r><vs |</R> <VS |g; # mantis 2374 ...
    $e =~ s| *</label-g> *<vs |</label-g> <VS |gi;
    return($e);
}

##################################################

sub gen_v_gs {
    my($e) = @_;
    my($bit, $res, $type, $has_label, $first_variant);
    my(@BITS);
    $e =~ s|(<v-gs[ >].*?</v-gs>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $type = restructure::get_tag_attval($bit, "v-gs", "type"); 
	    $has_label = 0;
	    if ($bit =~ m|<v-gs [^>]*> *(<v-g[ >].*?</v-g>)|i)
	    {
		$first_variant = $1;
		if (($first_variant =~ m|<reg|i) || ($first_variant =~ m|<geo|i))
		{
		    $has_label = 1;
		}
	    }
	    if ($has_label)
	    {
		## TO ADD - stuff for dealing with the labels inside variants
		$bit = sprintf(" %s ", $bit);
	    }
	    else  {
		$bit =~ s|(<v-gs[^>]*>)| \1<z>\(&z_also;</z> |i;
		$bit =~ s|(</v-gs>)|<z>\)</z>\1 |i;
	    }
	}
	$res .= $bit;
    }
    return($res);
}

##################################################

sub gen_wf_box
{
}

##################################################

sub gen_wf_g {
}

##################################################

sub gen_wfo {
    my($e) = @_;
    $e =~ s| *<wfo ([^>]*)> *(.*?)</wfo>| <WFO $1><z>\(&\#x2260;</z> $2<z>\)</z></WFO>|g;
    $e =~ s|<wfo | <WFO |g;
    return($e);
}

##################################################

sub gen_wfp {
    my($e) = @_;
    $e =~ s| *(<wfp[ >])| $1|gi;
    $e =~ s|(</wfp>) *(<wfp)|$1<z>, </z>$2|gi;
    return($e);
}

##################################################

sub gen_wfw {
    my($e) = @_;
    $e =~ s|<wfw | <WFW |g;
    return($e);
}

##################################################

sub gen_wx {
    my($e) = @_;
    $e =~ s|</wx> *<wx |</WX><z> &xsep; </z><WX |g;
    return($e);
}

##################################################

sub gen_x_old {
    my($e) = @_;
    my($nocolon) = @_;
    if ($CF_WITH_X) {
	$e =~ s|</cf><cf |&cfpair;|g;
	$e =~ s|(<cf ([^<]*)</cf>)(<x (.*?)>)|$3$1|g; # this line replaces following commented line - CF immediately followed by X ...
#	s|(<cf[ ](?:  (?!<d) . )*? </cf>)(<x[ ](.*?)>)|$2$1|gx; # added negative lookahead assertion [(?!<d)]  to stop the match between cf tags taking half the entry. Other tags mnight need to be added to this as alternates... TT 2009-06-05

    }

    $e =~ s|</ts><dlf([^>]*)></dlf><x |</TS> <dlf$1></dlf><x |g; # mantis 1974 ...
    $e =~ s|</tcf><dlf([^>]*)></dlf><x |</TCF> <dlf$1></dlf><x |g; # mantis 1974 ...
    unless (($APP) || ($nocolon)) {
	$e =~ s|(<x-g[^>]*> *)<x|$1<X|gi;
#   position colon before labels and example ...
#   D: labels X ...
	s/<\/d>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/D><z>: <\/z>$1<z> <\/z><X /g;
#   UD: labels X ...
	s/<\/ud>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/UD><z>: <\/z>$1<z> <\/z><X /g; # mantis 2634 ...
#   TS: labels X ...
	s/<\/ts>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/TS><z>: <\/z>$1<z> <\/z><X /g;
#   TID: labels X ...
	s/<\/tid>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/TID><z>: <\/z>$1<z> <\/z><X /g; # mantis 1783 # fixed FK
#   TCF: labels X ...
	s/<\/tcf>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/TCF><z>: <\/z>$1<z> <\/z><X /g; # mantis 1783
#   P labels: X ...
	s/<\/p>((<(cf|g|gr|r|s) ([^<]*)<\/\3>)+)<x /<\/p>$1<z>: <\/z><X /g;
#   XR: labels X ...
	s/<\/xr>((<(cf|g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/XR><z>: <\/z>$1<z> <\/z><X /g;
#   T2-G: labels X ...
	s/<\/t2-g>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/T2-G><z>: <\/z>$1<z> <\/z><X /g; # mantis 2258
#   TS-G: labels X ...
	s/<\/ts-g>((<(g|gr|pvpt|pt|r|s) ([^<]*)<\/\3>)+)<x /<\/TS-G><z>: <\/z>$1<z> <\/z><X /g; # mantis 2258
#   position labels between examples after separator ...
	s/<\/x>((<(cc|cf|cm|g|pt|pvpt|r|s) ([^<]*)<\/\3>)+)<x /<\/X><z> &xsep;<\/z>$1<z> <\/z><X /g;
	s/<\/tx>((<(cm|g|pt|pvpt|r|s) ([^<]*)<\/\3>)+)<x /<\/TX><z> &xsep;<\/z>$1<z> <\/z><X /g;
	$e =~ s|</x><x |</X><z> &xsep; </z><X |g;
	$e =~ s|</x> *<wx |</X><z> &xsep; </z><WX |g;
	$e =~ s|</wx> *<x |</WX><z> &xsep; </z><X |g;
# Prevent paragraphs from generating the colon
	$e =~ s|(<para[^>]*>)<x |$1<X |g;
	$e =~ s|(<[a-z] zp=\"y\"[^>]*>)<x |$1<X |g;
	$e =~ s|<x |<z>: </z><X |g;
    }
    $e =~ s|(<x ([^>]*)?>)(<cf (.*?)</cf>)|$3 $1|gi;
    $e =~ s|(</x>)(<e[bir]i?)|$1 $2|g;

    $e =~ s|&cfpair;|</cf><cf |g;

    return($e);
}

sub gen_x
{
    my($e) = @_;
    my($res, $eid);	
    if ($EXAMPLE_SYMBOLS eq "ALL")
    {
	$e =~ s|(<x-g [^>]*>)|\1<z>&xsym; </z>|gi;
    }
    elsif ($EXAMPLE_SYMBOLS eq "SEPARATORS")
    {
	$e =~ s|(</x-g> *<x-g [^>]*>)|\1<z>&xsym; </z>|gi;
    }
    return $e;
}


##################################################

sub gen_xh {
    my($e) = @_;
    $e =~ s|</xw><xh |</XW> <XH |g;
    return($e);
}

##################################################

sub gen_xp {
    $e =~ s|<xp |<z>&nbthinsp;</z>$&|g;
    return($e);
}

##################################################

sub gen_xr {
    my($e) = @_;
    $e =~ s|(</xr>)(<xr[ >])|$1<z>, </z>$2|gi;
    return($e);
}

sub gen_xr_g {
    my($e) = @_;
    $e =~ s|(</xr-g>) *(<xr-g[ >])|$1<z>,</z> $2|gi;
    return($e);
}


sub gen_xr_g_old {
    my($e) = @_;
#   full point at end of last xr of type if attribute present ...
    $e =~ s|(<xr-g [^>]*fullpoint=\"y\".*?)(</xr-g>)|$1<z>.</z>$2|gi;
    $e =~ s|</xr-g><z>\(</z>|</xr-g><z> \(</z>|g;
    $e =~ s|</xr-g><gl|</xr-g> <gl|g;
    $e =~ s|(</[^>]*-g>)(<xr-g)|$1 $2|gi; # FK
    $e =~ s|(</ts>)(<xr-g)|$1 $2|gi; # FK
    $e =~ s|(</tx>)(<xr-g)|$1 $2|gi; # FK
    $e =~ s|(</t?id>)(<xr-g)|$1 $2|gi; # FK 
    return($e);
}

##################################################

sub gen_xs {
    my($e) = @_;
    $e =~ s|(<xs [^>]*>)|$1<z>&nbthinsp;\(</z>|g;
    $e =~ s|(</xs>)|<z>\)</z>$1|g;
    return($e);
}

##################################################

sub gen_xt {
    my($e) = @_;
    $e =~ s|</unbox><xt |</unbox><XT |g; # mantis 2319 ...
    $e =~ s|<xt | <XT |g; # mantis 2319 ...

    if ($XT_SYMBOL) {
	$e =~ s|<XT |<z>&xrsym; </z><XT |g;
    }
    return($e);
}

##################################################

sub gen_xw {
    my($e) = @_;
    $e =~ s|</xw> *<xw([ >])|</XW><z>, </z><XW\1|gi;
    return($e);
}

##################################################

sub gen_y {
    my($e) = @_;
    $e =~ s|</y><y |</Y><z>; </z><Y |g;
    $e =~ s|</y><g ([^<]*)</g><i |</Y><z>; </z><G $1</G> <I |g;
    $e =~ s|</y><g ([^<]*)</g><y |</Y><z>; </z><G $1</G> <Y |g;
    unless ($US_IPA_FIRST) {
	$e =~ s|<y |<z> <z_y>&z_us;</z_y> </z><Y |g;
    }
    $e = &gen_cut_ipa_hyphens($e);
    return($e);
}

##################################################

sub gen_zd {
}

##################################################

sub gen_zdp {
    my($e) = @_;
    $e =~ s|<zdp |/<ZDP |g;
    return($e);
}

##################################################

sub gen_zp_key
{
}

##################################################

sub gen_init {
    my($e) = @_;
    $e =~ s|\r||g;
#   cut comments etc ...
    $e =~ s|<!--.*?-->||g;
    $e =~ s|<\?.*?>||g;
    $e =~ s|<hsrch>.*?</hsrch>||g;
#   next line allows for attributes on any start tag ...
    $e =~ s|<([^/> ]+)>|<$1 >|g;
#   cut <d> ...
    if ($CUT_D) {
	$e =~ s|<d .*?</d>||g;
    }
    return($e);
}

##################################################

sub gen_pre_tweak {
    my($e) = @_;
#   add missing spaces ...

    $e =~ s|([\)'0-9A-z;,])<([^/])|$1 <$2|g;
$e =~ s|</([^>]*)>([\('0-9A-z&])|</$1> $2|g;
    $e =~ s|,<fm>|, <fm>|g;
    $e =~ s|\.<fm |. <fm |g;

#   add temp end tags on empty elements ...

    $e =~ s|<([^/ >]+) ([^>]*)/>|<$1 $2></$1>|g;

#    s|<(atpr) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(dlf) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(ds) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(g) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(gi) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(gr) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(il) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(p) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(pt) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(pvpt) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(r) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(s) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(tatpr) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(tcu) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(tev) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(tg) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(tgr) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(til) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(treg) ([^>]*)/>|<$1 $2></$1>|g;
#    s|<(wfp) ([^>]*)/>|<$1 $2></$1>|g;

#   "contextualise" non-ipa stress marks and wordbreak dots ...
    $e = &gen_stress_marks($e);

#   multiple discriminators ...
    if ($DLF_DS_SEPARATE) {
	s/<\/(dacadv|dnca|dncn|dnov|dnsv|dsyn|dtxt|dvcadv)><(dacadv|dnca|dncn|dnov|dnsv|dsyn|dtxt|dvcadv) /<\/\U$1\E><z>, <\/z><\U$2\E /g;
	$e =~ s|</dlf><dlf |</DLF><z>, </z><DLF |g;
	$e =~ s|</ds><ds |</DS><z>, </z><DS |g;
    }
    else {
	s/<\/(dacadv|dlf|dnca|dncn|dnov|dnsv|ds|dsyn|dtxt|dvcadv)><(dacadv|dlf|dnca|dncn|dnov|dnsv|ds|dsyn|dtxt|dvcadv) /<\/\U$1\E><z>, <\/z><\U$2\E /g;
    }
    return($e);
}

##################################################

sub gen_spaces {
    my($e) = @_;
    my($e) = @_;
#   add missing spaces ...
    $e =~ s|([\.\?\:\,])<arbd|\1 <arbd|g;
    $e =~ s|([\.\!\%])(<cl[ >])|$1 $2|g; # mantis 2656 ...
    $e =~ s|([\.\?\:\,])(<e[bir]i?[ >])|$1 $2|g;
    $e =~ s|([\.\?\:\,])(<esc)|$1 $2|g;
    $e =~ s|([\.\?\:\,])(<cm[ >])|$1 $2|g;
    $e =~ s|:(<unw?x[ >])|: $1|g;
    $e =~ s|:(<wx[ >])|: $1|g;
#    $e =~ s|</x><eb>|</x> <eb>|g;
    $e =~ s| *(<xr-g)| $1|gi;
#    $e =~ s|</eb><xr|</eb> <xr|g;
    $e =~ s|</xr><eb|</xr> <eb|g;
    $e =~ s|(<e[bir]i?[^>]>) | $1|gi; # move any space at start of  font override to precede it
    $e =~ s|(<cm[^>]*>) | $1|gi; # move any space at start of <cm> to precede it
    $e =~ s| *(</[^>]*>)(<e[bir]i?[ >])|$1 $2|gi; # add space between any font overrides
    $e =~ s|(</e[bir]i?[^>]*>)(<e[bir]i?[ >])|$1 $2|gi; # add space between any font overrides
    $e =~ s|(</esc>)(<e[bir]i?[ >])|$1 $2|gi; # add space between any font overrides
    $e =~ s|(</e[bir]i?[^>]*>)(<esc[ >])|$1 $2|gi; # add space between any font overrides
    $e =~ s|(</esc[^>]*>)(<esc[ >])|$1 $2|gi; # add space between any font overrides
    $e =~ s|(</xr[^>]*>)(<e[bir]i?[ >])|$1 $2|gi; # add space between </xr> and any font overrides
    $e =~ s|([\.\:\?\;=])(<un)|$1 $2|gi; # 
    $e =~ s|</x><e|</x> <e|g;
    $e =~ s|</unei>,<|</unei>, <|g;
    $e =~ s|</unfm>,<|</unfm>, <|g;
    $e =~ s|</ungi><arbd|</ungi> <arbd|g;
    $e =~ s|</ungi>,<|</ungi>, <|g;
    $e =~ s|</unxh>,<|</unxh>, <|g;
    $e =~ s| </esc> |</esc> |gi;
    $e =~ s|</esc>([A-z])|</esc> $1|gi;
    $e =~ s|</gi>([A-z])|</gi> $1|gi;
    $e =~ s|</gi><fm>|</gi> <fm>|gi;
    $e =~ s|</gi>\.<fm>|</gi>. <fm>|gi;
    $e =~ s|([A-z])<e|$1 <e|gi;
    $e =~ s|</gl><cl|</gl> <cl|gi;
    $e =~ s|</gl><dhb|</gl> <dhb|gi; # mantis 2653 ...
    $e =~ s|</dhb><xr |</dhb> <xr |gi;
    $e =~ s|\.<dh|. <dh|gi;
#    $e =~ s|\.<dhb>|. <dhb>|gi;
    $e =~ s|\.<xr |. <xr |gi;
#   deduplicate spaces ...
    $e =~ s| ( +)| |g;
    $e =~ s|( <[^>]*>) |$1|g;
    $e =~ s| (<[^>]*>)([\.:\),])|$1$2|g;
    $e =~ s| ([;\?,:])|$1|g;
    $e =~ s|(<[a-z][^>]* zp=\"y\"[^>]*>) |$1|gi; # never want a space at the start of a para
    $e =~ s| *(</z[^>]*>) *(<z[^>]*> )|$1$2|gi;
    $e =~ s|([\(\[]) *(<[^>]*>) *|$1$2|g;
    $e =~ s|([\(\[]) *(<[^>]*>) *|$1$2|g;
    $e =~ s|([\(\[]) *(<[^>]*>) *(<[^>]*>) *|$1$2$3|g;
    return $e;
}

##################################################

sub gen_tweak {
    my($e) = @_;
#   lowercase tags ...
    $e =~ s|<(.*?)>|\L$&\E|g;
#    merge duplicate z tags ...
    $e =~ s|</(z[^>]*)><\1>||g;
#   remove empty z tags ...
    $e =~ s|<(z[^>]*)></\1>||g;
#   tidy up start tags ...
####    s| +>|>|g;
#   tidy up line starts ...
    $e =~ s|^(&split;)? +<|<|g;
    $e = &gen_spaces($e);
    $e =~ s|(</un[^>]*>)(<un)|$1 $2|gi; # mantis 2674 ...

    $e =~ s|<z>\)\)|<z>\)|g;
    $e =~ s|&mdash; <cl>|&mdash;<cl>|g;
    $e =~ s|([\.\!\?])<gl|$1 <gl|g;
    $e =~ s|&lsquo; <cl>|&lsquo;<cl>|g;
    $e =~ s|</gl> &rsquo;</x>|</gl>&rsquo;</x>|g;
    $e =~ s|</cl> &mdash;|</cl>&mdash;|g;
    $e =~ s|</xr><dhb|</xr> <dhb|g; # mantis 2478 ...
    $e =~ s|</xr><gl>|</xr> <gl>|g; # mantis 2653 ...
    $e =~ s|</xr><xr |</xr> <xr |g; # mantis 2478 ...
    $e =~ s|(\(</z><ifs-g><if-g>) |$1|g; # mantis 2636 ...
    $e =~ s| (<xr ([^>]*)><z_xr><z_spc_pre> </z_spc_pre>)|$1|gi; # mantis 2669 ...
    $e =~ s|</unx><arit1|</unx> <arit1|gi; # mantis 2679 ...
    $e =~ s|</arbd1><ungl|</arbd1> <ungl|gi; # mantis 2690 ...
    $e =~ s|</ei><z>\(|</ei> <z>\(|g; # mantis 3182 ...
    $e =~ s|([\.\!\?])(<z[^>]*>)\(|$1 $2\(|g; # mantis 3182 ...
    $e =~ s|([\.\!\?])<arbd|$1 <arbd|g; # mantis 2691 ...
    $e =~ s| </z>, |</z>, |gi; # mantis 2694 ...
    $e =~ s|</unwx><arbd|</unwx> <arbd|gi; # mantis 2703 ...
    $e =~ s|</unwx><unei|</unwx> <unei|gi; # mantis 2703 ...
    $e =~ s|</fm><ei|</fm> <ei|gi; # mantis 2709 ...
    $e =~ s|</z>([a-z])|</z> $1|gi; # mantis 2701 ...
    $e =~ s|</pre> |</pre>|gi; # mantis 2704 ...
    $e =~ s| <suf>|<suf>|gi; # mantis 2704 ...
    $e =~ s|\)</z><eb>|\) </z><eb>|gi; # mantis 2699 ...
    $e =~ s|</unebi><z>\(|</unebi><z> \(|gi; # mantis 2752 ...
    $e =~ s|</unei><z>\(|</unei><z> \(|gi; # mantis 2752 ...
    $e =~ s|\]</z_gr_br>([a-z])|\]</z_gr_br> $1|gi; # mantis 2752 ...

    $e =~ s|<z>\)</z>\(|<z>\)</z> \(|gi; # mantis 2752 ...
    $e =~ s|</g><eb>|</g> <eb>|gi; # mantis 2699 ...

    unless ($NUMBERS_OK){
	$e = &gen_renumber_ng($e);
    }
    $e = &gen_fix_ipa_colon($e); # mantis 2151 ...
    $e = &lose_duplicate_attributes($e);
#    s|(\(</z><ifs-g([^>]*)><if-g([^>]*)><z>) \(|$1|g; # mantis 2635 ...
    $e =~ s|<z></z>||g;
    return($e);
}

sub lose_duplicate_attributes {
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<[^>]* zp=\"y\"[^>]*>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit =~ s| zp=| _zp_=|i;
	    $bit =~ s| zp=\"y\"||gi;
	    $bit =~ s| _zp_=| zp=|i;
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_renumber_ng {
    my($e) = @_;
    my(@NGS);
    my($ng);
    my($res);
    $res = "";
    if (s|(<n-g)|&split;$1|gi) {
	$expected = 1;
	$res = "";
	@NGS = split(/&split;/);
	foreach $ng (@NGS) {
	    if ($ng =~ /<n-g([^>]*) n="([0-9]+)"/i) {
		$num = $2;
		if ($num == 1) {
# always allowed
		    $expected = 1;
		}
		elsif ($num != $expected) {
		    $ng =~ s|(<n-g([^>]*) n=")[0-9]+|<!--ng changed -->$1$expected|i unless ($NoNumChange);
$ng =~ s|<z_n>(.*?)</z_n>|<z_n>$expected</z_n>|i unless ($NoNumChange);
}
$expected++;
if ($ng =~ /<(bf-g|dr-g|h-g|id-g|p-g|pv-g)/i) {
    $expected = 1;
}
}
$res = sprintf("%s%s", $res, $ng);
}
$e = $res;
}
else {
    return;
}
return($e);
}

##################################################

sub gen_add_xt_to_closer {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    $e =~ s|<xr .*?</xr>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ m|<xr([^>]*) (xt=".*?")|io) {
	    $xt = $2;
	    $bit =~ s|</xr>|</xr $xt>|io;
	}
	$res .= $bit;
    }
    $e = $res;
    return($e);
}

##################################################

sub gen_eltdicts_imgs {
    my($e) = @_;
    $e =~ s|&(awlsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(blarrow);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(careof);|c/o|gio;
    $e =~ s|&(cfesep);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(cfesym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(cfesyms);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(clsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(coresym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(crosssym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(csym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(drsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(etymsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(helpsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(idsep);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(idsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(idsyms);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(idssym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(notesym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(oppsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&p;|&\#x02C8;|gio;
    $e =~ s|&(p_in_(.*?));|&\#x02C8;|gio;
    $e =~ s|&(psym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(pvarr);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(pvsep);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(pvsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(pvsyms);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(reflsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&s;|&\#x02CC;|gio;
    $e =~ s|&(s_in_(.*?));|&\#x02CC;|gio;
    $e =~ s|&(sdsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(synsep);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(synsep2);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(synsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(taboo);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(tceqsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(ticksym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(tssym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(tusipa);|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    $e =~ s|&(unsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&w;|&\#x00B7;|gio;
    $e =~ s|&(w_in_(.*?));|&\#x00B7;|gio;
    $e =~ s|&(xrsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(xsym);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(xsep);|<img src=\"\1.png\"/>|gio;
    $e =~ s|&(xsym_first);|<img src=\"\1.png\"/>|gio;
    return($e);
}

sub gen_symbols_app {
    my($e) = @_;
    $e =~ s|&([a-z][^ ;]*syms?);|<img src=\"\1.png\"/>|gi;
    $e =~ s|&([a-z][^ ;]*sep);|<img src=\"\1.png\"/>|gi;
    $e =~ s|&f([0-9]+)d([0-9]+);|\1/\2|gi;
    $e =~ s|&(careof);|c/o|gi;
    $e =~ s|&pause;|<img src=\"pause.png\"/>|gi;
    $e =~ s|&CO2;|CO<sub>2</sub>|gi;
    $e =~ s|&dollar;|\$|gi;
    $e =~ s|&p;|&\#x02C8;|gi;
    $e =~ s|&(p_in_(.*?));|&\#x02C8;|gi;
    $e =~ s|&s;|&\#x02CC;|gi;
    $e =~ s|&(s_in_(.*?));|&\#x02CC;|gi;
    $e =~ s|&(tusipa);|t&\#x032C;|gi; # flap t as proper unicode - for typesetting redefine as &#xE000;
    $e =~ s|&w;|&\#x00B7;|gi;
    $e =~ s|&(w_in_(.*?));|&\#x00B7;|gi;
    if ($e =~ m|&[a-z]|i) {
	$e = $e;
	&ents_to_unicode;
	$e = $e;
    }
    return $e;
}

sub gen_symbols_3b2 {
    my($e) = @_;
    $e =~ s|&coresym;|&\#xE03A;|gio; #Core entry symbol (usually a key)
    $e =~ s|&drsym;|&\#xE001;|gio; #Derivative symbol (usually a right-facing triangle)
    $e =~ s|&drsyms;|&\#xE002;|gio; #Derivative group symbol (usually a right-facing triangle)
    $e =~ s|&idsym;|&\#xE003;|gio; #Idiom symbol
    $e =~ s|&idsyms;|&\#xE004;|gio; #Idiom group symbol
    $e =~ s|&infosym;|&\#xE044;|gio; #Usage note Info symbol
    $e =~ s|&oppsym;|&\#xE08C;|gio; #Cross reference opposite symbol
    $e =~ s|&psym;|&\#xE005;|gio; #Part of speech marker
    $e =~ s|&pvsym;|&\#xE005;|gio; #Phrasal verb symbol
    $e =~ s|&pvsyms;|&\#xE006;|gio; #Phrasal verb group symbol
    $e =~ s|&sdsym;|&\#xE000;|gio; #'Signpost' sense division symbol (usually a right-facing triangle)
    $e =~ s|&synsym;|&\#xE08B;|gio; #Cross reference synonym symbol
    $e =~ s|&uncultsym;|&\#xE040;|gio; #Usage note Culture symbol
    $e =~ s|&undrsym;|&\#xE045;|gio; #Usage note Derivative symbol
    $e =~ s|&ungramsym;|&\#xE041;|gio; #Usage note Grammar symbol
    $e =~ s|&unhelpsym;|&\#xE042;|gio; #Usage note Help symbol
    $e =~ s|&unmoresym;|&\#xE043;|gio; #Usage note More symbol
    $e =~ s|&unsym;|&\#xE046;|gio; #Usage note Note symbol
    $e =~ s|&untopicsym;|&\#xE03F;|gio; #Usage note Topic symbol
    $e =~ s|&xrsym;|&\#xE08A;|gio; #Cross reference symbol
    $e =~ s|&xsep;|&\#xE0CA;|gio; #Separator: examples (usually a solid diamond)
    return($e);
}

sub gen_eltdicts_symbols_old {
    my($e) = @_;
    $e =~ s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    $e =~ s| &awlsym; |<z_spc_pre> </z_spc_pre><z_awlsym>w</z_awlsym><z_spc_post> </z_spc_post>|g;
#   cfesym is same symbol as idsym ...
    $e =~ s| &csym; |<z_spc_pre> </z_spc_pre><z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&csym; |<z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &cfesym; |<z_spc_pre> </z_spc_pre><z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&cfesym; |<z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
#   cfesep - used between <id-g>s ...
    $e =~ s| &cfesep; |<z_spc_pre> </z_spc_pre><z_cfesep>X</z_cfesep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
#   clsym uses same character position as unsym ...
    $e =~ s|&clsym; |<z_clsym>A</z_clsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &coresym; |<z_spc_pre> </z_spc_pre><z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&coresym; |<z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &crosssym; |<z_spc_pre> </z_spc_pre><z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&crosssym; |<z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &drsym; |<z_spc_pre> </z_spc_pre><z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&drsym; |<z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &drsep; |<z_spc_pre> </z_spc_pre><z_drsep>X</z_drsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s| &etymsym; |<z_spc_pre> </z_spc_pre><z_etymsym>e</z_etymsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&helpsym;|<z_helpsym>h</z_helpsym>|g;
    $e =~ s| &idsym; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &idsym;|<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym>|g;
    $e =~ s|&idsym; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
# Need to define these properly FK
    $e =~ s| &idsyms; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&idsyms; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
#   idsep - used between <id-g>s ...
    $e =~ s| &idsep; |<z_spc_pre> </z_spc_pre><z_idsep>X</z_idsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s|&notesym;|<z_notesym>n</z_notesym>|g;
    $e =~ s| &oppsym; |<z_spc_pre> </z_spc_pre><z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&oppsym; |<z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&psym;|<z_psym>S</z_psym>|g;
    $e =~ s|&pvarr;|<z_pvarr>P</z_pvarr>|g;
    $e =~ s| &pvsym; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&pvsym; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
# Need to change this in the future FK
    $e =~ s| &pvsyms; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&pvsyms; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
#   pvsep - used between <id-g>s ...
    $e =~ s| &pvsep; |<z_spc_pre> </z_spc_pre><z_pvsep>X</z_pvsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s|&reflsym; |<z_reflsym>r</z_reflsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&sdsym;|<z_sdsym>b</z_sdsym>|g;
#   synsep - used between synonyms ...
    $e =~ s| &synsep; |<z_spc_pre> </z_spc_pre><z_synsep>X</z_synsep><z_spc_post> </z_spc_post>|g;
#   synsep2 - used between groups of synonyms ...
    $e =~ s| &synsep2; |<z_spc_pre> </z_spc_pre><z_synsep2>\|</z_synsep2><z_spc_post> </z_spc_post>|g;
#   synsym - used before first synonym ...
    $e =~ s| &synsym; |<z_spc_pre> </z_spc_pre><z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&synsym; |<z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g; # mantis 5095 ...
    $e =~ s|&taboo;|<z_taboosym>\!</z_taboosym>|g;
    $e =~ s| &tceqsym; |<z_spc_pre> </z_spc_pre><z_tceqsym>=</z_tceqsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&ticksym; |<z_ticksym>Y</z_ticksym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    $e =~ s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES) {
	$e = &gen_bold_tildes($e);
    }
    $e =~ s| &tssym; |<z_spc_pre> </z_spc_pre><z_tssym>t</z_tssym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &unsym; |<z_spc_pre> </z_spc_pre><z_unsym>A</z_unsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    $e =~ s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    $e =~ s| &xsym_first; |<z_spc_pre> </z_spc_pre><z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    $e =~ s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    $e =~ s|&p_in_(.*?);|<p_in_$1>"</p_in_$1>|g;
$e =~ s|&s_in_(.*?);|<s_in_$1>%</s_in_$1>|g;
$e =~ s|&w_in_(.*?);|<w_in_$1>&w;</w_in_$1>|g;
$e =~ s| <z_spc_pre> |<z_spc_pre>|g;
$e =~ s| </z_spc_post><z> | </z_spc_post><z>|g;
$e =~ s| </z_spc_post></z><z> | </z_spc_post>|g;
$e =~ s| </z_spc_post> | </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post> |<z_spc_post> </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post></z><z><z_spc_pre> </z_spc_pre>|<z_spc_post> </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post></z><ts-g> |<z_spc_post> </z_spc_post></z><ts-g>|g;
return($e);
}



sub gen_eltdicts_symbols_to_tags {
    my($e) = @_;
    $e =~ s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    $e =~ s| &awlsym; |<z_spc_pre> </z_spc_pre><z_awlsym>w</z_awlsym><z_spc_post> </z_spc_post>|g;
#   cfesym is same symbol as idsym ...
    $e =~ s| &csym; |<z_spc_pre> </z_spc_pre><z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&csym; |<z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &cfesym; |<z_spc_pre> </z_spc_pre><z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&cfesym; |<z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
#   cfesep - used between <id-g>s ...
    $e =~ s| &cfesep; |<z_spc_pre> </z_spc_pre><z_cfesep>X</z_cfesep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
#   clsym uses same character position as unsym ...
    $e =~ s|&clsym; |<z_clsym>A</z_clsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &coresym; |<z_spc_pre> </z_spc_pre><z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&coresym; |<z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &crosssym; |<z_spc_pre> </z_spc_pre><z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&crosssym; |<z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &drsym; |<z_spc_pre> </z_spc_pre><z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&drsym; |<z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &drsep; |<z_spc_pre> </z_spc_pre><z_drsep>X</z_drsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s| &etymsym; |<z_spc_pre> </z_spc_pre><z_etymsym>e</z_etymsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&helpsym;|<z_helpsym>h</z_helpsym>|g;
    $e =~ s| &idsym; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &idsym;|<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym>|g;
    $e =~ s|&idsym; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
# Need to define these properly FK
    $e =~ s| &idsyms; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&idsyms; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
#   idsep - used between <id-g>s ...
    $e =~ s| &idsep; |<z_spc_pre> </z_spc_pre><z_idsep>X</z_idsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s|&notesym;|<z_notesym>n</z_notesym>|g;
    $e =~ s| &oppsym; |<z_spc_pre> </z_spc_pre><z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&oppsym; |<z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&psym;|<z_psym>S</z_psym>|g;
    $e =~ s|&pvarr;|<z_pvarr>P</z_pvarr>|g;
    $e =~ s| &pvsym; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&pvsym; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
# Need to change this in the future FK
    $e =~ s| &pvsyms; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&pvsyms; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
#   pvsep - used between <id-g>s ...
    $e =~ s| &pvsep; |<z_spc_pre> </z_spc_pre><z_pvsep>X</z_pvsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    $e =~ s|&reflsym; |<z_reflsym>r</z_reflsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&sdsym;|<z_sdsym>b</z_sdsym>|g;
#   synsep - used between synonyms ...
    $e =~ s| &synsep; |<z_spc_pre> </z_spc_pre><z_synsep>X</z_synsep><z_spc_post> </z_spc_post>|g;
#   synsep2 - used between groups of synonyms ...
    $e =~ s| &synsep2; |<z_spc_pre> </z_spc_pre><z_synsep2>\|</z_synsep2><z_spc_post> </z_spc_post>|g;
#   synsym - used before first synonym ...
    $e =~ s| &synsym; |<z_spc_pre> </z_spc_pre><z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&synsym; |<z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g; # mantis 5095 ...
    $e =~ s|&taboo;|<z_taboosym>\!</z_taboosym>|g;
    $e =~ s| &tceqsym; |<z_spc_pre> </z_spc_pre><z_tceqsym>=</z_tceqsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&ticksym; |<z_ticksym>Y</z_ticksym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    $e =~ s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES) {
	$e = &gen_bold_tildes($e);
    }
    $e =~ s| &tssym; |<z_spc_pre> </z_spc_pre><z_tssym>t</z_tssym><z_spc_post> </z_spc_post>|g;
    $e =~ s| &unsym; |<z_spc_pre> </z_spc_pre><z_unsym>A</z_unsym><z_spc_post> </z_spc_post>|g;
    $e =~ s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    $e =~ s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    $e =~ s| &xsym_first; |<z_spc_pre> </z_spc_pre><z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    $e =~ s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    $e =~ s|&p_in_(.*?);|<p_in_$1>"</p_in_$1>|g;
$e =~ s|&s_in_(.*?);|<s_in_$1>%</s_in_$1>|g;
$e =~ s|&w_in_(.*?);|<w_in_$1>&w;</w_in_$1>|g;
$e =~ s| <z_spc_pre> |<z_spc_pre>|g;
$e =~ s| </z_spc_post><z> | </z_spc_post><z>|g;
$e =~ s| </z_spc_post></z><z> | </z_spc_post>|g;
$e =~ s| </z_spc_post> | </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post> |<z_spc_post> </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post></z><z><z_spc_pre> </z_spc_pre>|<z_spc_post> </z_spc_post>|g;
$e =~ s|<z_spc_post> </z_spc_post></z><ts-g> |<z_spc_post> </z_spc_post></z><ts-g>|g;
return($e);
}

##################################################

sub gen_stress_marks {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    my($tag);
#   next line assumes no embedded tags in element containing stress mark/wordbreak dot...
    $e =~ s|<([^> ]+) ([^>]*)>([^<]*)&[psw];(.*?)</\1>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ m|&[psw];|) {
	    $bit =~ m|<([^> ]+)|;
	    $tag = $1;
	    unless ($tag =~ m/^(eph|entry|i|phon-gb|phon-us|y)$/) {
#   keep the entities for the moment so extra tags don't interfere with punctuation ...
#   these are changed to tagged text later in subroutine "gen_eltdicts_symbols" ...
		$bit =~ s|&p;|&p_in_$tag;|g;
		$bit =~ s|&s;|&s_in_$tag;|g;
		if ($WORDBREAK_IN_CONTEXT) {
		    $bit =~ s|&w;|&w_in_$tag;|g;
		}
	    }
	}
	$res .= $bit;
    }
    $e = $res;
#   clean up any of above entities generated within attribute values ...
    while (s|(<([^>]+))&([psw])_in_.*?;|$1&$3;|g) {}
    return($e);
}

##################################################

sub gen_cut_ipa_hyphens
#   cut hyphens pre stress at start of print IPA ...
{
    my($e) = @_;
#    s/(<(eph|i|y) ([^>]*)>)\-(["%])/$1$4/gi; # commented - mantis 1826 ...
    return($e);
}

##################################################

sub gen_bold_tildes {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    $splits ="(cf|id|pv)"; # this based on ENGPOR2E requirements ...
    s/<$splits /&split;$&/goi;
    s/<\/$splits>/$&&split;/goi;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ /<$splits([ >])/i) {
	    $bit =~ s|<z_tilde|<z_bold_tilde|g;
	    $bit =~ s|</z_tilde>|</z_bold_tilde>|g;
	}
	$res .= $bit;
    }
    $e = $res;
    return($e);
}

##################################################

sub gen_fix_ipa_colon {
    my($e) = @_;
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    $splits ="(eph|i|phon-gb|phon-us|y)";
    s/<$splits([ >])/&split;$&/goi;
    s/<\/$splits>/$&&split;/goi;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ /<$splits([ >])/i) {
	    $bit =~ s|\:|\;|g;
	}
	$res .= $bit;
    }
    $e = $res;
    return($e);
}

##################################################

sub gen_pos_full {
    my($e) = @_;

#   requires <p p="xxx_FULL">...</p> in attval file ...

    my(@BITS);
    my($bit);
    my($res);
    $e =~ s|<h-g .*?</h-g>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS) {
	if ($bit =~ m|<h-g|io) {
	    $bit =~ s|(<p ([^>]*)p="(.*?))"|$1\_FULL"|gi;
}
$res .= $bit;
}
$e = $res;
return($e);
}

##################################################

sub gen_expand_if {
    my($e) = @_;
    m|<h ([^>]*)>(.*?)</h>|i;
    $head=$2;
    $head =~ s|<.*?>||g;
    $head =~ s|&[psw];||g;

    $e =~ s|<if ([^>]*)>-bb-</if>|<if $1>$head###bing</if><if >$head###bed</if>|gi;
    $e =~ s|<if ([^>]*)>-ck-</if>|<if $1>$head###king</if><if >$head###ked</if>|gi;
    $e =~ s|<if ([^>]*)>-dd-</if>|<if $1>$head###ding</if><if >$head###ded</if>|gi;
    $e =~ s|<if ([^>]*)>-gg-</if>|<if $1>$head###ging</if><if >$head###ged</if>|gi;
    $e =~ s|<if ([^>]*)>-kk-</if>|<if $1>$head###king</if><if >$head###ked</if>|gi;
    $e =~ s|<if ([^>]*)>-l-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    $e =~ s|<if ([^>]*)>-ll-</if>|<if $1>$head###ling</if><if >$head###led</if>|gi;
    $e =~ s|<if ([^>]*)>-m-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    $e =~ s|<if ([^>]*)>-mm-</if>|<if $1>$head###ming</if><if >$head###med</if>|gi;
    $e =~ s|<if ([^>]*)>-nn-</if>|<if $1>$head###ning</if><if >$head###ned</if>|gi;
    $e =~ s|<if ([^>]*)>-p-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    $e =~ s|<if ([^>]*)>-pp-</if>|<if $1>$head###ping</if><if >$head###ped</if>|gi;
    $e =~ s|<if ([^>]*)>-rr-</if>|<if $1>$head###ring</if><if >$head###red</if>|gi;
    $e =~ s|<if ([^>]*)>-s-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    $e =~ s|<if ([^>]*)>-ss-</if>|<if $1>$head###sing</if><if >$head###sed</if>|gi;
    $e =~ s|<if ([^>]*)>-t-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    $e =~ s|<if ([^>]*)>-tt-</if>|<if $1>$head###ting</if><if >$head###ted</if>|gi;
    $e =~ s|<if ([^>]*)>-vv-</if>|<if $1>$head###ving</if><if >$head###ved</if>|gi;
    $e =~ s|<if ([^>]*)>-zz-</if>|<if $1>$head###zing</if><if >$head###zed</if>|gi;

    if ($EXPAND_MORE_IF) {
	if ($head =~ s|woman$||) {
	    $e =~ s|<if ([^>]*)>-women</if>|<if $1>$head###women</if>|g;
	}
	if ($head =~ s|man$||) {
	    $e =~ s|<if ([^>]*)>-men</if>|<if $1>$head###men</if>|g;
	}
	if ($head =~ s|y$||) {
	    $e =~ s|<if ([^>]*)>-ied</if>|<if $1>$head###ied</if>|g;
	    $e =~ s|<if ([^>]*)>-died</if>|<if $1>$head###ied</if>|g;
	    $e =~ s|<if ([^>]*)>-fied</if>|<if $1>$head###ied</if>|g;
	    $e =~ s|<if ([^>]*)>-pied</if>|<if $1>$head###ied</if>|g;
	    $e =~ s|<if ([^>]*)>-plied</if>|<if $1>$head###ied</if>|g;
	    $e =~ s|<if ([^>]*)>-sied</if>|<if $1>$head###ied</if>|g;
	}
	$e =~ s|(<if ([^>]*)wd="([^"]+)"([^>]*)>)\-([^<]+)</if>|$1$3</if>|g;
}

$e =~ s|###||g;
return($e);
}

##################################################

sub gen_xml_head {
    print "<\?xml version=\"1.0\" encoding=\"utf-8\"\?>\n<batch>\n";
}

##################################################

sub gen_xml_output {
    my($e) = @_;
    if ($e =~ m|&[^\#]|)
    {
	$e = &ents_to_unicode($e);
    }
    return($e);
}

##################################################

sub gen_xml_tail {
    print "</batch>\n";
}

##################################################
# $e = &rename_tag_in_tag($e, $container, $oldtag, $newtag);
sub rename_tag_in_tag {
    my($e, $container, $oldtag, $newtag) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<$container[ >].*?</$container>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit =~ s|<$oldtag([ >])|<$newtag$1|gi;
	    $bit =~ s|</$oldtag([ >])|</$newtag$1|gi;
	}
	$res .= $bit;
    }
    return $res;
}

sub gen_label_punc {
    my($e, $dict) = @_;
    my($bit, $res, $start);
    my(@BITS);
    $e =~ s|<ei(.*?)>|{{ei$1}}|gio;
    $e =~ s|</ei>|{{/ei}}|gio;
    $e =~ s|</r><r [^>]*>|&rsep;|gi;
    $e =~ s|</g><g [^>]*>|&gsep;|gi;
    $e =~ s|</gr><gr [^>]*>|&grsep;|gi;
    $e =~ s|(<label-g[ >].*?</label-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit =~ s|<(/?chn[^>]*)>|=open=\1=close=|gi;
	    $start = $bit;
	    $bit =~ s|(<label-g[^>]*>)(<pt [^>]*>[^<]*</pt>)(</label-g>)|$1\[$2\]$3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>)(</label-g>)|$1\[$2\]$3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<g [^>]*>[^<]*</g>)(</label-g>)|$1\($2\) $3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<r [^>]*>[^<]*</r>)(</label-g>)|$1\($2\)$3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<s [^>]*>[^<]*</s>)(</label-g>)|$1\($2\)$3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<u [^>]*>.*?</u>)(</label-g>)|$1\($2\)$3|gi;
	    $bit =~ s|(<label-g[^>]*>)(<[grsu] [^>]*>[^<]*</[grsu]>)(<[grsu] [^>]*>[^<]*</[grsu]>)(</label-g>)|$1\($2\) \($3\) $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<u [^>]*>[^<]*</u>)(<[grs] [^>]*>[^<]*</[grs]>)(</label-g>)|$1\($2\) \($3\) $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<pt [^>]*>[^<]*</pt>)(<[grsu] [^>]*>[^<]*</[grsu]>)(</label-g>)|$1\[$2\] \($3\) $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<[grsu] [^>]*>[^<]*</[grsu]>)(<gr [^>]*>[^<]*</gr>)(</label-g>)|$1\($2\) \[$3\] $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(</label-g>)|$1\[$2\] \($3\) $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<pt [^>]*>[^<]*</pt>)(<[grsu] [^>]*>[^<]*</[grsu]>)(<g [^>]*>[^<]*</g>)(</label-g>)|$1\[$2\] \($3\) \($4\) $5|gi;
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(</label-g>)|$1\[$2\] \($3 $4\) $5|gi;
	    $bit =~ s|(<label-g[^>]*>)(<pt [^>]*>[^<]*</pt>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(</label-g>)|$1\[$2\] \($3\) \($4\) $5|gi;
	    $bit =~ s|(<label-g[^>]*>)(<r [^>]*>[^<]*</r>)(<g [^>]*>[^<]*</g>)(<r [^>]*>[^<]*</r>)(</label-g>)|$1\($2\) \($3 $4\) $5|gi;
	    $bit =~ s|(<label-g[^>]*>)(<[grsu] [^>]*>[^<]*</[rgsu]>) *(<cm [^>]*>[^<]*</cm>) *(</label-g>)|$1\($2\) $3 $4|gi;
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>) *(<cm [^>]*>[^<]*</cm>) *(</label-g>)|$1\[$2\] $3 $4|gi;
	    if ($dict =~ m|ald8|i) {
		$bit =~ s|(<label-g[^>]*>)(<[grs] [^>]*>[^<]*</[rgs]>) *(<cm [^>]*>[^<]*</cm>) *(<[grs] [^>]*>[^<]*</[rgs]>)(</label-g>)|$1\($2 $3 $4\) $5|gi;
	    }
	    else {
		$bit =~ s|(<label-g[^>]*>)(<[grs] [^>]*>[^<]*</[rgs]>) *(<cm [^>]*>[^<]*</cm>) *(<[grs] [^>]*>[^<]*</[rgs]>)(</label-g>)|$1\($2\) $3 \($4\) $5|gi;
	    }
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(</label-g>)|$1\[$2\] \($3\) \($4\) $5|gi;
#(<g>US</g>) <cm>or</cm> (<r>old-fashioned</r>)
#<r>old-fashioned</r><g>Brit</g><r>informal</r>
#(<r>old-fashioned</r>) (<g>Brit</g> <r>informal</r>)
	    if ($bit =~ m| brackets=\"n\"|) {
		$bit = $start;
	    }
	    unless ($bit eq $start) {
		$bit =~ s|(</?[^ >]*)|\U$1\E|g;
		$bit =~ s|(</?label-g)|\L$1\E|g;
	    }
	    $bit =~ s|=open=|<|gi;
	    $bit =~ s|=close=|>|gi;
	}
	$res .= $bit;
    }
    $res =~ s|(</[grsu]>)(<[grsu])|$1 $2|gi;
    $res =~ s|&gsep;|</g>, <g >|gio;
    $res =~ s|&grsep;|, |gio;
    $res =~ s|&rsep;|</r>, <r >|gio;
    $res =~ s| *(</cm>) *(<label-g[^>]*>) *|$1 $2|gi;
    $res =~ s|\{\{|<|g;
    $res =~ s|\}\}|>|g;
    return $res;
}    


##################################################

sub gen_cut_bord {
    my($e) = @_;
#   suppress elements marked bord="y" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)bord="y"([^>]*)/>||gi;
#   sort out n="1" followed by borderline n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) bord="y"|$3<n-g$4 n="2"$5bord="y"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)bord="y"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_oet {
    my($e) = @_;
#   suppress elements marked pub="oet" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="oet"([^>]*)/>||gi;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="oet"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_sup {
    my($e) = @_;
#   suppress elements marked sup="y" ...
    $e =~ s| pub=\"sup\"| sup=\"y\"|g;
    $e =~ s| del=\"y\"| sup=\"y\"|g;
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)sup="y"([^>]*)/>||gi;
#   and the rest ...
    $e =~ s|<x ([^>]*)sup="y"([^>]*)>(.*?)</x><tx .*?</tx>||gi;
    $e =~ s|<([^/ >]+) ([^>]*)sup="y"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_cd {
    my($e) = @_;
#   suppress elements marked pub="cd" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="cd"([^>]*)/>||gi;
#   sort out n="1" followed by pub="cd" n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="cd"|$3<n-g$4 n="2"$5pub="cd"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="cd"([^>]*)>(.*?)</\1>||gi;
#   cut sets ...
    $e =~ s|<set .*?>||g;
#   cut electronic ipa ...
    $e =~ s|<ei-g .*?</ei-g>||g;
#   cut xw on id xrefs for book ...
    $e =~ s|(<xr ([^>]*)xt="id"([^>]*)>)<xw>([^<]*?)</xw>|$1|g;
#   cut inflections ...
    $e =~ s|<infl .*?</infl>||g;
#   cut sidepanel ...
    $e =~ s|<sidepanel .*?</sidepanel>||g;
    return($e);
}

##################################################

sub gen_cut_digital {
    my($e) = @_;
#   suppress elements marked pub="digital" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="digital"([^>]*)/>||gi;
#   sort out n="1" followed by pub="digital" n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="digital"|$3<n-g$4 n="2"$5pub="digital"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="digital"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_dvd {
    my($e) = @_;
#   suppress elements marked pub="dvd" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="dvd"([^>]*)/>||gi;
#   sort out n="1" followed by pub="dvd" n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="dvd"|$3<n-g$4 n="2"$5pub="dvd"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="dvd"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_web {
    my($e) = @_;
#   suppress elements marked pub="web" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="web"([^>]*)/>||gi;
#   sort out n="1" followed by pub="web" n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="web"|$3<n-g$4 n="2"$5pub="web"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="web"([^>]*)>(.*?)</\1>||gi;
    return($e);
}

##################################################

sub gen_cut_el {
    my($e) = @_;
#   suppress elements marked pub="el" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="el"([^>]*)/>||gi;
#   sort out n="1" followed by pub="el" n="2" ...
    $e =~ s|#|&temphash;|g;
    $e =~ s|</n-g>|</n-g>#|gi;
    $e =~ s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="el"|$3<n-g$4 n="2"$5pub="el"|gi;
    $e =~ s|</n-g>#|</n-g>|gi;
    $e =~ s|&temphash;|#|g;
#   and the rest ...
    $e =~ s|\#|&temphash;|gio;
    $e =~ s|(</x>)|$1\#|gio;
    $e =~ s|<x ([^>]*)pub="el"([^>]*)>([^\#]*)</x>\#<tx .*?</tx>||gi;
    $e =~ s|\#||g;
    $e =~ s|&temphash;|#|g;
    $e =~ s|<([^/ >]+) ([^>]*)pub="el"([^>]*)>(.*?)</\1>||gi;
#   cut sets ...
    $e =~ s|<set .*?>||g;
#   cut electronic ipa ...
    $e =~ s|<ei-g .*?</ei-g>||g;
#   cut xw on id xrefs for book ...
    $e =~ s|(<xr ([^>]*)xt="id"([^>]*)>)<xw>([^<]*?)</xw>|$1|g;
#   cut inflections ...
    $e =~ s|<infl .*?</infl>||g;
#   cut sidepanel ...
    $e =~ s|<sidepanel .*?</sidepanel>||g;
    return($e);
}

##################################################

sub gen_cut_pr {
    my($e) = @_;
#   suppress elements marked pub="pr" ...
#   empty elements ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="pr"([^>]*)/>||g;
#   and the rest ...
    $e =~ s|<([^/ >]+) ([^>]*)pub="pr"([^>]*)>(.*?)</\1>||g;
    if (0) {
#   cut print ipa ...
	$e =~ s|<i-g.*?</i-g>||g;
    }
    return($e);
}


1;
