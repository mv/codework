
XML
---
http://www.w3schools.com/xml/
http://en.wikipedia.org/wiki/XML

	[&lt;]   [<]
	[&gt;]   [>]
	[&amp;]  [&]
	[&apos;] [']
	[&quot;] ["]

http://en.wikipedia.org/wiki/Xpath
http://www.w3schools.com/xpath/default.asp

http://xml-simple.rubyforge.org/
http://nokogiri.org/
http://www.engineyard.com/blog/2009/xml-parsing-in-ruby/

http://xmlstar.sourceforge.net/doc/UG/index.html
http://www.freesoftwaremagazine.com/articles/xml_starlet
http://arstechnica.com/open-source/news/2005/11/linux-20051115.ars/1


## XML structure
xml el -u comps-centos57-x86_64.xml
	comps
	comps/category
	comps/category/description
	comps/category/display_order
	comps/category/grouplist
	comps/category/grouplist/groupid
	comps/category/id
	comps/category/name
	comps/group
	comps/group/default
	comps/group/description
	comps/group/id
	comps/group/langonly
	comps/group/name
	comps/group/packagelist
	comps/group/packagelist/packagereq
	comps/group/uservisible

## XML attributes
xml el -v comps-centos57-x86_64.xml | sort | uniq
xml el -v comps-centos57-x86_64.xml  | grep -v 'xml:lang' | sort | uniq
	comps
	comps/category
	comps/category/description
	comps/category/display_order
	comps/category/grouplist
	comps/category/grouplist/groupid
	comps/category/id
	comps/category/name
	comps/group
	comps/group/default
	comps/group/description
	comps/group/id
	comps/group/langonly
	comps/group/name
	comps/group/packagelist
	comps/group/packagelist/packagereq[@type='conditional' and @requires='aspell']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='kdelibs']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='man-pages']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='openoffice.org-core']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='qt']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='scim-m17n']
	comps/group/packagelist/packagereq[@type='conditional' and @requires='xorg-x11-server-Xorg']
	comps/group/packagelist/packagereq[@type='default']
	comps/group/packagelist/packagereq[@type='mandatory']
	comps/group/packagelist/packagereq[@type='optional']
	comps/group/uservisible

## Counting
xml sel -t -v "count(/comps/group/packagelist/packagereq)" comps-centos57-x86_64.xml
	1390

xml sel -t -v "count(//category)" comps-centos57-x86_64.xml
	9

## Listing
cat comps-centos57-x86_64.xml | xml sel -t -m "//category" -v id -n | sort | uniq

cat comps-centos57-x86_64.xml | \
xml sel -t \
	-m "//group" -s A:T:U default \
		-v default  -o ": "       \
		-v id       -o ": ="      \
		-v langonly -o "= "       \
		-v uservisible -n         \
	-m packagelist[packagereq]    \
		-o "      "                 \
		-v packagereq             \
		-b -n -o "      -----" -n
#   	-n -n                     \

