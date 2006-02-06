use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
use strict;

use Getopt::Long;
use vars qw($opt_gssapiimpl $opt_help);

my @whichcand = qw(/bin/which /usr/bin/which);

&GetOptions("gssapiimpl=s", \$opt_gssapiimpl, "help", \$opt_help);


open(MANIFEST, "MANIFEST")	or die "$0: Unable to open MANIFEST: $!";
my $otherxs = join " ",
		map { substr($_, 0, -1) }
		grep { m:^xs/: }
		<MANIFEST>;
close(MANIFEST);



if ($opt_help){
print <<HELP;

==================================================================
BUILDING HELP
==================================================================

Hello - you obviously need Help! :-)

This additional command line options are available
for adjusting:

(1) --gssapiimpl /bla/local/heimdal
  This tells me where to look for your installed
  GSSAPI installation MIT or Heimdal.
  This must be the directory that contains
  the ./lib and ./include directories

HELP
;
  exit;
}

#-------------------------------------------------------------
print "\n Welcome to GSSAPI.pm setup! \n";
print qq{\n run "perl Makefile.PL --help" to see further installation options\n};

my $ADDLINKPATH='';
my $ADDINCLUDEPATH='';
#---------------------------------------------------------------
my @GSSLIBS = ();
#---------------------------------------------------------------

print "\n Searching krb5-config command...";
my $krb5cmd = find_krb5config_cmd($opt_gssapiimpl );
unless ($krb5cmd) {
    fatal_error( 'not found!');
    exit
} else {
  print $krb5cmd ;
}
#---------------------------------------------
my $implementation = krb5_version( $krb5cmd  );
print "\n using GSSAPI implementation ", $implementation;
#---------------------------------------------
my $libconf =  krb5_libconfig( $krb5cmd );
unless ($libconf) {
   fatal_error("$krb5cmd does not respond libconf!");
} else {
  push @GSSLIBS, $libconf ;

}
print "\n Using libconfiguration\n", @GSSLIBS;

#---------------------------------------------------------------
my $incconf =  krb5_cflags( $krb5cmd  );
unless ( $incconf ) {
   #fatal_error("$krb5cmd does not respond inconfconf!");
   #
   # krb5-conf does not respond -I/usr/include
   # on Fedora and RHL.
   # Thanks to Dax Kelson <dax@gurulabs.com>
   #
   $incconf = '-I/usr/include';
}
print "\n Using includeconfiguration\n", $incconf;
#---------------------------------------------------------------
my @EXTRADEFINES;
if ( is_heimdal($krb5cmd) ) {
   push @EXTRADEFINES, '-DHEIMDAL';
   print "Setting Heimdal Defines\n";
} else {
   print "Setting MIT defines\n";
}
print "\n using own defines \n", @EXTRADEFINES, "\n";


#--------------------------------------------------------------


WriteMakefile(
     LIBS => join (' ', @GSSLIBS),
    'NAME'		=> 'GSSAPI',
    'VERSION_FROM'	=> 'GSSAPI.pm',
    'PREREQ_PM'		=> { 'Test::More' => 0 },

    'DEFINE'            => join (' ', @EXTRADEFINES),
    'INC'  => $incconf,
    'macro'		=> { OTHER_XS => $otherxs },
    'depend'		=> { 'GSSAPI.c' => '$(OTHER_XS)' }
);

#--------------------------------------------------------------
#-------------------------------------------------
sub find_which_command {
    foreach (@whichcand) {
       return $_ if ( -e $_);
    }
    return undef;
}
#-------------------------------------------------
sub find_krb5config_cmd {
   my ($expl_path) = @_;
   my $r = undef;
   unless ($expl_path) {
      my $whichcmd =  find_which_command() || die 'cannot locat which command';
      $r = `$whichcmd krb5-config 2>/dev/null`;
      chomp $r;
   } else {
      my $supposed = join '/', $expl_path, 'bin', 'krb5-config';
      if ( -e $supposed ) {
         $r = $supposed ;
      }
   }
   return $r;
}
#-------------------------------------------------
sub krb5_libconfig {
   my ($cfgcmd) = @_;
   $cfgcmd || die 'no $cfgcmd ';
   return `$cfgcmd --libs gssapi`;
}
#-------------------------------------------------
#-------------------------------------------------
sub krb5_cflags  {
   my ($cfgcmd) = @_;
   $cfgcmd || die 'no $cfgcmd ';
   return `$cfgcmd --cflags gssapi`;
}
#-------------------------------------------------
sub krb5_version {
   my ($cfgcmd) = @_;
   $cfgcmd || die 'no $cfgcmd ';
   return `$cfgcmd --version`;
}
#-------------------------------------------------
#-------------------------------------------------
sub is_heimdal {
   my ($cfgcmd) = @_;
   my $r = undef;
   my @vinfo = krb5_version( $cfgcmd );
   GEFUNDEN: {
      foreach ( @vinfo) {
         if ( m/eimdal/) {
            $r = 1;
	    last GEFUNDEN;
         }
       }
   }
   return $r;
}
#-------------------------------------------------