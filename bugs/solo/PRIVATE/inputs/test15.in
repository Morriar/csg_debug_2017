# Using the script that comes with the distribution.
chef.pl file.chef
 
# Using the module
use Acme::Chef;
 
my $compiled = Acme::Chef->compile($code_string);  
print $compiled->execute();
 
my $string = $compiled->dump(); # requires Data::Dumper
# Save it to disk, send it over the web, whatever.
my $reconstructed_object = eval $string;
 
# or:
$string = $compiled->dump('autorun'); # requires Data::Dumper
# Save it to disk, send it over the web, whatever.
my $output_of_chef_program = eval $string;
