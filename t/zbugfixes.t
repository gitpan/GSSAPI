
use strict;

use ExtUtils::testlib;

use GSSAPI qw(:all);
use Test::More tests => 1;



#--------------------------------------------------------
{
   my ($name, $display);
   my $keystring = 'chpasswd@mars.gac.edu';
   my $status = GSSAPI::Name->import($name, $keystring);
   $status = $name->display($display);
   ok ($keystring eq $display, 'check bugfix of <http://rt.cpan.org/Public/Bug/Display.html?id=5681>');
}
#--------------------------------------------------------