
use strict;

use ExtUtils::testlib;

use GSSAPI qw(:all);
use Test::More tests => 3;



#--------------------------------------------------------
{
   my ($name, $display);
   my $keystring = 'chpasswd@mars.gac.edu';
   my $status = GSSAPI::Name->import($name, $keystring);
   ok ( $status, 'GSSAPI::Name->import()');
   SKIP: {
       if ( $status->major != GSS_S_COMPLETE  ) {
           skip('GSSAPI::Name->import() failed', 2 );
       }

       my $status = $name->display($display);
       #
       # The lc is needed for implementations that uppercase
       # the realm - part of $display
       # see <http://rt.cpan.org/Public/Bug/Display.html?id=18531>
       #
       ok ( $status, '$name->display() GSS_S_COMPLETE');
       SKIP: {
           if ( $status->major != GSS_S_COMPLETE  ) {
             skip('$name->display() failed', 1 );
           }
           ok ( $keystring eq lc $display,
                'check bugfix of <http://rt.cpan.org/Public/Bug/Display.html?id=5681>');

       }
   }
}
#--------------------------------------------------------