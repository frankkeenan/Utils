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
#
# Input =
# Result =
# $Id: generic_pnc_cd.pl,v 1.1 2010/01/25 17:32:54 keenanf Exp keenanf $
# $Log: generic_pnc_cd.pl,v $
# Revision 1.1  2010/01/25 17:32:54  keenanf
# Initial revision
#
# Revision 1.105  2010/01/19 15:36:34  coumbeb
# *** empty log message ***
#
# Revision 1.104  2009/12/09 16:11:47  coumbeb
# *** empty log message ***
#
# Revision 1.103  2009/11/20 15:47:50  coumbeb
# *** empty log message ***
#
# Revision 1.102  2009/10/26 11:21:06  coumbeb
# *** empty log message ***
#
# Revision 1.101  2009/10/08 15:23:14  coumbeb
# *** empty log message ***
#
# Revision 1.100  2009/10/06 10:55:56  coumbeb
# *** empty log message ***
#
# Revision 1.99  2009/09/30 12:31:40  coumbeb
# *** empty log message ***
#
# Revision 1.98  2009/09/29 16:35:47  coumbeb
# *** empty log message ***
#
# Revision 1.97  2009/09/29 14:20:06  coumbeb
# *** empty log message ***
#
# Revision 1.96  2009/09/28 14:53:49  coumbeb
# *** empty log message ***
#
# Revision 1.95  2009/09/24 16:11:04  coumbeb
# *** empty log message ***
#
# Revision 1.94  2009/09/23 16:26:09  coumbeb
# *** empty log message ***
#
# Revision 1.93  2009/09/22 15:36:01  coumbeb
# mantis 2640
#
# Revision 1.92  2009/09/21 13:24:01  coumbeb
# mantis 2635
#
# Revision 1.91  2009/09/21 12:19:17  coumbeb
# *** empty log message ***
#
# Revision 1.90  2009/09/18 16:30:30  coumbeb
# *** empty log message ***
#
# Revision 1.89  2009/09/17 14:53:18  coumbeb
# *** empty log message ***
#
# Revision 1.88  2009/09/10 13:01:39  coumbeb
# *** empty log message ***
#
# Revision 1.87  2009/09/04 16:27:52  coumbeb
# *** empty log message ***
#
# Revision 1.86  2009/09/03 16:37:40  coumbeb
# *** empty log message ***
#
# Revision 1.85  2009/09/03 14:13:34  coumbeb
# *** empty log message ***
#
# Revision 1.84  2009/08/28 16:20:40  coumbeb
# mantis 2541
#
# Revision 1.83  2009/08/28 16:12:45  coumbeb
# mantis 2541
#
# Revision 1.82  2009/08/28 09:36:50  coumbeb
# lingea mantis 1272
#
# Revision 1.81  2009/08/14 15:48:24  coumbeb
# *** empty log message ***
#
# Revision 1.80  2009/08/14 14:54:05  coumbeb
# mantis 2522
#
# Revision 1.79  2009/08/14 14:33:45  coumbeb
# mantis 2515
#
# Revision 1.78  2009/08/14 13:43:46  coumbeb
# *** empty log message ***
#
# Revision 1.77  2009/08/14 13:26:07  coumbeb
# mantis 2514
#
# Revision 1.76  2009/08/14 13:08:13  coumbeb
# mantis 2519
#
# Revision 1.75  2009/08/05 10:26:01  coumbeb
# mantis 2494
#
# Revision 1.74  2009/08/05 09:47:05  coumbeb
# *** empty log message ***
#
# Revision 1.73  2009/08/04 14:41:44  coumbeb
# *** empty log message ***
#
# Revision 1.72  2009/08/03 10:42:18  coumbeb
# *** empty log message ***
#
# Revision 1.71  2009/07/20 10:38:51  coumbeb
# un spacing
#
# Revision 1.70  2009/07/13 13:35:19  coumbeb
# *** empty log message ***
#
# Revision 1.69  2009/07/10 16:07:31  coumbeb
# *** empty log message ***
#
# Revision 1.68  2009/07/10 13:28:18  coumbeb
# *** empty log message ***
#
# Revision 1.67  2009/07/09 11:38:18  coumbeb
# *** empty log message ***
#
# Revision 1.66  2009/06/10 15:53:05  coumbeb
# *** empty log message ***
#
# Revision 1.65  2009/06/08 13:51:13  coumbeb
# *** empty log message ***
#
# Revision 1.64  2009/06/08 11:08:57  teasdalt
# fixed minor bug in code for keeping <cf> with <x>
#
# Revision 1.63  2009/06/05 09:28:30  coumbeb
# *** empty log message ***
#
# Revision 1.62  2009/05/28 14:48:58  coumbeb
# *** empty log message ***
#
# Revision 1.61  2009/05/22 15:24:05  coumbeb
# *** empty log message ***
#
# Revision 1.60  2009/05/21 12:55:16  coumbeb
# *** empty log message ***
#
# Revision 1.59  2009/05/19 16:27:35  coumbeb
# *** empty log message ***
#
# Revision 1.58  2009/05/18 15:59:53  coumbeb
# *** empty log message ***
#
# Revision 1.57  2009/05/15 15:09:42  coumbeb
# *** empty log message ***
#
# Revision 1.56  2009/05/15 12:36:07  coumbeb
# *** empty log message ***
#
# Revision 1.55  2009/05/14 16:31:59  coumbeb
# *** empty log message ***
#
# Revision 1.54  2009/05/14 15:31:46  coumbeb
# *** empty log message ***
#
# Revision 1.53  2009/04/30 15:34:54  coumbeb
# *** empty log message ***
#
# Revision 1.52  2009/04/28 15:24:30  teasdalt
# *** empty log message ***
#
# Revision 1.51  2009/04/01 15:46:12  coumbeb
# *** empty log message ***
#
# Revision 1.50  2009/03/27 11:15:11  coumbeb
# mntis 2151 - again ...
#
# Revision 1.49  2009/03/27 10:36:46  coumbeb
# mantis 2151
#
# Revision 1.48  2009/03/24 13:58:29  coumbeb
# *** empty log message ***
#
# Revision 1.47  2009/03/10 08:36:55  keenanf
# Defined flap t as a unicode combining character
#
# Revision 1.46  2009/03/09 10:30:26  keenanf
# Added backslashes to hashes, and brackets
#
# Revision 1.45  2009/03/04 10:15:31  coumbeb
# various mods for portuguese 2e
#
# Revision 1.44  2009/03/02 16:57:17  coumbeb
# *** empty log message ***
#
# Revision 1.43  2009/02/24 17:25:40  coumbeb
# *** empty log message ***
#
# Revision 1.42  2009/02/18 13:58:13  coumbeb
# *** empty log message ***
#
# Revision 1.41  2009/02/13 08:27:53  keenanf
# *** empty log message ***
#
# Revision 1.40  2009/02/12 14:20:48  coumbeb
# various czech fixes ...
#
# Revision 1.39  2009/02/09 16:47:06  coumbeb
# *** empty log message ***
#
# Revision 1.38  2009/01/20 12:24:54  coumbeb
# *** empty log message ***
#
# Revision 1.37  2009/01/19 15:00:06  coumbeb
# *** empty log message ***
#
# Revision 1.36  2009/01/14 14:47:55  coumbeb
# *** empty log message ***
#
# Revision 1.35  2009/01/14 11:00:16  coumbeb
# *** empty log message ***
#
# Revision 1.34  2009/01/14 10:53:20  coumbeb
# *** empty log message ***
#
# Revision 1.33  2009/01/13 16:22:36  coumbeb
# *** empty log message ***
#
# Revision 1.32  2009/01/13 15:02:45  coumbeb
# *** empty log message ***
#
# Revision 1.31  2009/01/13 14:05:10  coumbeb
# *** empty log message ***
#
# Revision 1.30  2009/01/13 11:33:42  coumbeb
# *** empty log message ***
#
# Revision 1.29  2009/01/05 16:52:22  coumbeb
# *** empty log message ***
#
# Revision 1.28  2009/01/05 16:44:01  coumbeb
# *** empty log message ***
#
# Revision 1.27  2008/12/22 12:50:15  coumbeb
# *** empty log message ***
#
# Revision 1.26  2008/12/15 16:00:18  coumbeb
# added some code for OAD
#
# Revision 1.25  2008/10/16 14:32:42  coumbeb
# *** empty log message ***
#
# Revision 1.24  2008/09/30 16:26:02  coumbeb
# *** empty log message ***
#
# Revision 1.23  2008/09/25 15:00:20  coumbeb
# *** empty log message ***
#
# Revision 1.22  2008/09/25 14:45:18  coumbeb
# *** empty log message ***
#
# Revision 1.21  2008/09/22 14:51:55  coumbeb
# *** empty log message ***
#
# Revision 1.20  2008/09/22 13:41:23  coumbeb
# *** empty log message ***
#
# Revision 1.19  2008/09/19 15:40:00  coumbeb
# *** empty log message ***
#
# Revision 1.18  2008/09/19 13:57:27  coumbeb
# *** empty log message ***
#
# Revision 1.17  2008/09/19 12:57:35  coumbeb
# *** empty log message ***
#
# Revision 1.16  2008/09/18 10:15:28  coumbeb
# *** empty log message ***
#
# Revision 1.15  2008/09/18 10:06:55  coumbeb
# *** empty log message ***
#
# Revision 1.14  2008/09/17 08:39:39  keenanf
# Fixed lint error
#
# Revision 1.13  2008/09/16 16:07:44  coumbeb
# *** empty log message ***
#
# Revision 1.12  2008/09/16 15:27:53  keenanf
# *** empty log message ***
#
# Revision 1.11  2008/09/16 09:22:48  coumbeb
# *** empty log message ***
#
# Revision 1.10  2008/09/15 14:47:32  coumbeb
# *** empty log message ***
#
# Revision 1.9  2008/09/15 13:09:02  coumbeb
# *** empty log message ***
#
# Revision 1.8  2008/09/15 12:31:51  coumbeb
# *** empty log message ***
#
# Revision 1.7  2008/09/12 16:11:33  coumbeb
# *** empty log message ***
#
# Revision 1.6  2008/09/04 15:15:47  coumbeb
# *** empty log message ***
#
# Revision 1.5  2008/09/04 09:42:50  keenanf
# *** empty log message ***
#
# Revision 1.4  2008/08/28 10:59:51  coumbeb
# *** empty log message ***
#
# Revision 1.3  2008/08/26 15:42:10  coumbeb
# *** empty log message ***
#
# Revision 1.2  2008/07/23 13:01:53  coumbeb
# *** empty log message ***
#
# Revision 1.1  2007/06/28 13:05:39  coumbeb
# Initial revision
#
#
##################################################

use Getopt::Std;
use Smart::Comments '###';
require "/data/dicts/generic/progs/ents_to_unicode.pl";
require "/data/dicts/generic/progs/unicode_phons.pl";

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
    while (<ATTVAL>)
    {
#   look for <tag attribute="value">text</tag> ...
	while (s|<([^ >]+) ([^=]+)="([^"]+)">(.*?)</\1>||)
	{
#   key to ATT hash = tag_attribute_value ...
	    $key = "$1_$2_$3";
	    $text = "$4";
	    $ATT{$key} = "$text";
	}
    }
    close(ATTVAL);
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
    s|<x ([^>]*)pub="el"([^>]*)>(.*?)</x><tx .*?</tx>||gi;
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
    s|<i-g.*?</i-g>||g;
}

##################################################

sub gen_a
{
    s|</a><a |</A><z>, </z><A |g;
    if ($A_ROUND_BRACKETS)
    {
	s|<a |<z> \(</z><A |g;
	s|</a>|</A><z>\)</z>|g;
    }
    else
    {
	s|<a |<z> </z><A |g;
    }
#   insert expansion text ...
    s|<A |<a |g;
    while (/<a ([^>]*)q="(.*?)"/)
    {
        $key = "a_q_$2";
	$text = $ATT{$key};
	s|<a ([^>]*)q="(.*?)"(.*?)>|<a $1Q="$2"$3><z_a>$text </z_a>|;
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
    s|<ATPR |<atpr |g;
    while (/<atpr ([^>]*)atpr="(.*?)"/)
    {
        $key = "atpr_atpr_$2";
	$text = $ATT{$key};
	s|<atpr ([^>]*)atpr="(.*?)"(.*?)>|<atpr $1ATPR="$2"$3><z_atpr>$text</z_atpr>|;
    }
}

##################################################

sub gen_bf
{
    s|</bf><bf |</BF><z>, </z><BF |g;
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
    s|</cfe-g><cfe-g |</CFE-G><z> </z><CFE-G |g;
    if ($IDSEP)
    {
	s|</cfe-g><z> </z><cfe-g |</cfe-g><z> &cfesep; </z><cfe-g |gi;
    }
}

##################################################

sub gen_cfes_g
{
    s|<cfes-g |<z> &cfesym; </z><CFES-G |g;
}

##################################################

sub gen_cl
{
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
		$bit =~ s|<d |<zp_d/><D |g;
	    }
	    $res .= $bit;
	}
	$_ = $res;
    }
    else
    {
	s|<d |<z> </z><D |g;
    }
}

##################################################

sub gen_dacadv
{
    s|(<dacadv)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</dacadv>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_dc
{
    s|(<dc)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dc>|<z>\)</z></DC>|g;
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
    s|</dhs>|<z>&rsquo;</z></DHS>|g;
    s| ?<dhs ([^>]*>)|<DHS $1<z>&lsquo;</z>|g;
}

##################################################

sub gen_dlf
{
    s|</tgr><dlf |</tgr><z>;</z><dlf |g; # mantis 1823 ...

    s|(<dlf)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dlf>|<z>\)</z></DLF>|g;


#    s|</dlf>|</DLF><z>\)</z>|g;
#    s|<dlf |<z> \(</z><DLF |g;
#   insert expansion text ...
    s|<DLF |<dlf |g;
    while (/<dlf ([^>]*)dlf="(.*?)"/)
    {
	$key = "dlf_dlf_$2";
	$text = $ATT{$key};
	s|<dlf ([^>]*)dlf="(.*?)"(.*?)>|<dlf $1DLF="$2"$3><z_dlf>$text</z_dlf>|;
    }
}

##################################################

sub gen_dnca
{
    s|(<dnca)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dnca>|<z>\)</z></DNCA>|g;
#    s|<dnca |<z> \(</z><DNCA |g;
#    s|</dnca>|</DNCA><z>\)</z>|g;
}

##################################################

sub gen_dncn
{
    s|(<dncn)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dncn>|<z>\)</z></DNCN>|g;
#    s|<dncn |<z> \(</z><DNCN |g;
#    s|</dncn>|</DNCN><z>\)</z>|g;
}

##################################################

sub gen_dnov
{
    s|(<dnov)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dnov>|<z>\)</z></DNOV>|g;
#    s|<dnov |<z> \(</z><DNOV |g;
#    s|</dnov>|</DNOV><z>\)</z>|g;
}

##################################################

sub gen_dnsv
{
    s|(<dnsv)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|</dnsv>|<z>\)</z></DNSV>|g;
#    s|<dnsv |<z> \(</z><DNSV |g;
#    s|</dnsv>|</DNSV><z>\)</z>|g;
}

##################################################

sub gen_dr
{
    s|</dr><dr |</DR><z>, </z><DR |gio;
}

##################################################

sub gen_dr_g
{
    s|<dr-g([^>]*)academic=\"y\"(.*?)</dr>|$&<z> &awlsym; </z>|g;
    s|</dr-g><dr-g |</DR-G><DR-G |g;
    s|<dr-g (.*?>)|<DR-G $1<z>&drsym; </z>|g;
}

##################################################

sub gen_dre
{
    s|(<z> &awlsym; </z>)(<dre (.*?)</dre>)|$2$1|g;
    s|<dre |<z>, </z>$&|g;
}

##################################################

sub gen_ds
{
    s|</ts><ds |</ts><z>;</z><ds |g; # mantis 1811 ...
    s|</tcf><ds |</tcf><z>;</z><ds |g; # mantis 1946 ...
    s|</tgr><ds |</tgr><z>;</z><ds |g; # mantis 2006 ...
    s|</treg><ds |</treg><z>;</z><ds |g; # mantis 2004 ...
#   insert expansion text ...
    while (/<ds ([^>]*)ds="(.*?)"/)
    {
	$key = "ds_ds_$2";
	$text = $ATT{$key};
	warn "not defined: ds = $2\n" if ($text !~/[a-z]/i);
	s|<ds ([^>]*)ds="(.*?)"(.*?)>|<ds $1DS="$2"$3><z_ds>$text</z_ds>|;
    }
    s|<ds (.*?>)|<DS $1<z> \(</z>|g;
    s|</ds>|<z>\)</z></DS>|g;
}

##################################################

sub gen_dst
{
    s|<dst (.*?>)|<DST $1<z> \(</z>|g;
    s|</dst>|<z>\)</z></DST>|g;
}

##################################################

sub gen_dsyn
{
    s|<dsyn (.*?>)|<DSYN $1<z> \(</z>|g;
    s|</dsyn>|<z>\)</z></DSYN>|g;
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
    s|(<dtxt ([^>]*)type="gr"([^>]*)>)(.*?)(</dtxt>)|<z> </z><z_gr_br>[</z_gr_br>\U$1\E<z_gr>$4</z_gr>\U$5\E<z_gr_br>]</z_gr_br>|gi; # as per engpor2e ...
    s|<z_gr_br>\]</z_gr_br><z>, </z><z> </z><z_gr_br>\[</z_gr_br>|<z>, </z>|g;
    s|</dtxt><t2 |</dtxt><z> </z><T2 |g; # mantis 2257 ...
    s|<dtxt (.*?>)|<DTXT $1<z> \(</z>|g;
    s|</dtxt>|<z>\)</z></DTXT>|g;
}

##################################################

sub gen_dvcadv
{
    s|<dvcadv (.*?>)|<DVCADV $1<z> \(</z>|g;
    s|</dvcadv>|<z>\)</z></DVCADV>|g;
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
    s|<ei-g ([^>]*>)|<EI-G $1<z> /</z>|g;
    s|</ei-g>|<z>/</z></EI-G>|g;
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

#   insert expansion text for "usage note entries" (as found in AMESS) ...
    s|<ENTRY |<entry |g;
    while (/<entry ([^>]*)boxtype="(.*?)"/)
    {
        $key = "entry_boxtype_$2";
	$text = $ATT{$key};
	s|<entry ([^>]*)boxtype="(.*?)"(.*?)>|<entry $1BOXTYPE="$2"$3><z_unbox>$text</z_unbox>|;
	s|<z_unbox>&TAB;|<z_unbox tab="y">|g;
    }

}

##################################################

sub gen_eph
{
    s|<eph ([^>]*>)|<EPH $1<z> /</z>|g;
    s|</eph>|<z>/</z></EPH>|g;
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
    s|<etym ([^>]*>)|<ETYM $1<z> &etymsym; </z>|g;
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
	s|(<ff)( [^>]*>)|\U$1\E$2<z> \(<z_ff>&z_abbr_of;</z_ff> </z>|g;
	s|(</ff>)|<z>\)</z>\U$1\E|g;
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
#   insert expansion text ...
    s|<G |<g |g;
    while (/<g ([^>]*)g="(.*?)"/)
    {
	$key = "g_g_$2";
	$text = $ATT{$key};
	s|<g ([^>]*)g="(.*?)"(.*?)>|<g $1G="$2"$3><z_g>$text</z_g>|;
    }
    s|</cf><g |</CF><z>;</z><g |g; # mantis 1941 ...
    s|</g><g |</G><z>, </z><G |g;
    s|</g><r |</G><z>, </z><R |g;
    s|</g><s |</G><z>, </z><S |g;
    s|</r><g |</R><z>, </z><G |g;
    s|<g brackets="n"(.*?)</g>|<z> </z><G $1</G>|g; # mantis 2699
    s|(<g)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</g>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_gi
{
#   insert expansion text ...
    s|<GI |<gi |g;
    while (/<gi ([^>]*)gi="(.*?)"/)
    {
        $key = "gi_gi_$2";
	$text = $ATT{$key};
	s|<gi ([^>]*)gi="(.*?)"(.*?)>|<gi $1GI="$2"$3><z_gi>$text</z_gi>|;
    }
}

##################################################

sub gen_gl
{
    if ($GL_ADD_EQUALS)
    {
	s|(<gl)( [^>]*>)|$1$2<z>=</z>|g;
    }
    if ($GL_ADD_BRACKETS)
    {
	s|(<gl)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
	s|(</gl>)|<z>\)</z>\U$1\E|g;
    }
}

##################################################

sub gen_gr
{
#   insert expansion text ...
    s|<GR |<gr |g;
    while (/<gr ([^>]*)gr="(.*?)"/)
    {
	$key = "gr_gr_$2";
	$text = $ATT{$key};
	s|<gr ([^>]*)gr="(.*?)"(.*?)>|<gr $1GR="$2"$3><z_gr>$text</z_gr>|;
    }
    s|</gr><p |</gr><z>,</z><p |g;
    s|</gr><gr |</GR><z>, </z><GR |g;
    s|(<gr)( [^>]*>)|\U$1\E$2<z> \[</z>|g;
    s|(</gr>)|<z>\]</z>\U$1\E|g;

}

##################################################

sub gen_h
{
    if (/<entry([^>]*)core="y"/)
    {
	s|<h ([^>]*)>(.*?)</h>|<h $1><z_core_h>$2</z_core_h></h>|g;
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
    s|(<x)( [^>]*>)|\U$1\E$2<z> \(<z_he>&z_gb;</z_he> &z_also; </z>|g;
    s|(</x>)|<z>\)</z>\U$1\E|g;
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
	s|<help (.*?)>|<HELP $1><z>&helpsym; </z>|g;
    }
    else
    {
	s|<help (.*?)>|<HELP $1><z> &helpsym; </z>|g;
    }
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
    s|</i><g ([^<]*)</g><y |</I><z>; </z><G $1</G><z> </z><Y |g; # mantis 2530 ...
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
    s|(<i-g)( [^>]*>)|\U$1\E$2<z> /</z>|g;
    s|</i-g><if |<z>/</z></I-G><z>, </z><IF |g;
    s|</i-g><il |<z>/</z></I-G><z>, </z><IL |g;
    s|</i-g><v |<z>/</z></I-G><z>, </z><V |g;
    s|</i-g>|<z>/</z></I-G>|g;
}

##################################################

sub gen_id
{
    s|</id><id |</ID><z>; </z><ID |g;

    s|</id>(<g ([^>]*)></g>)<id |</ID><z>;</z>$1<z> </z><ID |g; # mantis 2303 ...
    s|</id>(<r ([^>]*)></r>)<id |</ID><z>;</z>$1<z> </z><ID |g; # mantis 2303 ...
    s|</id>(<s ([^>]*)></s>)<id |</ID><z>;</z>$1<z> </z><ID |g; # mantis 2303 ...
}

##################################################

sub gen_id_g
{
    s|(<id-g)( [^>]*multi=\"y[^>]*>)|\U$1\E$2<z>&idsyms; </z>|g;
    s|(<id-g)( [^>]*>)|\U$1\E$2<z>&idsym; </z>|g;
    if ($IDSEP)
    {
	s|</id-g><z> </z><id-g |</id-g><z> &idsep; </z><id-g |gi;
    }
}

##################################################

sub idxh
{
    s|<idxh .*?</idxh>( ?)||g;
}

##################################################

sub gen_if
{
    s|</g><if |</G><z> </z><IF |g;
    s|</r><if |</R><z> </z><IF |g; # mantis 2560 ...
    s|</s><if |</R><z> </z><IF |g; # mantis 2636 ...
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
	    $bit =~ s|<ifs-g |<z> </z><IFS-G|go;
	}
	$res .= $bit;
    }
    $_ = $res;
    s|(<ifs-g)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</ifs-g>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_il
{
    s|</il><il |</IL><z>, </z><IL |g; # mantis 2352 ...
    s|(<ifs-g ([^>]*)>)<il |$1<IL |gi;
    s|<il |<z> </z><IL |g;
#   insert expansion text ...
    s|<IL |<il |g;
    while (/<il ([^>]*)il="(.*?)"/)
    {
        $key = "il_il_$2";
	$text = $ATT{$key};
	s|<il ([^>]*)il="(.*?)"(.*?)>|<il $1IL="$2"$3><z_il>$text</z_il>|;
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

sub gen_l_g
{
    s|<l-g([^>]*) l="([a-z])"(.*?)>|<z> </z>$&<z_l>($2)</z_l><z> </z>|g;
}

##################################################

sub gen_n_g
{
    s|<n-g([^>]*) n="([0-9]+)"(.*?)>|$&<z_n>$2</z_n><z> </z>|g;
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
    s|</g><opp |</g><z> </z><OPP |g;
    s|</r><opp |</r><z> </z><OPP |g;
    s|</opp><opp |</OPP><z>, </z><OPP |g;
    s|</opp><g |</OPP><z>,</z><g |g;
    s|</opp><r |</OPP><z>,</z><r |g;
}

##################################################

sub gen_opp_g
{
    s|<opp-g ([^>]*)><([grs]) ([^>]*)></\2>|<opp-g $1><z> </z><\U$2\E $3></\U$2\E><z> </z>|g;
    if ($OPPTEXT)
    {
	s|<opp-g (.*?)>|<OPP-G $1><z>&oppsym; </z><z_opptext>OPP</z_opptext>|g;
    }
    else
    {
	s|<opp-g (.*?)>|<OPP-G $1><z>&oppsym; </z>|g;
    }
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

#   insert expansion text ...
    s|<P |<p |g;
    while (/<p ([^>]*)p="(.*?)"/)
    {
        $key = "p_p_$2";
	$text = $ATT{$key};
	s|<p ([^>]*)p="(.*?)"(.*?)>|<p $1P="$2"$3><z_p>$text</z_p>|;
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
##	    $bit =~ s|<z_p>|<z_p_in_p-g>|gio;
##	    $bit =~ s|</z_p>|</z_p_in_p-g>|gio;
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
##            $bit =~ s|<z_p_in_p-g>|<z_p>|gio;
##            $bit =~ s|</z_p_in_p-g>|</z_p>|gio;
        }
        $res .= $bit;
    }
    $_ = $res;

}

##################################################

sub gen_p_g
{
    s|<p-g (.*?)>|<P-G $1><z>&psym; </z>|g;
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
	    $bit =~ s|(<h-g.*?<p [^>]*>)|$1$2<z> &psym;</z>|;
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
    $_ = &phon_ents($_);
    s|</phon-gb><g ([^<]*)</g><phon-gb |</PHON-GB><z>; </z><G $1</G><z> </z><PHON-GB |g;
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
    $_ = &phon_ents($_);
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
#   insert expansion text ...
    s|<PT |<pt |g;
    while (/<pt ([^>]*)pt="(.*?)"/)
    {
	$key = "pt_pt_$2";
	$text = $ATT{$key};
	s|<pt ([^>]*)pt="(.*?)"(.*?)>|<pt $1PT="$2"$3><z_pt>$text</z_pt>|;
    }
    while (/<pt ([^>]*)q="(.*?)"/)
    {
	$key = "pt_q_$2";
	$text = $ATT{$key};
	s|<pt ([^>]*)q="(.*?)"(.*?)>|<pt $1Q="$2"$3><z_pt>$text </z_pt>|;
    }
    s|</pt><pt |</PT><z>, </z><PT |g;
    s|(<pt)( [^>]*>)|\U$1\E$2<z> \[</z>|g;
    s|(</pt>)|<z>\]</z>\U$1\E|g;
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
    unless ($PVG_NEWLINE)
    {
	s|</pv-g><pv-g |</PV-G><z> </z><PV-G |g;
    }

    s|</pv-g></pvp-g><pvp-g([^>]*)><pv-g |</PV-G></PVP-G><zp_pv-g/><PVP-G$1><PV-G |g; # mantis 2522 ...
    s|</pv-g><np/><pv-g |</PV-G><PV-G |g;

    if ($PVSYM_NEWLINE)
    {
	s|<pv-g( [^>]*multi=\"y[^>]*>)|<PV-G $1<z>&pvsyms; </z>|g;
	s|<pv-g( [^>]*>)|<PV-G $1<z>&pvsym; </z>|g;
    }
    else
    {
	s|<pv-g( [^>]*multi=\"y[^>]*>)|<PV-G $1<z> &pvsyms; </z>|g;
	s|<pv-g( [^>]*>)|<PV-G $1<z> &pvsym; </z>|g;
    }
    s|</sd-g><z> &pvsym|</sd-g><zp_pv-g/><z>&pvsym|g;
    if ($PVSEP)
    {
	s|</pv-g><z> </z><pv-g |</pv-g><z> &pvsep; </z><pv-g |gi;
    }
}

##################################################

sub gen_pvp_g
{
}

##################################################

sub gen_pvpt
{
#   insert expansion text ...
    s|<PVPT |<pvpt |g;
    while (/<pvpt ([^>]*)pvpt="(.*?)"/)
    {
	$key = "pvpt_pvpt_$2";
	$text = $ATT{$key};
	s|<pvpt ([^>]*)pvpt="(.*?)"(.*?)>|<pvpt $1PVPT="$2"$3><z_pvpt>$text</z_pvpt>|;
    }
    s|</pvpt><pvpt |</PVPT><z>, </z><PVPT |g;
    s|(<pvpt)( [^>]*>)|\U$1\E$2<z> \[</z>|g;
    s|(</pvpt>)|<z>\]</z>\U$1\E|g;

}

##################################################

sub gen_r
{
#   insert expansion text ...
    s|<R |<r |g;
    while (/<r ([^>]*)r="(.*?)"/)
    {
	$key = "r_r_$2";
	$text = $ATT{$key};
	s|<r ([^>]*)r="(.*?)"(.*?)>|<r $1R="$2"$3><z_r>$text</z_r>|;
    }
    while (/<r ([^>]*)q="(.*?)"/)
    {
	$key = "r_q_$2";
	$text = $ATT{$key};
	s|<r ([^>]*)q="(.*?)"(.*?)>|<r $1Q="$2"$3><z_r>$text </z_r>|;
    }
    s|</r><g |</R><z>, </z><G |g;
    s|</r><r |</R><z>, </z><R |g;
    s|</r><s |</R><z>, </z><S |g;
    s|(<r)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</r>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_refl
{
}

##################################################

sub gen_refl_g
{
    s|<refl-g ([^>]*>)|<REFL-G $1<z>&reflsym; </z>|g;
}

##################################################

sub gen_reflp
{
    s|<reflp |/<REFLP |g;
}

##################################################

sub gen_rv
{
    s|<rv |<z> </z><RV |g;
}

##################################################

sub gen_s
{
#   insert expansion text ...
    s|<S |<s |g;
    while (/<s ([^>]*)s="(.*?)"/)
    {
	$key = "s_s_$2";
	$text = $ATT{$key};
	s|<s ([^>]*)s="(.*?)"(.*?)>|<s $1S="$2"$3><z_s>$text</z_s>|;
    }
    s|</s><g |</S><z>, </z><G |g;
    s|</s><r |</S><z>, </z><R |g;
    s|</s><s |</S><z>, </z><S |g;
    s|(<s)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</s>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_sd
{
}

##################################################

sub gen_sd_g
{
    s|<sd-g ([^>]*)>|\U$&\E<z>&sdsym; </z>|g;
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
    s|</sym>|</SYM><z>\)</z>|g;
    s|<sym |<z> \(</z><z_sym>&z_symb;</z_sym><z> </z><SYM |g;
}

##################################################

sub gen_syn
{
    s|</syn><g |</SYN><z> &synsep2; </z><G |g;
    s|</syn><r |</SYN><z> &synsep2; </z><R |g;
    s|</syn><s |</SYN><z> &synsep2; </z><S |g;
    s|</syn><u |</SYN><z> &synsep2;</z><u |g;
    s|</g><syn |</G><z> </z><SYN |g;
    s|</r><syn |</R><z> </z><SYN |g;
    s|</s><syn |</S><z> </z><SYN |g;
    s|</syn><syn |</SYN><z> &synsep; </z><SYN |g;
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
    s|</tab><tg |<z>\)</z></TAB><z>,</z><tg |g; # mantis 2020 ...
    s|(<tab)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tab>)|<z>\)</z>\U$1\E|g;
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
    # next one is hairy
    s|<tadv ([^>]*)>(.*?)</tadv>(<i-g .*?)(</i-g>)|<TADV $1><z> (</z><z_tadv>&z_adv;</z_tadv><z> </z>$2</TADV> $3<z>)</z></I-G>|g;
#    s|<tadv (.*?)</tadv>(<i-g (.*?)</i-g>)|<z> (</z><z_tadv>&z_adv;</z_tadv><z> </z><TADV $1</TADV>$2<z>)</z>|g;

    s|(<tadv)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tadv>)|<z>\)</z>\U$1\E|g;

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
#   insert expansion text ...
    s|<TATPR |<tatpr |g;
    while (/<tatpr ([^>]*)tatpr="(.*?)"/)
    {
        $key = "tatpr_tatpr_$2";
	$text = $ATT{$key};
	s|<tatpr ([^>]*)tatpr="(.*?)"(.*?)>|<tatpr $1TATPR="$2"$3><z_tatpr>$text</z_tatpr>|;
    }
    s|(<tatpr)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tatpr>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tceq
{
    s|</tceq><tg |</TCEQ><z>,</z><tg |g; # mantis 1817 ...
    s|</tceq><tceq |</TCEQ><z>, </z><TCEQ |g; # mantis 1793 ...
    s|(<tceq [^>]*>)|$1<z> &tceqsym; </z>|g;
}

##################################################

sub gen_tcf
{
    s|</treg><tcf |</treg><z>,</z><tcf |g;
    s|</tgr><tcf |</tgr><z>,</z><tcf |g; # mantis 2017 ...
    s|</tcf><tcf |</TCF><z>, </z><TCF |g;
    s|</tcf><tg |</tcf><z>,</z><tg |g; # mantis 1983 ...
    s|</tcf><ts |</TCF><z>, </z><TS |g; # mantis 1837 ...
    s|</ts><tcf |</TS><z>, </z><TCF |g; # mantis 1990 ...
    s|(<tcf ([^>]*)>)<ts |$1<TS |g;
    s|<tcf |<z> </z><TCF |g;
}

##################################################

sub gen_tcfe
{
    s|<tcfe |<z> </z><TCFE |g;
}

##################################################

sub gen_tcu
{
#   insert expansion text ...
    s|<TCU |<tcu |g;
    while (/<tcu ([^>]*)tcu="(.*?)"/)
    {
	$key = "tcu_tcu_$2";
	$text = $ATT{$key};
	s|<tcu ([^>]*)tcu="(.*?)"(.*?)>|<tcu $1TCU="$2"$3><z_tcu>$text</z_tcu>|;
    }
    s|</tcu><tev |</TCU><z>, </z><TEV |g;
    s|(<tcu)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tcu>)|<z>\)</z>\U$1\E|g;
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
    s|(<tel)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tel>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tev
{
#   insert expansion text ...
    s|<TEV |<tev |g;
    while (/<tev ([^>]*)tev="(.*?)"/)
    {
	$key = "tev_tev_$2";
	$text = $ATT{$key};
	s|<tev ([^>]*)tev="(.*?)"(.*?)>|<tev $1TEV="$2"$3><z_tev>$text</z_tev>|;
    }
    s|</treg><tev |</TREG><z>, </z><TEV |g;
    s|</tev><tev |</TEV><z>, </z><TEV |g; # mantis 2016 ...
    s|</tev><tg |</tev><z>,</z><tg |g; # mantis 2022 ...
    s|(<tev)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tev>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tg
{
#   insert expansion text ...
    s|<TG |<tg |g;
    while (/<tg ([^>]*)tg="(.*?)"/)
    {
	$key = "tg_tg_$2";
	$text = $ATT{$key};
	s|<tg ([^>]*)tg="(.*?)"(.*?)>|<tg $1TG="$2"$3><z_tg>$text</z_tg>|;
    }
    s|</tg><tg |</TG><z>, </z><TG |g;
    s|</tg><treg |</TG><z>, </z><TREG |g;
    s|</treg><tg |</TREG><z>, </z><TG |g; # mantis 1853 ...
    s|(<tg)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tg>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tgl
{
    s|(<tgl)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tgl>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tgr
{
#   insert expansion text ...
    s|<TGR |<tgr |g;
    while (/<tgr ([^>]*)tgr="(.*?)"/)
    {
	$key = "tgr_tgr_$2";
	$text = $ATT{$key};
	s|<tgr ([^>]*)tgr="(.*?)"(.*?)>|<tgr $1TGR="$2"$3><z_tgr>$text</z_tgr>|;
    }
    s|</tgr><tgr |</TGR><z>, </z><TGR |g;
    s|(<tgr)( [^>]*>)|\U$1\E$2<z> \[</z>|g;
    s|(</tgr>)|<z>\]</z>\U$1\E|g;
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
    s|<tid |<z> </z><TID |g;
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
    s|<TIL |<til |g;
    while (/<til ([^>]*)til="(.*?)"/)
    {
        $key = "til_til_$2";
	$text = $ATT{$key};
	s|<til ([^>]*)til="(.*?)"(.*?)>|<til $1TIL="$2"$3><z_til>$text</z_til>|;
    }
}

##################################################

sub gen_title
{
}

##################################################

sub gen_tp
{
    s|<tp |<z> </z><TP |g;
#   insert expansion text ...
    s|<TP |<tp |g;
    while (/<tp ([^>]*)tp="(.*?)"/)
    {
        $key = "tp_tp_$2";
	$text = $ATT{$key};
	s|<tp ([^>]*)tp="(.*?)"(.*?)>|<tp $1TP="$2"$3><z_tp>$text</z_tp>|;
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
#   insert expansion text ...
    s|<TREG |<treg |g;
    while (/<treg ([^>]*)treg="(.*?)"/)
    {
	$key = "treg_treg_$2";
	$text = $ATT{$key};
	s|<treg ([^>]*)treg="(.*?)"(.*?)>|<treg $1TREG="$2"$3><z_treg>$text</z_treg>|;
    }
    s|</treg><treg |</TREG><z>, </z><TREG |g; # mantis 1976 ...
    s|(<treg)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</treg>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_ts
{
    s|</treg><ts |</treg><z>,</z><ts |g; # mantis 1822 ...
#    s|(<ts([^>]*) t="(.*?)"(.*?))</ts>|$1, -$3</ts>|g; # commented by mantis 2234 ...
    s|(<ts([^>]*) t="([^"]+)"(.*?))(</ts>)|$1, -$3$5|gi; # mantis 2234 ...
    s|</ts><ts |</TS><z>, </z><TS |g; # requested for engpor2e ...
    s|<ts |<z> </z><TS |g;
}

##################################################

sub gen_ts_g
{
    s|</t2-g><ts-g |</T2-G><z>; </z><TS-G |g;
    s|</ts-g><ts-g |</TS-G><z>; </z><TS-G |g;
    s|(<ts-g)( [^>]*>)|\U$1\E$2<z> &tssym; </z>|g;
}

##################################################

sub gen_tu
{
    s|(<tu)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</tu>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_tx
{
    s|</tx><x |</TX><z> &xsep; </z><X |g;
    s|<tx |<z> </z><TX |g;
}

##################################################

sub gen_u
{
    if ($U_SQUARE_BRACKETS)
    {
	s|(<u)( [^>]*>)|\U$1\E$2<z> \[</z>|g;
	s|(</u>)|<z>\]</z>\U$1\E|g;
    }
    else
    {
	s|(<u)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
	s|(</u>)|<z>\)</z>\U$1\E|g;
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
#   insert expansion text ...
    s|<un |<un |g;
    while (/<un ([^>]*)type="(.*?)"/)
    {
        $key = "un_type_$2";
	$text = $ATT{$key};
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
	s|<unbox ([^>]*)type="(.*?)"(.*?)>|<unbox $1TYPE="$2"$3><z_unbox>$text</z_unbox>|;

#   following line requires &TAB; in attval file ...

	s|<z_unbox>&TAB;|<z_unbox tab="y">|g;
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
	s|(<ungl)( [^>]*>)|\U$1\E$2<z> \(=</z>|g;
	s|(</ungl>)|<z>\)</z>\U$1\E|g;
    }
}

##################################################

sub gen_unp
{
#   insert expansion text ...
    s|<UNP |<unp |g;
    while (/<unp ([^>]*)p="(.*?)"/)
    {
        $key = "unp_p_$2";
	$text = $ATT{$key};
	s|<unp ([^>]*)p="(.*?)"(.*?)>|<unp $1P="$2"$3><z_unp>$text</z_unp>|;
    }
    s|(<unp)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</unp>)|<z>\)</z>\U$1\E|g;
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
    s|</g><v |</G><z> </z><V |g;
    s|</r><v |</R><z> </z><V |g;
    s|</s><v |</S><z> </z><V |g;
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
    s|</g><vf |</G><z> </z><VF |g;
}

##################################################

sub gen_vs
{
    s|</vs><g |</VS><z> </z><G |g;
    s|</vs><vs |</VS><z>, </z><VS |g;
    s|</g><vs |</G><z> </z><VS |g;
    s|</r><vs |</R><z> </z><VS |g; # mantis 2374 ...
}

##################################################

sub gen_vs_g
{
    s|<vs-g ([^>]*?)><g |<VS-G $1><z> \(</z><G |g;
    s|<vs-g ([^>]*?)><r |<VS-G $1><z> \(</z><R |g;
    s|<vs-g ([^>]*?)>|<VS-G $1><z> \(</z><z_vs-g>&z_also;</z_vs-g><z> </z>|g;
    s|</vs-g>|<z>\)</z></VS-G>|g;
}

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
#   insert expansion text ...
    s|<WFP |<wfp |g;
    while (/<wfp ([^>]*)p="(.*?)"/)
    {
        $key = "wfp_p_$2";
	$text = $ATT{$key};
	s|<wfp ([^>]*)p="(.*?)"(.*?)>|<wfp $1P="$2"$3><z_wfp>$text</z_wfp>|;
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
    s|</wx><wx |</WX><z> &xsep; </z><WX |g;
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
    if ($DOXSEP)
    {
	s|</x><x |</X><z> &xsep; </z><X |g;
	s|</x><wx |</X><z> &xsep; </z><WX |g;
	s|<x |<z>: </z><X |g;
    }
	s|</wx><x |</WX><z> &xsep; </z><X |g;


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

sub gen_xp
{
    s|<xp |<z> </z>$&|g;
#   insert expansion text (if used) ...
    s|<XP |<xp |g;
    while (/<xp ([^>]*)p="(.*?)"/)
    {
        $key = "xp_xp_$2";
	$text = $ATT{$key};
	s|<xp ([^>]*)p="(.*?)"(.*?)>|<xp $1P="$2"$3><z_xp>$text</z_xp>|;
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
    &gen_add_xt_to_closer;

    s|</xr xt="(n?syn)"><xr ([^>]*)xt="(n?syn)"|</XR><z>, </z><XR_HIDE $2xt="$3"|g; # mantis 2519 ...
    s|</xr xt="(.*?)"><xr ([^>]*)xt="\1"|</XR><z>, </z><XR_HIDE $2xt="$1"|g;

#   conditional "idioms see also" generated text requires <xr xt="id_ALSO"> in attval file ...

    if ($ID_SEE_ALSO)
    {
	s|(</id-g>)<xr ([^>]*)xt="id"|$1<xr $2xt="id_ALSO"|gi;
    }

#   conditional "illustrations at" generated text requires <xr xt="picat_PLURAL"> in attval file ...

    if ($ILLS_AT)
    {
	s|#|&temphash;|g;
	s|</xr (.*?)>|$&#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt="picat"([^\#]*)</xr xt="picat">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr ([^>]*)xt="picat"([^\#]*)</XR>|<xr $1xt="picat_PLURAL"$2</XR>|g;
	s|\#||g;
	s|&temphash;|\#|g;
    }

#   conditional "notes at" generated text requires <xr xt="useat_PLURAL"> in attval file ...
    
    if ($NOTES_AT)
    {
	s|\#|&temphash;|g;
	s|</xr (.*?)>|$&\#|gi;
	s|<z>, </z>(<XR_HIDE ([^>]*)xt="useat"([^\#]*)</xr xt="useat">)|<z_xr> &z_xr_and; </z_xr>$1|g;
	s|<xr ([^>]*)xt="useat"([^\#]*)</XR>|<xr $1xt="useat_PLURAL"$2</XR>|g;
	s|\#||g;
	s|&temphash;|\#|g;
    }
    
#   full point at end of last xr of type if attribute present ...
    
    s|\#|&temphash;|g;
    s|</xr (.*?)>|$&\#|gi;
    s|(<xr ([^>]*)fullpoint="y"([^\#]*))</xr xt="(.*?)">|$1<z>.</z></XR>|g;
    s|\#||g;
    s|&temphash;|\#|g;
    
    s|</xr xt="(.*?)">|</XR>|g;

#   insert expansion text ...
    s|<XR |<xr |g;
    while (/<xr ([^>]*)xt="(.*?)"/)
    {
	$key = "xr_xt_$2";
	$text = $ATT{$key};
	s|<xr ([^>]*)xt="(.*?)"(.*?)>|<xr $1XT="$2"$3><z_xr>$text</z_xr>|;
    }
    
    s|<XR_HIDE |<xr |g;
    s| (xt="id)_ALSO"| $1"|gi;
    s| (xt="picat)_PLURAL"| $1"|gi;
    s| (xt="useat)_PLURAL"| $1"|gi;

}

##################################################

sub gen_xs
{
    s|(<xs)( [^>]*>)|\U$1\E$2<z> \(</z>|g;
    s|(</xs>)|<z>\)</z>\U$1\E|g;
}

##################################################

sub gen_xt
{
    s|</unbox><xt |</unbox><XT |g; # mantis 2319 ...
    s|<xt |<z> </z><XT |g; # mantis 2319 ...

    if ($XT_SYMBOL)
    {
	s|(<XT [^>]*>)|$1<z>&xrsym; </z>|g;
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
    s|<atpr (.*?)>|$&</atpr>|g;
    s|<dlf (.*?)>|$&</dlf>|g;
    s|<ds (.*?)>|$&</ds>|g;
    s|<g (.*?)>|$&</g>|g;
    s|<gi (.*?)>|$&</gi>|g;
    s|<gr (.*?)>|$&</gr>|g;
    s|<il (.*?)>|$&</il>|g;
    s|<p (.*?)>|$&</p>|g;
    s|<pt (.*?)>|$&</pt>|g;
    s|<pvpt (.*?)>|$&</pvpt>|g;
    s|<r (.*?)>|$&</r>|g;
    s|<s (.*?)>|$&</s>|g;
    s|<tatpr (.*?)>|$&</tatpr>|g;
    s|<tcu (.*?)>|$&</tcu>|g;
    s|<tev (.*?)>|$&</tev>|g;
    s|<tg (.*?)>|$&</tg>|g;
    s|<tgr (.*?)>|$&</tgr>|g;
    s|<til (.*?)>|$&</til>|g;
    s|<treg (.*?)>|$&</treg>|g;
    s|<wfp (.*?)>|$&</wfp>|g;
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

sub gen_tweak
{
#   lowercase tags ...
    s|<(.*?)>|\L$&\E|g;
#   map eltdicts symbols as per project symbol fonts ...
    &gen_eltdicts_symbols;
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
    s|([\.\!\?])<ungl|$1 <ungl|g; # mantis 2692 ...
    s|([\.\!\?])<arbd1|$1 <arbd1|g; # mantis 2691 ...
    s| </z>, |</z>, |gi; # mantis 2694 ...
    s|</unwx><arbd1|</unwx> <arbd1|gi; # mantis 2703 ...
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
    
#   remove temp end tags from empty elements ...
    s|</atpr>||g;
    s|</dlf>||g;
    s|</ds>||g;
    s|</g>||g;
    s|</gi>||g;
    s|</gr>||g;
    s|</il>||g;
    s|</p>||g;
    s|</pt>||g;
    s|</pvpt>||g;
    s|</r>||g;
    s|</s>||g;
    s|</tatpr>||g;
    s|</tcu>||g;
    s|</tev>||g;
    s|</tg>||g;
    s|</tgr>||g;
    s|</til>||g;
    s|</treg>||g;
    s|</wfp>||g;
    &gen_renumber_ng;
    &gen_fix_ipa_colon; # mantis 2151 ...
    s|<z>\) *</z><d>|<z>\) </z><d>|gi;
    s|(\(</z><ifs-g([^>]*)><if-g([^>]*)><z>) \(|$1|g; # mantis 2635 ...
    s|<z></z>||g;

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

sub gen_eltdicts_symbols
{
    s|</z><z>||g;
#   map eltdicts symbols as per project symbol fonts ...
    if ($DO_SYM_FONT)
    {
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
    s| &tssym; |<z> </z><z_tssym>t</z_tssym><z> </z>|g;
    s| &unsym; |<z> </z><z_unsym>A</z_unsym><z> </z>|g;
    s|&xrsym;|<z_xrsym>a</z_xrsym>|g;
#   xsep - used between examples ...
    s|&xsep;|<z_xsym>x</z_xsym>|g;
#   xsym_first - used before first example (same character position as psym) ...
    s| &xsym_first; |<z> </z><z_xsym_first>S</z_xsym_first><z> </z>|g;
    s|&xsym_first; |<z_xsym_first>S</z_xsym_first><z> </z>|g;
    }
    s|&tusipa;|t&\#x032C;|gio; # flap t as proper unicode - for typesetting redefine as &#xE000;
    s|~|<z_tilde>~</z_tilde>|g;
    if ($BOLD_TILDES)
    {
	&gen_bold_tildes;
    }
    s|&p_in_(.*?);|&pstress;|g;
    s|&s_in_(.*?);|&sstress;|g;
    s|&w_in_(.*?);|&w;|g;
    s| <z> |<z>|g;
    s| </z><z> | </z><z>|g;
    s| </z></z><z> | </z>|g;
    s| </z> | </z>|g;
    s|<z> </z><z> </z>|<z> </z>|g;
    s|<z> </z></z><z><z> </z>|<z> </z>|g;
    s|<z> </z></z><ts-g><z> </z>|<z> </z></z><ts-g>|g;
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
1;
