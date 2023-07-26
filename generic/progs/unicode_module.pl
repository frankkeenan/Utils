#!/usr/local/bin/perl
#

# $Id$
# $Log$

# $res = &ents2unicode($_);
# $res = &unicode2ents($_);
# $x = &unicode_to_letter($_) - returns the letter only for unicode entities and removes non-letter unicode ents (e.g. uuml -> u)
# $x = &get_unicode_sort_key($_); - return a sortkey for a word - has the lcase letters only with underscore and a number for how it should sort in place

sub ents2unicode
{
    my($e) = @_;
    $e =~ s|&amp;|&\#x0026;|go;
    $e =~ s|&arrow;|&\#x27F6;|go;
    $e =~ s|&blarrow;|&\#x27F6;|go;
    $e =~ s|&ap;|&apos;|go;
    $e =~ s|&co2;|CO<sub>2</sub>|gio;
    $e =~ s|&([A-Z])2;|$1<sub>2</sub>|go;
    $e =~ s|&cuberoot;|&\#x221B;|go;
    $e =~ s|&ditto;|&\#x3003;|go;
    $e =~ s|&dp;|.|go;
    $e =~ s|&euro;|&\#x20AC;|go;
    $e =~ s|&f1d10;|1/10|go;
    $e =~ s|&f1d100;|1/100|go;
    $e =~ s|&f1d1000;|1/1000|go;
    $e =~ s|&f1d16;|1/16|go;
    $e =~ s|&frac17;|1/7|go;
    $e =~ s|&frac19;|1/9|go;
    $e =~ s|&frac76;|7/6|go;
    $e =~ s|&grslash;|/|go;
    $e =~ s|&h2o;|H<sub>2</sub>O|gio;
    $e =~ s|&half;|&frac12;|go;
    $e =~ s|&key;|&star;|go;
    $e =~ s|&key_space;| |go;
    $e =~ s|&nbhyph;|-|go;
    $e =~ s|&nbhyphen;|-|go;
    $e =~ s|&nbthinsp;|&thinsp;|go;
    $e =~ s|&NDASH;|&ndash;|go;
    $e =~ s|&ne;|&\#x2260;|go; 
    $e =~ s|&p;|&\#x02C8;|go; 
    $e =~ s|&pstress;|&\#x02C8;|go; 
    $e =~ s|&pause;||go;
    $e =~ s|&phis;|&phi;|go;
    $e =~ s|&s;|&#x02CC;|go;

    $e =~ s|&sdsym;|&#x27A4;|go;
    $e =~ s|&sstress;|&#x02CC;|go;
    $e =~ s|&sol;|/|goi;
    $e =~ s|&spc_sl2;| |go;
    $e =~ s|&spc_ssym;| |go;
    $e =~ s|&spc_xhm;| |go;
    $e =~ s|&sub([0-9]+);|<sub>\1</sub>|go;
    $e =~ s|&sup([0-9]+);|<sup>\1</sup>|go;
    $e =~ s|&supminus([0-9]+);|<sup>-\1</sup>|go;
    $e =~ s|&thetas;|&theta;|go;
    $e =~ s|&tilde;|~|go;
    $e =~ s|&w;|&#x2027;|go;

    $e =~ s|&AElig;|&\#x00C6;|go;
    $e =~ s|&Aacute;|&\#x00C1;|go;
    $e =~ s|&Abreve;|&\#x0102;|go;
    $e =~ s|&Acirc;|&\#x00C2;|go;
    $e =~ s|&Agrave;|&\#x00C0;|go;
    $e =~ s|&Amacr;|&\#x0100;|go;
    $e =~ s|&Aogon;|&\#x0104;|go;
    $e =~ s|&Aring;|&\#x00C5;|go;
    $e =~ s|&Atilde;|&\#x00C3;|go;
    $e =~ s|&Auml;|&\#x00C4;|go;
    $e =~ s|&Cacute;|&\#x0106;|go;
    $e =~ s|&Ccaron;|&\#x010C;|go;
    $e =~ s|&Ccedil;|&\#x00C7;|go;
    $e =~ s|&Ccirc;|&\#x0108;|go;
    $e =~ s|&Cdot;|&\#x010A;|go;
    $e =~ s|&Dagger;|&\#x2021;|go;
    $e =~ s|&Dcaron;|&\#x010E;|go;
    $e =~ s|&Delta;|&\#x0394;|go;
    $e =~ s|&Dstrok;|&\#x0110;|go;
    $e =~ s|&ENG;|&\#x014A;|go;
    $e =~ s|&ETH;|&\#x00D0;|go;
    $e =~ s|&Eacute;|&\#x00C9;|go;
    $e =~ s|&Ecaron;|&\#x011A;|go;
    $e =~ s|&Ecirc;|&\#x00CA;|go;
    $e =~ s|&Edot;|&\#x0116;|go;
    $e =~ s|&Egrave;|&\#x00C8;|go;
    $e =~ s|&Emacr;|&\#x0112;|go;
    $e =~ s|&Eogon;|&\#x0118;|go;
    $e =~ s|&Euml;|&\#x00CB;|go;
    $e =~ s|&Gamma;|&\#x0393;|go;
    $e =~ s|&Gbreve;|&\#x011E;|go;
    $e =~ s|&Gcedil;|&\#x0122;|go;
    $e =~ s|&Gcirc;|&\#x011C;|go;
    $e =~ s|&Gdot;|&\#x0120;|go;
    $e =~ s|&Hcirc;|&\#x0124;|go;
    $e =~ s|&Hstrok;|&\#x0126;|go;
    $e =~ s|&IJlig;|&\#x0132;|go;
    $e =~ s|&Iacute;|&\#x00CD;|go;
    $e =~ s|&Icirc;|&\#x00CE;|go;
    $e =~ s|&Idot;|&\#x0130;|go;
    $e =~ s|&Igrave;|&\#x00CC;|go;
    $e =~ s|&Imacr;|&\#x012A;|go;
    $e =~ s|&Iogon;|&\#x012E;|go;
    $e =~ s|&Itilde;|&\#x0128;|go;
    $e =~ s|&Iuml;|&\#x00CF;|go;
    $e =~ s|&Jcirc;|&\#x0134;|go;
    $e =~ s|&Kcedil;|&\#x0136;|go;
    $e =~ s|&Lacute;|&\#x0139;|go;
    $e =~ s|&Lambda;|&\#x039B;|go;
    $e =~ s|&Lcaron;|&\#x013D;|go;
    $e =~ s|&Lcedil;|&\#x013B;|go;
    $e =~ s|&Lmidot;|&\#x013F;|go;
    $e =~ s|&Lstrok;|&\#x0141;|go;
    $e =~ s|&Nacute;|&\#x0143;|go;
    $e =~ s|&Ncaron;|&\#x0147;|go;
    $e =~ s|&Ncedil;|&\#x0145;|go;
    $e =~ s|&Ntilde;|&\#x00D1;|go;
    $e =~ s|&OElig;|&\#x0152;|go;
    $e =~ s|&Oacute;|&\#x00D3;|go;
    $e =~ s|&Ocirc;|&\#x00D4;|go;
    $e =~ s|&Odblac;|&\#x0150;|go;
    $e =~ s|&Ograve;|&\#x00D2;|go;
    $e =~ s|&Omacr;|&\#x014C;|go;
    $e =~ s|&Omega;|&\#x03A9;|go;
    $e =~ s|&Oslash;|&\#x00D8;|go;
    $e =~ s|&Otilde;|&\#x00D5;|go;
    $e =~ s|&Ouml;|&\#x00D6;|go;
    $e =~ s|&Phi;|&\#x03A6;|go;
    $e =~ s|&Pi;|&\#x03A0;|go;
    $e =~ s|&Prime;|&\#x2033;|go;
    $e =~ s|&Psi;|&\#x03A8;|go;
    $e =~ s|&Racute;|&\#x0154;|go;
    $e =~ s|&Rcaron;|&\#x0158;|go;
    $e =~ s|&Rcedil;|&\#x0156;|go;
    $e =~ s|&Sacute;|&\#x015A;|go;
    $e =~ s|&Scaron;|&\#x0160;|go;
    $e =~ s|&Scedil;|&\#x015E;|go;
    $e =~ s|&Scirc;|&\#x015C;|go;
    $e =~ s|&Sigma;|&\#x03A3;|go;
    $e =~ s|&THORN;|&\#x00DE;|go;
    $e =~ s|&Tcaron;|&\#x0164;|go;
    $e =~ s|&Tcedil;|&\#x0162;|go;
    $e =~ s|&Theta;|&\#x0398;|go;
    $e =~ s|&Tstrok;|&\#x0166;|go;
    $e =~ s|&Uacute;|&\#x00DA;|go;
    $e =~ s|&Ubreve;|&\#x016C;|go;
    $e =~ s|&Ucirc;|&\#x00DB;|go;
    $e =~ s|&Udblac;|&\#x0170;|go;
    $e =~ s|&Ugrave;|&\#x00D9;|go;
    $e =~ s|&Umacr;|&\#x016A;|go;
    $e =~ s|&Uogon;|&\#x0172;|go;
    $e =~ s|&Upsi;|&\#x03D2;|go;
    $e =~ s|&Uring;|&\#x016E;|go;
    $e =~ s|&Utilde;|&\#x0168;|go;
    $e =~ s|&Uuml;|&\#x00DC;|go;
    $e =~ s|&Wcirc;|&\#x0174;|go;
    $e =~ s|&Xi;|&\#x039E;|go;
    $e =~ s|&Yacute;|&\#x00DD;|go;
    $e =~ s|&Ycirc;|&\#x0176;|go;
    $e =~ s|&Yuml;|&\#x0178;|go;
    $e =~ s|&Zacute;|&\#x0179;|go;
    $e =~ s|&Zcaron;|&\#x017D;|go;
    $e =~ s|&Zdot;|&\#x017B;|go;
    $e =~ s|&aacute;|&\#x00E1;|go;
    $e =~ s|&abreve;|&\#x0103;|go;
    $e =~ s|&acirc;|&\#x00E2;|go;
    $e =~ s|&aelig;|&\#x00E6;|go;
    $e =~ s|&agrave;|&\#x00E0;|go;
    $e =~ s|&alpha;|&\#x03B1;|go;
    $e =~ s|&amacr;|&\#x0101;|go;
    $e =~ s|&amp;|&\#x0026;|go;
    $e =~ s|&aogon;|&\#x0105;|go;
    $e =~ s|&apos;|&\#x0027;|go;
    $e =~ s|&aring;|&\#x00E5;|go;
    $e =~ s|&ast;|&\#x002A;|go;
    $e =~ s|&ast;|&\#x2217;|go;
    $e =~ s|&atilde;|&\#x00E3;|go;
    $e =~ s|&auml;|&\#x00E4;|go;
    $e =~ s|&bclef;|&\#x1D122;|go;
    $e =~ s|&beta;|&\#x03B2;|go;
    $e =~ s|&blank;|&\#x2423;|go;
    $e =~ s|&blk12;|&\#x2592;|go;
    $e =~ s|&blk14;|&\#x2591;|go;
    $e =~ s|&blk34;|&\#x2593;|go;
    $e =~ s|&block;|&\#x2588;|go;
    $e =~ s|&brvbar;|&\#x00A6;|go;
    $e =~ s|&bsol;|&\#x005C;|go;
    $e =~ s|&bull;|&\#x2022;|go;
    $e =~ s|&cacute;|&\#x0107;|go;
    $e =~ s|&caret;|&\#x2041;|go;
    $e =~ s|&ccaron;|&\#x010D;|go;
    $e =~ s|&ccedil;|&\#x00E7;|go;
    $e =~ s|&ccirc;|&\#x0109;|go;
    $e =~ s|&cdot;|&\#x010B;|go;
    $e =~ s|&cent;|&\#x00A2;|go;
    $e =~ s|&check;|&\#x2713;|go;
    $e =~ s|&chi;|&\#x03C7;|go;
    $e =~ s|&cir;|&\#x25CB;|go;
    $e =~ s|&clubs;|&\#x2663;|go;
    $e =~ s|&colon;|&\#x003A;|go;
    $e =~ s|&comma;|&\#x002C;|go;
    $e =~ s|&commat;|&\#x0040;|go;
    $e =~ s|&copy;|&\#x00A9;|go;
    $e =~ s|&copysr;|&\#x2117;|go;
    $e =~ s|&cross;|&\#x2717;|go;
    $e =~ s|&curren;|&\#x00A4;|go;
    $e =~ s|&dagger;|&\#x2020;|go;
    $e =~ s|&darr;|&\#x2193;|go;
    $e =~ s|&dash;|&\#x2010;|go;
    $e =~ s|&dcaron;|&\#x010F;|go;
    $e =~ s|&deg;|&\#x00B0;|go;
    $e =~ s|&delta;|&\#x03B4;|go;
    $e =~ s|&diams;|&\#x2666;|go;
    $e =~ s|&divide;|&\#x00F7;|go;
    $e =~ s|&dlcrop;|&\#x230D;|go;
    $e =~ s|&dollar;|&\#x0024;|go;
    $e =~ s|&drcrop;|&\#x230C;|go;
    $e =~ s|&dstrok;|&\#x0111;|go;
    $e =~ s|&dtri;|&\#x25BF;|go;
    $e =~ s|&dtrif;|&\#x25BE;|go;
    $e =~ s|&eacute;|&\#x00E9;|go;
    $e =~ s|&ecaron;|&\#x011B;|go;
    $e =~ s|&ecirc;|&\#x00EA;|go;
    $e =~ s|&edot;|&\#x0117;|go;
    $e =~ s|&egrave;|&\#x00E8;|go;
    $e =~ s|&emacr;|&\#x0113;|go;
    $e =~ s|&emsp13;|&\#x2004;|go;
    $e =~ s|&emsp14;|&\#x2005;|go;
    $e =~ s|&emsp;|&\#x2003;|go;
    $e =~ s|&eng;|&\#x014B;|go;
    $e =~ s|&ensp;|&\#x2002;|go;
    $e =~ s|&eogon;|&\#x0119;|go;
    $e =~ s|&epsi;|&\#x03F5;|go;
    $e =~ s|&equals;|&\#x003D;|go;
    $e =~ s|&eta;|&\#x03B7;|go;
    $e =~ s|&eth;|&\#x00F0;|go;
    $e =~ s|&euml;|&\#x00EB;|go;
    $e =~ s|&excl;|&\#x0021;|go;
    $e =~ s|&female;|&\#x2640;|go;
    $e =~ s|&ffilig;|&\#xFB03;|go;
    $e =~ s|&fflig;|&\#xFB00;|go;
    $e =~ s|&ffllig;|&\#xFB04;|go;
    $e =~ s|&filig;|&\#xFB01;|go;
    $e =~ s|&flat;|&\#x266D;|go;
    $e =~ s|&fllig;|&\#xFB02;|go;
    $e =~ s|&frac12;|&\#x00BD;|go;
    $e =~ s|&frac13;|&\#x2153;|go;
    $e =~ s|&frac14;|&\#x00BC;|go;
    $e =~ s|&frac15;|&\#x2155;|go;
    $e =~ s|&frac16;|&\#x2159;|go;
    $e =~ s|&frac18;|&\#x215B;|go;
    $e =~ s|&frac23;|&\#x2154;|go;
    $e =~ s|&frac25;|&\#x2156;|go;
    $e =~ s|&frac34;|&\#x00BE;|go;
    $e =~ s|&frac35;|&\#x2157;|go;
    $e =~ s|&frac38;|&\#x215C;|go;
    $e =~ s|&frac45;|&\#x2158;|go;
    $e =~ s|&frac56;|&\#x215A;|go;
    $e =~ s|&frac58;|&\#x215D;|go;
    $e =~ s|&frac78;|&\#x215E;|go;
    $e =~ s|&gacute;|&\#x01F5;|go;
    $e =~ s|&gamma;|&\#x03B3;|go;
    $e =~ s|&gbreve;|&\#x011F;|go;
    $e =~ s|&gcirc;|&\#x011D;|go;
    $e =~ s|&gdot;|&\#x0121;|go;
    $e =~ s|&gt;|&\#x003E;|go;
    $e =~ s|&hairsp;|&\#x200A;|go;
    $e =~ s|&half;|&\#x00BD;|go;
    $e =~ s|&hcirc;|&\#x0125;|go;
    $e =~ s|&hearts;|&\#x2665;|go;
    $e =~ s|&hellip;|&\#x2026;|go;
    $e =~ s|&horbar;|&\#x2015;|go;
    $e =~ s|&hstrok;|&\#x0127;|go;
    $e =~ s|&hybull;|&\#x2043;|go;
    $e =~ s|&hyphen;|&\#x2010;|go;
    $e =~ s|&iacute;|&\#x00ED;|go;
    $e =~ s|&icirc;|&\#x00EE;|go;
    $e =~ s|&iexcl;|&\#x00A1;|go;
    $e =~ s|&igrave;|&\#x00EC;|go;
    $e =~ s|&ijlig;|&\#x0133;|go;
    $e =~ s|&imacr;|&\#x012B;|go;
    $e =~ s|&incare;|&\#x2105;|go;
    $e =~ s|&infin;|&\#x221E;|go;
    $e =~ s|&inodot;|&\#x0131;|go;
    $e =~ s|&iogon;|&\#x012F;|go;
    $e =~ s|&iota;|&\#x03B9;|go;
    $e =~ s|&iquest;|&\#x00BF;|go;
    $e =~ s|&itilde;|&\#x0129;|go;
    $e =~ s|&iuml;|&\#x00EF;|go;
    $e =~ s|&jcirc;|&\#x0135;|go;
    $e =~ s|&kappa;|&\#x03BA;|go;
    $e =~ s|&kcedil;|&\#x0137;|go;
    $e =~ s|&kgreen;|&\#x0138;|go;
    $e =~ s|&lacute;|&\#x013A;|go;
    $e =~ s|&lambda;|&\#x03BB;|go;
    $e =~ s|&laquo;|&\#x00AB;|go;
    $e =~ s|&larr;|&\#x2190;|go;
    $e =~ s|&lcaron;|&\#x013E;|go;
    $e =~ s|&lcedil;|&\#x013C;|go;
    $e =~ s|&lcub;|&\#x007B;|go;
    $e =~ s|&ldquo;|&\#x201C;|go;
    $e =~ s|&ldquor;|&\#x201E;|go;
    $e =~ s|&lhblk;|&\#x2584;|go;
    $e =~ s|&lmidot;|&\#x0140;|go;
    $e =~ s|&lowbar;|&\#x005F;|go;
    $e =~ s|&loz;|&\#x25CA;|go;
    $e =~ s|&lozf;|&\#x2726;|go;
    $e =~ s|&lpar;|&\#x0028;|go;
    $e =~ s|&lsqb;|&\#x005B;|go;
    $e =~ s|&lsquo;|&\#x2018;|go;
    $e =~ s|&lsquor;|&\#x201A;|go;
    $e =~ s|&lstrok;|&\#x0142;|go;
    $e =~ s|&lt;|&\#x003C;|go;
    $e =~ s|&ltri;|&\#x25C3;|go;
    $e =~ s|&ltrif;|&\#x25C2;|go;
    $e =~ s|&macr;|&\#x00AF;|go;
    $e =~ s|&male;|&\#x2642;|go;
    $e =~ s|&malt;|&\#x2720;|go;
    $e =~ s|&marker;|&\#x25AE;|go;
    $e =~ s|&mdash;|&\#x2014;|go;
    $e =~ s|&micro;|&\#x00B5;|go;
    $e =~ s|&middot;|&\#x00B7;|go;
    $e =~ s|&minus;|&\#x2212;|go;
    $e =~ s|&mldr;|&\#x2026;|go;
    $e =~ s|&mu;|&\#x03BC;|go;
    $e =~ s|&nacute;|&\#x0144;|go;
    $e =~ s|&napos;|&\#x0149;|go;
    $e =~ s|&natur;|&\#x266E;|go;
    $e =~ s|&nbsp;|&\#x00A0;|go;
    $e =~ s|&nbthinsp;|&\#x2009;|go;
    $e =~ s|&ncaron;|&\#x0148;|go;
    $e =~ s|&ncedil;|&\#x0146;|go;
    $e =~ s|&ndash;|&\#x2013;|go;
    $e =~ s|&nldr;|&\#x2025;|go;
    $e =~ s|&not;|&\#x00AC;|go;
    $e =~ s|&ntilde;|&\#x00F1;|go;
    $e =~ s|&nu;|&\#x03BD;|go;
    $e =~ s|&num;|&\#x0023;|go;
    $e =~ s|&numsp;|&\#x2007;|go;
    $e =~ s|&ob;|/|go;
    $e =~ s|&oacute;|&\#x00F3;|go;
    $e =~ s|&ocirc;|&\#x00F4;|go;
    $e =~ s|&odblac;|&\#x0151;|go;
    $e =~ s|&oelig;|&\#x0153;|go;
    $e =~ s|&ograve;|&\#x00F2;|go;
    $e =~ s|&ohm;|&\#x2126;|go;
    $e =~ s|&omacr;|&\#x014D;|go;
    $e =~ s|&omega;|&\#x03C9;|go;
    $e =~ s|&ordf;|&\#x00AA;|go;
    $e =~ s|&ordm;|&\#x00BA;|go;
    $e =~ s|&oslash;|&\#x00F8;|go;
    $e =~ s|&otilde;|&\#x00F5;|go;
    $e =~ s|&ouml;|&\#x00F6;|go;
    $e =~ s|&para;|&\#x00B6;|go;
    $e =~ s|&percnt;|&\#x0025;|go;
    $e =~ s|&period;|&\#x002E;|go;
    $e =~ s|&phone;|&\#x260E;|go;
    $e =~ s|&pi;|&\#x03C0;|go;
    $e =~ s|&phi;|&\#x03D5;|go; # BC 15Sep04
    $e =~ s|&plus;|&\#x002B;|go;
    $e =~ s|&plusmn;|&\#x00B1;|go;
    $e =~ s|&pound;|&\#x00A3;|go;
    $e =~ s|&prime;|&\#x2032;|go;
    $e =~ s|&psi;|&\#x03C8;|go;
    $e =~ s|&puncsp;|&\#x2008;|go;
    $e =~ s|&quest;|&\#x003F;|go;
    $e =~ s|&quot;|&\#x0022;|go;
    $e =~ s|&racute;|&\#x0155;|go;
    $e =~ s|&radic;|&\#x221A;|go;
    $e =~ s|&raquo;|&\#x00BB;|go;
    $e =~ s|&rarr;|&\#x2192;|go;
    $e =~ s|&rcaron;|&\#x0159;|go;
    $e =~ s|&rcedil;|&\#x0157;|go;
    $e =~ s|&rcub;|&\#x007D;|go;
    $e =~ s|&rdquo;|&\#x201D;|go;
    $e =~ s|&rdquor;|&\#x201C;|go;
    $e =~ s|&rect;|&\#x25AD;|go;
    $e =~ s|&reg;|&\#x00AE;|go;
    $e =~ s|&rho;|&\#x03C1;|go;
    $e =~ s|&rpar;|&\#x0029;|go;
    $e =~ s|&rsqb;|&\#x005D;|go;
    $e =~ s|&rsquo;|&\#x2019;|go;
    $e =~ s|&rsquor;|&\#x2018;|go;
    $e =~ s|&rtri;|&\#x25B9;|go;
    $e =~ s|&rtrif;|&\#x25B8;|go;
    $e =~ s|&rx;|&\#x211E;|go;
    $e =~ s|&sacute;|&\#x015B;|go;
    $e =~ s|&scaron;|&\#x0161;|go;
    $e =~ s|&scedil;|&\#x015F;|go;
    $e =~ s|&scirc;|&\#x015D;|go;
    $e =~ s|&sect;|&\#x00A7;|go;
    $e =~ s|&semi;|&\#x003B;|go;
    $e =~ s|&sext;|&\#x2736;|go;
    $e =~ s|&sharp;|&\#x266F;|go;
    $e =~ s|&shy;|&\#x00AD;|go;
    $e =~ s|&sigma;|&\#x03C3;|go;
    $e =~ s|&sol;|&\#x002F;|go;
    $e =~ s|&spades;|&\#x2660;|go;
    $e =~ s|&squ;|&\#x25A1;|go;
    $e =~ s|&squf;|&\#x25AA;|go;
    $e =~ s|&star;|&\#x22C6;|go;
    $e =~ s|&starf;|&\#x2605;|go;
    $e =~ s|&sung;|&\#x2669;|go;
    $e =~ s|&sup1;|&\#x00B9;|go;
    $e =~ s|&sup2;|&\#x00B2;|go;
    $e =~ s|&sup3;|&\#x00B3;|go;
    $e =~ s|&szlig;|&\#x00DF;|go;
    $e =~ s|&target;|&\#x2316;|go;
    $e =~ s|&tau;|&\#x03C4;|go;
    $e =~ s|&tcaron;|&\#x0165;|go;
    $e =~ s|&tcedil;|&\#x0163;|go;
    $e =~ s|&telrec;|&\#x2315;|go;
    $e =~ s|&theta;|&\#x03B8;|go; # BC 15Sep04
    $e =~ s|&thinsp;|&\#x2009;|go;
    $e =~ s|&thinsp[^;]*;|&\#x2009;|go;
    $e =~ s|&thorn;|&\#x00FE;|go;
    $e =~ s|&tilde;|&\#x02DC;|go;
    $e =~ s|&times;|&\#x00D7;|go;
    $e =~ s|&trade;|&\#x2122;|go;
    $e =~ s|&tclef;|&\#x1D120;|go;
    $e =~ s|&tstrok;|&\#x0167;|go;
    $e =~ s|&uacute;|&\#x00FA;|go;
    $e =~ s|&uarr;|&\#x2191;|go;
    $e =~ s|&ubreve;|&\#x016D;|go;
    $e =~ s|&ucirc;|&\#x00FB;|go;
    $e =~ s|&udblac;|&\#x0171;|go;
    $e =~ s|&ugrave;|&\#x00F9;|go;
    $e =~ s|&uhblk;|&\#x2580;|go;
    $e =~ s|&ulcrop;|&\#x230F;|go;
    $e =~ s|&umacr;|&\#x016B;|go;
    $e =~ s|&uogon;|&\#x0173;|go;
    $e =~ s|&upsi;|&\#x03C5;|go;
    $e =~ s|&urcrop;|&\#x230E;|go;
    $e =~ s|&uring;|&\#x016F;|go;
    $e =~ s|&utilde;|&\#x0169;|go;
    $e =~ s|&utri;|&\#x25B5;|go;
    $e =~ s|&utrif;|&\#x25B4;|go;
    $e =~ s|&uuml;|&\#x00FC;|go;
    $e =~ s|&vellip;|&\#x22EE;|go;
    $e =~ s|&verbar;|&\#x007C;|go;
    $e =~ s|&wcirc;|&\#x0175;|go;
    $e =~ s|&xi;|&\#x03BE;|go;
    $e =~ s|&yacute;|&\#x00FD;|go;
    $e =~ s|&ycirc;|&\#x0177;|go;
    $e =~ s|&yen;|&\#x00A5;|go;
    $e =~ s|&yuml;|&\#x00FF;|go;
    $e =~ s|&zacute;|&\#x017A;|go;
    $e =~ s|&zcaron;|&\#x017E;|go;
    $e =~ s|&zdot;|&\#x017C;|go;
    $e =~ s|&zeta;|&\#x03B6;|go;
    return $e;
}

sub unicode_to_letter
{
    my($e) = @_;
    $e =~ s|&\#x([0-9A-F]+);|&\#x\U\1\E;|gio;
    $e =~ s|&\#x00C6;|AE|go;
    $e =~ s|&\#x00C1;|A|go;
    $e =~ s|&\#x0102;|A|go;
    $e =~ s|&\#x00C2;|A|go;
    $e =~ s|&\#x00C0;|A|go;
    $e =~ s|&\#x0100;|A|go;
    $e =~ s|&\#x0104;|A|go;
    $e =~ s|&\#x00C5;|A|go;
    $e =~ s|&\#x00C3;|A|go;
    $e =~ s|&\#x00C4;|A|go;
    $e =~ s|&\#x0106;|C|go;
    $e =~ s|&\#x010C;|C|go;
    $e =~ s|&\#x00C7;|C|go;
    $e =~ s|&\#x0108;|C|go;
    $e =~ s|&\#x010A;|C|go;
    $e =~ s|&\#x010E;|D|go;
    $e =~ s|&\#x0110;|D|go;
    $e =~ s|&\#x00C9;|E|go;
    $e =~ s|&\#x011A;|E|go;
    $e =~ s|&\#x00CA;|E|go;
    $e =~ s|&\#x0116;|E|go;
    $e =~ s|&\#x00C8;|E|go;
    $e =~ s|&\#x0112;|E|go;
    $e =~ s|&\#x0118;|E|go;
    $e =~ s|&\#x00CB;|E|go;
    $e =~ s|&\#x011E;|G|go;
    $e =~ s|&\#x0122;|G|go;
    $e =~ s|&\#x011C;|G|go;
    $e =~ s|&\#x0120;|G|go;
    $e =~ s|&\#x0124;|H|go;
    $e =~ s|&\#x0126;|H|go;
    $e =~ s|&\#x0132;|IJ|go;
    $e =~ s|&\#x00CD;|I|go;
    $e =~ s|&\#x00CE;|I|go;
    $e =~ s|&\#x0130;|I|go;
    $e =~ s|&\#x00CC;|I|go;
    $e =~ s|&\#x012A;|I|go;
    $e =~ s|&\#x012E;|I|go;
    $e =~ s|&\#x0128;|I|go;
    $e =~ s|&\#x00CF;|I|go;
    $e =~ s|&\#x0134;|J|go;
    $e =~ s|&\#x0136;|K|go;
    $e =~ s|&\#x0139;|L|go;
    $e =~ s|&\#x013D;|L|go;
    $e =~ s|&\#x013B;|L|go;
    $e =~ s|&\#x0141;|L|go;
    $e =~ s|&\#x0143;|N|go;
    $e =~ s|&\#x0147;|N|go;
    $e =~ s|&\#x0145;|N|go;
    $e =~ s|&\#x00D1;|N|go;
    $e =~ s|&\#x0152;|OE|go;
    $e =~ s|&\#x00D3;|O|go;
    $e =~ s|&\#x00D4;|O|go;
    $e =~ s|&\#x00D2;|O|go;
    $e =~ s|&\#x014C;|O|go;
    $e =~ s|&\#x00D8;|O|go;
    $e =~ s|&\#x00D5;|O|go;
    $e =~ s|&\#x00D6;|O|go;
    $e =~ s|&\#x0154;|R|go;
    $e =~ s|&\#x0158;|R|go;
    $e =~ s|&\#x0156;|R|go;
    $e =~ s|&\#x015A;|S|go;
    $e =~ s|&\#x0160;|S|go;
    $e =~ s|&\#x015E;|S|go;
    $e =~ s|&\#x015C;|S|go;
    $e =~ s|&\#x0164;|T|go;
    $e =~ s|&\#x0162;|T|go;
    $e =~ s|&\#x0166;|T|go;
    $e =~ s|&\#x00DA;|U|go;
    $e =~ s|&\#x016C;|U|go;
    $e =~ s|&\#x00DB;|U|go;
    $e =~ s|&\#x00D9;|U|go;
    $e =~ s|&\#x016A;|U|go;
    $e =~ s|&\#x0172;|U|go;
    $e =~ s|&\#x016E;|U|go;
    $e =~ s|&\#x0168;|U|go;
    $e =~ s|&\#x00DC;|U|go;
    $e =~ s|&\#x0174;|W|go;
    $e =~ s|&\#x00DD;|Y|go;
    $e =~ s|&\#x0176;|Y|go;
    $e =~ s|&\#x0178;|Y|go;
    $e =~ s|&\#x0179;|Z|go;
    $e =~ s|&\#x017D;|Z|go;
    $e =~ s|&\#x017B;|Z|go;
    $e =~ s|&\#x00E1;|a|go;
    $e =~ s|&\#x0103;|a|go;
    $e =~ s|&\#x00E2;|a|go;
    $e =~ s|&\#x00E6;|ae|go;
    $e =~ s|&\#x00E0;|a|go;
    $e =~ s|&\#x0101;|a|go;
    $e =~ s|&\#x0105;|a|go;
    $e =~ s|&\#x00E5;|a|go;
    $e =~ s|&\#x00E3;|a|go;
    $e =~ s|&\#x00E4;|a|go;
    $e =~ s|&\#x0107;|c|go;
    $e =~ s|&\#x010D;|c|go;
    $e =~ s|&\#x00E7;|c|go;
    $e =~ s|&\#x0109;|c|go;
    $e =~ s|&\#x010B;|c|go;
    $e =~ s|&\#x010F;|d|go;
    $e =~ s|&\#x0111;|d|go;
    $e =~ s|&\#x00E9;|e|go;
    $e =~ s|&\#x011B;|e|go;
    $e =~ s|&\#x00EA;|e|go;
    $e =~ s|&\#x0117;|e|go;
    $e =~ s|&\#x00E8;|e|go;
    $e =~ s|&\#x0113;|e|go;
    $e =~ s|&\#x0119;|e|go;
    $e =~ s|&\#x00EB;|e|go;
    $e =~ s|&\#xFB03;|ffi|go;
    $e =~ s|&\#xFB00;|ff|go;
    $e =~ s|&\#xFB04;|ffl|go;
    $e =~ s|&\#xFB01;|fi|go;
    $e =~ s|&\#xFB02;|fl|go;
    $e =~ s|&\#x01F5;|g|go;
    $e =~ s|&\#x011D;|g|go;
    $e =~ s|&\#x0121;|g|go;
    $e =~ s|&\#x0125;|h|go;
    $e =~ s|&\#x0127;|h|go;
    $e =~ s|&\#x00ED;|i|go;
    $e =~ s|&\#x00EE;|i|go;
    $e =~ s|&\#x00EC;|i|go;
    $e =~ s|&\#x0133;|ij|go;
    $e =~ s|&\#x012B;|i|go;
    $e =~ s|&\#x0131;|ino|go;
    $e =~ s|&\#x012F;|i|go;
    $e =~ s|&\#x0129;|i|go;
    $e =~ s|&\#x00EF;|i|go;
    $e =~ s|&\#x0135;|j|go;
    $e =~ s|&\#x0137;|k|go;
    $e =~ s|&\#x013A;|l|go;
    $e =~ s|&\#x013E;|l|go;
    $e =~ s|&\#x013C;|l|go;
    $e =~ s|&\#x0140;|lmi|go;
    $e =~ s|&\#x0142;|l|go;
    $e =~ s|&\#x0144;|n|go;
    $e =~ s|&\#x0148;|n|go;
    $e =~ s|&\#x0146;|n|go;
    $e =~ s|&\#x00F1;|n|go;
    $e =~ s|&\#x00F3;|o|go;
    $e =~ s|&\#x00F4;|o|go;
    $e =~ s|&\#x0153;|oe|go;
    $e =~ s|&\#x00F2;|o|go;
    $e =~ s|&\#x014D;|o|go;
    $e =~ s|&\#x00F8;|o|go;
    $e =~ s|&\#x00F5;|o|go;
    $e =~ s|&\#x00F6;|o|go;
    $e =~ s|&\#x0155;|r|go;
    $e =~ s|&\#x0159;|r|go;
    $e =~ s|&\#x0157;|r|go;
    $e =~ s|&\#x015B;|s|go;
    $e =~ s|&\#x0161;|s|go;
    $e =~ s|&\#x015F;|s|go;
    $e =~ s|&\#x015D;|s|go;
    $e =~ s|&\#x00DF;|sz|go;
    $e =~ s|&\#x0165;|t|go;
    $e =~ s|&\#x0163;|t|go;
    $e =~ s|&\#x0167;|t|go;
    $e =~ s|&\#x00FA;|u|go;
    $e =~ s|&\#x016D;|u|go;
    $e =~ s|&\#x00FB;|u|go;
    $e =~ s|&\#x00F9;|u|go;
    $e =~ s|&\#x016B;|u|go;
    $e =~ s|&\#x0173;|u|go;
    $e =~ s|&\#x016F;|u|go;
    $e =~ s|&\#x0169;|u|go;
    $e =~ s|&\#x00FC;|u|go;
    $e =~ s|&\#x0175;|w|go;
    $e =~ s|&\#x00FD;|y|go;
    $e =~ s|&\#x0177;|y|go;
    $e =~ s|&\#x00FF;|y|go;
    $e =~ s|&\#x017A;|z|go;
    $e =~ s|&\#x017E;|z|go;
    $e =~ s|&\#x017C;|z|go;
    $e =~ s|&\#x[0-9A-F]*;||gio;
    return $e;
}

sub unicode2ents
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

sub lose_non_letter_ents
{
    my($e) = @_;
    $e =~ s|&(.acute;)|&_$1|gi;
    $e =~ s|&(.grave;)|&_$1|gi;
    $e =~ s|&(.cedil;)|&_$1|gi;
    $e =~ s|&(.uml;)|&_$1|gi;
    $e =~ s|&(.circ;)|&_$1|gi;
    $e =~ s|&(.tilde;)|&_$1|gi;
    $e =~ s|&(.strok;)|&_$1|gi;
    $e =~ s|&(.breve;)|&_$1|gi;
    $e =~ s|&(.ogon;)|&_$1|gi;
    $e =~ s|&(.caron;)|&_$1|gi;
    $e =~ s|&(.macr;)|&_$1|gi;
    $e =~ s|&(.dot;)|&_$1|gi;
    $e =~ s|&(.ring;)|&_$1|gi;
    $e =~ s|&[^_]*?;||gi;
    $e =~ s|&_|&|gi;
    return $e;
}

sub get_unicode_sort_key_ex
{
    my ($e) = @_;
    my $ct;
    $ct = 0;
    if ($e =~ s| +||g)
    {
	$ct++;
    }
    if ($e =~ m|A-Z|)
    {
	$ct += 4;
    }
    $e =~ tr|a-z|A-Z|;
    if ($e =~ m|&\#|)
    {
	$e = &unicode2ents($e);
	$e2 = &lose_non_letter_ents($e);
	unless ($e2 eq $e)
	{
	    $ct += 2;
	    $e = $e2;
	}
    }

    
#	$e2 = &lose_ents($e);
    if ($e =~ s|&(.).*?;|\L$1\E|gio)
    {
	$ct += 8;
    }
    $e = sprintf("%s_%02d", $e, $ct);
    return $e;
}

sub get_unicode_sort_key
{
    my ($e) = @_;
    my $ct;
    $ct = 0;
    if ($e =~ s| +||g)
    {
	$ct++;
    }

    $e = &unicode2ents($e);
    $e2 = &lose_non_letter_ents($e);
    unless ($e2 eq $e)
    {
	$ct += 2;
	$e = $e2;
    }
    unless ($e =~ tr|A-Z|a-z|)
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
    $e = &lose_ent_spaces($e);
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


1;
