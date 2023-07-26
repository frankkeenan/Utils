#!/usr/local/bin/perl
#
# generic punctuation subroutines (not book or CD specific) ...
# load with
# require "/NEWdata/dicts/generic/progs/generic_pnc_app.pl";
# access programs 
# generic_pnc_app::gen_a();
#
# START TAGS are all referred to as "<tag "
# in this program - see subroutine gen_pre_tweak
#
# project specific changes can go in here if they are likely to apply universally
# but please comment these with a mantis issue number in case they need to be moved
# to punc_PROJECT.pl ...
#
# Input =
# Result =
# $Id: generic_pnc_app.pl,v 1.7 2013/07/23 10:41:04 keenanf Exp keenanf $
# $Log: generic_pnc_app.pl,v $
# Revision 1.7  2013/07/23 10:41:04  keenanf
# *** empty log message ***
#
# Revision 1.6  2012/07/10 13:35:51  hughsoni
#
#
##################################################

use Getopt::Std;
#use Smart::Comments '###';
require "/NEWdata/dicts/generic/progs/restructure.pl";
require "/data/dicts/generic/progs/ents_to_unicode.pl";

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
    s| pub="sup"| sup="y"|g;
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
#   cut print ipa ...
    if (m|<ei-g|i)
    {
	s|<i-g.*?</i-g>||g;
    }
}

##################################################

sub gen_a
{
    s|</a><a |</A><z>, </z><A |g;
    if ($A_ROUND_BRACKETS)
    {
	s|<(a) ([^>]*)>| <\U\1\E $2><z>\(</z>|g;
	s|</(a)>|<z>\)</z></\U\1\E>|g;
    }
    else
    {
	s|<a | <A |g;
    }
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<A |<a |g;
	while (/<a ([^>]*)q="(.*?)"/)
	{
	    $key = "a_q_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<a ([^>]*)q="(.*?)"(.*?)>|<a $1Q="$2"$3><z_a>$text </z_a>|;
	}
    }
}

##################################################

sub gen_ab
{
    s|</ab><ab |</AB><z>, </z><AB |g;
    s|<ab |<z> \(<z_ab>&z_abbr;</z_ab> </z><AB |g;
    s|</ab><tg |</AB><z>\),</z><tg |g; # mantis 2020 ...
    s|</ab>|</AB><z>) </z>|g;
}

##################################################

sub gen_adv
{
    s|<adv (.*?)</adv>(<i-g (.*?)</i-g>)?|<z> (</z><z_adv>&z_adv;</z_adv><z> </z><ADV $1</ADV>$2<z>)</z>|g;
}

##################################################

sub gen_alt
{
    s|</alt><alt |</ALT><z>, </z><ALT |g;
    if ($A_ROUND_BRACKETS)
    {
	s|<alt ([^>]*>)|<ALT $1<z> \(</z>|g;
	s|</alt>|<z>\)</z></ALT>|g;
    }
    else
    {
	s|<alt | <ALT |g;
    }
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<ALT |<alt |g;
	while (/<alt ([^>]*)q="(.*?)"/)
	{
	    $key = "alt_q_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<alt ([^>]*)q="(.*?)"(.*?)>|<alt $1Q="$2"$3>$text </alt>|;
	}
    }
    s|(</alt>)(<d[ >])|$1 $2|gi;
    s|(</alt>)(<label-g[ >])|$1 $2|gi;
}


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
    s|</atpr><p |</ATPR><z>, </z><P |g; # mantis 1963 ...
    s|<atpr |<z> </z><ATPR |g;
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<ATPR |<atpr |g;
	while (/<atpr ([^>]*)atpr="(.*?)"/)
	{
	    $key = "atpr_atpr_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<atpr ([^>]*)atpr="(.*?)"(.*?)>|<atpr $1ATPR="$2"$3><z_atpr>$text</z_atpr>|;
	}
    }
}

##################################################

sub gen_bf
{
    s|</bf><bf |</BF><z>; </z><BF |g; # mantis 2870 ...
    s|</cm><bf |</CM><z> </z><BF |g;
}

##################################################

sub gen_bf_g
{
    s|<bf-g |<zp_bf-g/><BF-G |g;
}

##################################################

sub gen_c
{
    s|</c><c |</C><z>, </z><C |gio;
    s|</fce><c |</FCE><z>, </z><C |gio; # mantis 1998 ...
    s|</c><v |</C><z>, </z><V |gio; # mantis 1845 ...
}

##################################################

sub gen_c_g
{
    s|</c-g><c-g |</C-G><z> </z><C-G |g;
    if ($CSYM_NEWLINE)
    {
        s|<c-g |<zp_c-g/><z>&csym; </z><C-G |g;
    }
    else
    {
        s|<c-g |<z> &csym; </z><C-G |g;
    }
    s|</sd-g><z> &csym;|</sd-g><zp_c-g/><z>&csym;|g;
}

##################################################

sub gen_cc
{
    s|<cc |<z> </z><CC |g;
}

##################################################

sub gen_cf
{
    s|</cf><cf |</CF><z>; </z><CF |g;
    s|</tadv><cf |</tadv><z>;</z><cf |g; # mantis 2003 ...
    s|</tcf><cf |</TCF><z>; </z><CF |g;
    s|</tgr><cf |</tgr><z>;</z><cf |g; # mantis 1986 ...
    s|</treg><cf |</treg><z>;</z><cf |g; # mantis 1996 ...
    s|<cf |<z> </z><CF |g;
}

##################################################

sub gen_cfe
{
    s|</cfe><cfe |</CFE><z>, </z><CFE |g;
}

##################################################

sub gen_cfe_g
{
    s|</cfe-g><cfe-g |</CFE-G><CFE-G |g;
    if (0)
    {
	if ($IDSEP)
	{
	    s|</cfe-g><z> </z><cfe-g |</cfe-g><z> &cfesep; </z><cfe-g |gi;
	}
    }
}

##################################################

sub gen_cfes_g
{
    s|<cfes-g([^>]*>)|<CFES-G$1<z>&cfesyms; </z>|g;
}

##################################################

sub gen_cl
{
    s|</cl><cl |</CL><z>, </z><CL |g;
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

    s|</label-g><cm>|</LABEL-G> <CM>$1</cm>|g;
    s|</cm><label-g>|</CM> </LABEL-G>|g;
    s|</g><cm>([^<]*)</cm><g |</G><z> </z><CM>$1</cm><g |g;
    s|</g><cm ([^<]*)</cm><g |</G><z> </z><CM $1</cm><g |g;
    s|</g><cm>([^<]*)</cm><r |</G><z> </z><CM>$1</cm><r |g;
    s|</g><cm ([^<]*)</cm><r |</G><z> </z><CM $1</cm><r |g;
    s|</g><cm>([^<]*)</cm><s |</G><z> </z><CM>$1</cm><s |g;
    s|</g><cm ([^<]*)</cm><s |</G><z> </z><CM $1</cm><s |g;
    s|</a><cm>([^<]*)</cm><a |</A><z> </z><CM>$1</CM><z> </z><A |g;
    s|</r><cm>([^<]*)</cm><r |</R><z> </z><CM>$1</cm><z> </z><R |g;
    s|</s><cm ([^<]*)</cm><r |</S><z> </z><CM $1</cm><z> </z><R |g;
    s|</s><cm ([^<]*)</cm><s |</S><z> </z><CM $1</cm><s |g;
    s|</s><cm>([^<]*)</cm><s |</S><z> </z><CM>$1</cm><s |g;
    s|</if-g><cm ([^<]*)</cm><if-g |</IF-G><z> </z><CM $1</cm><z> </z><IF-G |g;
    s|</if-g><cm>([^<]*)</cm><if-g |</IF-G><z> </z><CM>$1</cm><z> </z><IF-G |g;
    s|</cm><label-g |</CM><z> </z><LABEL-G |g;
    s|</cm><g |</CM><z> </z><G |g;
    s|</cm><r |</CM><z> </z><R |g;
    s|</cm><s |</CM><z> </z><S |g;
    s|</cm><i |</CM><z> </z><I |g;
    s|</cm><if |</CM><z> </z><IF |g;
    s|</ei-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</ei-g></if-g></ifs-g><z> </z><CM $1</CM><ifs-g |g; # mantis 2564 ...
    s|</i-g></if-g></ifs-g><cm ([^<]*)</cm><ifs-g |</i-g></if-g></ifs-g><z> </z><CM $1</CM><ifs-g |g; # mantis 2564 ...
    s|</cm><ifs-g |</CM><z> </z><IFS-G |g; # mantis 2610 ...
    s|</dtxt><cm |</dtxt><z> </z><CM |g; # mantis 2355 ...
    s|</gr><cm |</gr><z> </z><CM |g; # mantis 2355 ...
    s|</i-g><cm |</i-g><z> </z><CM |g; # mantis 2355 ...
    s|</if><cm |</IF><z> </z><CM |g;
    s|</il><cm |</IL><z> </z><CM |g; # mantis 1969 ...
    s|</r><cm |</R><z> </z><CM |g; # mantis 1862 ...
    s|</s><cm>([^<]*)</cm><s |</S><z> </z><CM>$1</cm><S |g;
    s|</s><cm ([^<]*)</cm><s |</S><z> </z><CM $1</cm><S |g;
    s|</y><cm |</Y><z>; </z><CM |g; # mantis 1982 ...
    s|</xh><cm |</XH><z> </z><CM |g;
    s|</cm><xh |</CM><z> </z><XH |g;
    s|</a><cm |</A><z> </z><CM |g; # mantis 2610 ...
    s|</ifs-g><cm |</IFS-G><z> </z><CM |g; # mantis 2610 ...
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
		$bit =~ s|<d |<z> </z><D |g;
	    }
	    else
	    {
		$bit =~ s|<d |<D display=\"block\" |g;
#		$bit =~ s|<d |<zp_d/><D |g;
	    }
	    $res .= $bit;
	}
	$_ = $res;
    }
    else
    {
	s|<d |<z> </z><D |g;
    }
    s|(</cf>) *(<d[ >])|$1 $2|gi;
}

##################################################

sub gen_dacadv
{
    s|<dacadv |<z> \(</z><DACADV |g;
    s|</dacadv>|</DACADV><z>\)</z>|g;
}

##################################################

sub gen_dc
{
    s|</dc>|</DC><z>\)</z>|g;
    s|<dc |<z> \(</z><DC |g;
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
    s|</dhs>|</DHS><z>&rsquo;</z>|g;
    s| ?<dhs | <z>&lsquo;</z><DHS |g;
}

##################################################

sub gen_dlf
{
    s|</tgr><dlf |</tgr><z>;</z><dlf |g; # mantis 1823 ...
    s|</dlf>|</DLF><z>\)</z>|g;
    s|<dlf |<z> \(</z><DLF |g;
#   insert expansion text ...
    unless ($EXPANSION_DONE){

	s|<DLF |<dlf |g;
	if (m|<dlf [^>]*dlf=|)
	{
	    while (/<dlf ([^>]*)dlf="(.*?)"/)
	    {
		$key = "dlf_dlf_$2";
		$text = $ATT{$key};
		if ($text =~ m|^ *$|i) {
		    $ATT_ERRS{$key} = 1;	  
		}
		s|<dlf ([^>]*)dlf="(.*?)"(.*?)>|<dlf $1DLF="$2"$3><z_dlf>$text</z_dlf>|;
	    }
	}
	else
	{
	    s|<(dlf[ >])|<z_$1|gio;
	    s|</(dlf[ >])|</z_$1|gio;
	}
    }
}

##################################################

sub gen_dnca
{
    s|<dnca |<z> \(</z><DNCA |g;
    s|</dnca>|</DNCA><z>\)</z>|g;
}

##################################################

sub gen_dncn
{
    s|<dncn |<z> \(</z><DNCN |g;
    s|</dncn>|</DNCN><z>\)</z>|g;
}

##################################################

sub gen_dnov
{
    s|<dnov |<z> \(</z><DNOV |g;
    s|</dnov>|</DNOV><z>\)</z>|g;
}

##################################################

sub gen_dnsv
{
    s|<dnsv |<z> \(</z><DNSV |g;
    s|</dnsv>|</DNSV><z>\)</z>|g;
}

##################################################

sub gen_dr
{
    s|</dr><dr |</DR><z>, </z><DR |gio;
}

##################################################

sub gen_dr_g
{
    if (0)
    {
	s|<dr-g([^>]*)academic="y"(.*?)</dr>|$&<z> &awlsym; </z>|g;
	s|<dr-g>|<dr-g >|gi;
	s|<dr-g( [^>]*>)|<DR-G $1<z>&drsym; </z>|gi;
    }
    $_ = &do_gen_drg($_);
    return;
}

sub do_gen_drg
{
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<dr-g[ >].*?</dr-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<dr-g([^>]*)academic="y"|i)
	    {
		$bit =~ s|(</dr>)|$1<z> &awlsym; </z>|i;
	    }
	    $bit =~ s|(<dr[ >])|<z>&drsym; </z>$1|i;
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
    my($attrib);
    s|</ts><ds |</ts><z>;</z><ds |g; # mantis 1811 ...
    s|</tcf><ds |</tcf><z>;</z><ds |g; # mantis 1946 ...
    s|</tgr><ds |</tgr><z>;</z><ds |g; # mantis 2006 ...
    s|</treg><ds |</treg><z>;</z><ds |g; # mantis 2004 ...
    s|</ds><ds([ >])|</DS><z>, </z><DS\1|gi;
    s|</ds>|</DS><z>\)</z>|g;
    s|<ds |<z> \(</z><DS |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<DS |<ds |g;
	while (/<ds ([^>]*)ds="(.*?)"/)
	{
	    $attrib = $2;
	    $key = "ds_ds_$attrib";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    warn "not defined: ds = $attrib\n" if ($text !~/[a-z]/i);
	    s|<ds ([^>]*)ds="(.*?)"(.*?)>|<ds $1DS="$2"$3><z_ds>$text</z_ds>|;
	}
    }
}
##################################################

sub gen_dst
{
    s|<dst |<z> \(</z>$&|g;
    s|</dst>|$&<z>\)</z>|g;
}

##################################################

sub gen_dsyn
{
    s|<dsyn |<z> \(</z><DSYN |g;
    s|</dsyn>|</DSYN><z>\)</z>|g;
}

##################################################

sub gen_dtxt
{
#   we should have used a ts-g here ...!
    s|(<label-g[^>]*>)<dtxt([^>]*>[^>]*)</dtxt *>(</label-g>)| $1<z>\(</z><DTXT$2</DTXT><z>\)</z>$3 |gi;
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
    s|(<dtxt ([^>]*)type="gr"([^>]*)>)(.*?)(</dtxt>)|<z> </z><z>\[</z>\U$1\E<z_gr>$4</z_gr>\U$5\E<z>\]</z>|gi; # as per engpor2e ...
    s|<z>\]</z><z>, </z><z> </z><z>\[</z>|<z>, </z>|g;
    s|</z><z>, </z><DS |</z><ds |g; # mantis 3178 ...
    s|<dtxt |<z> \(</z><DTXT |g;
    s|</dtxt><t2 |</dtxt><z> </z><T2 |g; # mantis 2257 ...
    s|</dtxt>|</DTXT><z>\)</z>|g;
}

##################################################

sub gen_dvcadv
{
    s|<dvcadv |<z> \(</z><DVCADV |g;
    s|</dvcadv>|</DVCADV><z>\)</z>|g;
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
    my($style) = @_;
    my($bit, $res);
    my(@BITS);
    $e = $_;
    $e =~ s|(<ei-g[ >].*?</ei-g>)|&split;&fk;$1&split;|gio;
    $e =~ s|<ei-g>|<ei-g type=\"_full\">|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($bit =~ s|&fk;||gio)
	{
	    $type = "";
	    if ($bit =~ m| type=\"(.*?)\"|)
	    {
		$type = $1;
	    }
	    else
	    {
		$type = "_full";
	    }
	    if ($type =~ m|_full|)
	    {
		# standard behaviour - put slashes inside the ei-g
		if ($bit =~ m| slashes=\"n|i)
		{
		    $bit =~ s|<ei-g( .*?>)| <EI-G$1<z> </z>|g;
		    $bit =~ s|</ei-g>|</EI-G> |g;
		}
		else
		{
		    if ($style =~ m|inline|i)
		    {
			$bit =~ s|<ei-g( .*?>)| <EI-G$1<z>/</z>|g;
			$bit =~ s|</ei-g>|<z>/</z></EI-G> |g;
		    }		# 
		    else
		    {
			$bit =~ s|<ei-g( .*?>)| <EI-G$1<z>/</z>|g;
			$bit =~ s|</ei-g>|<z>/</z></EI-G> |g;
		    }
		}
	    }
	    elsif ($type =~ m|example|)
	    {
		# don't want the phon-gb or phon-us to generate text
		$bit =~ s|<phon| <PHON|g;
		$bit =~ s|<ei-g| <EI-G|;
		$bit =~ s|</ei-g>|</EI-G> |;
	    }
	    else
	    {
		$bit =~ s|<ei-g| <EI-G|;
		$bit =~ s|</ei-g>|</EI-G> |;
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_entry
{
    s|<entry([^>]*)academic="y"(.+)</h([em])?>|$&<z> &awlsym; </z>|g;
    if ($KEYSYM_BEFORE_H)
    {
	s|(<entry[^>]*core="y".*?)(<h[ >])|$1&coresym; $2|gi;
    }
    else
    {
	s|<entry([^>]*)core="y"(.+)</hm?>|$&<z> &coresym; </z>|g;
    }
    s|</entry>|$&\n|g;

#   insert expansion text for "usage note entries" (as found in AMESS) ...
    s|<ENTRY |<entry |g;
    while (/<entry ([^>]*)boxtype="(.*?)"/)
    {
        $key = "entry_boxtype_$2";
	$text = $ATT{$key};
	if ($text =~ m|^ *$|i) {
	    $ATT_ERRS{$key} = 1;	  
	}
	s|<entry ([^>]*)boxtype="(.*?)"(.*?)>|<entry $1BOXTYPE="$2"$3><z_unbox>$text</z_unbox>|;
	s|<z_unbox>&TAB;|<z_unbox tab="y">|g;
    }

}

##################################################

sub gen_eph
{
    s|<eph |<z> /</z><EPH |g;
    s|</eph>|</EPH><z>/ </z>|g;
    &gen_cut_ipa_hyphens;
}

##################################################

sub gen_er
{
}

##################################################

sub gen_esc
{
    s| *(</ei>) *(<esc[^>]*>) *|\1 \2|gi;
    s| *(</eb>) *(<esc[^>]*>) *|\1 \2|gi;
}

##################################################

sub gen_esu
{
}

##################################################

sub gen_etym
{
    s|(<etym [^>]*>)|$1<z> &etymsym; </z>|g;
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
	s|<ff |<z> </z><FF |g;
	s|</ff>|</FF>|g;
    }
    else
    {
	s|<ff |<z> \(<z_ff>&z_abbr_of;</z_ff> </z><FF |g;
	s|</ff>|</FF><z>\)</z>|g;
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
    s|</cf>(<label-g[^>]*><g )|</CF><z>; </z>$1|g; 
    s|</g><g |</G><z>, </z><G |g;
    s|</g><r |</G><z>, </z><R |g;
    s|</g><s |</G><z>, </z><S |g;
    s|</r><g |</R><z>, </z><G |g;
    if (0) # let label-g deal with brackets
    {
	s|<g brackets="n"(.*?)</g>|<z> </z><G $1</G>|g; # mantis 2699
	s|</g>|</G><z>\)</z>|g;
	s|<g |<z> \(</z><G |g;
    }
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<G |<g |g;
	while (/<g ([^>]*)g="(.*?)"/)
	{
	    $key = "g_g_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<g ([^>]*)g="(.*?)"(.*?)>|<g $1G="$2"$3><z_g>$text</z_g>|;
	}
	$_ = &add_labelg_brackets($_);
    }
}

sub add_labelg_brackets
{
    my($e) = @_;
    my($res, $eid);	
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<label-g[ >].*?</label-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $brackets = restructure::get_tag_attval($bit, "label-g", "brackets"); 
	    unless ($brackets eq "n")
	    {
		$bit =~ s|(<label-g[^>]*>)(<g )|$1<z> \(</z><G |gio;
		$bit =~ s|</z_g></label-g>|</z_g><z>\) </z></label-g>|gio;
		$bit =~ s|</g></label-g>|</g><z>\) </z></label-g>|gio;
	    }
	}
	$res .= $bit;
    }    
    return $res;
}


##################################################

sub gen_gi
{
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<GI |<gi |g;
	while (/<gi ([^>]*)gi="(.*?)"/)
	{
	    $key = "gi_gi_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<gi ([^>]*)gi="(.*?)"(.*?)>|<gi $1GI="$2"$3><z_gi>$text</z_gi>|;
	}
    }
}

##################################################

sub gen_gl
{
    if ($GL_ADD_BRACKETS)
    {
	s|<gl |<z>\(</z><GL |g;
	s|</gl>|</GL><z>\)</z>|g;
    }
    if ($GL_ADD_EQUALS)
    {
	s|<gl |<z>=</z><gl |gi;
    }
}

##################################################

sub gen_gr
{
    s|</gr><p |</gr><z>,</z><p |g;
    s|</gr><gr |</GR><z>, </z><GR |g;
    s|</gr>|</GR><z>\]</z>|g;
    s|<gr |<z> </z><z>\[</z><GR |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<GR |<gr |g;
	while (/<gr ([^>]*)gr="(.*?)"/)
	{
	    $key = "gr_gr_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<gr ([^>]*)gr="(.*?)"(.*?)>|<gr $1GR="$2"$3><z_gr>$text</z_gr>|;
	}
    }
}

##################################################

sub gen_h
{
    if (/<entry([^>]*)core="y"/)
    {
	$_ = restructure::set_tag_attval($_, "h", "core", "y");
    }
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
}

##################################################

sub gen_he
{
    s|<he |<z> \(<z_he>&z_gb;</z_he> &z_also; </z>$&|g;
    s|</he>|$&<z>\)</z>|g;
}

##################################################

sub gen_heading
{
#   do nothing
}

##################################################

sub gen_help
{
    s|<help (.*?)>|<HELP $1><z>&helpsym;&nbsp;</z>|g;
}

##################################################

sub gen_hh
{
    s|</hh>|</HH><z> </z>|g;
}

##################################################

sub gen_hm
{
#   do nothing
    s|(</hm>) *(<gram-g)|\1 \2|gi;
}

##################################################

sub gen_hp
{
    s|<hp |/<HP |g;
}

##################################################

sub gen_hs
{
    s|</hs>|$&<z> </z>|g;
}

##################################################

sub gen_i
{
    s|(<i-g ([^>]*)>)<g ([^<]*)</g><i |$1<G $3</G><z> </z><I |g; # mantis 2547 ...
    s|</i><g ([^<]*)</g><i |</I><z>; </z><G $1</G><z> </z><I |g;
    s|</i> *<g ([^<]*)</g><y |</I><z>; </z><G $1</G><z> </z><Y |g; # mantis 2530 ...
    s|</y><g ([^<]*)</g><i |</Y><z>; </z><G $1</G><z> </z><I |g; # mantis 2585 ...
    s|</i><cm |</I><z>; </z><CM |g; # mantis 1790 ...
    s|</i><i |</I><z>; </z><I |g;
    s|</i><il |</I><z>; </z><IL |g; # mantis 2515 ...
    s|</il><i |</IL><z> </z><I |g;
    s|</i><y |</I><z>; <z_y>&z_us;</z_y> </z><Y |g;
    if ($US_IPA_FIRST)
    {
	s|</y><i |</Y><z>; <z_i>&z_gb;</z_i> </z><I |g;
    }
    else
    {
        s|</y><i |</Y><z>, </z><I |g;
    }
    &gen_cut_ipa_hyphens;
}

##################################################

sub gen_i_g
{
    my($default) = @_;
    my($bit, $res, $default);
    my(@BITS);
    $e = $_;
    $e =~ s|(<i-g[ >].*?</i-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($bit =~ s|&fk;||gio)
	{
	    $type = $default;
	    if ($bit =~ m| type=\"(.*?)\"|)
	    {
		$type = $1;
	    }
	    if ($type =~ m|_full|)
	    {
		# standard behaviour - put slashes inside the i-g
		unless ($bit =~ m|slashes=\"n|i)
		{
		    $bit =~ s|<i-g( .*?>)| <I-G$1<z_i-g>/</z_i-g>|g;
		    $bit =~ s|</i-g>|<z_i-g>/</z_i-g></I-G> |g;
		}
	    }
	    elsif ($type =~ m|example|)
	    {
		# don't want the phon-gb or phon-us to generate text
		$bit =~ s|<i([ >])| <I$1|g;
		$bit =~ s|<y([ >])| <Y$1|g;
		$bit =~ s|<i-g| <I-G|;
		$bit =~ s|</i-g>|</I-G> |;
	    }
	    else
	    {
		$bit =~ s|<i-g| <I-G|;
		$bit =~ s|</i-g>|</I-G> |;
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
}

sub gen_i_g_prev
{
    s|<i-g ([^>]*)> | <I-G $1><z_i-g>/</z_i-g>|g;
    s|</i-g><if |<z_i-g>/</z_i-g></I-G><z>, </z><IF |g;
    s|</i-g><il |<z_i-g>/</z_i-g></I-G><z>, </z><IL |g;
    s|</i-g><v |<z_i-g>/</z_i-g></I-G><z>, </z><V |g;
    s|</i-g>|<z_i-g>/</z_i-g></I-G> |g;
}

##################################################

sub gen_id
{
    my($ID_SEP) = @_;
    s|(<id)|£$1|gio;
    s|(<idiom>)(<label-g[^£]*</label-g>)(£<id)|$1<z>\(</z>$2<z>\) </z>$3|gio;
    s|(</id>)(<label-g[^£]*</label-g>)(£<id)|$1<z> \(</z>$2<z>\) </z>$3|gio;
    unless ($ID_SEP =~ m|^ *$|)
    {
	s|</id>£<id |</ID><z>$ID_SEP </z><ID |g;
	s|<label>(<g ([^>]*)></g>)<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<g ([^>]*)></g>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<r ([^>]*)></r>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<s ([^>]*)></s>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<label-g[^>]*><g ([^>]*)></g></label-g>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<label-g[^>]*><r ([^>]*)></r></label-g>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
	s|</id>(<label-g[^>]*><s ([^>]*)></s></label-g>)£<id |</ID><z>$ID_SEP</z>$1<z> </z><ID |g; # mantis 2303 ...
    }
    s|£||g;
    s|(</id>)(<d[ >])|$1 $2|gi;
}

##################################################

sub gen_id_g
{
    my($idg_sym) = @_;
    unless ($idg_sym =~ m|^ *$|)
    {
	s|(<id-g[^>]*>)|$1$idgsym|gio;
    }				# 
    if ($IDSEP)
    {
	s|</id-g><z> </z><id-g |</id-g><z> &idsep; </z><id-g |gi;
    }
}

##################################################
sub gen_ids_g
{
    my($bit, $res);
    my(@BITS);
    $e = $_;
    $e =~ s|(<ids-g[ >].*?</ids-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS)
    {
	if ($bit =~ s|&fk;||gio)
	{
	    $ct = ($bit =~ s|(<id-g)|$1|gi);
	    if ($ct > 1)
	    {
		$bit =~ s|(<ids-g[^>]*>)|$1<z>&idsyms;</z>|;
	    }
	    else
	    {
		$bit =~ s|(<ids-g[^>]*>)|$1<z>&idsym;</z>|;
	    }

	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub idxh
{
    s|<idxh .*?</idxh>( ?)||g;
}

##################################################

sub gen_if
{
    s|</label-g><if |</LABEL-G><z> </z><IF |g;
    s|</g><if |</G><z> </z><IF |g;
    s|</r><if |</R><z> </z><IF |g; # mantis 2560 ...
    s|</s><if |</S><z> </z><IF |g; # mantis 2636 ...
    s|</if> *<label-g |</IF><z>, </z><LABEL-G |g; 
    s|</if><g |</IF><z>, </z><G |g; # mantis 1788 ...
    s|</if><if |</IF><z>, </z><IF |g;
    s|</il><if |</IL><z> </z><IF |g;
}

##################################################

sub gen_if_g
{
    s|(</if-g><if-g ([^>]*)>)<g |$1<G |g; # mantis 2561 ...
    s|</if-g><if-g|</IF-G><z>, </z><IF-G|go;
    s|</if-g><cm>or</cm><if-g|</IF-G><z> </z><CM>or</CM><z> </z><IF-G|g;
}

##################################################

sub gen_ifs_g
{
#   no brackets if IFS-G within VS-G ...
    my(@BITS);
    my($bit);
    my($res);
    s|<vs-g |&split;$&|goi;
    s|</vs-g>|$&&split;|goi;
    @BITS = split(/&split;/);
    foreach $bit (@BITS)
    {
	if ($bit =~ /<vs-g .*<ifs-g /i)
	{
	    $bit =~ s|</ifs-g>|</IFS-G>|go;
	    $bit =~ s|<ifs-g |<z> </z><IFS-G |go;
	}
	$res .= $bit;
    }
    $_ = $res;
    s|</ifs-g>|<z>\)</z></IFS-G>|g;
    s|<ifs-g( [^>]*>)|<IFS-G $1<z> \(</z>|g;
}

##################################################

sub gen_il
{
    s|</il><il |</IL><z>, </z><IL |g; # mantis 2352 ...
    s|(<ifs-g ([^>]*)>)<il |$1<IL |gi;
    s|<il |<z> </z><IL |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<IL |<il |g;
	while (/<il ([^>]*)il="(.*?)"/)
	{
	    $key = "il_il_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<il ([^>]*)il="(.*?)"(.*?)>|<il $1IL="$2"$3><z_il>$text</z_il>|;
	}
	s|\( |\(|g;
    }
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

sub gen_label_g
{
    my($DBG) = @_;
    my($bit, $res);
    my(@BITS);
    $e = $_;
    $e =~ s|(<label-g[ >].*?</label-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if (&need_brackets($bit, $DBG))
	    {
		$bit =~ s|(<label-g[^>]*>)(.*?)(</label-g>)|\1<z>\(</z>\2<z>\)</z>\3|;
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
}

sub need_brackets
{
    my($e, $DBG) = @_;
    my($bit, $res);
    $e =~ s| *>| >|gi;
    $e =~ s|(<[^ >]*) .*?>|\1>|gi;
    $e =~ s|>[^<>]*<|><|gi;
    $e =~ tr|A-Z|a-z|;
    if ($DBG)
    {
	$BRA_STORE{$e}++;
    }
    if ($BRACKETS{$e})
    {
	return 1;
    }
    return 0;
}

##################################################

sub gen_l_g
{
    s|<l-g([^>]*) l="([a-z])"(.*?)>|<z> </z>$&<z_l>($2)</z_l><z> </z>|g;
}

##################################################

sub gen_n_g
{
    if ($NG_NEWLINE)
    {
	s|<n-g([^>]*) n="([0-9]+)"(.*?)>|$&<z_n>$2</z_n><z> </z>|g;
    }
    else
    {
	s|<n-g([^>]*) n="([0-9]+)"(.*?)>|<z> </z>$&<z_n>$2</z_n><z> </z>|g;
    }
    s|<z_n>0</z_n>||g;
    s|<z> </z>(<[^>]*><z> )|$1|gio;
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
    s|</label-g><opp |</label-g> <OPP |g;
    s|</g><opp |</g><z> </z><OPP |g;
    s|</r><opp |</r><z> </z><OPP |g;
    s|</opp><opp |</OPP><z>, </z><OPP |g;
    s|</opp><g |</OPP><z>,</z><g |g;
    s|</opp><r |</OPP><z>,</z><r |g;
}

##################################################

sub gen_opp_g
{
    s|<opp-g ([^>]*)><(label-g)(.*?)</label-g>|<opp-g $1> <\U$2\E $3></\U$2\E> |g;
    s|<opp-g ([^>]*)><([grs]) ([^>]*)></\2>|<opp-g $1><z> </z><\U$2\E $3></\U$2\E><z> </z>|g;
    s|<opp-g (.*?)>|<OPP-G $1><z>&oppsym; </z><z_opptext>OPP</z_opptext>|g;
}

##################################################
sub gen_pos
{
    s|</pos><pos |</POS><z>, </z><POS |g;
    s| *<pos | <POS |g;
}

##################################################

sub gen_p
{
    s|</p><p |</P><z>, </z><P |g;
    s|<p |<z> </z><P |g;

#   spell out parts of speech in h-g in multi-pos entries ...

    if (/<p-g/i)
    {
	if ($POS_FULL)
	{
	    &gen_pos_full;
	}
    }
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<P |<p |g;
	while (/<p ([^>]*)p="(.*?)"/)
	{
	    $key = "p_p_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<p ([^>]*)p="(.*?)"(.*?)>|<p $1P="$2"$3><z_p>$text</z_p>|;
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

sub gen_p_new
{
    s|</p><p |</P><z>, </z><P |g;
    s|<p |<z> </z><P |g;
#   spell out parts of speech in h-g in multi-pos entries ...
    if (/<p-g/i)
    {
	if ($POS_FULL)
	{
	    &gen_pos_full;
	}
    }
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<P |<p |g;
	while (/<p ([^>]*)p="(.*?)"/)
	{
	    $key = "p_p_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<p ([^>]*)p="(.*?)"(.*?)>|<p $1P="$2"$3>$text|;
	}
    }
    s|(<p ([^>]*)p="(.*?))_FULL"|$1"|gi;
}

##################################################

sub gen_p_g
{
    my($bit, $res, $e);
    my(@BITS);
    $e = $_;
    $e =~ s|(<p-g[ >].*?</p-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    unless ($bit =~ s|(<p-g [^>]*><top-g[^>]*>)|\1<z>&psym; </z>|i)
	    {
		$bit =~ s|(<p-g [^>]*>)|\1<z>&psym; </z>|i;
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
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
    s|<ph |<z> </z><PH |g;
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
    my($samesep) = @_;
    if ($samesep =~ m|^ *$|)
    {
	$samesep = ";";
    }
    s|</phon-gb><g ([^<]*)</g><phon-gb |</PHON-GB><z>$samesep </z><G $1</G><z> </z><PHON-GB |g;
    s|</phon-gb><phon-gb |</PHON-GB><z>$samesep </z><PHON-GB |g;
    s|</phon-gb><il |</PHON-GB><z>; </z><IL |g; # mantis 2515 ...
    s|</phon-gb><phon-us |</PHON-GB><z>; <z_phon-us>&z_us;</z_phon-us> </z><PHON-US |g;
    s| *(</cm><phon)| $1|gio;
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
    my($samesep) = @_;
    if ($samesep =~ m|^ *$|)
    {
	$samesep = ";";
    }
    s|</(phon-[^>]*)><g ([^<]*)</g><(phon-[a-z]+) |</\U\1\E><z>; </z><G \2</G><z> </z><\U\3\E |g;
    s|</phon-us><phon-us |</PHON-US><z>$samesep </z><PHON-US |g;
    s|</phon-us><il |</PHON-US><z>; </z><IL |g; # mantis 2515 ...
#
    s|</phon-us><cm |</PHON-US><z>; </z><CM |g; # mantis 1982 ...
    s|</phon-us><phon-us |</PHON-US><z>$samesep </z><PHON-US |g;
    s| *(</cm><phon)| $1|gio;
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
    s|</pt><pt |</PT><z>, </z><PT |g;
    s|</pt>|</PT><z_pt_br>\]</z_pt_br>|g;
    s|<pt |<z> </z><z_pt_br>\[</z_pt_br><PT |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<PT |<pt |g;
	while (/<pt ([^>]*)pt="(.*?)"/)
	{
	    $key = "pt_pt_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<pt ([^>]*)pt="(.*?)"(.*?)>|<pt $1PT="$2"$3><z_pt>$text</z_pt>|;
	}
	while (/<pt ([^>]*)q="(.*?)"/)
	{
	    $key = "pt_q_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<pt ([^>]*)q="(.*?)"(.*?)>|<pt $1Q="$2"$3><z_pt>$text </z_pt>|;
	}
    }
}

##################################################

sub gen_pv
{
    s|</tcf><pv |</TCF><z> </z><PV |g; # mantis 1973 ...
    s|</pv><pv |</PV><z>; </z><PV |g;
}

##################################################

sub gen_pv_g
{
}


##################################################

sub gen_pv_g_old
{
###    if ($PVG_NEWLINE)
###    {
###	s|</pv-g><pv-g |</PV-G><PV-G zp=\"y\"|g;
###    }
###    else
###    {
###	s|</pv-g><pv-g |</PV-G> <PV-G |g;
###    }
###    s|</pv-g></pvp-g><pvp-g([^>]*)><pv-g |</PV-G></PVP-G><PVP-G zp=\"y\"$1><PV-G |g; # mantis 2522 ...
###    s|</pv-g><np/><pv-g |</PV-G><PV-G zp=\"y\"|g;
###    if ($PVSYM_NEWLINE)
###    {
###	s|<pv-g( [^>]*multi=\"y)|<zp_pv-g/><z>&pvsyms; </z><PV-G $1|g;
###	s|<pv-g |<zp_pv-g/><z>&pvsym; </z><PV-G |g;
###    }
###    else
###    {
###	s|<pv-g( [^>]*multi=\"y)|<z> &pvsyms; </z><PV-G $1|g;
###	s|<np/><pv-g |<zp_pv-g/><z>&pvsym; </z><PV-G |g;
###	s|<pv-g |<z> &pvsym; </z><PV-G |g;
###    }
###    s|</sd-g><z> &pvsym|</sd-g><zp_pv-g/><z>&pvsym|g;
###    if ($PVSEP)
###    {
###	s|</pv-g><z> </z><pv-g |</pv-g><z> &pvsep; </z><pv-g |gi;
###    }
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
	    $ct = ($bit =~ s|(<pv-g)|$1|gi);
	    if ($ct > 1)
	    {
		$bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsyms;</z>|;
	    }
	    else
	    {
		$bit =~ s|(<pvs-g[^>]*>)|$1<z>&pvsym;</z>|;
	    }

	}
	$res .= $bit;
    }
    $_ = $res;
}

##################################################

sub gen_pvp_g
{
}

##################################################

sub gen_pvpt
{
    s|</pvpt><pvpt |</PVPT><z>, </z><PVPT |g;
    s|</pvpt>|</PVPT><z>\]</z>|g;
    s|<pvpt |<z> \[</z><PVPT |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<PVPT |<pvpt |g;
	while (/<pvpt ([^>]*)pvpt="(.*?)"/)
	{
	    $key = "pvpt_pvpt_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<pvpt ([^>]*)pvpt="(.*?)"(.*?)>|<pvpt $1PVPT="$2"$3><z_pvpt>$text</z_pvpt>|;
	}
    }
}

##################################################

sub gen_r
{
    s|</r><g |</R><z>, </z><G |g;
    s|</r><r |</R><z>, </z><R |g;
    s|</r><s |</R><z>, </z><S |g;
    unless (m|<label-g|i)
    {
	s|</r>|</R><z>\)</z>|g;
	s|<r |<z> \(</z><R |g;
    }
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<R |<r |g;
	while (/<r ([^>]*)r="(.*?)"/)
	{
	    $key = "r_r_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<r ([^>]*)r="(.*?)"(.*?)>|<r $1R="$2"$3><z_r>$text</z_r>|;
	}
	while (/<r ([^>]*)q="(.*?)"/)
	{
	    $key = "r_q_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<r ([^>]*)q="(.*?)"(.*?)>|<r $1Q="$2"$3><z_r>$text </z_r>|;
	}
    }
}

##################################################

sub gen_refl
{
}

##################################################

sub gen_refl_g
{
    s|<refl-g |<zp_refl-g/><z>&reflsym; </z><REFL-G |g;
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
    s|<rv |<z> </z><RV |g;
}

##################################################

sub gen_s
{
    s|</s><g |</S><z>, </z><G |g;
    s|</s><r |</S><z>, </z><R |g;
    s|</s><s |</S><z>, </z><S |g;
    s|</s>|</S><z>\)</z>|g;
    s|<s |<z> \(</z><S |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<S |<s |g;
	while (/<s ([^>]*)s="(.*?)"/)
	{
	    $key = "s_s_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<s ([^>]*)s="(.*?)"(.*?)>|<s $1S="$2"$3><z_s>$text</z_s>|;
	}
    }
}

##################################################

sub gen_sd
{
}

##################################################

sub gen_sd_g
{
    unless ($NO_SDSYM)
    {
	s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym;&nbsp;</z>|g;
	s|(<z>&sdsym;&nbsp;</z>) *(<top-g[^>]*>)|\2\1|gi;
    }
}

##################################################

sub gen_set
{
}

##################################################

sub gen_sn_g
{
    my($bit, $res, $e, $ngnum);
    my(@BITS);
    $e = $_;
    $e =~ s|(<sn-g[ >].*?</sn-g>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gi){
	    $ngnum = restructure::get_tag_attval($bit, "sn-g", "n"); 
	    unless (($ngnum == 0) || ($ngnum =~ m|^ *$|))
	    {
		$bit =~ s|>|><sensenum>$ngnum</sensenum> |i;
	    }
	}
	$res .= $bit;
    }
    $_ = $res;
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


sub gen_symbols_app
{
    my($e) = @_;
    $e =~ s|&([a-z][^ ;]*syms?);|<img src=\"\1.png\"/>|gi;
    $e =~ s|&([a-z][^ ;]*sep);|<img src=\"\1.png\"/>|gi;
    $e =~ s|&f([0-9]+)d([0-9]+);|\1/\2|gi;
    $e =~ s|&(careof);|c/o|gi;
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

##################################################

sub gen_sym
{
    s|</sym>|</SYM><z>\)</z>|g;
    s|<sym |<z> \(</z><z_sym>&z_symb;</z_sym><z> </z><SYM |g;
}

##################################################

sub gen_syn
{
    s|</syn><label-g |</SYN><z> &synsep2; </z><LABEL-G |g;
    s|</syn><g |</SYN><z> &synsep2; </z><G |g;
    s|</syn><r |</SYN><z> &synsep2; </z><R |g;
    s|</syn><s |</SYN><z> &synsep2; </z><S |g;
    s|</syn><u |</SYN><z> &synsep2;</z><u |g;
    s|</label-g><syn |</LABEL-G> <SYN |g;
    s|</g><syn |</G><z> </z><SYN |g;
    s|</r><syn |</R><z> </z><SYN |g;
    s|</s><syn |</S><z> </z><SYN |g;
    s|</syn><syn |</SYN><z> &synsep; </z><SYN |g;
}

##################################################

sub gen_syn_g
{
#    s|<syn-g ([^>]*)><label-g |<syn-g $1><\U$2\E |g;
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
    s|<tab |<z> \(<z_tab>&z_abbr;</z_tab> </z><TAB |g;
    s|</tab>|</TAB><z>) </z>|g;
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
    s|<tadv (.*?)</tadv>(<i-g (.*?)</i-g>)|<z> (</z><z_tadv>&z_adv;</z_tadv><z> </z><TADV $1</TADV>$2<z>)</z>|g;
    s|<tadv (.*?)</tadv>|<z> (</z><z_tadv>&z_adv;</z_tadv><z> </z><TADV $1</TADV><z>)</z>|g; # mantis 1847 ...
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
    s|<tatpr |<z> \(</z><TATPR |g;
    s|</tatpr>|</TATPR><z>\)</z>|g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TATPR |<tatpr |g;
	while (/<tatpr ([^>]*)tatpr="(.*?)"/)
	{
	    $key = "tatpr_tatpr_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tatpr ([^>]*)tatpr="(.*?)"(.*?)>|<tatpr $1TATPR="$2"$3><z_tatpr>$text</z_tatpr>|;
	}
    }
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
##    s|</tcf><ts |</TCF><z>, </z><TS |g; # mantis 1837 ...
##    s|</ts><tcf |</TS><z>, </z><TCF |g; # mantis 1990 ...
    s|(<tcf ([^>]*)>)<ts |$1<TS |g;
    s|<tcf |<z> </z><TCF |g;
}

##################################################

sub gen_tcfe
{
    s|</tcfe><tcfe |</TCFE><z>, </z><TCFE |g; # mantis 3271 ...
    s|<tcfe |<z> </z><TCFE |g;
}

##################################################

sub gen_tcu
{
    s|</tcu><tev |</TCU><z>, </z><TEV |g;
    s|</tcu>|</TCU><z>\)</z>|g;
    s|<tcu |<z> \(</z><TCU |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TCU |<tcu |g;
	while (/<tcu ([^>]*)tcu="(.*?)"/)
	{
	    $key = "tcu_tcu_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tcu ([^>]*)tcu="(.*?)"(.*?)>|<tcu $1TCU="$2"$3><z_tcu>$text</z_tcu>|;
	}
    }
}

##################################################

sub gen_td
#   use for HTML-style table data ONLY ...
{
}

##################################################

sub gen_tdef
{
    s|<tdef |<z> </z><TDEF |g;
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
    s|(</tel>) *(<ts[ >])|</TEL><z>\), </z>\2|gi;
    s|<tel |<z> \(</z>$&|g;
    s|</tel>|$&<z>\)</z>|g;
}

##################################################

sub gen_tev
{
    s|</treg><tev |</TREG><z>, </z><TEV |g;
    s|</tev><tev |</TEV><z>, </z><TEV |g; # mantis 2016 ...
    s|</tev><tg |</tev><z>,</z><tg |g; # mantis 2022 ...
    s|</tev>|</TEV><z>\)</z>|g;
    s|<tev |<z> \(</z><TEV |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TEV |<tev |g;
	while (/<tev ([^>]*)tev="(.*?)"/)
	{
	    $key = "tev_tev_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tev ([^>]*)tev="(.*?)"(.*?)>|<tev $1TEV="$2"$3><z_tev>$text</z_tev>|;
	}
    }
}

##################################################

sub gen_tg
{
    s|</tg><tg |</TG><z>, </z><TG |g;
    s|</tg><treg |</TG><z>, </z><TREG |g;
    s|</treg><tg |</TREG><z>, </z><TG |g; # mantis 1853 ...
    s|</tg>|</TG><z>\)</z>|g;
    s|<tg |<z> \(</z><TG |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TG |<tg |g;
	while (/<tg ([^>]*)tg="(.*?)"/)
	{
	    $key = "tg_tg_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tg ([^>]*)tg="(.*?)"(.*?)>|<tg $1TG="$2"$3><z_tg>$text</z_tg>|;
	}
    }
}

##################################################

sub gen_tgl
{
    s| *(<tgl [^>]*>)| $1<z>\(</z>|g;
    s|(</tgl>)|<z>\)</z>$1|g;
}

##################################################

sub gen_tgr
{
    s|</tgr><tgr |</TGR><z>, </z><TGR |g;
    s|</tgr>|</TGR><z_tgr_br>\]</z_tgr_br>|g;
    s|<tgr |<z> </z><z_tgr_br>\[</z_tgr_br><TGR |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TGR |<tgr |g;
	while (/<tgr ([^>]*)tgr="(.*?)"/)
	{
	    $key = "tgr_tgr_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tgr ([^>]*)tgr="(.*?)"(.*?)>|<tgr $1TGR="$2"$3><z_tgr>$text</z_tgr>|;
	}
    }
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
    my($tsep) = @_;
    s|</tid><tg |</TID><z>;</z><tg |g; # mantis 1851 ...
    s|</tev><tid |</tev><z>, </z><TID |g; # mantis 2023 ...
    s|</tid><tid |</TID>$tsep <TID |g;
    s|<tid |<TID |g;
}

##################################################

sub gen_tif
{
    s|</tif><t2 |</TIF><z>, </z><T2 |g;
    s|</tif><tif |</TIF><z>, </z><TIF |g;
    s|</til><tif |</TIL><z> </z><TIF |g;
}

##################################################

sub gen_til
{
    s|<til |<z> </z><TIL |g;
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<TIL |<til |g;
	while (/<til ([^>]*)til="(.*?)"/)
	{
	    $key = "til_til_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<til ([^>]*)til="(.*?)"(.*?)>|<til $1TIL="$2"$3><z_til>$text</z_til>|;
	}
    }
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
    s|<tp |<z> </z><TP |g;
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<TP |<tp |g;
	while (/<tp ([^>]*)tp="(.*?)"/)
	{
	    $key = "tp_tp_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<tp ([^>]*)tp="(.*?)"(.*?)>|<tp $1TP="$2"$3><z_tp>$text</z_tp>|;
	}
    }
}

##################################################

sub gen_tph
{
    s|<tph |<z> </z><TPH |g;
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
    s|</treg>|</TREG><z>\)</z>|g;
    s|<treg |<z> \(</z><TREG |g;
    unless ($EXPANSION_DONE){
#   insert expansion text ...
	s|<TREG |<treg |g;
	while (/<treg ([^>]*)treg="(.*?)"/)
	{
	    $key = "treg_treg_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<treg ([^>]*)treg="(.*?)"(.*?)>|<treg $1TREG="$2"$3><z_treg>$text</z_treg>|;
	}
    }
}

##################################################

sub gen_ts
{
    if ($TSSEP =~ m|^ *$|)
    {
	$TSSEP = ", ";
    }
    s|</treg><ts |</treg><z>,</z><ts |g; # mantis 1822 ...
#    s|(<ts([^>]*) t="(.*?)"(.*?))</ts>|$1, -$3</ts>|g; # commented by mantis 2234 ...
    s|(<ts([^>]*) t="([^"]+)"(.*?))(</ts>)|$1, -$3$5|gi; # mantis 2234 ...
#    s|</ts><ts |</TS><z>, </z><TS |g; # requested for engpor2e ...
    s|</ts><ts |</TS>$TSSEP<TS |g; #
    s|<ts |<z> </z><TS |g;
}

##################################################

sub gen_ts_g
{
    s|</t2-g><ts-g |</T2-G><z>; </z><TS-G |g;
    s|</ts-g><ts-g |</TS-G><z>; </z><TS-G |g;
    s|<ts-g (.*?)>|<TS-G $1><z>&tssym; </z>|g;
}

##################################################

sub gen_tu
{
    s|<tu |<z> \(</z><TU |g;
    s|</tu>|</TU><z>\)</z>|g;
}

##################################################

sub gen_tx
{
    if ($X_TX_SEPARATE)
    {
	s|</tx> *<x |</TX><z> &xsep; </z><X |g;
    }
    s|<tx |<z> </z><TX |g;
}

##################################################

sub gen_u
{
    if ($U_SQUARE_BRACKETS)
    {
	s|<u( [^>]*>) *|<U$1<z> \[</z>|g;
	s| *</u>|<z>\]</z></U>|g;
    }
    else
    {
	s|<u( [^>]*>)|<U$1<z> \(</z>|g;
	s|</u>|<z>\)</z></U>|g;
    }
}

##################################################

sub gen_ud
{
    s|<ud |<z> </z><UD |g;
}

##################################################

sub gen_un
#   for inline usage notes ...
{
#unless ($EXPANSION_DONE){
#   insert expansion text ...
    s|<un |<un |g;
    while (/<un ([^>]*)type="(.*?)"/)
    {
        $key = "un_type_$2";
	$text = $ATT{$key};
	if ($text =~ m|^ *$|i) {
	    $ATT_ERRS{$key} = 1;	  
	}
	s|<un ([^>]*)type="(.*?)"(.*?)>|<un $1TYPE="$2"$3><z_un>$text</z_un>|;
    }
}

##################################################

sub gen_unbox
#   for boxed usage notes ...
{
#   insert expansion text ...
    s|<UNBOX |<unbox |g;
    while (/<unbox ([^>]*)type="(.*?)"/)
    {
        $key = "unbox_type_$2";
	$text = $ATT{$key};
	if ($text =~ m|^ *$|i) {
	    $ATT_ERRS{$key} = 1;	  
	}
	s|<unbox ([^>]*)type="(.*?)"(.*?)>|<unbox $1TYPE="$2"$3><z_unbox>$text</z_unbox>|;
#   following line requires &TAB; in attval file ...
	s|<z_unbox>&TAB;|<z_unbox tab="y">|g;
    }
}

##################################################
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
        s|<ungl |<z>(=</z><UNGL |g;
		     s|</ungl>|</UNGL><z>)</z>|g;
    }
}

##################################################

sub gen_unp
{
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<UNP |<unp |g;
	while (/<unp ([^>]*)p="(.*?)"/)
	{
	    $key = "unp_p_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<unp ([^>]*)p="(.*?)"(.*?)>|<unp $1P="$2"$3><z_unp>$text</z_unp>|;
	}
	s|<unp | <UNP |g;
    }
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


}

##################################################

sub gen_unxh
{
}

##################################################

sub gen_v
{
    s|</vs><v |</VS><z>, </z><V |g; # mantis 2658 ...
    s|</v><v |</V><z>, </z><V |g; # mantis 2296 ...
    s|</fe><v |</FE><z>, </z><V |g; # mantis 2001 ...
    s|</label-g><v |</LABEL-G><z> </z><V |g;
    s|</g><v |</G><z> </z><V |g;
    s|</r><v |</R><z> </z><V |g;
    s|</s><v |</S><z> </z><V |g;
    s|</v><label-g |</V><z>, </z><LABEL-G |g; # mantis 1779 ...
    s|</v><g |</V><z>, </z><G |g; # mantis 1779 ...
    s|</v><r |</V><z>, </z><R |g; # mantis 1949 ...
}

##################################################

sub gen_vc
{
    s|</g><vc |</G><z> </z><VC |g;
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
    s|</g><vf |</G><z> </z><VF |g;
    s|</r><vf |</R><z> </z><VF |g; # mantis 2842 ...
}

##################################################

sub gen_vs
{
    s|</vs><g |</VS><z> </z><G |g;
    s|</vs><label|</VS><z> </z><LABEL|g;
    s|</vs><vs |</VS><z>, </z><VS |g;
    s|</g><vs |</G><z> </z><VS |g;
    s|</r><vs |</R><z> </z><VS |g; # mantis 2374 ...
}

##################################################

sub gen_vs_g
{
    s|<vs-g ([^>]*?)><g |<VS-G $1><z> \(</z><G |g;
    s|<vs-g ([^>]*?)><r |<VS-G $1><z> \(</z><R |g;
    s|<vs-g ([^>]*?)><label-g|<VS-G $1><z> \(</z><LABEL-G|g;
    s|<vs-g ([^>]*?)>|<VS-G $1><z> \(</z><z_vs-g>&z_also;</z_vs-g><z> </z>|g;
    s|</vs-g>|<z>\)</z></VS-G>|g;
}

##################################################

sub gen_v_g
{
    s|<v-g ([^>]*?)><g |<V-G $1><z> \(</z><G |g;
    s|<v-g ([^>]*?)><r |<V-G $1><z> \(</z><R |g;
    s|<v-g ([^>]*?)><label-g|<V-G $1><z> \(</z><LABEL-G|g;
    s|<v-g ([^>]*?)>|<V-G $1><z> \(</z><z_v-g>&z_also;</z_v-g><z> </z>|g;
    s|</v-g>|<z>\)</z></V-G>|g;
}

##################################################


##################################################

sub gen_wf_g
{
}

##################################################

sub gen_wfo
{
    s|<wfo |<z> </z><WFO |g;
}

##################################################

sub gen_wfp
{
    s|(</wfw>) *(<wfp)|$1 $2|gi;
#   insert expansion text ...
    unless ($EXPANSION_DONE){
	s|<WFP |<wfp |g;
	while (/<wfp ([^>]*)p="(.*?)"/)
	{
	    $key = "wfp_p_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<wfp ([^>]*)p="(.*?)"(.*?)>|<wfp $1P="$2"$3><z_wfp>$text</z_wfp>|;
	}
    }
}

##################################################

sub gen_wfw
{
    s|<wfw |<z> </z><WFW |g;
}

##################################################

sub gen_wx
{
    s|</wx> *<wx |</WX><z> &xsep; </z><WX |g;
}

##################################################

sub gen_x
{

    if ($CF_WITH_X)
    {
	s|</cf><cf |&cfpair;|g;
        s|(<cf ([^<]*)</cf>)(<x (.*?)>)|$3$1|g; # this line replaces following commented line - CF immediately followed by X ...
#	s|(<cf[ ](?:  (?!<d) . )*? </cf>)(<x[ ](.*?)>)|$2$1|gx; # added negative lookahead assertion [(?!<d)]  to stop the match between cf tags taking half the entry. Other tags mnight need to be added to this as alternates... TT 2009-06-05

    }

    s|</ts><dlf([^>]*)></dlf><x |</TS><z> </z><dlf$1></dlf><x |g; # mantis 1974 ...
    s|</tcf><dlf([^>]*)></dlf><x |</TCF><z> </z><dlf$1></dlf><x |g; # mantis 1974 ...
    
    # FOR AN APP WE DON'T WANT THE COLON - they all have symbols
    if (0)
    {
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
	s|<x |<z>: </z><X |g;
    }
    s|(<x ([^>]*)?>)(<cf (.*?)</cf>)|$3<z> </z>$1|gi; 

    s|&cfpair;|</cf><cf |g;

}

##################################################

sub gen_xh
{
    s|</xw><xh |</XW><z> </z><XH |g;
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
    s|<xp | $&|g;
    unless ($EXPANSION_DONE){
#   insert expansion text (if used) ...
	s|<XP |<xp |g;
	while (/<xp ([^>]*)p="(.*?)"/)
	{
	    $key = "xp_xp_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<xp ([^>]*)p="(.*?)"(.*?)>|<xp $1P="$2"$3><z_xp>$text</z_xp>|;
	}
    }
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
    if (m|<xr-g|i)
    {
	$_ = &gen_xr_new($_);
	return;
    }

    &gen_add_xt_to_closer;

    if ($SEMICOLON_BEFORE_XT_SEE)
    {
	s|</xr xt=\"eq\">(<xr ([^>]*)xt=\"see\")|</XR><z>;</z>$1|g; # mantis 3180 ...
	s|</xr xt=\"o?cfe\">(<xr ([^>]*)xt=\"see\")|</XR><z>;</z>$1|g; # mantis 3098 ...
	s|</xr xt=\"useat\">(<xr ([^>]*)xt=\"see\")|</XR><z>;</z>$1|g; # mantis 3098 ...
	s|</xr xt=\"id\">(<xr ([^>]*)xt=\"see\")|</XR><z>;</z>$1|g; # mantis 3180 ...
    }

    s|</xr xt=\"(n?syn)\"><xr ([^>]*)xt=\"(n?syn)\"|</XR><z>, </z><XR_HIDE $2xt=\"$3\"|g; # mantis 2519 ...
    s|</xr xt=\"(.*?)\"><xr ([^>]*)xt=\"\1\"|</XR><z>, </z><XR_HIDE $2xt=\"$1\"|g;

#   conditional "idioms see also" generated text requires <xr xt="id_ALSO"> in attval file ...

    if ($ID_SEE_ALSO)
    {
	s|(</id-g>)<xr ([^>]*)xt=\"id\"|$1<xr $2xt=\"id_ALSO\"|gi;
    }

#   conditional "synonyms" and "opposites" generated text require <xr xt="syn_PLURAL"> and <xr xt="opp_PLURAL"> in attval file ...

    if ($SYN_OPP_PLURAL)
    {
	s|<xr ([^>]*)xt=\"syn\"([^\#]*</XR><z>, </z>)|<xr $1xt=\"syn_PLURAL\"$2|g;
	s|<xr ([^>]*)xt=\"opp\"([^\#]*</XR><z>, </z>)|<xr $1xt=\"opp_PLURAL\"$2|g;
    }

#   "examples at" "and" text ...

    if ($EXAMPLES_AT_AND)
    {
	s|\#|&temphash;|g;
	s|</xr (.*?)>|$&\#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"exas\"([^\#]*)</xr xt=\"exas\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|\#||g;
	s|&temphash;|\#|g;
    }

#   conditional "illustrations at" generated text requires <xr xt="picat_PLURAL"> in attval file ...

    if ($ILLS_AT)
    {
	s|\#|&temphash;|g;
	s|</xr (.*?)>|$&\#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"picat\"([^\#]*)</xr xt=\"picat\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr ([^>]*)xt=\"picat\"([^\#]*)</XR>|<xr $1xt=\"picat_PLURAL\"$2</XR>|g;
	s|\#||g;
	s|&temphash;|\#|g;
    }

#   conditional "notes at" generated text requires <xr xt="useat_PLURAL"> in attval file ...

    if ($NOTES_AT)
    {
	s|\#|&temphash;|g;
	s|</xr (.*?)>|$&\#|gi;
	s|(<xr ([^>]*)xt=\"useat\"([^\#]*)</xr>)(<z>[^;])|$1\#$4|gi; # mantis 3199 ...
	s|<z>, </z>(<XR_HIDE ([^>]*)xt=\"useat\"([^\#]*)</xr xt=\"useat\">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr (([^>]*)xt=\"useat\"([^\#]*)</XR><z>;</z>)|<XR_HIDE_USEAT $1|g; # mantis 3180 ...
	s|<xr ([^>]*)xt=\"useat\"([^\#]*)</XR>|<xr $1xt=\"useat_PLURAL\"$2</XR>|g;
	s|<XR_HIDE_USEAT|<xr|g; # mantis 3180 ...
	s|\#||g;
	s|&temphash;|\#|g;
    }

#   full point at end of last xr of type if attribute present ...

    s|\#|&temphash;|g;
    s|</xr (.*?)>|$&\#|gi;
    s|(<xr ([^>]*)fullpoint=\"y\"([^\#]*))</xr xt=\"(.*?)\">|$1<z>.</z></XR>|g;
    s|\#||g;
    s|&temphash;|\#|g;

    s|</xr xt=\"(.*?)\">|</XR>|g;
    unless ($V2)
    {
#   insert expansion text ...
	s|<XR |<xr |g;
	while (/<xr ([^>]*)xt=\"(.*?)\"/)
	{
	    $key = "xr_xt_$2";
	    $text = $ATT{$key};
	    if ($text =~ m|^ *$|i) {
		$ATT_ERRS{$key} = 1;	  
	    }
	    s|<xr ([^>]*)xt=\"(.*?)\"(.*?)>|<xr $1XT=\"$2\"$3><z_xr>$text</z_xr>|;
	}
    }
    s|<XR_HIDE |<xr |g;
    s| (xt=\"id)_ALSO\"| $1\"|gi;
    s| (xt=\"picat)_PLURAL\"| $1\"|gi;
    s| (xt=\"useat)_PLURAL\"| $1\"|gi;

    s|(</xr>)<z>;</z>(<xr ([^>]*)><z_xr>)|$1$2;|gi; # mantis 3098 ...

}

##################################################

sub gen_xr_new
{
#   commas between same xr types ...
#    &gen_add_xt_to_closer;
    # in xr-g's and all same type so no need for end attributes on tags
    my($e) = @_;
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<xr-g[ >].*?</xr-g>)|&split;&fk;$1&split;|gio;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    $bit = &do_xr_internals($bit);
	}
	$res .= $bit;
    }    
    $e = $res;
    if ($SEMICOLON_BEFORE_XT_SEE)
    {
	$e =~ s|(</xr-g>)(<xr-g[^>]*xt=\"see\")|$1<z>; </z>$2|g; # mantis 3180 ...
    }
    $e =~ s|(</id-g><xr-g [^>]*xt=\")id\"|$1id_also\"|gi;
    $e =~ s|<XR_HIDE |<xr |g;
    $e =~ s| (xt=\"id)_ALSO\"| $1\"|gi;
    $e =~ s| (xt=\"picat)_PLURAL\"| $1\"|gi;
    $e =~ s| (xt=\"useat)_PLURAL\"| $1\"|gi;
    $e =~ s|(</xr>)<z>;</z>(<xr ([^>]*)><z_xr>)|$1$2;|gi; # mantis 3098 ...
    return $e;
}

sub do_xr_internals
{
    my($e) = @_;
    my($bit, $res, $xrct); 
    $xrct = ($e =~ s|(<xr[ >])|$1|gi);
    if ($xrct > 1){
	$e =~ s|(<xr-g [^>]*xt=\".*?)\"|$1_PLURAL\"|i;
    }
#   full point at end of last xr of type if attribute present ...
    if ($e =~ m|fullpoint=\"y\"|)    {
	$e =~ s|(</xr-g>)|.$1|gi;
    }
    if ($EXAMPLES_AT_AND){
	$e =~ s|(.*)(<xr[^>]* xt=\"exas\")|$1<z_xr>, &z_xr_and;</z_xr>$2|g;
    }
    $e =~ s|(</xr>)(<xr)|$1<z>, </z><XR|gi;
#   insert expansion text ...
    if ($e =~ m|<xr-g [^>]*xt=\"(.*?)\"|i)
    {
	$xt = $1;
	$key = "xrg_xt_$xt";
	$text = $ATT{$key};
	if ($text =~ m|^ *$|i) {
	    $key =~ s|_plural *$||i;
	    $text = $ATT{$key};
	}
	if ($text =~ m|^ *$|i) {
	    $ATT_ERRS{$key} = 1;	  
	}
	$e =~ s|(<xr-g[^>]*>)|$1$text|gi;
    }
    $e =~ m|(</xr>)(<xr[ >])$1<z>, </z>$2|gi;
    return $e;
}

sub gen_xs
{
    s|<xs |<z> \(</z>$&|g;
    s|</xs>|$&<z>\)</z>|g;
}
##################################################

sub gen_xt
{
    s|</unbox><xt |</unbox><XT |g; # mantis 2319 ...
    s|<xt |<z> </z><XT |g; # mantis 2319 ...

    if ($XT_SYMBOL)
    {
	s|<XT |<z>&xrsym; </z><XT |g;
    }
}

##################################################

sub gen_xw
{
}

##################################################

sub gen_y
{
    s|</y><y |</Y><z>; </z><Y |g;
    s|</y><g ([^<]*)</g><i |</Y><z>; </z><G $1</G><z> </z><I |g;
    s|</y><g ([^<]*)</g><y |</Y><z>; </z><G $1</G><z> </z><Y |g;
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
    s| *<co|<co|gi;
    s|</co> *|</co>|gi;
}

##################################################

sub gen_tweak
{
#   lowercase tags ...
    s|<([^ >]*)|<\L\1\E|g;
#   map eltdicts symbols as per project symbol fonts ...
#    unless ($NO_SYM_CHANGE)
#    {
#	&gen_eltdicts_symbols;
#    }
#   merge duplicate z tags ...
    s|</(z[^>]*)><\1>||g;
#   remove empty z tags ...
    s|<(z[^>]*)></\1>||g;
#   tidy up start tags ...
    s| +>|>|g;
#   tidy up line starts ...
    s|^(&split;)? +<|<|g;

#   deduplicate spaces ...
    s| ( +)| |g;
    s| <z> |<z> |g;
    s| <z>: |<z>: |g;
    s|:<z>:|<z>:|g;
    s| ; |; |g;
    s| : |: |g;
    s| , |, |g;

#   add missing spaces ...
    s|\.<arbd1>|\. <arbd1>|g;
    s|</unx><arbd1>|</unx> <arbd1>|g;
    s|([\.\!\%])<cl>|$1 <cl>|g; # mantis 2656 ...
    s|\.<eb>|\. <eb>|g;
    s|\?<eb>|? <eb>|g;
    s|,<eb>|, <eb>|g;
    s|:<eb>|: <eb>|g;
    s|\.<ei>|\. <ei>|g;
    s|\?<ei>|? <ei>|g;
    s|,<ei>|, <ei>|g;
    s|:<ei>|: <ei>|g;
    s|:<unx>|: <unx>|g;
    s|:<unwx>|: <unwx>|g;
    s|:<wx>|: <wx>|g; # mantis 2661 ...
    s|</x><eb>|</x> <eb>|g;
    s|</eb><xr|</eb> <xr|g;
    s|</xr><eb>|</xr> <eb>|g;
    s|</eb><ei>|</eb> <ei>|g;
    s|</x><ei>|</x> <ei>|g;
    s|</ei><eb>|</ei> <eb>|g;
    s|</eb><eb>|</eb> <eb>|g;
    s|</ebi><ei>|</ebi> <ei>|g;
    s|</ei><ebi>|</ei> <ebi>|g;
    s|</ei><ei>|</ei> <ei>|g;
    s|</unei>,<|</unei>, <|g;
    s|</unfm>,<|</unfm>, <|g;
    s|</ungi><arbd1>|</ungi> <arbd1>|g;
    s|</ungi>,<|</ungi>, <|g;
    s|</unxh>,<|</unxh>, <|g;
    s|</xr><z>\(</z><gl|</xr><z> \(</z><gl|g;
    s| </esc> |</esc> |gi;
    s|</esc>([A-z])|</esc> $1|gi;
    s|</gi>([A-z])|</gi> $1|gi;
    s|</gi><fm>|</gi> <fm>|gi;
    s|</gi>\.<fm>|</gi>. <fm>|gi;
    s|([A-z])<esc>|$1 <esc>|gi;
    s|</gl><cl>|</gl> <cl>|gi;
    s|</gl><dhb>|</gl> <dhb>|gi; # mantis 2653 ...
    s|</dhb><xr |</dhb> <xr |gi;
    s|\.<dh>|. <dh>|gi;
    s|\.<dhb>|. <dhb>|gi;
    s|\.<xr |. <xr |gi;
    s|<z>\)\)|<z>\)|g;
    s|&mdash; <cl>|&mdash;<cl>|g;
    s|([\.\!\?])<gl|$1 <gl|g;
    s|&lsquo; <cl>|&lsquo;<cl>|g;
    s|</gl> &rsquo;</x>|</gl>&rsquo;</x>|g;
    s|</cl> &mdash;|</cl>&mdash;|g;
    s|</xr><dhb>|</xr> <dhb>|g; # mantis 2478 ...
    s|</xr><ei>|</xr> <ei>|g; # mantis 2478 ...
    s|</xr><gl>|</xr> <gl>|g; # mantis 2653 ...
    s|</xr><xr |</xr> <xr |g; # mantis 2478 ...
    s|(\(</z><ifs-g><if-g>)<z> </z>|$1|g; # mantis 2636 ...
    s| (<xr ([^>]*)><z_xr><z> </z>)|$1|gi; # mantis 2669 ...
    s|</ungi><unfm|</ungi> <unfm|gi; # mantis 2672 ...
    s|</unx><unfm|</unx> <unfm|gi; # mantis 2671 ...
    s|\.<unfm|\. <unfm|gi; # mantis 2673 ...
    s|\:<unfm|\: <unfm|gi; # mantis 2673 ...
    s|\;<unfm|\; <unfm|gi; # mantis 2681 ...
    s|=<unfm|= <unfm|gi; # mantis 2688 ...
    s|</unxh><unx|</unxh> <unx|gi; # mantis 2674 ...
    s|</unx><unwx|</unx> <unwx|gi; # mantis 2677 ...
    s|</unx><arit1|</unx> <arit1|gi; # mantis 2679 ...
    s|</unx><ungl|</unx> <ungl|gi; # mantis 2678 ...
    s|</ungl><unx|</ungl> <unx|gi; # mantis 2678 ...
    s|</unfm><unfm|</unfm> <unfm|gi; # mantis 2680 ...
    s|</unei><unfm|</unei> <unfm|gi; # mantis 2682 ...
    s|\:<unei|\: <unei|gi; # mantis 2687 ...
    s|\;<unei|\; <unei|gi; # mantis 2687 ...
    s|\.<unei|\. <unei|gi; # mantis 2689 ...
    s|</arbd1><ungl|</arbd1> <ungl|gi; # mantis 2690 ...
    s|</ei><z>\(|</ei> <z>\(|g; # mantis 3182 ...
    s|([\.\!\?])<z>\(|$1 <z>\(|g; # mantis 3182 ...
    s|([\.\!\?])<ungl|$1 <ungl|g; # mantis 2692 ...
    s|([\.\!\?])<arbd1|$1 <arbd1|g; # mantis 2691 ...
    s| </z>, |</z>, |gi; # mantis 2694 ...
    s|</unwx><arbd1|</unwx> <arbd1|gi; # mantis 2703 ...
    s|</unwx><unei|</unwx> <unei|gi; # mantis 2703 ...
    s|</fm><ei|</fm> <ei|gi; # mantis 2709 ...
    s|([^\[\(])</z>([a-z])|$1</z> $2|gi; # mantis 2701 ...
    s|</pre> |</pre>|gi; # mantis 2704 ...
    s| <suf>|<suf>|gi; # mantis 2704 ...
    s|\)</z><eb>|\) </z><eb>|gi; # mantis 2699 ...
    s|</unebi><z>\(|</unebi><z> \(|gi; # mantis 2752 ...
    s|</unei><z>\(|</unei><z> \(|gi; # mantis 2752 ...
    s|\]</z>([a-z])|\]</z> $1|gi; # mantis 2752 ...
    s|<z>\)</z>\(|<z>\)</z> \(|gi; # mantis 2752 ...
    s|</g><eb>|</g> <eb>|gi; # mantis 2699 ...

    unless ($V2)
    {
	unless ($EXPANSION_DONE){
#   remove temp end tags from empty elements ...    
	    s|<(atpr ([^>]*))>(.*?)</atpr>|<$1/>$3|g;
	    s|<(dlf ([^>]*))>(.*?)</dlf>|<$1/>$3|g;
	    s|<(ds ([^>]*))>(.*?)</ds>|<$1/>$3|g;
	    s|<(g ([^>]*))>(.*?)</g>|<$1/>$3|g;
	    s|<(gi ([^>]*))>(.*?)</gi>|<$1/>$3|g;
	    s|<(gr ([^>]*))>(.*?)</gr>|<$1/>$3|g;
	    s|<(il ([^>]*))>(.*?)</il>|<$1/>$3|g;
	    s|<(p ([^>]*))>(.*?)</p>|<$1/>$3|g;
	    s|<(pt ([^>]*))>(.*?)</pt>|<$1/>$3|g;
	    s|<(pvpt ([^>]*))>(.*?)</pvpt>|<$1/>$3|g;
	    s|<(r ([^>]*))>(.*?)</r>|<$1/>$3|g;
	    s|<(s ([^>]*))>(.*?)</s>|<$1/>$3|g;
	    s|<(tatpr ([^>]*))>(.*?)</tatpr>|<$1/>$3|g;
	    s|<(tcu ([^>]*))>(.*?)</tcu>|<$1/>$3|g;
	    s|<(tev ([^>]*))>(.*?)</tev>|<$1/>$3|g;
	    s|<(tg ([^>]*))>(.*?)</tg>|<$1/>$3|g;
	    s|<(tgr ([^>]*))>(.*?)</tgr>|<$1/>$3|g;
	    s|<(til ([^>]*))>(.*?)</til>|<$1/>$3|g;
	    s|<(treg ([^>]*))>(.*?)</treg>|<$1/>$3|g;
	    s|<(wfp ([^>]*))>(.*?)</wfp>|<$1/>$3|g;
	}

	&gen_renumber_ng;
	&gen_fix_ipa_colon; # mantis 2151 ...

	s|(\(</z><ifs-g([^>]*)><if-g([^>]*)><z>) \(|$1|g; # mantis 2635 ...
	s|<z></z>||g;
	s| *(</z></label-g><tid>)| $1|gio;
    }
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
sub gen_eltdicts_xml_symbols
{
    # to keep old programs working
    &gen_eltdicts_imgs;
}

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
    s|&(infosym);|<img src=\"\1.png\"/>|gio;
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
    s|&(ssym);|<img src=\"\1.png\"/>|gio;
    s|&(synsep);|<img src=\"\1.png\"/>|gio;
    s|&(synsep2);|<img src=\"\1.png\"/>|gio;
    s|&(synsym);|<img src=\"\1.png\"/>|gio;
    s|&(taboo);|<img src=\"\1.png\"/>|gio;
    s|&(tceqsym);|<img src=\"\1.png\"/>|gio;
    s|&(ticksym);|<img src=\"\1.png\"/>|gio;
    s|&(tssym);|<img src=\"\1.png\"/>|gio;
    s|&(tusipa);|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|&(txsym);|<img src=\"\1.png\"/>|gio;
    s|&(unsym);|<img src=\"\1.png\"/>|gio;
    s|&(uncomp_sym);|<img src=\"\1.png\"/>|gio;
    s|&w;|&\#x00B7;|gio;
    s|&(w_in_(.*?));|&\#x00B7;|gio;
    s|&(xrsym);|<img src=\"\1.png\"/>|gio;
    s|&(xsym);|<img src=\"\1.png\"/>|gio;
    s|&(xsep);|<img src=\"\1.png\"/>|gio;
    s|&(xsym_first);|<img src=\"\1.png\"/>|gio;
}

sub gen_eltdicts_symbols
{
    s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    s| &awlsym; |<z> </z><z_awlsym>w</z_awlsym><z> </z>|g;
#   cfesym is same symbol as idsym ...
    s| &csym; |<z> </z><z_csym>c</z_csym><z> </z>|g;
    s|&csym; |<z_csym>c</z_csym><z> </z>|g;
    s| &cfesym; |<z> </z><z_cfesym>i</z_cfesym><z> </z>|g;
    s|&cfesym; |<z_cfesym>i</z_cfesym><z> </z>|g;
#   cfesep - used between <id-g>s ...
    s| &cfesep; |<z> </z><z_cfesep>X</z_cfesep><z> </z>|g; # same character as synsep ...
#   clsym uses same character position as unsym ...
    s|&clsym; |<z_clsym>A</z_clsym><z> </z>|g;
    s| &coresym; |<z> </z><z_coresym>k</z_coresym><z> </z>|g;
    s|&coresym; |<z_coresym>k</z_coresym><z> </z>|g;
    s| &crosssym; |<z> </z><z_crosssym>N</z_crosssym><z> </z>|g;
    s|&crosssym; |<z_crosssym>N</z_crosssym><z> </z>|g;
    s| &drsym; |<z> </z><z_drsym>d</z_drsym><z> </z>|g;
    s|&drsym; |<z_drsym>d</z_drsym><z> </z>|g;
    s| &etymsym; |<z> </z><z_etymsym>e</z_etymsym><z> </z>|g;
    s|&helpsym;|<z_helpsym>h</z_helpsym>|g;
    s| &idsym; |<z> </z><z_idsym>i</z_idsym><z> </z>|g;
    s| &idsym;|<z> </z><z_idsym>i</z_idsym>|g;
    s|&idsym; |<z_idsym>i</z_idsym><z> </z>|g;
    # Need to define these properly FK
    s| &idsyms; |<z> </z><z_idsym>i</z_idsym><z> </z>|g;
    s|&idsyms; |<z_idsym>i</z_idsym><z> </z>|g;
#   idsep - used between <id-g>s ...
    s| &idsep; |<z> </z><z_idsep>X</z_idsep><z> </z>|g; # same character as synsep ...
    s|&notesym;|<z_notesym>n</z_notesym>|g;
    s| &oppsym; |<z> </z><z_oppsym>o</z_oppsym><z> </z>|g;
    s|&oppsym; |<z_oppsym>o</z_oppsym><z> </z>|g;
    s|&psym;|<z_psym>S</z_psym>|g;
    s|&pvarr;|<z_pvarr>P</z_pvarr>|g;
    s| &pvsym; |<z> </z><z_pvsym>p</z_pvsym><z> </z>|g;
    s|&pvsym; |<z_pvsym>p</z_pvsym><z> </z>|g;
    # Need to change this in the future FK
    s| &pvsyms; |<z> </z><z_pvsym>p</z_pvsym><z> </z>|g;
    s|&pvsyms; |<z_pvsym>p</z_pvsym><z> </z>|g;
#   pvsep - used between <id-g>s ...
    s| &pvsep; |<z> </z><z_pvsep>X</z_pvsep><z> </z>|g; # same character as synsep ...
    s|&reflsym; |<z_reflsym>r</z_reflsym><z> </z>|g;
    s|&sdsym;|<z_sdsym>b</z_sdsym>|g;
#   synsep - used between synonyms ...
    s| &synsep; |<z> </z><z_synsep>X</z_synsep><z> </z>|g;
#   synsep2 - used between groups of synonyms ...
    s| &synsep2; |<z> </z><z_synsep2>\|</z_synsep2><z> </z>|g;
#   synsym - used before first synonym ...
    s| &synsym; |<z> </z><z_synsym>s</z_synsym><z> </z>|g;
    s|&taboo;|<z_taboosym>\!</z_taboosym>|g;
    s| &tceqsym; |<z> </z><z_tceqsym>=</z_tceqsym><z> </z>|g;
    s|&ticksym; |<z_ticksym>Y</z_ticksym><z> </z>|g;
    s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES)
    {
	&gen_bold_tildes;
    }
    s| &tssym; |<z> </z><z_tssym>t</z_tssym><z> </z>|g;
    s| &unsym; |<z> </z><z_unsym>A</z_unsym><z> </z>|g;
    s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    s| &xsym_first; |<z> </z><z_xsym_first>S</z_xsym_first><z> </z>|g;
    s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z> </z>|g;
    s|&p_in_(.*?);|<p_in_$1>"</p_in_$1>|g;
    s|&s_in_(.*?);|<s_in_$1>%</s_in_$1>|g;
    s|&w_in_(.*?);|<w_in_$1>&w;</w_in_$1>|g;
s|</z><z>||gi;
    s| <z> |<z> |g;
    s| </z><z> | </z><z>|g;
    s| </z></z><z> | </z>|g;
    s| </z> | </z>|g;
    s|<z> </z><z> </z>|<z> </z>|g;
    s|<z> </z></z><z><z> </z>|<z> </z>|g;
    s|<z> </z></z><ts-g><z> </z>| </z><ts-g>|g;
}


sub xdcc_symbols
{
#    <span class="symbol" data-s_type="sdsym"/>
    s|&(awlsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(blarrow);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(careof);|c/o|gio;
    s|&(cfesep);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(cfesym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(cfesyms);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(clsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(coresym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(crosssym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(csym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(drsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(etymsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(helpsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(idsep);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(idsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(idsyms);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(idssym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(infosym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(notesym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(oppsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&p;|&\#x02C8;|gio;
    s|&(p_in_(.*?));|&\#x02C8;|gio;
    s|&(psym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(pvarr);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(pvsep);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(pvsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(pvsyms);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(reflsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&s;|&\#x02CC;|gio;
    s|&(s_in_(.*?));|&\#x02CC;|gio;
    s|&(sdsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(ssym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(synsep);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(synsep2);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(synsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(taboo);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(tceqsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(ticksym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(tssym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(tusipa);|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|&(txsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(unsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(uncomp_sym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&w;|&\#x00B7;|gio;
    s|&(w_in_(.*?));|&\#x00B7;|gio;
    s|&(xrsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(xsym);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(xsep);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
    s|&(xsym_first);|<span class=\"symbol\" data-s_type=\"\1\"/>|gio;
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

sub gen_xg
{
    s|(<x-g[^>]*>)|$1<z>&xsym; </z>|gio;
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
	}
	$res .= $bit;
    }
    $res =~ s|&gsep;|</g>, <g >|gio;
    $res =~ s|&grsep;|, |gio;
    $res =~ s|&rsep;|</r>, <r >|gio;
    $res =~ s| *(</cm>) *(<label-g[^>]*>) *|$1 $2|gi;
    $res =~ s|\{\{|<|g;
    $res =~ s|\}\}|>|g;
    return $res;
}    

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
	}
	if (m|<value>(.*?)</value>|i)
	{
	    $value = $1;
	    $expr = sprintf("\$%s = %s", $var, $value);
	    eval $expr;
	}
    }
    close(in_fp);
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
    $e =~ s|\.<dh>|. <dh>|gi;
    $e =~ s|\.<dhb>|. <dhb>|gi;
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

sub do_dtxt_gr_fix
{
    my($e) = @_;
    unless ($e =~ m|<dtxt [^>]*type=\"gr\"|i)
    {
	return $e;
    }
    my($bit, $res);
    my(@BITS);
    $e =~ s|(<dtxt[ >].*?</dtxt>)|&split;&fk;$1&split;|gi;
    @BITS = split(/&split;/, $e);
    $res = "";
    foreach $bit (@BITS){
	if ($bit =~ s|&fk;||gio){
	    if ($bit =~ m|<dtxt [^>]*type=\"gr\"|i)
	    {
		$bit =~ s|<dtxt |<gr |i;
		$bit =~ s|</dtxt *> *$|</gr>|i;
	    }
	}
	$res .= $bit;
    }
    return $res;
}

##################################################

sub gen_trans_g
{
    my($e, $sep) = @_;
    my($res, $eid);
    $e =~ s|(</trans-g>) *(<trans-g)|\U\1\E$sep\U\2\E|gi;
    return $e;
}


sub label_punc
{
    my($e) = @_;
    my($bit, $res, $start);
    my(@BITS);
    $e = &do_dtxt_gr_fix($e);
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
	    $bit =~ s|(<label-g[^>]*>)(<[grs] [^>]*>[^<]*</[rgs]>) *(<cm [^>]*>[^<]*</cm>) *(<[grs] [^>]*>[^<]*</[rgs]>)(</label-g>)|$1\($2\) $3 \($4\) $5|gi;
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
	}
	$res .= $bit;
    }
    $res =~ s|&gsep;|</g>, <g >|gio;
    $res =~ s|&grsep;|, |gio;
    $res =~ s|&rsep;|</r>, <r >|gio;
    $res =~ s|\{\{|<|g;
    $res =~ s|\}\}|>|g;
    $res =~ s| *(<label-g)| $1|gi;
    $res =~ s|(</label-g>)|$1 |gi;
    return $res;
}    

sub add_space_after
{
    my($e, $a) = @_;
#    $e =~ s|(</[a-z0-9]+)>|$1 >|gi;
    $e =~ s| *(</$a>) *|\U\1\E\2 |g;
    return $e;
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


1;

