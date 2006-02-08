use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
use strict;

use Getopt::Long;
my %options;

my @whichcand = qw(/bin/which /usr/bin/which);

&GetOptions(\%options , "gssapiimpl=s",  "help", "gssapi_libs=s", "gssapi_inc=s", "gssapi_lddlflags=s");

open(MANIFEST, "MANIFEST")	or die "$0: Unable to open MANIFEST: $!";
my $otherxs = join " ",
		map { substr($_, 0, -1) }
		grep { m:^xs/: }
		<MANIFEST>;
close(MANIFEST);



if ($options{'help'}){
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
  the ./bin/krb5_config utility.

(2) --gssapi_libs='-L/bla/local/mitkrb/lib -lgss_all'
  The precise location of the libraries with -L and the libraries needed with -l.

(3) --gssapi_inc -I/bla/local/mitkrb/include
  The exact location of the header files.

(4) --gssapi_lddlflags='-shared -Wl,--enable-new-dtags -Wl,-rpath -Wl/bla/local/mitkrb/lib'
  Allows for any flags to be passed to the linker, for instance if WriteMakefile ignores 
  entries in LIBS.

Option (1) is preferred, use (2),(3) and (4) only if needed and you know what you 
are doing. If any of (2),(3) or (4) is supplied, (1) will be ignored.

HELP
;
  exit;
}

#-------------------------------------------------------------
print "\n Welcome to GSSAPI.pm setup! \n";
print qq{\n run "perl Makefile.PL --help" to see further installation options\n};

#---------------------------------------------------------------
my @GSSLIBS = ();
my @LDDLFLAGS = ();
my $incconf = '';
my @EXTRADEFINES;
#---------------------------------------------------------------

if (exists $options{gssapi_libs} || exists $options{gssapi_inc} || exists $options{gssapi_lddlflags} ) {
    if ($options{gssapi_libs}) {
	push @GSSLIBS, $options{gssapi_libs}
    } else {
	die 'if options gssapi_inc or gssapi_lddlflags are provided, then gssapi_libs must be as well';
    }
    if ($options{gssapi_inc}) {
	$incconf = $options{gssapi_inc}
    } else {
	die 'if options gssapi_libs or gssapi_lddlflags are provided, then gssapi_inc must be as well';
    }
    if ($options{gssapi_lddlflags}) {
	push @LDDLFLAGS, 'LDDLFLAGS', $options{gssapi_lddlflags}
    }
} else {
    print "\n Searching krb5-config command...";
    my $krb5cmd = find_krb5config_cmd($options{'gssapiimpl'} );
    unless ($krb5cmd) {
	die 'not found!';
    } else {
      print $krb5cmd ;
    }
    #---------------------------------------------
    my $implementation = krb5_version( $krb5cmd  );
    print "\n using GSSAPI implementation ", $implementation;
    #---------------------------------------------
    my $libconf =  krb5_libconfig( $krb5cmd );
    unless ($libconf) {
       die "$krb5cmd does not respond libconf!";
    } else {
      push @GSSLIBS, $libconf ;

    }

    #---------------------------------------------------------------
    $incconf =  krb5_cflags( $krb5cmd  );
    unless ( $incconf ) {
       #
       # krb5-conf does not respond -I/usr/include
       # on Fedora and RHL.
       # Thanks to Dax Kelson <dax@gurulabs.com>
       #
       $incconf = '-I/usr/include';
    }
    #---------------------------------------------------------------
    if ( is_heimdal($krb5cmd) ) {
       push @EXTRADEFINES,  '-DHEIMDAL';
       print "Setting Heimdal Defines\n";
    } else {
       print "Setting MIT defines\n";
    }
}


#--------------------------------------------------------------
print "\n Using libconfiguration\n", @GSSLIBS;
print "\n Using includeconfiguration\n", $incconf;
print "\n using own defines \n", @EXTRADEFINES, "\n";
#--------------------------------------------------------------


WriteMakefile(
     LIBS               => join (' ', @GSSLIBS),
    'NAME'		=> 'GSSAPI',
    'VERSION_FROM'	=> 'GSSAPI.pm',
    'PREREQ_PM'		=> { 'Test::More' => 0 },
    @LDDLFLAGS,
    'DEFINE'            => join (' ', @EXTRADEFINES),
    'INC'               => $incconf,
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
      my $whichcmd =  find_which_command() || die 'cannot locate which command';
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
   FOUND: {
      foreach ( @vinfo) {
         if ( m/eimdal/) {
            $r = 1;
	    last FOUND;
         }
       }
   }
   return $r;
}
#-------------------------------------------------
