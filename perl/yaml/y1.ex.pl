use YAML;

# Load a YAML stream of 3 YAML documents into Perl data structures.
my ($hashref, $arrayref, $string) = Load(<<'...');
---
name: ingy
age: old
weight: heavy
# I should comment that I also like pink, but don't tell anybody.
favorite colors:
    - red
    - green
    - blue
---
- Clark Evans
- Oren Ben-Kiki
- Ingy döt Net
--- >
You probably think YAML stands for "Yet Another Markup Language". It
ain't! YAML is really a data serialization language. But if you want
to think of it as a markup, that's OK with me. A lot of people try
to use XML as a serialization format.

"YAML" is catchy and fun to say. Try it. "YAML, YAML, YAML!!!"
...

# Dump the Perl data structures back into YAML.
# print Dump($string, $arrayref, $hashref);
print "\n";
print "hashref : \n", Dump($hashref), "\n";
print "arrayref: \n", Dump($arrayref), "\n";
print "String  : \n", Dump($string), "\n";
print "\n";


# YAML::Dump is used the same way you'd use Data::Dumper::Dumper
use Data::Dumper;
# print Dumper($string, $arrayref, $hashref);
print "\n";
print "String  : \n", Dumper($string), "\n";
print "arrayref: \n", Dumper($arrayref), "\n";
print "hashref : \n", Dumper($hashref), "\n";
print "\n";
