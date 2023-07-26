#!/usr/local/bin/perl

# extracts element and attribute descriptions from oup_elt_dicts.dtd ...

#

line:

while (<>)

{
    next line unless (/(attribute|element)\:/);
	
	next line if (/element "element_name element: comment text"/);
	next line if (/attribute "element_name attlist:/);
	next line if (/attribute_name attribute: comment text"/);
	
	chomp;
	s|\r||;
	
	s|<!--||g;
	s|-->||g;
    s/^(\s|\t)+//g;
	s/(\s|\t)+$//g;
	
	s|\t| |g;
	s| ( )+| |g;
	
	s/(attribute|element)\:/$1\t/g;
	
	s|$|\n|g;
	
	s|^([^ ]+) attribute\t|\@$1\t|g;
	s|^([^ ]+) element\t|$1\t|g;
	
    s|\t|</td><td>|g;
	s|.+|<tr><td>$&</td></tr>|g;
	
    print;
}
