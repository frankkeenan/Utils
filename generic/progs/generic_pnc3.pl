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
require "/data/dicts/generic/progs/ents_to_unicode.pl";
#
if (0)
{
    $_ = &add_space_before($_, "alt");
    $_ = &add_space_between($_, "alt", "def-g");
    $_ = &add_separator($_, "alt", "alt");
    $_ = &add_para($_, "bf-g");
    $_ = &add_para_between($_, "sd-g", "c-g");
    $_ = &add_brackets_around($_, "dlf");
    $_ = &add_brackets_and_sym($_, "dlf");

}

##################################################


sub load_config_options
{
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

sub gen_load_exp
#   loads attribute expansions from XML file ...
{
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

sub gen_load_import
{
    my($f) = @_;
    open(in_fp, "$f") || die "Unable to open $f";
    while (<in_fp>)
    {
	chomp;
	s|
	    ||g;
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

sub add_space_before
{
    my($e, $a) = @_;
    $e =~ s|(<[a-z0-9]+)>|$1 >|gi;
    $e =~ s| *(<$a)( [^>]*>) *| \U\1\E\2|g;
    return $e;
}

sub add_para
{
    my($e, $a) = @_;
    $e =~ s|(<[a-z0-9]+)>|$1 >|gi;
    $e =~ s| *(<$a) ([^>]*>) *|\U\1\E zp=\"y\" $2|g;
    return $e;
}

sub add_para_between
{
    my($e, $a, $b) = @_;
    $e =~ s|(<[a-z0-9\-]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *(<$b) ([^>]*>) *|\U\1\E \U\2\E zp=\"y\" \3|g;
    return $e;
}

sub add_space_between
{
    my($e, $a, $b) = @_;
    $e =~ s|(<[a-z0-9\-]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *(<$b)( [^>]*>) *|\U\1\E \U\2\E\3|g;
    return $e;
}

sub add_separator
{
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

sub add_brackets_around
{
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

sub gen_a
{
    $_ = &add_separator($_, "a", "a");
    if ($A_ROUND_BRACKETS)
    {
	$_ = &add_brackets_around($_, "a");
    }
    else
    {
	$_ = &add_space_before($_, "a");
    }
    $_ = &add_space_between($_, "a", "def-g");
    $_ = &add_space_between($_, "a", "vs-g");
}

##################################################

sub gen_ab
{
    $_ = &add_space_between($_, "ab", "label-g");
    $_ = &add_separator($_, "ab", "ab");
    s|</ab><tg |<z>\)</z></AB><z>,</z><tg |g; # mantis 2020 ...
    s|<(ab) ([^>]*)>| <\U\1\E $2><z>\(</z><z_ab>&z_abbr;</z_ab> |g;
    s|</(ab)>|<z>\)</z></\U\1\E> |g;
}

##################################################

sub gen_adv
{
    $_ = &add_brackets_around($_, "adv");
    s|<adv (.*?)</adv>(<i-g (.*?)</i-g>)?|<z> (</z><z_adv>&z_adv;</z_adv> <ADV $1</ADV>$2<z>)</z>|g;
}

##################################################

sub gen_alt
{
    $_ = &add_separator($_, "alt", "alt");    
    if ($A_ROUND_BRACKETS)
    {
	$_ = &add_brackets_around($_, "alt");
    }
    else
    {
	$_ = &add_space_before($_, "alt");
    }
    s| *(</label-g>) *(<alt [^>]*>) *|\1 \2|gi;
#    $_ = &add_space_between($_, "label-g", "alt");
    $_ = &add_space_between($_, "alt", "def-g");
    $_ = &add_space_between($_, "alt", "vs-g");
}

##################################################

sub gen_althead
{
}

##################################################

sub gen_arbd1
{
}

##################################################

sub gen_arit1
{
}

##################################################

sub gen_atpr
{
    $_ = &add_separator($_, "atpr", "p");
    $_ = &add_space_before($_, "atpr");
}

##################################################

sub gen_audio_g
{
    $_ = &add_space_before($_, "audio-g");
}

##################################################

sub gen_bf
{
    $_ = &add_separator($_, "bf", "bf");
    $_ = &add_space_between($_, "cm", "bf");
}

##################################################

sub gen_bf_g
{
    $_ = &add_para($_, "bf-g");
}

##################################################

sub gen_c
{
    $_ = &add_separator($_, "c", "c");
    $_ = &add_separator($_, "fce", "c");
    $_ = &add_separator($_, "c", "v");
}

##################################################

sub gen_c_g
{
    $_ = &add_space_between($_, "c-g", "c-g");
    if ($CSYM_NEWLINE)
    {
        s|<c-g ([^>]*)>|<C-G zp="y" $1><z>&csym; </z>|g;
    }
    else
    {
        s|<c-g ([^>]*)>| <C-G $1><z>&csym; </z>|g;
    }
    &add_para_between($_, "sd-g", "c-g");
}

##################################################

sub gen_cc
{
    $_ = &add_space_before($_, "cc");
}

##################################################

sub gen_cf
{
    $_ = &add_separator($_, "cf", "cf");
    $_ = &add_separator($_, "tadv", "cf");
    $_ = &add_space_before($_, "cf");
    $_ = &add_space_between($_, "cf", "def-g");
    $_ = &add_space_between($_, "cf", "x");
#    $_ = &add_space_between($_, "cf", "x-g");
}

##################################################

sub gen_cfe
{
    $_ = &add_separator($_, "cfe", "cfe");
}

##################################################

sub gen_cfe_g
{
    $_ = &add_space_between($_, "cfe-g", "cfe-g");
    if ($IDSEP)
    {
	s|</cfe-g> <cfe-g |</cfe-g><z> &cfesep; </z><cfe-g |gi;
    }
}

##################################################

sub gen_cfes_g
{
    s|<cfes-g ([^>]*>)| <CFES-G \1><z>&cfesym; </z>|g;
}

##################################################

sub gen_cl
{
    $_ = &add_separator($_, "cl", "cl");
}

##################################################

sub gen_cl_g
{
}

##################################################

sub gen_clpara
{
}

##################################################

sub gen_cm
{
    s|</g><cm>([^<]*)</cm><g |</G> <CM>$1</cm><g |g;
    s|</g><cm ([^<]*)</cm><g |</G> <CM $1</cm><g |g;
    s|</g><cm>([^<]*)</cm><r |</G> <CM>$1</cm><r |g;
    s|</g><cm ([^<]*)</cm><r |</G> <CM $1</cm><r |g;
    s|</g><cm>([^<]*)</cm><s |</G> <CM>$1</cm><s |g;
    s|</g><cm ([^<]*)</cm><s |</G> <CM $1</cm><s |g;
    s|</a><cm>([^<]*)</cm><a |</A> <CM>$1</CM> <A |g;
    s|</r><cm>([^<]*)</cm><r |</R> <CM>$1</cm> <R |g;
    s|</s><cm ([^<]*)</cm><r |</S> <CM $1</cm> <R |g;
    s|</s><cm ([^<]*)</cm><s |</S> <CM $1</cm><s |g;
    s|</s><cm>([^<]*)</cm><s |</S> <CM>$1</cm><s |g;
    s|</if-g><cm ([^<]*)</cm><if-g |</IF-G> <CM $1</cm> <IF-G |g;
    s|</if-g><cm>([^<]*)</cm><if-g |</IF-G> <CM>$1</cm> <IF-G |g;
    s|</cm><g |</CM> <G |g;
    s|</cm><r |</CM> <R |g;
    s|</cm><s |</CM> <S |g;
    s|</cm><i |</CM> <I |g;
    s|</cm><if |</CM> <IF |g;
    s|</ei-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</ei-g></if-g></ifs-g> <CM $1</CM><ifs-g |g; # mantis 2564 ...
    s|</i-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</i-g></if-g></ifs-g> <CM $1</CM><ifs-g |g; # mantis 2564 ...
    s|</cm><ifs-g |</CM> <IFS-G |g; # mantis 2610 ...
    s|</dtxt><cm |</dtxt> <CM |g; # mantis 2355 ...
    s|</gr><cm |</gr> <CM |g; # mantis 2355 ...
    s|</i-g><cm |</i-g> <CM |g; # mantis 2355 ...
    s|</if><cm |</IF> <CM |g;
    s|</il><cm |</IL> <CM |g; # mantis 1969 ...
    s|</r><cm |</R> <CM |g; # mantis 1862 ...
    s|</s><cm>([^<]*)</cm><s |</S> <CM>$1</cm><S |g;
    s|</s><cm ([^<]*)</cm><s |</S> <CM $1</cm><S |g;
    s|</y><cm |</Y><z>; </z><CM |g; # mantis 1982 ...
    s|</xh><cm |</XH> <CM |g;
    s|</cm><xh |</CM> <XH |g;
    s|</a><cm |</A> <CM |g; 
    s|(</cm>) *(<cm )|$1 $2|g; 
    s|</ifs-g><cm |</IFS-G> <CM |g; # mantis 2610 ...
}

##################################################

sub gen_co
{
#   do nothing
}

##################################################

sub gen_collsubhead
{
}

##################################################

sub gen_d
{
    if ($D_NEWLINE)
    {
	my(@BITS);
	my($bit);
	my($res);
	my($splits);
#	don't newline <d> within these contexts ...
	$splits ="(bf|id|n|pv|)-g"; # this based on AMESS requirements ...
	s/<$splits/&split;$&/goi;
	s/<\/$splits>/$&&split;/goi;
	@BITS = split(/&split;/);
	foreach $bit (@BITS)
	{
            if ($bit =~ /<$splits/i)
	    {
		$bit =~ s|<d | <D |g;
	    }
	    else
	    {
		$bit = &add_para($_, "d");
	    }
	    $res .= $bit;
	}
	$_ = $res;
    }
    else
    {
	s|<d | <D |g;
    }
}

##################################################

sub gen_dacadv
{
    $_ = &add_brackets_around($_, "dacadv");
}

##################################################

sub gen_dc
{
    $_ = &add_brackets_around($_, "dc");
}

##################################################

sub gen_dh
{
#   do nothing
}

##################################################

sub gen_dhb
{
#   do nothing
}

##################################################

sub gen_dhs
{
    s|</dhs>|</DHS><z>&rsquo;</z> |g;
    s| ?<dhs | <z>&lsquo;</z><DHS |g;
}

##################################################

sub gen_discrim
{
    $_ = &add_separator($_, "discrim", "discrim");
}

##################################################

sub gen_discrim_g
{
    $_ = &add_separator($_, "tgr", "discrim-g");
    $_ = &add_brackets_around($_, "discrim-g");
}

##################################################

sub gen_dlf
{
    $_ = &add_separator($_, "tgr", "dlf");
    $_ = &add_brackets_around($_, "dlf");
}

##################################################

sub gen_dnca
{
    $_ = &add_brackets_around($_, "dnca");
}

##################################################

sub gen_dncn
{
    $_ = &add_brackets_around($_, "dncn");
}

##################################################

sub gen_dnov
{
    $_ = &add_brackets_around($_, "dnov");
}

##################################################

sub gen_dnsv
{
    $_ = &add_brackets_around($_, "dnsv");
}

##################################################

sub gen_dr
{
    $_ = &add_separator($_, "dr", "dr");
}

##################################################

sub gen_dr_g
{
    $_ = &add_drg_syms($_);
    if ($DRG_NEWLINE)
    {
	$_ = &add_para($_, "dr-g");
    }
    else
    {
	$_ = &add_space_between($_, "dr-g", "dr-g");
    }
    s|<dr-g ([^>]*)>| <DR-G $1><z>&drsym; </z>|g;
    $_ = &add_para_between($_, "sd-g", "dr-g");
    s|(</sd-g>) *(<dr-g )|$1$2 zp=\"y\" |gi;
    s|(<z[^>]*> *&drsym; *</z[^>]*>)(<top-g[^>]*>)|$2$1|gi;
}


sub add_drg_syms
{
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<dr-g[ >].*?</dr-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<dr-g([^>]*)academic=\"y\"|i)
	    {
		$bit =~ s|(</dr>)|$1<z> &awlsym; </z>|i;
	    }
	    if ($bit =~ m|<dr-g([^>]*)core=\"y\"|i)
	    {
		if ($KEYSYM_BEFORE_H)
		{
		    $bit =~ s|(<dr[ >])|<z>&small_coresym; </z>$1|i;
		}
		else
		{
		    $bit =~ s|(</dr>)|$1<z> &small_coresym; </z>|i;
		}
	    }
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_dre
{
    s|(<z> &awlsym; </z>)(<dre (.*?)</dre>)|$2$1|g;
    s|<dre |<z>, </z>$&|g;
}

##################################################

sub gen_drp
{
    s|<drp |/<DRP |g;
}

##################################################

sub gen_ds
{
    $_ = &add_space_between($_, "ts", "ds");
    $_ = &add_space_between($_, "tcf", "ds");
    $_ = &add_space_between($_, "tgr", "ds");
    $_ = &add_space_between($_, "treg", "ds");
    $_ = &add_brackets_around($_, "ds");
}

##################################################

sub gen_dst
{
    $_ = &add_brackets_around($_, "dst");
    $_ = &add_space_between($_, "label-g", "dst");
}

##################################################

sub gen_dsyn
{
    $_ = &add_brackets_around($_, "dsyn");
}

##################################################

sub gen_dtxt
{
#   we should have used a ts-g here ...!
    s|</tab><dtxt |</tab><z>;</z><dtxt |g; # mantis 1984 ...
    s|</tadv><dtxt |</tadv><z>;</z><dtxt |g; # mantis 1847 ...
    s|</tatpr><dtxt |</tatpr><z>;</z><dtxt |g;
    s|</tceq><dtxt |</tceq><z>;</z><dtxt |g; # mantis 1995 ...
    s|</tcf><dtxt |</tcf><z>;</z><dtxt |g; # mantis 1798 ...
    s|</tcu><dtxt |</tcu><z>;</z><dtxt |g; # mantis 1992 ...
    s|</tdef><dtxt |</tdef><z>;</z><dtxt |g; # mantis 1989 ...
    s|</tev><dtxt |</tev><z>;</z><dtxt |g; # mantis 1854 ...
    s|</tgr><dtxt |</tgr><z>;</z><dtxt |g; # mantis 1849 ...
    s|</tid><dtxt |</tid><z>;</z><dtxt |g; # mantis 1778 ...
    s|</treg><dtxt |</treg><z>;</z><dtxt |g; # mantis 1812 ...
    s|</ts><dtxt |</ts><z>;</z><dtxt |g; # mantis 1815 ...
    s|</tu><dtxt |</tu><z>;</z><dtxt |g; # mantis 2002 ...
    s|</xr><dtxt |</xr><z>;</z><dtxt |g; # mantis 1997 ...
    s|(<dtxt ([^>]*)type="gr"([^>]*)>)(.*?)(</dtxt>)| <z_gr_br>[</z_gr_br>\U$1\E<z_gr>$4</z_gr>\U$5\E<z_gr_br>]</z_gr_br>|gi; # as per engpor2e ...
    s|<z_gr_br>\]</z_gr_br><z>, </z> <z_gr_br>\[</z_gr_br>|<z>, </z>|g;
    s|</z_gr_br><z>, </z><DS |</z_gr_br><ds |g; # mantis 3178 ...
    s|<dtxt ([^>]*)>| <DTXT $1><z>\(</z>|g;
    s|</dtxt><t2 |</dtxt> <T2 |g; # mantis 2257 ...
    s|</dtxt>|<z>\)</z></DTXT>|g;
}

##################################################

sub gen_dvcadv
{
    $_ = &add_brackets_around($_, "dvcadv");
}

##################################################

sub gen_eb
{
}

##################################################

sub gen_ebi
{
}

##################################################

sub gen_ei
{
}

##################################################

sub gen_ei_g
{
    s|<ei-g ([^>]*)>| <EI-G $1><z_ei-g>/</z_ei-g>|g;
    s|</ei-g>|<z_ei-g>/</z_ei-g></EI-G>|g;
}

##################################################

sub gen_entry
{
    s|<entry([^>]*)academic="y"(.+)</h([em])?>|$&<z> &awlsym; </z>|g;
    if ($KEYSYM_BEFORE_H)
    {
	s|<entry([^>]*)core="y"(.*?)>|$&<z>&coresym; </z>|g;
    }
    else
    {
	s|<entry([^>]*)core="y"(.+)</hm?>|$&<z> &coresym; </z>|g;
    }
    s|</entry>|$&\n|g;
}

##################################################

sub gen_eph
{
    s|<eph ([^>]*)> *| <EPH $1><z>/</z>|g;
    s|</eph>|<z>/</z></EPH> |g;
    &gen_cut_ipa_hyphens;
}

##################################################

sub gen_er
{
}

##################################################

sub gen_esc
{
}

##################################################

sub gen_esu
{
}

##################################################

sub gen_etym
{
    s|<etym ([^>]*)>| <ETYM $1><z>&etymsym; </z>|g;
}

##################################################

sub gen_eu
{
}

##################################################

sub gen_eul
{
}

##################################################

sub gen_fc
#   z_fc tag allows blue punctuation ...
{
    s|<fc |<z_fc>, </z_fc><FC |g;
}

##################################################

sub gen_fce
{
}

##################################################

sub gen_fe
{
    if ($FE_BLUE_COMMA)
    {
	s|<fe |<z_fe>, </z_fe><FE |g;
    }

    s|<fe |<z>, </z><FE |g;
}

##################################################

sub gen_ff
{
    if ($FF_NO_TEXT_OR_BRACKETS)
    {
	s|<ff | <FF |g;
	s|</ff>|</FF>|g;
    }
    else
    {
	s|<ff ([^>]*)>| <FF $1><z>\(<z_ff>&z_abbr_of;</z_ff> </z>|g;
	s|</ff>|<z>\)</z></FF>|g;
    }
}

##################################################

sub gen_fh
#   z_fh tag allows blue punctuation ...
{
    s|<fh |<z_fh>, </z_fh><FH |g;
}

##################################################

sub gen_fm
{
}

##################################################

sub gen_fve
{
}

##################################################

sub gen_g
{
    s|</cf><g |</CF><z>;</z><g |g; # mantis 1941 ...
    s|</g><g |</G><z>, </z><G |g;
    s|</g><r |</G><z>, </z><R |g;
    s|</g><s |</G><z>, </z><S |g;
    s|</r><g |</R><z>, </z><G |g;
    s|<g brackets="n"(.*?)</g>| <G $1</G>|g; # mantis 2699
    s|</g>|<z>\)</z></G>|g;
    s|<g ([^>]*)>| <G $1><z>\(</z>|g;
}

##################################################

sub gen_gi
{
}

##################################################

sub gen_gl
{
    my($equals);
    my($bit, $res, $e);
    my(@BITS);
    $e = $_;
    $e =~ s|(<gl[ >].*?</gl>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    if ($GL_ADD_EQUALS)
    {
	$equals = "= ";
    }
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    if ($GL_ADD_BRACKETS)
	    {
		unless ($bit =~ m|\(|)
		{
		    $bit =~ s|<gl ([^>]*)>|<GL $1><z>\($equals</z>|g;
		    $bit =~ s|</gl>|<z>\)</z></GL>|g;
		}
	    }
	    elsif ($GL_ADD_EQUALS)
	    {
		unless ($bit =~ m|=|)
		{
		    $bit =~ s|<gl ([^>]*)>|<GL $1><z>=</z>|gi;
		}
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
    s| *(</e[^>]*>) *(<gl)|$1 $2|gi;
    s| *(<gl)| $1|gi;
}

##################################################

sub gen_gr
{
    $_ = &add_space_between($_, "gr", "cf");
    s|</gr><p |</gr><z>,</z><p |g;
    s|</gr><gr |</GR><z>,&nbthinsp;</z><GR |g;
    s|</gr>|<z_gr_br>\]</z_gr_br></GR>|g;
    s|<gr ([^>]*)>| <GR $1><z_gr_br>\[</z_gr_br>|g;
    s| *(</gr>) *(<label-g)|$1 $2|gi;
    s| *(</gr>) *(<def-g)|$1 $2|gi;
    s| *(</gr>) *(<vs-g)|$1 $2|gi;
}

##################################################

sub gen_h
{
    if (/<entry([^>]*)core="y"/)
    {
	s|<h ([^>]*)>|<h $1 core=\"y\">|g;
    }
    s|(</h>) *(<xr-g)|$1 $2|gi;
    s|(</h>) *(<label-g)|$1 $2|gi;
}

##################################################

sub gen_h_g
{
#   do nothing
}

##################################################

sub gen_h2
{
    s|<h2 |<z>, </z>$&|g;
    s|(</h2>) *(<xr-g)|$1 $2|gi;
}

##################################################

sub gen_he
{
    s|<he ([^>]*)>| <HE $1><z>\(<z_he>&z_gb;</z_he> &z_also; </z>|g;
    s|</he>|<z>\)</z></HE>|g;
    s|(</he>) *(<xr-g)|$1 $2|gi;
}

##################################################

sub gen_heading
{
#   do nothing
}

##################################################

sub gen_help
{
    if ($HELP_NEWLINE)
    {
	s|<help (.*?)>|<HELP $1><z>&helpsym;&nbsp;</z>|g;
    }
    else
    {
	s|<help ([^>]*)>| <HELP $1><z>&helpsym;&nbsp;</z>|g;
    }
}

##################################################

sub gen_hh
{
    s|</hh>|</HH> |g;
}

##################################################

sub gen_hm
{
    s|(</hm>) *(<xr-g)|$1 $2|gi;
}

##################################################

sub gen_hp
{
    s|<hp |/<HP |g;
}

##################################################

sub gen_hs
{
    s|</hs>|$& |g;
}

##################################################

sub gen_i
{
    s|(<i-g ([^>]*)>)<g ([^<]*)</g><i |$1<G $3</G> <I |g; # mantis 2547 ...
    s|</i><g ([^<]*)</g><i |</I><z_ig>; </z_ig><G $1</G> <I |g;
    s|</i> *<g ([^<]*)</g><y |</I><z_ig>; </z_ig><G $1</G> <Y |g; # mantis 2530 ...
    s|</y><g ([^<]*)</g><i |</Y><z_ig>; </z_ig><G $1</G> <I |g; # mantis 2585 ...
    s|</i><cm |</I><z_ig>; </z_ig><CM |g; # mantis 1790 ...
    s|</i><i |</I><z_ig>; </z_ig><I |g;
    s|</i><il |</I><z_ig>; </z_ig><IL |g; # mantis 2515 ...
    s|</il><i |</IL> <I |g;
    s|</i><y |</I><z_ig>; </z_ig><z_y>&z_us; </z_y><Y |g;
    if ($US_IPA_FIRST)
    {
	s|</y><i |</Y><z_ig>; </z_ig><z_i>&z_gb; </z_i><I |g;
    }
    else
    {
        s|</y><i |</Y><z_ig>, </z_ig><I |g;
    }
    &gen_cut_ipa_hyphens;
}

##################################################

sub gen_i_g
{
    s|<i-g ([^>]*)>| <I-G $1><z_i-g>/</z_i-g>|g;
    s|</i-g><if |<z_i-g>/</z_i-g></I-G><z>, </z><IF |g;
    s|</i-g><il |<z_i-g>/</z_i-g></I-G><z>, </z><IL |g;
    s|</i-g><v |<z_i-g>/</z_i-g></I-G><z>, </z><V |g;
    s|</i-g>|<z_i-g>/</z_i-g></I-G>|g;
}

##################################################

sub gen_id
{
    if ($IDSEP_CHAR =~ m|^ *$|)
    {
	$IDSEP_CHAR = ";";
    }
    s|</id><id |</ID><z>$IDSEP_CHAR </z><ID |g;
    s|</id>(<g ([^>]*)></g>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    s|</id>(<r ([^>]*)></r>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    s|</id>(<s ([^>]*)></s>)<id |</ID><z>$IDSEP_CHAR</z>$1 <ID |g; # mantis 2303 ...
    s|(</id>)(<label-g)|$1 $2|gi; 
}

##################################################

sub gen_id_g
{
    if ($IDG_NEWLINE)
    {
	s|</id-g><id-g |</ID-G><ID-G zp=\"y\" |g;
    }
    else
    {
	s|</id-g><id-g |</ID-G> &idsep; <ID-G |g;
    }
    if (($IDSYM_ICON) || ($IDG_SYMBOL_ALL))
    {
	if ($IDSYM_NEWLINE)
	{
	    s|<id-g ([^>]*multi=\"y[^>]*)>|<ID-G zp=\"y\" $1><z>&idsyms; </z>|g;
	    s|<id-g ([^>]*)>|<ID-G zp=\"y\" $1><z>&idsym; </z>|g;
	}
	else
	{
	    s|<id-g ([^>]*multi=\"y[^>]*)>| <ID-G $1><z>&idsyms; </z>|g;
	    s|<id-g ([^>]*)>| <ID-G $1><z>&idsym; </z>|g;
	}
    }
    s|(</sd-g>) *(<ids?-g) |$1$2 zp=\"y\" |g;
    if ($IDG_SEP){
	s|</id-g> <id-g |</id-g><z> &idsep; </z><id-g |gi;
    }
}

##################################################

sub gen_ids_g
{
    if (($IDSYMS_ICON) || ($IDG_SYMBOL_FIRST))
    {
	$_ = &add_idsym_symbols($_);
    }
}

sub add_idsym_symbols
{
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<ids-g[ >].*?</ids-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<id[ >].*<id[ >]|i)
	    {
		$bit =~ s|<ids-g ([^>]*)>| <IDS-G $1>&idsyms; |i;
	    }
	    else
	    {
		$bit =~ s|<ids-g ([^>]*)>| <IDS-G $1>&idsym; |i;
	    }
	    
	}
	$res .= $bit;
    }
    return $res;
}


##################################################

sub idxh
{
    s|<idxh .*?</idxh>( ?)||g;
}

##################################################

sub gen_if
{
    s|</g><if |</G> <IF |g;
    s|</r><if |</R> <IF |g; # mantis 2560 ...
    s|</s><if |</S> <IF |g; # mantis 2636 ...
    s|</if><g |</IF><z>, </z><G |g; # mantis 1788 ...
    s|</if><if |</IF><z>, </z><IF |g;
    s|</il><if |</IL> <IF |g;
    s|</if><il |</IF><z>, </z><IL |g;
    s| *<if | <IF |g;
}

##################################################

sub gen_if_g
{
    s|(</if-g><if-g ([^>]*)>)<g |$1<G |g; # mantis 2561 ...
    s|</if-g><if-g|</IF-G><z>, </z><IF-G|go;
    s|</if-g><cm>or</cm><if-g|</IF-G> <CM>or</CM> <IF-G|g;
}

##################################################

sub gen_ifs_g
{
#   no brackets if IFS-G within VS-G ...
    my(@BITS);
    my($bit);
    my($res);
    $_ =~ s|(<vs-g[ >].*?</vs-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $_);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit =~ s|</ifs-g>|</IFS-G>|go;
	    $bit =~ s|<ifs-g | <IFS-G |go;
	}
	$res .= $bit;
    }
    $_ = $res;
    s|(<ifs-g[^>]*>) *<il |$1<IL |gi;

    # I think the previous logic was wrong - FK
    s|</ifs-g>|<z>\)</z></IFS-G>|g;
    s|<ifs-g ([^>]*)>| <IFS-G $1><z>\(</z>|g;
}

##################################################

sub gen_il
{
    s|(/<\/[^>]*>)(<il )|$1<IL |gi;
    s|</il><il |</IL><z>, </z><IL |g; # mantis 2352 ...
    s|(<ifs-g ([^>]*)>)<il |$1<IL |gi;
    s|</il> *|</IL> |gi;
    s| *<il | <IL |g;
}

##################################################

sub gen_ill
{
}

##################################################

sub gen_ill_g
{
}

##################################################

sub gen_infl
{
}

##################################################

sub gen_inflection
{
}

##################################################

sub gen_l_g
{
    s|<l-g([^>]*) l="([a-z])"(.*?)>|<z_spc_pre> </z_spc_pre>$&<z_l>\($2\)</z_l><z_spc_post> </z_spc_post>|g;
}


##################################################

sub gen_label_g
{
    s|(</label-g>) *(<v)|$1 $2|gi;
}

##################################################

sub gen_n_g
{
    if ($NG_NEWLINE)
    {
	s|<n-g([^>]*) n="([0-9]+)"(.*?)>|$&<z_n>$2</z_n><z_spc_post> </z_spc_post>|g;
    }
    else
    {
	s|<n-g([^>]*) n="([0-9]+)"(.*?)>|<z_spc_pre> </z_spc_pre>$&<z_n>$2</z_n><z_spc_post> </z_spc_post>|g;
    }
}

##################################################

sub gen_n0_g
{
}

##################################################

sub gen_np
{
}

##################################################

sub gen_opp
{
    s|</g><opp |</g> <OPP |g;
    s|</r><opp |</r> <OPP |g;
    s|</opp><opp |</OPP><z>, </z><OPP |g;
    s|</opp><g |</OPP><z>,</z><g |g;
    s|</opp><r |</OPP><z>,</z><r |g;
}

##################################################

sub gen_opp_g
{
    s|<opp-g ([^>]*)><([grs]) ([^>]*)></\2>|<opp-g $1> <\U$2\E $3></\U$2\E> |g;
    s|<opp-g (.*?)>|<OPP-G $1><z>&oppsym; </z><z_opptext>OPP</z_opptext> |g;
}

##################################################

sub gen_pos
{
    s|</pos><pos |</POS><z>, </z><POS |g;
    s|<pos | <POS |g;
}

##################################################

sub gen_pos_g
{
    s| *(</pos-g>) *(<label-g[^>]*>) *|$1 $2|gi;
}

sub gen_p
{
    s|</p><p |</P><z>, </z><P |g;
    s|<p | <P |g;

#   spell out parts of speech in h-g in multi-pos entries ...

    if (/<p-g/i)
    {
	if ($POS_FULL)
	{
	    &gen_pos_full;
	}
    }
    s|(<p ([^>]*)p="(.*?))_FULL"|$1"|gi;
#   tag <z_p> within <p-g> ...
    my(@BITS);
    my($bit);
    my($res);
    s|<p-g .*?</p-g>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ m|<p-g|io)
	{
	    $bit =~ s|<z_p>|<z_p_in_p-g>|gio;
	    $bit =~ s|</z_p>|</z_p_in_p-g>|gio;
	}
	$res .= $bit;
    }

#   but not in dr-g within p-g ...

    $_ = $res;
    my(@BITS);
    my($bit);
    my($res);
    s|<dr-g .*?</dr-g>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
        if ($bit =~ m|<dr-g|io)
        {
            $bit =~ s|<z_p_in_p-g>|<z_p>|gio;
            $bit =~ s|</z_p_in_p-g>|</z_p>|gio;
        }
        $res .= $bit;
    }
    $_ = $res;

}

##################################################

sub gen_p_g
{
    if ($IS_DEFINED{"PG_SYMBOL"})
    {
	if ($PG_SYMBOL)
	{
	    s|<p-g (.*?)>|<P-G $1><z>&psym; </z>|g;
	}
    }
    else
    {
	s|<p-g (.*?)>|<P-G $1><z>&psym; </z>|g;
    }
    return unless ($HG_PSYM);
    my(@BITS);
    my($bit);
    my($res);
    s|<h-g .*?</h-g>|&split;$&&split;|i;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ m|<h-g|)
	{
	    $bit =~ s|<h-g(.*?)<p |<h-g$1<z> &psym;</z><p |;
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_para
{
}

##################################################

sub gen_patterns
{
}

##################################################

sub gen_pfv
{
#   do nothing ...
}

##################################################

sub gen_ph
{
    s|(<ph-g([^>]*)>)<ph |$1<PH |gi;
    s|</ph><ph |</PH><z>; </z><PH |g;
    s|<ph | <PH |g;
}

##################################################

sub gen_ph_g
{
    s|</ph-g><ph-g |</PH-G><z>; </z><PH-G |g;
    s|<ph-g |<z>: </z><PH-G |g;
}

##################################################

sub gen_phon_gb
{
    s|</phon-gb><g ([^<]*)</g><phon-gb |</PHON-GB><z>; </z><G $1</G> <PHON-GB |g;
    s|</phon-gb><phon-gb |</PHON-GB><z>; </z><PHON-GB |g;
    s|</phon-gb><il |</PHON-GB><z>; </z><IL |g; # mantis 2515 ...
    s|</phon-gb><phon-us |</PHON-GB><z>; <z_phon-us>&z_us;</z_phon-us> </z><PHON-US |g;
    if ($US_IPA_FIRST)
    {
	s|</phon-us><phon-gb |</PHON-US><z>; <z_phon-gb>&z_gb;</z_phon-gb> </z><PHON-GB |g;
    }
    else
    {
        s|</phon-us><phon-gb |</PHON-US><z>, </z><PHON-GB |g;
    }
}

##################################################

sub gen_phon_us
{
    s|</phon-us><cm |</PHON-US><z>; </z><CM |g; # mantis 1982 ...
    s|</phon-us><phon-us |</PHON-US><z>; </z><PHON-US |g;
    unless ($US_IPA_FIRST)
    {
	s|<phon-us |<z> <z_phon-us>&z_us;</z_phon-us> </z><PHON-US |g;
    }
}

##################################################

sub gen_pre
{
}

##################################################

sub gen_pt
{
    s|</pt><pt |</PT><z>,&nbthinsp;</z><PT |g;
    s|</pt>|<z_pt_br>\]</z_pt_br></PT>|g;
    s|<pt ([^>]*)>| <PT $1><z_pt_br>\[</z_pt_br>|g;
}

##################################################

sub gen_pv
{
    s|</tcf><pv |</TCF> <PV |g; # mantis 1973 ...
    s|</pv><pv |</PV><z>; </z><PV |g;
    s| *(</pv>) *(<def-g)|$1 $2|gi;
}

##################################################

sub gen_pv_g
{
    if ($PVG_NEWLINE)
    {
	s|</pv-g><pv-g |</PV-G><PV-G zp=\"y\" |g;
    }
    else
    {
	if ($PVG_SEP)
	{
	    s|</pv-g><pv-g |</PV-G> &pvsep; <PV-G |g;
	}
    }
    s|</pvp-g><pvp-g ([^>]*)>|</PVP-G><PVP-G  zp=\"y\" $1>|g; # should now be covered by the target_3b2.pl config file
    s|</pv-g><np */><pv-g |</PV-G><PV-G  zp=\"y\" |g;
    if ($PVSYMS_ICON)
    {
	unless (m|<pvs-g|i)
	{
	    $_ = &add_pvsym($_);
	}
    }
    s|(</sd-g>) *(<pvs?-g) |$1 $2 zp=\"y\" |g;
    if ($PVG_SEP)
    {
	s|</pv-g> *<pv-g |</pv-g><z> &pvsep; </z><pv-g |g;
    }
}


##################################################

sub gen_pvs_g
{
    my($bit, $res);
    my(@BITS);
    $e = $_;
    $e =~ s|(<pvs-g[ >].*?</pvs-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($bit =~ s|&fk;||gio)
	{
	    $ct = (s|(<pv-g)|$1|gi);
	    if (($PVSYMS_ICON) || ($PVG_SYMBOL_FIRST))
	    {
		if ($ct > 1)
		{
		    $bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsyms;</z>|;
		}
		else
		{
		    $bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsym;</z>|;
		}
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
}

sub add_pvsym
{
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<pvs-g[ >].*?</pvs-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<pv[ >].*<pv[ >]|i)
	    {
		$bit =~ s|(<pvs-g[^>]*>)| $1&pvsyms; |;
	    }
	    else
	    {
		$bit =~ s|(<pvs-g[^>]*>)| $1&pvsym; |;
	    }	    
	    if ($PVSYM_NEWLINE)
	    {
		$bit =~ s|(<pvs-g) |$1 zp=\"y\" |i;
	    }
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_pvp_g
{
}

##################################################

sub gen_pvpt
{
    s|</pvpt><pvpt |</PVPT><z>,&nbthinsp;</z><PVPT |g;
    s|</pvpt>|</PVPT><z>\]</z>|g;
    s|<pvpt |<z> \[</z><PVPT |g;
}

##################################################

sub gen_r
{
    s|</r><g |</R><z>, </z><G |g;
    s|</r><r |</R><z>, </z><R |g;
    s|</r><s |</R><z>, </z><S |g;
    s| *<r ([^>]*brackets="n".*?)</r>| <R $1</R>|g; 
    s|</r>|<z>\)</z></R>|g;
    s|<r ([^>]*)>| <R $1><z>\(</z>|g;
}

##################################################

sub gen_refl
{
}

##################################################

sub gen_refl_g
{
    s|<refl-g ([^>]*)>|<REFL-G zp=\"y\" $1><z>&reflsym; </z>|g;
}

##################################################

sub gen_reflp
{
    s|<reflp |/<REFLP |g;
}

##################################################

sub gen_root
{
#   do nothing
}

##################################################

sub gen_rv
{
    s|<rv | <RV |g;
}

##################################################

sub gen_s
{
    s|</s><g |</S><z>, </z><G |g;
    s|</s><r |</S><z>, </z><R |g;
    s|</s><s |</S><z>, </z><S |g;
    s|</s>|<z>\)</z></S>|g;
    s|<s ([^>]*)>| <S $1><z>\(</z>|g;
}

##################################################

sub gen_sd
{
}

##################################################

sub gen_sd_g
{
    if ($IS_DEFINED{"SD_SYMBOL"})
    {
	if ($SD_SYMBOL)
	{
	    s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym;&nbsp;</z>|g;
	}
    }
    else
    {
	s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym;&nbsp;</z>|g;
    }
}

##################################################

sub gen_set
{
}

##################################################

sub gen_stem2
#   z_stem2 tag allows blue punctuation ...
{
    s|<stem2 |<z_stem2>, </z_stem2><STEM2 |g;
}

##################################################

sub gen_sub
{
#   do nothing
}

##################################################

sub gen_sub_g
{
#   do nothing
}

##################################################

sub gen_subhead
{
}

##################################################

sub gen_suf
{
}

##################################################

sub gen_sym
{
    s|</sym>|<z>\)</z></SYM>|g;
    s|<sym ([^>]*)>| <SYM $1><z>\(</z><z_sym>&z_symb;</z_sym> |g;
}

##################################################

sub gen_syn
{
    s|</syn><g |</SYN><z> &synsep2; </z><G |g;
    s|</syn><r |</SYN><z> &synsep2; </z><R |g;
    s|</syn><s |</SYN><z> &synsep2; </z><S |g;
    s|</syn><u |</SYN><z> &synsep2;</z><u |g;
    s|</g><syn |</G> <SYN |g;
    s|</r><syn |</R> <SYN |g;
    s|</s><syn |</S> <SYN |g;
    s|</syn><syn |</SYN><z> &synsep; </z><SYN |g;
    s|</label-g><syn |</LABEL-G> <SYN |g;
}

##################################################

sub gen_syn_g
{
    s|<syn-g ([^>]*)><([grs]) |<syn-g $1><\U$2\E |g;
}

##################################################

sub gen_t2
{
    s|</tceq><t2 |</TCEQ><z>, </z><T2 |g; # mantis 2273 ...
    s|</tcfe><t2 |</TCFE><z>, </z><T2 |g;
    s|</tcf><t2 |</TCF><z>, </z><T2 |g; # mantis 2359 ...
    s|</tab><t2 |</tab><z>, </z><T2 |g; # mantis 2274 ...
    s|</tgr><t2 |</tgr><z>, </z><T2 |g;
    s|</tid><t2 |</tid><z>, </z><T2 |g;
    s|</treg><t2 |</treg><z>, </z><T2 |g; # mantis 2272 ...
    s|</t2><t2 |</T2><z>, </z><T2 |g;
    s|</ts><t2 |</TS><z>, </z><T2 |g;
}

##################################################

sub gen_t2_g
{
    s|<t2-g |<z>, </z><T2-G |g;
}

##################################################

sub gen_tab
{
    s|</tab><tg |</TAB><z>\),</z><tg |g; # mantis 2020 ...
    s|<(tab) ([^>]*)>| <\U\1\E $2><z>\(</z><z_tab>&z_abbr;</z_tab> |g;
    s|</(tab)>|<z>\)</z></\U\1\E>|g;
#    s|<tab ([^>]*)>| <TAB $1><z>\(</z><z_tab>&z_abbr;</z_tab> |g;
#    s|<z>)</z></tab>|</TAB> |g;
}

##################################################

sub gen_table
#   for HTML-style table ONLY ...
{
}

##################################################

sub gen_tadv
{
    s|</tadv><dlf |</tadv><z>;</z><dlf |g; # mantis 2008 ...
    s|</tadv><tg |</tadv><z>,</z><tg |g; # mantis 1993 ...
    s|</tadv><ts |</tadv><z>,</z><ts |g; # mantis 2015 ...
    s|<tadv (.*?)</tadv>(<i-g (.*?)</i-g>)|<z> (</z><z_tadv>&z_adv;</z_tadv> <TADV $1</TADV>$2<z>)</z>|g;
    s|<tadv (.*?)</tadv>|<z> (</z><z_tadv>&z_adv;</z_tadv> <TADV $1</TADV><z>)</z>|g; # mantis 1847 ...
}

##################################################

sub gen_tam
{
}

##################################################

sub gen_tamb
{
}

##################################################

sub gen_tarial
{
}

##################################################

sub gen_tatpr
{
    s|<tatpr ([^>]*)>| <TATPR $1><z>\(</z>|g;
    s|</tatpr>|<z>\)</z></TATPR>|g;
}

##################################################

sub gen_tceq
{
    s|</tceq><tg |</TCEQ><z>,</z><tg |g; # mantis 1817 ...
    s|</tceq><tceq |</TCEQ><z>, </z><TCEQ |g; # mantis 1793 ...
    s|<tceq |<z> &tceqsym; </z>$&|g;
}

##################################################

sub gen_tcf
{
    s|</treg><tcf |</treg><z>,</z><tcf |g;
    s|</tgr><tcf |</tgr><z>,</z><tcf |g; # mantis 2017 ...
    s|</tcf><tcf |</TCF><z>, </z><TCF |g;
    s|</tcf><tg |</tcf><z>,</z><tg |g; # mantis 1983 ...
    s|</tcf><ts |</TCF><z>, </z><TS |g; # mantis 1837 ...
##    s|</ts><tcf |</TS><z>, </z><TCF |g; # mantis 1990 ...
    s|</ts><tcf |</TS><z> </z><TCF |g; # mantis 1990 ...
    s|(<tcf ([^>]*)>)<ts |$1<TS |g;
    s|<tcf | <TCF |g;
}

##################################################

sub gen_tcfe
{
    s|</tcfe><tcfe |</TCFE><z>, </z><TCFE |g; # mantis 3271 ...
    s|<tcfe | <TCFE |g;
}

##################################################

sub gen_tcu
{
    s|</tcu><tev |</TCU><z>, </z><TEV |g;
    s|</tcu>|<z>\)</z></TCU>|g;
    s|<tcu ([^>]*)>| <TCU $1><z>\(</z>|g;
}

##################################################

sub gen_td
#   use for HTML-style table data ONLY ...
{
}

##################################################

sub gen_tdef
{
    s|<tdef | <TDEF |g;
}

##################################################

sub gen_teb
{
#   do nothing
}

##################################################

sub gen_tebi
{
#   do nothing
}

##################################################

sub gen_tei
{
#   do nothing
}

##################################################

sub gen_tel
{
    s|<(tel) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(tel)>|<z>\)</z></\U\1\E>|g;
#    s|<tel |<z> \(</z>$&|g;
#    s|</tel>|$&<z>\)</z>|g;
}

##################################################

sub gen_tev
{
    s|</treg><tev |</TREG><z>, </z><TEV |g;
    s|</tev><tev |</TEV><z>, </z><TEV |g; # mantis 2016 ...
    s|</tev><tg |</tev><z>,</z><tg |g; # mantis 2022 ...
    s|<(tev) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(tev)>|<z>\)</z></\U\1\E>|g;
#    s|</tev>|</TEV><z>\)</z>|g;
#    s|<tev |<z> \(</z><TEV |g;
}

##################################################

sub gen_tg
{
    s|</tg><tg |</TG><z>, </z><TG |g;
    s|</tg><treg |</TG><z>, </z><TREG |g;
    s|</treg><tg |</TREG><z>, </z><TG |g; # mantis 1853 ...
    s|<(tg) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(tg)>|<z>\)</z></\U\1\E>|g;
#    s|</tg>|</TG><z>\)</z>|g;
#    s|<tg |<z> \(</z><TG |g;
}
##################################################

sub gen_tgl
{
    s|<(tgl) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(tgl)>|<z>\)</z></\U\1\E>|g;
#    s|<tgl |<z> \(</z>$&|g;
#    s|</tgl>|$&<z>\)</z>|g;
}

##################################################

sub gen_tgr
{
    s|</tgr><tgr |</TGR><z>,&nbthinsp;</z><TGR |g;
    s|</tgr>|</TGR><z_tgr_br>\]</z_tgr_br>|g;
    s|<tgr | <z_tgr_br>\[</z_tgr_br><TGR |g;
}

##################################################

sub gen_th
#   for HTML-style table header ONLY ...
{
}

##################################################

sub gen_thm
{
}

##################################################

sub gen_tid
{
    s|</tid><tg |</TID><z>;</z><tg |g; # mantis 1851 ...
    s|</tev><tid |</tev><z>, </z><TID |g; # mantis 2023 ...
    s|</tid><tid |</TID><z>; </z><TID |g;
    s|</tid><t2 |</tid><z>, </z><T2 |g;
    s|<tid | <TID |g;
}

##################################################

sub gen_tif
{
    s|</tif><t2 |</TIF><z>, </z><T2 |g;
    s|</tif><tif |</TIF><z>, </z><TIF |g;
    s|</til><tif |</TIL> <TIF |g;
    s|<tif(.*?)>(.*?)</tif>| <TIF$1><z>\[</z>$2<z>\]</z></TIF> |g;
}

##################################################

sub gen_til
{
    s|<til | <TIL |g;
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

sub gen_tp
{
    s|<tp | <TP |g;
}

##################################################

sub gen_tph
{
    s|<tph | <TPH |g;
}

##################################################

sub gen_tr
#   use for HTML-style table row ONLY ...
{
}

##################################################

sub gen_treg
{
    s|</treg><treg |</TREG><z>, </z><TREG |g; # mantis 1976 ...
    s|<(treg) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(treg)>|<z>\)</z></\U\1\E>|g;
#    s|</treg>|</TREG><z>\)</z>|g;
#    s|<treg |<z> \(</z><TREG |g;
}

##################################################

sub gen_ts
{
    s|</treg><ts |</treg><z>,</z><ts |g; # mantis 1822 ...
#    s|(<ts([^>]*) t="(.*?)"(.*?))</ts>|$1, -$3</ts>|g; # commented by mantis 2234 ...
    s|(<ts([^>]*) t="([^"]+)"(.*?))(</ts>)|$1, -$3$5|gi; # mantis 2234 ...
    s|</ts><ts |</TS><z>, </z><TS |g; # requested for engpor2e ...
    s|<ts | <TS |g;
}

##################################################

sub gen_ts_g
{
    s|</t2-g><ts-g |</T2-G><z>; </z><TS-G |g;
    s|</ts-g><ts-g |</TS-G><z>; </z><TS-G |g;
    s|<ts-g (.*?)>|<z> &tssym; </z><TS-G $1>|g;
}

##################################################

sub gen_tu
{
    s|<(tu) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
    s|</(tu)>|<z>\)</z></\U\1\E>|g;
#    s|<tu |<z> \(</z><TU |g;
#    s|</tu>|</TU><z>\)</z>|g;
}

##################################################

sub gen_tx
{
    s|</tx><x |</TX><z> &xsep; </z><X |g;
    s|<tx | <TX |g;
}

##################################################

sub gen_u
{
    if ($U_SQUARE_BRACKETS)
    {
	s|<(u) ([^>]*)>| <\U\1\E $2><z>\[</z>|g;
	s|</(u)>|<z>\]</z></\U\1\E>|g;
#	s|<u |<z> \[</z><U |g;
#	s|</u>|</U><z>\]</z>|g;
    }
    else
    {
	s|<(u) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
	s|</(u)>|<z>\)</z></\U\1\E>|g;
#	s|<u |<z> \(</z><U |g;
#	s|</u>|</U><z>\)</z>|g;
    }
}

##################################################

sub gen_ud
{
    s|<ud | <UD |g;
}

##################################################

sub gen_un
#   for inline usage notes ...
{
    s| *(<un) | $1 |g;
}

##################################################

sub gen_unbox
#   for boxed usage notes ...
{
}

sub gen_usage
{
    if ($U_SQUARE_BRACKETS)
    {
	s|<usage ([^>]*>)|<USAGE $1<z> \[</z>|g;
	s|</usage>|<z>\]</z></USAGE>|g;
    }
    else
    {
	s|<usage ([^>]*>)|<USAGE $1<z> \(</z>|g;
	s|</usage>|<z>\)</z></USAGE>|g;
    }
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

sub gen_ungl
{
    if ($UNGL_ADD_BRACKETS)
    {
        s|<ungl |<z>\(=</z><UNGL |g;
	s|</ungl>|</UNGL><z>\)</z>|g;
    }
    s| *(<ungl)| $1|gi;
}

##################################################

sub gen_unp
{
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

sub gen_unx
{
    s|</unx><unx |</UNX><z> &xsep; </z><UNX |g;
    if ($UNX_COLON)
    {
	s|<unx |<z>: </z><UNX |g;
    }
    s|</unx><arbd1|</unx> <arbd1|g;

}

##################################################

sub gen_unxh
{
}

##################################################

sub gen_v
{
    s|</v><label-g |</V> <LABEL-G |g;
    s|</vs><v |</VS><z>, </z><V |g; # mantis 2658 ...
    s|</v><v |</V><z>, </z><V |g; # mantis 2296 ...
    s|</fe><v |</FE><z>, </z><V |g; # mantis 2001 ...
    s|</g><v |</G> <V |g;
    s|</r><v |</R> <V |g;
    s|</s><v |</S> <V |g;
    s|</v><g |</V><z>, </z><G |g; # mantis 1779 ...
    s|</v><r |</V><z>, </z><R |g; # mantis 1949 ...
}

##################################################

sub gen_vc
{
    s|</g><vc |</G> <VC |g;
}

##################################################

sub gen_ve
{
#   do nothing
}

##################################################

sub gen_vf
{
    s|</vf><vf |</VF><z>, </z><VF |g;
    s|</vs><vf |</VS><z>, </z><VF |g; # mantis 3009 ...
    s|</vf><vs |</VF><z>, </z><VS |g; # mantis 3009 ...
    s|</g><vf |</G> <VF |g;
    s|</r><vf |</R> <VF |g; # mantis 2842 ...
}

##################################################

sub gen_vs
{
    s|</vs><label-g |</VS> <LABEL-G |g;
    s|</vs><g |</VS> <G |g;
    s|</vs><vs |</VS><z>, </z><VS |g;
    s|</g><vs |</G> <VS |g;
    s|</r><vs |</R> <VS |g; # mantis 2374 ...
    s| *</label-g> *<vs |</label-g> <VS |gi;
}

##################################################

sub gen_vs_g
{
    s|<vs-g ([^>]*> *<label-g)| <VS-G $1|gi;
    s|<vs-g ([^>]*)><g ([^>]*)>| <VS-G $1><G $2><z>\(</z>|g;
    s|<vs-g ([^>]*)><r ([^>]*)>| <VS-G $1><R $2><z>\(</z>|g;
    s|<(vs-g) ([^>]*)>| <\U\1\E $2><z>\(</z><z_vs-g>&z_also;</z_vs-g> |g;
    s|(</dr>) *(<vs-g)|$1 $2|gi;
    s|(</h>) *(<vs-g)|$1 $2|gi;
    s|</(vs-g)>|<z>\)</z></\U\1\E>|g;
#    s|<vs-g ([^>]*)>|<VS-G $1><z> \(</z><z_vs-g>&z_also;</z_vs-g> |g;
#    s|</vs-g>|<z>\)</z></VS-G>|g;
}

##################################################

sub gen_wf_box
{
}

##################################################

sub gen_wf_g
{
}

##################################################

sub gen_wfo
{
    s| *<wfo ([^>]*)> *(.*?)</wfo>| <WFO $1><z>\(&\#x2260;</z> $2<z>\)</z></WFO>|g;
    s|<wfo | <WFO |g;
}

##################################################

sub gen_wfp
{
    s| *(<wfp[ >])| $1|gi;
    s|(</wfp>) *(<wfp)|$1<z>, </z>$2|gi;
}

##################################################

sub gen_wfw
{
    s|<wfw | <WFW |g;
}

##################################################

sub gen_wx
{
    s|</wx> *<wx |</WX><z> &xsep; </z><WX |g;
}

##################################################

sub gen_x
{
    my($nocolon) = @_;
    if ($CF_WITH_X)
    {
	s|</cf><cf |&cfpair;|g;
        s|(<cf ([^<]*)</cf>)(<x (.*?)>)|$3$1|g; # this line replaces following commented line - CF immediately followed by X ...
#	s|(<cf[ ](?:  (?!<d) . )*? </cf>)(<x[ ](.*?)>)|$2$1|gx; # added negative lookahead assertion [(?!<d)]  to stop the match between cf tags taking half the entry. Other tags mnight need to be added to this as alternates... TT 2009-06-05

    }

    s|</ts><dlf([^>]*)></dlf><x |</TS> <dlf$1></dlf><x |g; # mantis 1974 ...
    s|</tcf><dlf([^>]*)></dlf><x |</TCF> <dlf$1></dlf><x |g; # mantis 1974 ...
    unless (($APP) || ($nocolon))
    {
	s|(<x-g[^>]*> *)<x|$1<X|gi;
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
	s|</x><x |</X><z> &xsep; </z><X |g;
	s|</x> *<wx |</X><z> &xsep; </z><WX |g;
	s|</wx> *<x |</WX><z> &xsep; </z><X |g;
	# Prevent paragraphs from generating the colon
	s|(<para[^>]*>)<x |$1<X |g;
	s|(<[a-z] zp=\"y\"[^>]*>)<x |$1<X |g;
	s|<x |<z>: </z><X |g;
    }
    s|(<x ([^>]*)?>)(<cf (.*?)</cf>)|$3 $1|gi;
    s|(</x>)(<e[bir]i?)|$1 $2|g;

    s|&cfpair;|</cf><cf |g;

}

##################################################

sub gen_xh
{
    s|</xw><xh |</XW> <XH |g;
}

##################################################

sub gen_xhm
{
#   do nothing
}

##################################################

sub gen_xid
{
}

##################################################

sub gen_xp
{
    s|<xp |<z>&nbthinsp;</z>$&|g;
}

##################################################

sub gen_xpara
{
#   do nothing
}

##################################################

sub gen_xr
{
#   commas between same xr types ...
    s|(</xr>)(<xr[ >])|$1<z>, </z>$2|gi;
}

sub gen_xr_old
{
#   commas between same xr types ...
    &gen_add_xt_to_closer;
    if ($SEMICOLON_BEFORE_XT_SEE)
    {
	s|</xr xt="eq">(<xr ([^>]*)xt="see")|</XR><z>;</z>$1|g; # mantis 3180 ...
	s|</xr xt="o?cfe">(<xr ([^>]*)xt="see")|</XR><z>;</z>$1|g; # mantis 3098 ...
	s|</xr xt="useat">(<xr ([^>]*)xt="see")|</XR><z>;</z>$1|g; # mantis 3098 ...
	s|</xr xt="id">(<xr ([^>]*)xt="see")|</XR><z>;</z>$1|g; # mantis 3180 ...
    }
    s|</xr xt="(n?syn)"><xr ([^>]*)xt="(n?syn)"|</XR><z>, </z><XR_HIDE $2xt="$3"|g; # mantis 2519 ...
    s|</xr xt="(.*?)"><xr ([^>]*)xt="\1"|</XR><z>, </z><XR_HIDE $2xt="$1"|g;
#   conditional "idioms see also" generated text requires <xr xt="id_ALSO"> in attval file ...
    if ($ID_SEE_ALSO)
    {
	s|(</ids?-g>)<xr ([^>]*)xt=\"id\"|$1<xr $2xt=\"id_ALSO\"|gi; # mantis 4790 added "s?" ...
	unless (s|(</ids?-g>)<xr-g ([^>]*?)xt=\"id\"([^>]*?)><xr ([^>]*)xt=\"id\"|$1<xr-g $2xt=\"id_ALSO\"$3><xr $4xt=\"id_ALSO\"|gi)
	{  # mantis 4790 ...
	    s|(</ids?-g>)<xr-g \"([^>]*)><xr ([^>]*)xt=\"id\"|$1<xr-g $2xt=\"id_ALSO\"><xr $3xt=\"id_ALSO\"|gi; # mantis 4790 ...
	}
    }
#   "examples at" "and" text ...
    if ($EXAMPLES_AT_AND)
    {
	s|#|&temphash;|g;
	s|</xr (.*?)>|$&#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"exas\"([^\#]*)</xr xt=\"exas\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|#||g;
	s|&temphash;|#|g;
    }
#   conditional "illustrations at" generated text requires <xr xt="picat_PLURAL"> in attval file ...
    if ($ILLS_AT)
    {
	s|#|&temphash;|g;
	s|</xr (.*?)>|$&#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"picat\"([^\#]*)</xr xt=\"picat\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr ([^>]*)xt=\"picat\"([^\#]*)</XR>|<xr $1xt=\"picat_PLURAL\"$2</XR>|g;
	s|#||g;
	s|&temphash;|#|g;
    }
#   conditional "notes at" generated text requires <xr xt="useat_PLURAL"> in attval file ...
    if ($NOTES_AT)
    {
	s|#|&temphash;|g;
	s|</xr (.*?)>|$&#|gi;
	s|(<xr ([^>]*)xt=\"useat\"([^\#]*)</xr>)(<z>[^;])|$1#$4|gi; # mantis 3199 ...
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"useat\"([^\#]*)</xr xt=\"useat\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr (([^>]*)xt=\"useat\"([^\#]*)</XR><z>;</z>)|<XR_HIDE_USEAT $1|g; # mantis 3180 ...
	s|<xr ([^>]*)xt=\"useat\"([^\#]*)</XR>|<xr $1xt=\"useat_PLURAL\"$2</XR>|g;
	s|<XR_HIDE_USEAT|<xr|g; # mantis 3180 ...
	s|#||g;
	s|&temphash;|#|g;
    }
#   full point at end of last xr of type if attribute present ...
    s|#|&temphash;|g;
    s|</xr (.*?)>|$&#|gi;
    s|(<xr ([^>]*)fullpoint=\"y\"([^\#]*))</xr xt=\"(.*?)\">|$1<z>.</z></XR>|g;
    s|#||g;
    s|&temphash;|#|g;
    s|</xr xt=\"(.*?)\">|</XR>|g;
    s|<XR_HIDE |<xr |g;
    s| (xt=\"id)_ALSO\"| $1\"|gi;
    s| (xt=\"picat)_PLURAL\"| $1\"|gi;
    s| (xt=\"useat)_PLURAL\"| $1\"|gi;
    s|(</xr>)<z>;</z>(<xr ([^>]*)><z_xr>)|$1$2;|gi; # mantis 3098 ...
    s|</xr><z>\(</z><gl|</xr><z> \(</z><gl|g;
    s|</xr><gl|</xr> <gl|g;
    s|(</t?id>)(<xr-g)|$1 $2|gi; # FK ##OLD
}

sub gen_xr_g
{
#   full point at end of last xr of type if attribute present ...
    s|(<xr-g [^>]*fullpoint=\"y\".*?)(</xr-g>)|$1<z>.</z>$2|gi;
    s|</xr-g><z>\(</z>|</xr-g><z> \(</z>|g;
    s|</xr-g><gl|</xr-g> <gl|g;
    s|(</[^>]*-g>)(<xr-g)|$1 $2|gi; # FK
    s|(</ts>)(<xr-g)|$1 $2|gi; # FK
    s|(</tx>)(<xr-g)|$1 $2|gi; # FK
    s|(</t?id>)(<xr-g)|$1 $2|gi; # FK 
}

##################################################

sub gen_xs
{
    s|(<xs [^>]*>)|$1<z>&nbthinsp;\(</z>|g;
    s|(</xs>)|<z>\)</z>$1|g;
}

##################################################

sub gen_xt
{
    s|</unbox><xt |</unbox><XT |g; # mantis 2319 ...
    s|<xt | <XT |g; # mantis 2319 ...

    if ($XT_SYMBOL)
    {
	s|<XT |<z>&xrsym; </z><XT |g;
    }
}

##################################################

sub gen_xw
{
    s|</xw> *<xw([ >])|</XW><z>, </z><XW\1|gi;
}

##################################################

sub gen_y
{
    s|</y><y |</Y><z>; </z><Y |g;
    s|</y><g ([^<]*)</g><i |</Y><z>; </z><G $1</G> <I |g;
    s|</y><g ([^<]*)</g><y |</Y><z>; </z><G $1</G> <Y |g;
    unless ($US_IPA_FIRST)
    {
	s|<y |<z> <z_y>&z_us;</z_y> </z><Y |g;
    }
    &gen_cut_ipa_hyphens;
}

##################################################

sub gen_zd
{
}

##################################################

sub gen_zdp
{
    s|<zdp |/<ZDP |g;
}

##################################################

sub gen_zp_key
{
}

##################################################

sub gen_init
{
    s|\r||g;
#   cut comments etc ...
    s|<!--.*?-->||g;
    s|<\?.*?>||g;
    s|<hsrch>.*?</hsrch>||g;
#   next line allows for attributes on any start tag ...
    s|<([^/> ]+)>|<$1 >|g;
#   cut <d> ...
    if ($CUT_D)
    {
	s|<d .*?</d>||g;
    }
}

##################################################

sub gen_pre_tweak
{
#   add missing spaces ...

    s|([\)'0-9A-z;,])<([^/])|$1 <$2|g;
    s|</([^>]*)>([\('0-9A-z&])|</$1> $2|g;
    s|,<fm>|, <fm>|g;
    s|\.<fm |. <fm |g;

#   add temp end tags on empty elements ...

    s|<([^/ >]+) ([^>]*)/>|<$1 $2></$1>|g;

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
    &gen_stress_marks;

#   multiple discriminators ...
    if ($DLF_DS_SEPARATE)
    {
        s/<\/(dacadv|dnca|dncn|dnov|dnsv|dsyn|dtxt|dvcadv)><(dacadv|dnca|dncn|dnov|dnsv|dsyn|dtxt|dvcadv) /<\/\U$1\E><z>, <\/z><\U$2\E /g;
	s|</dlf><dlf |</DLF><z>, </z><DLF |g;
	s|</ds><ds |</DS><z>, </z><DS |g;
    }
    else
    {
        s/<\/(dacadv|dlf|dnca|dncn|dnov|dnsv|ds|dsyn|dtxt|dvcadv)><(dacadv|dlf|dnca|dncn|dnov|dnsv|ds|dsyn|dtxt|dvcadv) /<\/\U$1\E><z>, <\/z><\U$2\E /g;
    }
}

##################################################

sub gen_spaces
{
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

sub gen_tweak
{
#   lowercase tags ...
    s|<(.*?)>|\L$&\E|g;
#    merge duplicate z tags ...
    s|</(z[^>]*)><\1>||g;
#   remove empty z tags ...
    s|<(z[^>]*)></\1>||g;
#   tidy up start tags ...
####    s| +>|>|g;
#   tidy up line starts ...
    s|^(&split;)? +<|<|g;
    $_ = &gen_spaces($_);
    s|(</un[^>]*>)(<un)|$1 $2|gi; # mantis 2674 ...

    s|<z>\)\)|<z>\)|g;
    s|&mdash; <cl>|&mdash;<cl>|g;
    s|([\.\!\?])<gl|$1 <gl|g;
    s|&lsquo; <cl>|&lsquo;<cl>|g;
    s|</gl> &rsquo;</x>|</gl>&rsquo;</x>|g;
    s|</cl> &mdash;|</cl>&mdash;|g;
    s|</xr><dhb|</xr> <dhb|g; # mantis 2478 ...
    s|</xr><gl>|</xr> <gl>|g; # mantis 2653 ...
    s|</xr><xr |</xr> <xr |g; # mantis 2478 ...
    s|(\(</z><ifs-g><if-g>) |$1|g; # mantis 2636 ...
    s| (<xr ([^>]*)><z_xr><z_spc_pre> </z_spc_pre>)|$1|gi; # mantis 2669 ...
    s|</unx><arit1|</unx> <arit1|gi; # mantis 2679 ...
    s|</arbd1><ungl|</arbd1> <ungl|gi; # mantis 2690 ...
    s|</ei><z>\(|</ei> <z>\(|g; # mantis 3182 ...
    s|([\.\!\?])(<z[^>]*>)\(|$1 $2\(|g; # mantis 3182 ...
    s|([\.\!\?])<arbd|$1 <arbd|g; # mantis 2691 ...
    s| </z>, |</z>, |gi; # mantis 2694 ...
    s|</unwx><arbd|</unwx> <arbd|gi; # mantis 2703 ...
    s|</unwx><unei|</unwx> <unei|gi; # mantis 2703 ...
    s|</fm><ei|</fm> <ei|gi; # mantis 2709 ...
    s|</z>([a-z])|</z> $1|gi; # mantis 2701 ...
    s|</pre> |</pre>|gi; # mantis 2704 ...
    s| <suf>|<suf>|gi; # mantis 2704 ...
    s|\)</z><eb>|\) </z><eb>|gi; # mantis 2699 ...
    s|</unebi><z>\(|</unebi><z> \(|gi; # mantis 2752 ...
    s|</unei><z>\(|</unei><z> \(|gi; # mantis 2752 ...
    s|\]</z_gr_br>([a-z])|\]</z_gr_br> $1|gi; # mantis 2752 ...

    s|<z>\)</z>\(|<z>\)</z> \(|gi; # mantis 2752 ...
    s|</g><eb>|</g> <eb>|gi; # mantis 2699 ...

    unless ($NUMBERS_OK)
    {
	&gen_renumber_ng;
    }
    &gen_fix_ipa_colon; # mantis 2151 ...
    $_ = &lose_duplicate_attributes($_);
#    s|(\(</z><ifs-g([^>]*)><if-g([^>]*)><z>) \(|$1|g; # mantis 2635 ...
    s|<z></z>||g;
}

sub lose_duplicate_attributes
{
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
		    $ng =~ s|(<n-g([^>]*) n=")[0-9]+|<!--ng changed -->$1$expected|i unless ($NoNumChange);
		    $ng =~ s|<z_n>(.*?)</z_n>|<z_n>$expected</z_n>|i unless ($NoNumChange);
		}
		$expected++;
		if ($ng =~ /<(bf-g|dr-g|h-g|id-g|p-g|pv-g)/i)
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

##################################################

sub gen_add_xt_to_closer
{
    my(@BITS);
    my($bit);
    my($res);
    s|<xr .*?</xr>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ m|<xr([^>]*) (xt=".*?")|io)
	{
	    $xt = $2;
	    $bit =~ s|</xr>|</xr $xt>|io;
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_eltdicts_imgs
{
    s|&(awlsym);|<img src=\"\1.png\"/>|gio;
    s|&(blarrow);|<img src=\"\1.png\"/>|gio;
    s|&(careof);|c/o|gio;
    s|&(cfesep);|<img src=\"\1.png\"/>|gio;
    s|&(cfesym);|<img src=\"\1.png\"/>|gio;
    s|&(cfesyms);|<img src=\"\1.png\"/>|gio;
    s|&(clsym);|<img src=\"\1.png\"/>|gio;
    s|&(coresym);|<img src=\"\1.png\"/>|gio;
    s|&(crosssym);|<img src=\"\1.png\"/>|gio;
    s|&(csym);|<img src=\"\1.png\"/>|gio;
    s|&(drsym);|<img src=\"\1.png\"/>|gio;
    s|&(etymsym);|<img src=\"\1.png\"/>|gio;
    s|&(helpsym);|<img src=\"\1.png\"/>|gio;
    s|&(idsep);|<img src=\"\1.png\"/>|gio;
    s|&(idsym);|<img src=\"\1.png\"/>|gio;
    s|&(idsyms);|<img src=\"\1.png\"/>|gio;
    s|&(idssym);|<img src=\"\1.png\"/>|gio;
    s|&(notesym);|<img src=\"\1.png\"/>|gio;
    s|&(oppsym);|<img src=\"\1.png\"/>|gio;
    s|&p;|&\#x02C8;|gio;
    s|&(p_in_(.*?));|&\#x02C8;|gio;
    s|&(psym);|<img src=\"\1.png\"/>|gio;
    s|&(pvarr);|<img src=\"\1.png\"/>|gio;
    s|&(pvsep);|<img src=\"\1.png\"/>|gio;
    s|&(pvsym);|<img src=\"\1.png\"/>|gio;
    s|&(pvsyms);|<img src=\"\1.png\"/>|gio;
    s|&(reflsym);|<img src=\"\1.png\"/>|gio;
    s|&s;|&\#x02CC;|gio;
    s|&(s_in_(.*?));|&\#x02CC;|gio;
    s|&(sdsym);|<img src=\"\1.png\"/>|gio;
    s|&(synsep);|<img src=\"\1.png\"/>|gio;
    s|&(synsep2);|<img src=\"\1.png\"/>|gio;
    s|&(synsym);|<img src=\"\1.png\"/>|gio;
    s|&(taboo);|<img src=\"\1.png\"/>|gio;
    s|&(tceqsym);|<img src=\"\1.png\"/>|gio;
    s|&(ticksym);|<img src=\"\1.png\"/>|gio;
    s|&(tssym);|<img src=\"\1.png\"/>|gio;
    s|&(tusipa);|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|&(unsym);|<img src=\"\1.png\"/>|gio;
    s|&w;|&\#x00B7;|gio;
    s|&(w_in_(.*?));|&\#x00B7;|gio;
    s|&(xrsym);|<img src=\"\1.png\"/>|gio;
    s|&(xsym);|<img src=\"\1.png\"/>|gio;
    s|&(xsep);|<img src=\"\1.png\"/>|gio;
    s|&(xsym_first);|<img src=\"\1.png\"/>|gio;
}

sub gen_symbols_app
{
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
    if ($e =~ m|&[a-z]|i)
    {
	$_ = $e;
	&ents_to_unicode;
	$e = $_;
    }
    return $e;
}

sub gen_symbols_3b2
{
    s|&coresym;|&\#xE03A;|gio; #Core entry symbol (usually a key)
    s|&drsym;|&\#xE001;|gio; #Derivative symbol (usually a right-facing triangle)
    s|&drsyms;|&\#xE002;|gio; #Derivative group symbol (usually a right-facing triangle)
    s|&idsym;|&\#xE003;|gio; #Idiom symbol
    s|&idsyms;|&\#xE004;|gio; #Idiom group symbol
    s|&infosym;|&\#xE044;|gio; #Usage note Info symbol
    s|&oppsym;|&\#xE08C;|gio; #Cross reference opposite symbol
    s|&psym;|&\#xE005;|gio; #Part of speech marker
    s|&pvsym;|&\#xE005;|gio; #Phrasal verb symbol
    s|&pvsyms;|&\#xE006;|gio; #Phrasal verb group symbol
    s|&sdsym;|&\#xE000;|gio; #'Signpost' sense division symbol (usually a right-facing triangle)
    s|&synsym;|&\#xE08B;|gio; #Cross reference synonym symbol
    s|&uncultsym;|&\#xE040;|gio; #Usage note Culture symbol
    s|&undrsym;|&\#xE045;|gio; #Usage note Derivative symbol
    s|&ungramsym;|&\#xE041;|gio; #Usage note Grammar symbol
    s|&unhelpsym;|&\#xE042;|gio; #Usage note Help symbol
    s|&unmoresym;|&\#xE043;|gio; #Usage note More symbol
    s|&unsym;|&\#xE046;|gio; #Usage note Note symbol
    s|&untopicsym;|&\#xE03F;|gio; #Usage note Topic symbol
    s|&xrsym;|&\#xE08A;|gio; #Cross reference symbol
    s|&xsep;|&\#xE0CA;|gio; #Separator: examples (usually a solid diamond)
}

sub gen_eltdicts_symbols_old
{
    s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    s| &awlsym; |<z_spc_pre> </z_spc_pre><z_awlsym>w</z_awlsym><z_spc_post> </z_spc_post>|g;
#   cfesym is same symbol as idsym ...
    s| &csym; |<z_spc_pre> </z_spc_pre><z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    s|&csym; |<z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    s| &cfesym; |<z_spc_pre> </z_spc_pre><z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
    s|&cfesym; |<z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
#   cfesep - used between <id-g>s ...
    s| &cfesep; |<z_spc_pre> </z_spc_pre><z_cfesep>X</z_cfesep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
#   clsym uses same character position as unsym ...
    s|&clsym; |<z_clsym>A</z_clsym><z_spc_post> </z_spc_post>|g;
    s| &coresym; |<z_spc_pre> </z_spc_pre><z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    s|&coresym; |<z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    s| &crosssym; |<z_spc_pre> </z_spc_pre><z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    s|&crosssym; |<z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    s| &drsym; |<z_spc_pre> </z_spc_pre><z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    s|&drsym; |<z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    s| &drsep; |<z_spc_pre> </z_spc_pre><z_drsep>X</z_drsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s| &etymsym; |<z_spc_pre> </z_spc_pre><z_etymsym>e</z_etymsym><z_spc_post> </z_spc_post>|g;
    s|&helpsym;|<z_helpsym>h</z_helpsym>|g;
    s| &idsym; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    s| &idsym;|<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym>|g;
    s|&idsym; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    # Need to define these properly FK
    s| &idsyms; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    s|&idsyms; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
#   idsep - used between <id-g>s ...
    s| &idsep; |<z_spc_pre> </z_spc_pre><z_idsep>X</z_idsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s|&notesym;|<z_notesym>n</z_notesym>|g;
    s| &oppsym; |<z_spc_pre> </z_spc_pre><z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    s|&oppsym; |<z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    s|&psym;|<z_psym>S</z_psym>|g;
    s|&pvarr;|<z_pvarr>P</z_pvarr>|g;
    s| &pvsym; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    s|&pvsym; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    # Need to change this in the future FK
    s| &pvsyms; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    s|&pvsyms; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
#   pvsep - used between <id-g>s ...
    s| &pvsep; |<z_spc_pre> </z_spc_pre><z_pvsep>X</z_pvsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s|&reflsym; |<z_reflsym>r</z_reflsym><z_spc_post> </z_spc_post>|g;
    s|&sdsym;|<z_sdsym>b</z_sdsym>|g;
#   synsep - used between synonyms ...
    s| &synsep; |<z_spc_pre> </z_spc_pre><z_synsep>X</z_synsep><z_spc_post> </z_spc_post>|g;
#   synsep2 - used between groups of synonyms ...
    s| &synsep2; |<z_spc_pre> </z_spc_pre><z_synsep2>\|</z_synsep2><z_spc_post> </z_spc_post>|g;
#   synsym - used before first synonym ...
    s| &synsym; |<z_spc_pre> </z_spc_pre><z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g;
    s|&synsym; |<z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g; # mantis 5095 ...
    s|&taboo;|<z_taboosym>\!</z_taboosym>|g;
    s| &tceqsym; |<z_spc_pre> </z_spc_pre><z_tceqsym>=</z_tceqsym><z_spc_post> </z_spc_post>|g;
    s|&ticksym; |<z_ticksym>Y</z_ticksym><z_spc_post> </z_spc_post>|g;
    s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES)
    {
	&gen_bold_tildes;
    }
    s| &tssym; |<z_spc_pre> </z_spc_pre><z_tssym>t</z_tssym><z_spc_post> </z_spc_post>|g;
    s| &unsym; |<z_spc_pre> </z_spc_pre><z_unsym>A</z_unsym><z_spc_post> </z_spc_post>|g;
    s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    s| &xsym_first; |<z_spc_pre> </z_spc_pre><z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    s|&p_in_(.*?);|<p_in_$1>"</p_in_$1>|g;
    s|&s_in_(.*?);|<s_in_$1>%</s_in_$1>|g;
    s|&w_in_(.*?);|<w_in_$1>&w;</w_in_$1>|g;
    s| <z_spc_pre> |<z_spc_pre>|g;
    s| </z_spc_post><z> | </z_spc_post><z>|g;
    s| </z_spc_post></z><z> | </z_spc_post>|g;
    s| </z_spc_post> | </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post> |<z_spc_post> </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post></z><z><z_spc_pre> </z_spc_pre>|<z_spc_post> </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post></z><ts-g> |<z_spc_post> </z_spc_post></z><ts-g>|g;
}



sub gen_eltdicts_symbols_to_tags
{
    s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    s| &awlsym; |<z_spc_pre> </z_spc_pre><z_awlsym>w</z_awlsym><z_spc_post> </z_spc_post>|g;
#   cfesym is same symbol as idsym ...
    s| &csym; |<z_spc_pre> </z_spc_pre><z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    s|&csym; |<z_csym>c</z_csym><z_spc_post> </z_spc_post>|g;
    s| &cfesym; |<z_spc_pre> </z_spc_pre><z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
    s|&cfesym; |<z_cfesym>i</z_cfesym><z_spc_post> </z_spc_post>|g;
#   cfesep - used between <id-g>s ...
    s| &cfesep; |<z_spc_pre> </z_spc_pre><z_cfesep>X</z_cfesep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
#   clsym uses same character position as unsym ...
    s|&clsym; |<z_clsym>A</z_clsym><z_spc_post> </z_spc_post>|g;
    s| &coresym; |<z_spc_pre> </z_spc_pre><z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    s|&coresym; |<z_coresym>k</z_coresym><z_spc_post> </z_spc_post>|g;
    s| &crosssym; |<z_spc_pre> </z_spc_pre><z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    s|&crosssym; |<z_crosssym>N</z_crosssym><z_spc_post> </z_spc_post>|g;
    s| &drsym; |<z_spc_pre> </z_spc_pre><z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    s|&drsym; |<z_drsym>d</z_drsym><z_spc_post> </z_spc_post>|g;
    s| &drsep; |<z_spc_pre> </z_spc_pre><z_drsep>X</z_drsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s| &etymsym; |<z_spc_pre> </z_spc_pre><z_etymsym>e</z_etymsym><z_spc_post> </z_spc_post>|g;
    s|&helpsym;|<z_helpsym>h</z_helpsym>|g;
    s| &idsym; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    s| &idsym;|<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym>|g;
    s|&idsym; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    # Need to define these properly FK
    s| &idsyms; |<z_spc_pre> </z_spc_pre><z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
    s|&idsyms; |<z_idsym>i</z_idsym><z_spc_post> </z_spc_post>|g;
#   idsep - used between <id-g>s ...
    s| &idsep; |<z_spc_pre> </z_spc_pre><z_idsep>X</z_idsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s|&notesym;|<z_notesym>n</z_notesym>|g;
    s| &oppsym; |<z_spc_pre> </z_spc_pre><z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    s|&oppsym; |<z_oppsym>o</z_oppsym><z_spc_post> </z_spc_post>|g;
    s|&psym;|<z_psym>S</z_psym>|g;
    s|&pvarr;|<z_pvarr>P</z_pvarr>|g;
    s| &pvsym; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    s|&pvsym; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    # Need to change this in the future FK
    s| &pvsyms; |<z_spc_pre> </z_spc_pre><z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
    s|&pvsyms; |<z_pvsym>p</z_pvsym><z_spc_post> </z_spc_post>|g;
#   pvsep - used between <id-g>s ...
    s| &pvsep; |<z_spc_pre> </z_spc_pre><z_pvsep>X</z_pvsep><z_spc_post> </z_spc_post>|g; # same character as synsep ...
    s|&reflsym; |<z_reflsym>r</z_reflsym><z_spc_post> </z_spc_post>|g;
    s|&sdsym;|<z_sdsym>b</z_sdsym>|g;
#   synsep - used between synonyms ...
    s| &synsep; |<z_spc_pre> </z_spc_pre><z_synsep>X</z_synsep><z_spc_post> </z_spc_post>|g;
#   synsep2 - used between groups of synonyms ...
    s| &synsep2; |<z_spc_pre> </z_spc_pre><z_synsep2>\|</z_synsep2><z_spc_post> </z_spc_post>|g;
#   synsym - used before first synonym ...
    s| &synsym; |<z_spc_pre> </z_spc_pre><z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g;
    s|&synsym; |<z_synsym>s</z_synsym><z_spc_post> </z_spc_post>|g; # mantis 5095 ...
    s|&taboo;|<z_taboosym>\!</z_taboosym>|g;
    s| &tceqsym; |<z_spc_pre> </z_spc_pre><z_tceqsym>=</z_tceqsym><z_spc_post> </z_spc_post>|g;
    s|&ticksym; |<z_ticksym>Y</z_ticksym><z_spc_post> </z_spc_post>|g;
    s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES)
    {
	&gen_bold_tildes;
    }
    s| &tssym; |<z_spc_pre> </z_spc_pre><z_tssym>t</z_tssym><z_spc_post> </z_spc_post>|g;
    s| &unsym; |<z_spc_pre> </z_spc_pre><z_unsym>A</z_unsym><z_spc_post> </z_spc_post>|g;
    s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    s| &xsym_first; |<z_spc_pre> </z_spc_pre><z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z_spc_post> </z_spc_post>|g;
    s|&p_in_(.*?);|<p_in_$1>"</p_in_$1>|g;
    s|&s_in_(.*?);|<s_in_$1>%</s_in_$1>|g;
    s|&w_in_(.*?);|<w_in_$1>&w;</w_in_$1>|g;
    s| <z_spc_pre> |<z_spc_pre>|g;
    s| </z_spc_post><z> | </z_spc_post><z>|g;
    s| </z_spc_post></z><z> | </z_spc_post>|g;
    s| </z_spc_post> | </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post> |<z_spc_post> </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post></z><z><z_spc_pre> </z_spc_pre>|<z_spc_post> </z_spc_post>|g;
    s|<z_spc_post> </z_spc_post></z><ts-g> |<z_spc_post> </z_spc_post></z><ts-g>|g;
}

##################################################

sub gen_stress_marks
{
    my(@BITS);
    my($bit);
    my($res);
    my($tag);
#   next line assumes no embedded tags in element containing stress mark/wordbreak dot...
    s|<([^> ]+) ([^>]*)>([^<]*)&[psw];(.*?)</\1>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ m|&[psw];|)
	{
	    $bit =~ m|<([^> ]+)|;
	    $tag = $1;
	    unless ($tag =~ m/^(eph|entry|i|phon-gb|phon-us|y)$/)
	    {
#   keep the entities for the moment so extra tags don't interfere with punctuation ...
#   these are changed to tagged text later in subroutine "gen_eltdicts_symbols" ...
		$bit =~ s|&p;|&p_in_$tag;|g;
		$bit =~ s|&s;|&s_in_$tag;|g;
		if ($WORDBREAK_IN_CONTEXT)
		{
		    $bit =~ s|&w;|&w_in_$tag;|g;
		}
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
#   clean up any of above entities generated within attribute values ...
    while (s|(<([^>]+))&([psw])_in_.*?;|$1&$3;|g) {}
}

##################################################

sub gen_cut_ipa_hyphens
#   cut hyphens pre stress at start of print IPA ...
{
#    s/(<(eph|i|y) ([^>]*)>)\-(["%])/$1$4/gi; # commented - mantis 1826 ...
}

##################################################

sub gen_bold_tildes
{
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    $splits ="(cf|id|pv)"; # this based on ENGPOR2E requirements ...
    s/<$splits /&split;$&/goi;
    s/<\/$splits>/$&&split;/goi;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ /<$splits([ >])/i)
	{
	    $bit =~ s|<z_tilde|<z_bold_tilde|g;
	    $bit =~ s|</z_tilde>|</z_bold_tilde>|g;
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_fix_ipa_colon
{
    my(@BITS);
    my($bit);
    my($res);
    my($splits);
    $splits ="(eph|i|phon-gb|phon-us|y)";
    s/<$splits([ >])/&split;$&/goi;
    s/<\/$splits>/$&&split;/goi;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ /<$splits([ >])/i)
	{
	    $bit =~ s|\:|\;|g;
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_pos_full
{

#   requires <p p="xxx_FULL">...</p> in attval file ...

    my(@BITS);
    my($bit);
    my($res);
    s|<h-g .*?</h-g>|&split;$&&split;|gio;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ m|<h-g|io)
	{
	    $bit =~ s|(<p ([^>]*)p="(.*?))"|$1\_FULL"|gi;
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_expand_if
{
    m|<h ([^>]*)>(.*?)</h>|i;
    $head=$2;
    $head =~ s|<.*?>||g;
    $head =~ s|&[psw];||g;

    s|<if ([^>]*)>-bb-</if>|<if $1>$head###bing</if><if >$head###bed</if>|gi;
    s|<if ([^>]*)>-ck-</if>|<if $1>$head###king</if><if >$head###ked</if>|gi;
    s|<if ([^>]*)>-dd-</if>|<if $1>$head###ding</if><if >$head###ded</if>|gi;
    s|<if ([^>]*)>-gg-</if>|<if $1>$head###ging</if><if >$head###ged</if>|gi;
    s|<if ([^>]*)>-kk-</if>|<if $1>$head###king</if><if >$head###ked</if>|gi;
    s|<if ([^>]*)>-l-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    s|<if ([^>]*)>-ll-</if>|<if $1>$head###ling</if><if >$head###led</if>|gi;
    s|<if ([^>]*)>-m-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    s|<if ([^>]*)>-mm-</if>|<if $1>$head###ming</if><if >$head###med</if>|gi;
    s|<if ([^>]*)>-nn-</if>|<if $1>$head###ning</if><if >$head###ned</if>|gi;
    s|<if ([^>]*)>-p-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    s|<if ([^>]*)>-pp-</if>|<if $1>$head###ping</if><if >$head###ped</if>|gi;
    s|<if ([^>]*)>-rr-</if>|<if $1>$head###ring</if><if >$head###red</if>|gi;
    s|<if ([^>]*)>-s-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    s|<if ([^>]*)>-ss-</if>|<if $1>$head###sing</if><if >$head###sed</if>|gi;
    s|<if ([^>]*)>-t-</if>|<if $1>$head###ing</if><if >$head###ed</if>|gi;
    s|<if ([^>]*)>-tt-</if>|<if $1>$head###ting</if><if >$head###ted</if>|gi;
    s|<if ([^>]*)>-vv-</if>|<if $1>$head###ving</if><if >$head###ved</if>|gi;
    s|<if ([^>]*)>-zz-</if>|<if $1>$head###zing</if><if >$head###zed</if>|gi;

    if ($EXPAND_MORE_IF)
    {
	if ($head =~ s|woman$||)
	{
	    s|<if ([^>]*)>-women</if>|<if $1>$head###women</if>|g;
	}
	if ($head =~ s|man$||)
	{
	    s|<if ([^>]*)>-men</if>|<if $1>$head###men</if>|g;
	}
	if ($head =~ s|y$||)
	{
	    s|<if ([^>]*)>-ied</if>|<if $1>$head###ied</if>|g;
	    s|<if ([^>]*)>-died</if>|<if $1>$head###ied</if>|g;
	    s|<if ([^>]*)>-fied</if>|<if $1>$head###ied</if>|g;
	    s|<if ([^>]*)>-pied</if>|<if $1>$head###ied</if>|g;
	    s|<if ([^>]*)>-plied</if>|<if $1>$head###ied</if>|g;
	    s|<if ([^>]*)>-sied</if>|<if $1>$head###ied</if>|g;
	}
	s|(<if ([^>]*)wd="([^"]+)"([^>]*)>)\-([^<]+)</if>|$1$3</if>|g;
    }

    s|###||g;
}

##################################################

sub gen_xml_head
{
    print "<\?xml version=\"1.0\" encoding=\"utf-8\"\?>\n<batch>\n";
}

##################################################

sub gen_xml_output
{
    &ents_to_unicode;
}

##################################################

sub gen_xml_tail
{
    print "</batch>\n";
}

##################################################
# $e = &rename_tag_in_tag($e, $container, $oldtag, $newtag);
sub rename_tag_in_tag
{
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

sub gen_label_punc
{
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
	    if ($dict =~ m|ald8|i)
	    {
		$bit =~ s|(<label-g[^>]*>)(<[grs] [^>]*>[^<]*</[rgs]>) *(<cm [^>]*>[^<]*</cm>) *(<[grs] [^>]*>[^<]*</[rgs]>)(</label-g>)|$1\($2 $3 $4\) $5|gi;
	    }
	    else
	    {
		$bit =~ s|(<label-g[^>]*>)(<[grs] [^>]*>[^<]*</[rgs]>) *(<cm [^>]*>[^<]*</cm>) *(<[grs] [^>]*>[^<]*</[rgs]>)(</label-g>)|$1\($2\) $3 \($4\) $5|gi;
	    }
	    $bit =~ s|(<label-g[^>]*>)(<gr [^>]*>[^<]*</gr>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(<[grsu] [^>]*>[^<]*</[rgsu]>)(</label-g>)|$1\[$2\] \($3\) \($4\) $5|gi;
#(<g>US</g>) <cm>or</cm> (<r>old-fashioned</r>)
#<r>old-fashioned</r><g>Brit</g><r>informal</r>
#(<r>old-fashioned</r>) (<g>Brit</g> <r>informal</r>)
	    if ($bit =~ m| brackets=\"n\"|)
	    {
		$bit = $start;
	    }
	    unless ($bit eq $start)
	    {
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

sub gen_cut_bord
{
#   suppress elements marked bord="y" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)bord="y"([^>]*)/>||gi;
#   sort out n="1" followed by borderline n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) bord="y"|$3<n-g$4 n="2"$5bord="y"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)bord="y"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_oet
{
#   suppress elements marked pub="oet" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="oet"([^>]*)/>||gi;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="oet"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_sup
{
#   suppress elements marked sup="y" ...
    s| pub=\"sup\"| sup=\"y\"|g;
    s| del=\"y\"| sup=\"y\"|g;
#   empty elements ...
    s|<([^/ >]+) ([^>]*)sup="y"([^>]*)/>||gi;
#   and the rest ...
    s|<x ([^>]*)sup="y"([^>]*)>(.*?)</x><tx .*?</tx>||gi;
    s|<([^/ >]+) ([^>]*)sup="y"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_cd
{
#   suppress elements marked pub="cd" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="cd"([^>]*)/>||gi;
#   sort out n="1" followed by pub="cd" n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="cd"|$3<n-g$4 n="2"$5pub="cd"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="cd"([^>]*)>(.*?)</\1>||gi;
#   cut sets ...
    s|<set .*?>||g;
#   cut electronic ipa ...
    s|<ei-g .*?</ei-g>||g;
#   cut xw on id xrefs for book ...
    s|(<xr ([^>]*)xt="id"([^>]*)>)<xw>([^<]*?)</xw>|$1|g;
#   cut inflections ...
    s|<infl .*?</infl>||g;
#   cut sidepanel ...
    s|<sidepanel .*?</sidepanel>||g;
}

##################################################

sub gen_cut_digital
{
#   suppress elements marked pub="digital" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="digital"([^>]*)/>||gi;
#   sort out n="1" followed by pub="digital" n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="digital"|$3<n-g$4 n="2"$5pub="digital"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="digital"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_dvd
{
#   suppress elements marked pub="dvd" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="dvd"([^>]*)/>||gi;
#   sort out n="1" followed by pub="dvd" n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="dvd"|$3<n-g$4 n="2"$5pub="dvd"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="dvd"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_web
{
#   suppress elements marked pub="web" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="web"([^>]*)/>||gi;
#   sort out n="1" followed by pub="web" n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="web"|$3<n-g$4 n="2"$5pub="web"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="web"([^>]*)>(.*?)</\1>||gi;
}

##################################################

sub gen_cut_el
{
#   suppress elements marked pub="el" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="el"([^>]*)/>||gi;
#   sort out n="1" followed by pub="el" n="2" ...
    s|#|&temphash;|g;
    s|</n-g>|</n-g>#|gi;
    s|<n-g([^>]*) n="1"([^>]*)>([^\#]*)</n-g>\#<n-g([^>]*) n="2"([^>]*) pub="el"|$3<n-g$4 n="2"$5pub="el"|gi;
    s|</n-g>#|</n-g>|gi;
    s|&temphash;|#|g;
#   and the rest ...
    s|\#|&temphash;|gio;
    s|(</x>)|$1\#|gio;
    s|<x ([^>]*)pub="el"([^>]*)>([^\#]*)</x>\#<tx .*?</tx>||gi;
    s|\#||g;
    s|&temphash;|#|g;
    s|<([^/ >]+) ([^>]*)pub="el"([^>]*)>(.*?)</\1>||gi;
#   cut sets ...
    s|<set .*?>||g;
#   cut electronic ipa ...
    s|<ei-g .*?</ei-g>||g;
#   cut xw on id xrefs for book ...
    s|(<xr ([^>]*)xt="id"([^>]*)>)<xw>([^<]*?)</xw>|$1|g;
#   cut inflections ...
    s|<infl .*?</infl>||g;
#   cut sidepanel ...
    s|<sidepanel .*?</sidepanel>||g;
}

##################################################

sub gen_cut_pr
{
#   suppress elements marked pub="pr" ...
#   empty elements ...
    s|<([^/ >]+) ([^>]*)pub="pr"([^>]*)/>||g;
#   and the rest ...
    s|<([^/ >]+) ([^>]*)pub="pr"([^>]*)>(.*?)</\1>||g;
    if (0)
    {
#   cut print ipa ...
	s|<i-g.*?</i-g>||g;
    }
}


1;
