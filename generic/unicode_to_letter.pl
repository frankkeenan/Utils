#!/usr/local/bin/perl
#
# Input = 
# Result = 
# 
#
#
use Getopt::Std;
require "/disk1/home/keenanf/perl/utils.pl";

$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator

sub usage
{
    printf(STDERR "USAGE: $0 -u \n"); 
    printf(STDERR "\t-u:\tDisplay usage\n"); 
#    printf(STDERR "\t-x:\t\n"); 
    exit;
}

&main;

sub main
{
    getopts('u');
#    getopts('a:bz:');
#    stores value of arguments in $opt_a and $opt_z and BOOLEAN $opt_b
#
    if ($opt_u)
    {
	&usage;
    }
  line:    
    while (<>) 
    {
	chomp;       # strip record separator
	$_ = &undo_ents($_);
	print $_;
    }
}
sub undo_ents
{
    my($e) = @_;
    $e =~ s|&apos;|&ap;|go;
    $e =~ s|&\#x221B;|&cuberoot;|go;
    $e =~ s|&\#x3003;|&ditto;|go;
    $e =~ s|&\#x20AC;|&euro;|go;
    $e =~ s|/|&grslash;|go;
    $e =~ s|&frac12;|&half;|go;
    $e =~ s|-|&nbhyph;|go;
    $e =~ s|-|&nbhyphen;|go;
    $e =~ s|&thinsp;|&nbthinsp;|go;
    $e =~ s|&ndash;|&NDASH;|go;
    $e =~ s|&\#x02C8;|&p;|go; 
    $e =~ s|&phi;|&phis;|go;
    $e =~ s|&#x02CC;|&s;|go;
    $e =~ s|&sol;|/|goi;
    $e =~ s|&#x2027;|&w;|go;
    $e =~ s|&\#x00C6;|&AElig;|go;
    $e =~ s|&\#x00C1;|&Aacute;|go;
    $e =~ s|&\#x0102;|&Abreve;|go;
    $e =~ s|&\#x00C2;|&Acirc;|go;
    $e =~ s|&\#x00C0;|&Agrave;|go;
    $e =~ s|&\#x0100;|&Amacr;|go;
    $e =~ s|&\#x0104;|&Aogon;|go;
    $e =~ s|&\#x00C5;|&Aring;|go;
    $e =~ s|&\#x00C3;|&Atilde;|go;
    $e =~ s|&\#x00C4;|&Auml;|go;
    $e =~ s|&\#x0106;|&Cacute;|go;
    $e =~ s|&\#x010C;|&Ccaron;|go;
    $e =~ s|&\#x00C7;|&Ccedil;|go;
    $e =~ s|&\#x0108;|&Ccirc;|go;
    $e =~ s|&\#x010A;|&Cdot;|go;
    $e =~ s|&\#x2021;|&Dagger;|go;
    $e =~ s|&\#x010E;|&Dcaron;|go;
    $e =~ s|&\#x0394;|&Delta;|go;
    $e =~ s|&\#x0110;|&Dstrok;|go;
    $e =~ s|&\#x014A;|&ENG;|go;
    $e =~ s|&\#x00D0;|&ETH;|go;
    $e =~ s|&\#x00C9;|&Eacute;|go;
    $e =~ s|&\#x011A;|&Ecaron;|go;
    $e =~ s|&\#x00CA;|&Ecirc;|go;
    $e =~ s|&\#x0116;|&Edot;|go;
    $e =~ s|&\#x00C8;|&Egrave;|go;
    $e =~ s|&\#x0112;|&Emacr;|go;
    $e =~ s|&\#x0118;|&Eogon;|go;
    $e =~ s|&\#x00CB;|&Euml;|go;
    $e =~ s|&\#x0393;|&Gamma;|go;
    $e =~ s|&\#x011E;|&Gbreve;|go;
    $e =~ s|&\#x0122;|&Gcedil;|go;
    $e =~ s|&\#x011C;|&Gcirc;|go;
    $e =~ s|&\#x0120;|&Gdot;|go;
    $e =~ s|&\#x0124;|&Hcirc;|go;
    $e =~ s|&\#x0126;|&Hstrok;|go;
    $e =~ s|&\#x0132;|&IJlig;|go;
    $e =~ s|&\#x00CD;|&Iacute;|go;
    $e =~ s|&\#x00CE;|&Icirc;|go;
    $e =~ s|&\#x0130;|&Idot;|go;
    $e =~ s|&\#x00CC;|&Igrave;|go;
    $e =~ s|&\#x012A;|&Imacr;|go;
    $e =~ s|&\#x012E;|&Iogon;|go;
    $e =~ s|&\#x0128;|&Itilde;|go;
    $e =~ s|&\#x00CF;|&Iuml;|go;
    $e =~ s|&\#x0134;|&Jcirc;|go;
    $e =~ s|&\#x0136;|&Kcedil;|go;
    $e =~ s|&\#x0139;|&Lacute;|go;
    $e =~ s|&\#x039B;|&Lambda;|go;
    $e =~ s|&\#x013D;|&Lcaron;|go;
    $e =~ s|&\#x013B;|&Lcedil;|go;
    $e =~ s|&\#x013F;|&Lmidot;|go;
    $e =~ s|&\#x0141;|&Lstrok;|go;
    $e =~ s|&\#x0143;|&Nacute;|go;
    $e =~ s|&\#x0147;|&Ncaron;|go;
    $e =~ s|&\#x0145;|&Ncedil;|go;
    $e =~ s|&\#x00D1;|&Ntilde;|go;
    $e =~ s|&\#x0152;|&OElig;|go;
    $e =~ s|&\#x00D3;|&Oacute;|go;
    $e =~ s|&\#x00D4;|&Ocirc;|go;
    $e =~ s|&\#x0150;|&Odblac;|go;
    $e =~ s|&\#x00D2;|&Ograve;|go;
    $e =~ s|&\#x014C;|&Omacr;|go;
    $e =~ s|&\#x03A9;|&Omega;|go;
    $e =~ s|&\#x00D8;|&Oslash;|go;
    $e =~ s|&\#x00D5;|&Otilde;|go;
    $e =~ s|&\#x00D6;|&Ouml;|go;
    $e =~ s|&\#x03A6;|&Phi;|go;
    $e =~ s|&\#x03A0;|&Pi;|go;
    $e =~ s|&\#x2033;|&Prime;|go;
    $e =~ s|&\#x03A8;|&Psi;|go;
    $e =~ s|&\#x0154;|&Racute;|go;
    $e =~ s|&\#x0158;|&Rcaron;|go;
    $e =~ s|&\#x0156;|&Rcedil;|go;
    $e =~ s|&\#x015A;|&Sacute;|go;
    $e =~ s|&\#x0160;|&Scaron;|go;
    $e =~ s|&\#x015E;|&Scedil;|go;
    $e =~ s|&\#x015C;|&Scirc;|go;
    $e =~ s|&\#x03A3;|&Sigma;|go;
    $e =~ s|&\#x00DE;|&THORN;|go;
    $e =~ s|&\#x0164;|&Tcaron;|go;
    $e =~ s|&\#x0162;|&Tcedil;|go;
    $e =~ s|&\#x0398;|&Theta;|go;
    $e =~ s|&\#x0166;|&Tstrok;|go;
    $e =~ s|&\#x00DA;|&Uacute;|go;
    $e =~ s|&\#x016C;|&Ubreve;|go;
    $e =~ s|&\#x00DB;|&Ucirc;|go;
    $e =~ s|&\#x0170;|&Udblac;|go;
    $e =~ s|&\#x00D9;|&Ugrave;|go;
    $e =~ s|&\#x016A;|&Umacr;|go;
    $e =~ s|&\#x0172;|&Uogon;|go;
    $e =~ s|&\#x03D2;|&Upsi;|go;
    $e =~ s|&\#x016E;|&Uring;|go;
    $e =~ s|&\#x0168;|&Utilde;|go;
    $e =~ s|&\#x00DC;|&Uuml;|go;
    $e =~ s|&\#x0174;|&Wcirc;|go;
    $e =~ s|&\#x039E;|&Xi;|go;
    $e =~ s|&\#x00DD;|&Yacute;|go;
    $e =~ s|&\#x0176;|&Ycirc;|go;
    $e =~ s|&\#x0178;|&Yuml;|go;
    $e =~ s|&\#x0179;|&Zacute;|go;
    $e =~ s|&\#x017D;|&Zcaron;|go;
    $e =~ s|&\#x017B;|&Zdot;|go;
    $e =~ s|&\#x00E1;|&aacute;|go;
    $e =~ s|&\#x0103;|&abreve;|go;
    $e =~ s|&\#x00E2;|&acirc;|go;
    $e =~ s|&\#x00E6;|&aelig;|go;
    $e =~ s|&\#x00E0;|&agrave;|go;
    $e =~ s|&\#x03B1;|&alpha;|go;
    $e =~ s|&\#x0101;|&amacr;|go;
    $e =~ s|&\#x0026;|&amp;|go;
    $e =~ s|&\#x0105;|&aogon;|go;
    $e =~ s|&\#x0027;|&apos;|go;
    $e =~ s|&\#x00E5;|&aring;|go;
    $e =~ s|&\#x002A;|&ast;|go;
    $e =~ s|&\#x2217;|&ast;|go;
    $e =~ s|&\#x00E3;|&atilde;|go;
    $e =~ s|&\#x00E4;|&auml;|go;
    $e =~ s|&\#x03B2;|&beta;|go;
    $e =~ s|&\#x2423;|&blank;|go;
    $e =~ s|&\#x2592;|&blk12;|go;
    $e =~ s|&\#x2591;|&blk14;|go;
    $e =~ s|&\#x2593;|&blk34;|go;
    $e =~ s|&\#x2588;|&block;|go;
    $e =~ s|&\#x00A6;|&brvbar;|go;
    $e =~ s|&\#x005C;|&bsol;|go;
    $e =~ s|&\#x2022;|&bull;|go;
    $e =~ s|&\#x0107;|&cacute;|go;
    $e =~ s|&\#x2041;|&caret;|go;
    $e =~ s|&\#x010D;|&ccaron;|go;
    $e =~ s|&\#x00E7;|&ccedil;|go;
    $e =~ s|&\#x0109;|&ccirc;|go;
    $e =~ s|&\#x010B;|&cdot;|go;
    $e =~ s|&\#x00A2;|&cent;|go;
    $e =~ s|&\#x2713;|&check;|go;
    $e =~ s|&\#x03C7;|&chi;|go;
    $e =~ s|&\#x25CB;|&cir;|go;
    $e =~ s|&\#x2663;|&clubs;|go;
    $e =~ s|&\#x003A;|&colon;|go;
    $e =~ s|&\#x002C;|&comma;|go;
    $e =~ s|&\#x0040;|&commat;|go;
    $e =~ s|&\#x00A9;|&copy;|go;
    $e =~ s|&\#x2117;|&copysr;|go;
    $e =~ s|&\#x2717;|&cross;|go;
    $e =~ s|&\#x00A4;|&curren;|go;
    $e =~ s|&\#x2020;|&dagger;|go;
    $e =~ s|&\#x2193;|&darr;|go;
    $e =~ s|&\#x2010;|&dash;|go;
    $e =~ s|&\#x010F;|&dcaron;|go;
    $e =~ s|&\#x00B0;|&deg;|go;
    $e =~ s|&\#x03B4;|&delta;|go;
    $e =~ s|&\#x2666;|&diams;|go;
    $e =~ s|&\#x00F7;|&divide;|go;
    $e =~ s|&\#x230D;|&dlcrop;|go;
    $e =~ s|&\#x0024;|&dollar;|go;
    $e =~ s|&\#x230C;|&drcrop;|go;
    $e =~ s|&\#x0111;|&dstrok;|go;
    $e =~ s|&\#x25BF;|&dtri;|go;
    $e =~ s|&\#x25BE;|&dtrif;|go;
    $e =~ s|&\#x00E9;|&eacute;|go;
    $e =~ s|&\#x011B;|&ecaron;|go;
    $e =~ s|&\#x00EA;|&ecirc;|go;
    $e =~ s|&\#x0117;|&edot;|go;
    $e =~ s|&\#x00E8;|&egrave;|go;
    $e =~ s|&\#x0113;|&emacr;|go;
    $e =~ s|&\#x2004;|&emsp13;|go;
    $e =~ s|&\#x2005;|&emsp14;|go;
    $e =~ s|&\#x2003;|&emsp;|go;
    $e =~ s|&\#x014B;|&eng;|go;
    $e =~ s|&\#x2002;|&ensp;|go;
    $e =~ s|&\#x0119;|&eogon;|go;
    $e =~ s|&\#x03F5;|&epsi;|go;
    $e =~ s|&\#x003D;|&equals;|go;
    $e =~ s|&\#x03B7;|&eta;|go;
    $e =~ s|&\#x00F0;|&eth;|go;
    $e =~ s|&\#x00EB;|&euml;|go;
    $e =~ s|&\#x0021;|&excl;|go;
    $e =~ s|&\#x2640;|&female;|go;
    $e =~ s|&\#xFB03;|&ffilig;|go;
    $e =~ s|&\#xFB00;|&fflig;|go;
    $e =~ s|&\#xFB04;|&ffllig;|go;
    $e =~ s|&\#xFB01;|&filig;|go;
    $e =~ s|&\#x266D;|&flat;|go;
    $e =~ s|&\#xFB02;|&fllig;|go;
    $e =~ s|&\#x00BD;|&frac12;|go;
    $e =~ s|&\#x2153;|&frac13;|go;
    $e =~ s|&\#x00BC;|&frac14;|go;
    $e =~ s|&\#x2155;|&frac15;|go;
    $e =~ s|&\#x2159;|&frac16;|go;
    $e =~ s|&\#x215B;|&frac18;|go;
    $e =~ s|&\#x2154;|&frac23;|go;
    $e =~ s|&\#x2156;|&frac25;|go;
    $e =~ s|&\#x00BE;|&frac34;|go;
    $e =~ s|&\#x2157;|&frac35;|go;
    $e =~ s|&\#x215C;|&frac38;|go;
    $e =~ s|&\#x2158;|&frac45;|go;
    $e =~ s|&\#x215A;|&frac56;|go;
    $e =~ s|&\#x215D;|&frac58;|go;
    $e =~ s|&\#x215E;|&frac78;|go;
    $e =~ s|&\#x01F5;|&gacute;|go;
    $e =~ s|&\#x03B3;|&gamma;|go;
    $e =~ s|&\#x011F;|&gbreve;|go;
    $e =~ s|&\#x011D;|&gcirc;|go;
    $e =~ s|&\#x0121;|&gdot;|go;
    $e =~ s|&\#x003E;|&gt;|go;
    $e =~ s|&\#x200A;|&hairsp;|go;
    $e =~ s|&\#x00BD;|&half;|go;
    $e =~ s|&\#x0125;|&hcirc;|go;
    $e =~ s|&\#x2665;|&hearts;|go;
    $e =~ s|&\#x2026;|&hellip;|go;
    $e =~ s|&\#x2015;|&horbar;|go;
    $e =~ s|&\#x0127;|&hstrok;|go;
    $e =~ s|&\#x2043;|&hybull;|go;
    $e =~ s|&\#x2010;|&hyphen;|go;
    $e =~ s|&\#x00ED;|&iacute;|go;
    $e =~ s|&\#x00EE;|&icirc;|go;
    $e =~ s|&\#x00A1;|&iexcl;|go;
    $e =~ s|&\#x00EC;|&igrave;|go;
    $e =~ s|&\#x0133;|&ijlig;|go;
    $e =~ s|&\#x012B;|&imacr;|go;
    $e =~ s|&\#x2105;|&incare;|go;
    $e =~ s|&\#x221E;|&infin;|go;
    $e =~ s|&\#x0131;|&inodot;|go;
    $e =~ s|&\#x012F;|&iogon;|go;
    $e =~ s|&\#x03B9;|&iota;|go;
    $e =~ s|&\#x00BF;|&iquest;|go;
    $e =~ s|&\#x0129;|&itilde;|go;
    $e =~ s|&\#x00EF;|&iuml;|go;
    $e =~ s|&\#x0135;|&jcirc;|go;
    $e =~ s|&\#x03BA;|&kappa;|go;
    $e =~ s|&\#x0137;|&kcedil;|go;
    $e =~ s|&\#x0138;|&kgreen;|go;
    $e =~ s|&\#x013A;|&lacute;|go;
    $e =~ s|&\#x03BB;|&lambda;|go;
    $e =~ s|&\#x00AB;|&laquo;|go;
    $e =~ s|&\#x2190;|&larr;|go;
    $e =~ s|&\#x013E;|&lcaron;|go;
    $e =~ s|&\#x013C;|&lcedil;|go;
    $e =~ s|&\#x007B;|&lcub;|go;
    $e =~ s|&\#x201C;|&ldquo;|go;
    $e =~ s|&\#x201E;|&ldquor;|go;
    $e =~ s|&\#x2584;|&lhblk;|go;
    $e =~ s|&\#x0140;|&lmidot;|go;
    $e =~ s|&\#x005F;|&lowbar;|go;
    $e =~ s|&\#x25CA;|&loz;|go;
    $e =~ s|&\#x2726;|&lozf;|go;
    $e =~ s|&\#x0028;|&lpar;|go;
    $e =~ s|&\#x005B;|&lsqb;|go;
    $e =~ s|&\#x2018;|&lsquo;|go;
    $e =~ s|&\#x201A;|&lsquor;|go;
    $e =~ s|&\#x0142;|&lstrok;|go;
    $e =~ s|&\#x003C;|&lt;|go;
    $e =~ s|&\#x25C3;|&ltri;|go;
    $e =~ s|&\#x25C2;|&ltrif;|go;
    $e =~ s|&\#x00AF;|&macr;|go;
    $e =~ s|&\#x2642;|&male;|go;
    $e =~ s|&\#x2720;|&malt;|go;
    $e =~ s|&\#x25AE;|&marker;|go;
    $e =~ s|&\#x2014;|&mdash;|go;
    $e =~ s|&\#x00B5;|&micro;|go;
    $e =~ s|&\#x00B7;|&middot;|go;
    $e =~ s|&\#x2212;|&minus;|go;
    $e =~ s|&\#x2026;|&mldr;|go;
    $e =~ s|&\#x03BC;|&mu;|go;
    $e =~ s|&\#x0144;|&nacute;|go;
    $e =~ s|&\#x0149;|&napos;|go;
    $e =~ s|&\#x266E;|&natur;|go;
    $e =~ s|&\#x00A0;|&nbsp;|go;
    $e =~ s|&\#x2009;|&nbthinsp;|go;
    $e =~ s|&\#x0148;|&ncaron;|go;
    $e =~ s|&\#x0146;|&ncedil;|go;
    $e =~ s|&\#x2013;|&ndash;|go;
    $e =~ s|&\#x2025;|&nldr;|go;
    $e =~ s|&\#x00AC;|&not;|go;
    $e =~ s|&\#x00F1;|&ntilde;|go;
    $e =~ s|&\#x03BD;|&nu;|go;
    $e =~ s|&\#x0023;|&num;|go;
    $e =~ s|&\#x2007;|&numsp;|go;
    $e =~ s|&\#x00F3;|&oacute;|go;
    $e =~ s|&\#x00F4;|&ocirc;|go;
    $e =~ s|&\#x0151;|&odblac;|go;
    $e =~ s|&\#x0153;|&oelig;|go;
    $e =~ s|&\#x00F2;|&ograve;|go;
    $e =~ s|&\#x2126;|&ohm;|go;
    $e =~ s|&\#x014D;|&omacr;|go;
    $e =~ s|&\#x03C9;|&omega;|go;
    $e =~ s|&\#x00AA;|&ordf;|go;
    $e =~ s|&\#x00BA;|&ordm;|go;
    $e =~ s|&\#x00F8;|&oslash;|go;
    $e =~ s|&\#x00F5;|&otilde;|go;
    $e =~ s|&\#x00F6;|&ouml;|go;
    $e =~ s|&\#x00B6;|&para;|go;
    $e =~ s|&\#x0025;|&percnt;|go;
    $e =~ s|&\#x002E;|&period;|go;
    $e =~ s|&\#x260E;|&phone;|go;
    $e =~ s|&\#x03C0;|&pi;|go;
    $e =~ s|&\#x03D5;|&phi;|go; # BC 15Sep04
    $e =~ s|&\#x002B;|&plus;|go;
    $e =~ s|&\#x00B1;|&plusmn;|go;
    $e =~ s|&\#x00A3;|&pound;|go;
    $e =~ s|&\#x2032;|&prime;|go;
    $e =~ s|&\#x03C8;|&psi;|go;
    $e =~ s|&\#x2008;|&puncsp;|go;
    $e =~ s|&\#x003F;|&quest;|go;
    $e =~ s|&\#x0022;|&quot;|go;
    $e =~ s|&\#x0155;|&racute;|go;
    $e =~ s|&\#x221A;|&radic;|go;
    $e =~ s|&\#x00BB;|&raquo;|go;
    $e =~ s|&\#x2192;|&rarr;|go;
    $e =~ s|&\#x0159;|&rcaron;|go;
    $e =~ s|&\#x0157;|&rcedil;|go;
    $e =~ s|&\#x007D;|&rcub;|go;
    $e =~ s|&\#x201D;|&rdquo;|go;
    $e =~ s|&\#x201C;|&rdquor;|go;
    $e =~ s|&\#x25AD;|&rect;|go;
    $e =~ s|&\#x00AE;|&reg;|go;
    $e =~ s|&\#x03C1;|&rho;|go;
    $e =~ s|&\#x0029;|&rpar;|go;
    $e =~ s|&\#x005D;|&rsqb;|go;
    $e =~ s|&\#x2019;|&rsquo;|go;
    $e =~ s|&\#x2018;|&rsquor;|go;
    $e =~ s|&\#x25B9;|&rtri;|go;
    $e =~ s|&\#x25B8;|&rtrif;|go;
    $e =~ s|&\#x211E;|&rx;|go;
    $e =~ s|&\#x015B;|&sacute;|go;
    $e =~ s|&\#x0161;|&scaron;|go;
    $e =~ s|&\#x015F;|&scedil;|go;
    $e =~ s|&\#x015D;|&scirc;|go;
    $e =~ s|&\#x00A7;|&sect;|go;
    $e =~ s|&\#x003B;|&semi;|go;
    $e =~ s|&\#x2736;|&sext;|go;
    $e =~ s|&\#x266F;|&sharp;|go;
    $e =~ s|&\#x00AD;|&shy;|go;
    $e =~ s|&\#x03C3;|&sigma;|go;
    $e =~ s|&\#x002F;|&sol;|go;
    $e =~ s|&\#x2660;|&spades;|go;
    $e =~ s|&\#x25A1;|&squ;|go;
    $e =~ s|&\#x25AA;|&squf;|go;
    $e =~ s|&\#x22C6;|&star;|go;
    $e =~ s|&\#x2605;|&starf;|go;
    $e =~ s|&\#x2669;|&sung;|go;
    $e =~ s|&\#x00B9;|&sup1;|go;
    $e =~ s|&\#x00B2;|&sup2;|go;
    $e =~ s|&\#x00B3;|&sup3;|go;
    $e =~ s|&\#x00DF;|&szlig;|go;
    $e =~ s|&\#x2316;|&target;|go;
    $e =~ s|&\#x03C4;|&tau;|go;
    $e =~ s|&\#x0165;|&tcaron;|go;
    $e =~ s|&\#x0163;|&tcedil;|go;
    $e =~ s|&\#x2315;|&telrec;|go;
    $e =~ s|&\#x03B8;|&theta;|go; # BC 15Sep04
    $e =~ s|&\#x2009;|&thinsp;|go;
    $e =~ s|&\#x2009;|&thinsp[^;]*;|go;
    $e =~ s|&\#x00FE;|&thorn;|go;
    $e =~ s|&\#x02DC;|&tilde;|go;
    $e =~ s|&\#x00D7;|&times;|go;
    $e =~ s|&\#x2122;|&trade;|go;
    $e =~ s|&\#x0167;|&tstrok;|go;
    $e =~ s|&\#x00FA;|&uacute;|go;
    $e =~ s|&\#x2191;|&uarr;|go;
    $e =~ s|&\#x016D;|&ubreve;|go;
    $e =~ s|&\#x00FB;|&ucirc;|go;
    $e =~ s|&\#x0171;|&udblac;|go;
    $e =~ s|&\#x00F9;|&ugrave;|go;
    $e =~ s|&\#x2580;|&uhblk;|go;
    $e =~ s|&\#x230F;|&ulcrop;|go;
    $e =~ s|&\#x016B;|&umacr;|go;
    $e =~ s|&\#x0173;|&uogon;|go;
    $e =~ s|&\#x03C5;|&upsi;|go;
    $e =~ s|&\#x230E;|&urcrop;|go;
    $e =~ s|&\#x016F;|&uring;|go;
    $e =~ s|&\#x0169;|&utilde;|go;
    $e =~ s|&\#x25B5;|&utri;|go;
    $e =~ s|&\#x25B4;|&utrif;|go;
    $e =~ s|&\#x00FC;|&uuml;|go;
    $e =~ s|&\#x22EE;|&vellip;|go;
    $e =~ s|&\#x007C;|&verbar;|go;
    $e =~ s|&\#x0175;|&wcirc;|go;
    $e =~ s|&\#x03BE;|&xi;|go;
    $e =~ s|&\#x00FD;|&yacute;|go;
    $e =~ s|&\#x0177;|&ycirc;|go;
    $e =~ s|&\#x00A5;|&yen;|go;
    $e =~ s|&\#x00FF;|&yuml;|go;
    $e =~ s|&\#x017A;|&zacute;|go;
    $e =~ s|&\#x017E;|&zcaron;|go;
    $e =~ s|&\#x017C;|&zdot;|go;
    return $e;
}
