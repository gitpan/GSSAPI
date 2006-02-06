package GSSAPI;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
use XSLoader;

our @ISA = qw(Exporter);
our $VERSION = '0.14';

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use GSSAPI ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

our %EXPORT_TAGS = ( 'all' => [ qw(
	GSS_C_ACCEPT
	GSS_C_AF_APPLETALK
	GSS_C_AF_BSC
	GSS_C_AF_CCITT
	GSS_C_AF_CHAOS
	GSS_C_AF_DATAKIT
	GSS_C_AF_DECnet
	GSS_C_AF_DLI
	GSS_C_AF_DSS
	GSS_C_AF_ECMA
	GSS_C_AF_HYLINK
	GSS_C_AF_IMPLINK
	GSS_C_AF_INET
	GSS_C_AF_LAT
	GSS_C_AF_LOCAL
	GSS_C_AF_NBS
	GSS_C_AF_NS
	GSS_C_AF_NULLADDR
	GSS_C_AF_OSI
	GSS_C_AF_PUP
	GSS_C_AF_SNA
	GSS_C_AF_UNSPEC
	GSS_C_AF_X25
	GSS_C_ANON_FLAG
	GSS_C_BOTH
	GSS_C_CALLING_ERROR_MASK
	GSS_C_CALLING_ERROR_OFFSET
	GSS_C_CONF_FLAG
	GSS_C_DELEG_FLAG
	GSS_C_EMPTY_BUFFER
	GSS_C_GSS_CODE
	GSS_C_INDEFINITE
	GSS_C_INITIATE
	GSS_C_INTEG_FLAG
	GSS_C_MECH_CODE
	GSS_C_MUTUAL_FLAG
	GSS_C_NO_BUFFER
	GSS_C_NO_CHANNEL_BINDINGS
	GSS_C_NO_CONTEXT
	GSS_C_NO_CREDENTIAL
	GSS_C_NO_NAME
	GSS_C_NO_OID
	GSS_C_NO_OID_SET
	GSS_C_PROT_READY_FLAG
	GSS_C_QOP_DEFAULT
	GSS_C_REPLAY_FLAG
	GSS_C_ROUTINE_ERROR_MASK
	GSS_C_ROUTINE_ERROR_OFFSET
	GSS_C_SEQUENCE_FLAG
	GSS_C_SUPPLEMENTARY_MASK
	GSS_C_SUPPLEMENTARY_OFFSET
	GSS_C_TRANS_FLAG
	GSS_S_BAD_BINDINGS
	GSS_S_BAD_MECH
	GSS_S_BAD_NAME
	GSS_S_BAD_NAMETYPE
	GSS_S_BAD_QOP
	GSS_S_BAD_SIG
	GSS_S_BAD_STATUS
	GSS_S_CALL_BAD_STRUCTURE
	GSS_S_CALL_INACCESSIBLE_READ
	GSS_S_CALL_INACCESSIBLE_WRITE
	GSS_S_COMPLETE
	GSS_S_CONTEXT_EXPIRED
	GSS_S_CONTINUE_NEEDED
	GSS_S_CREDENTIALS_EXPIRED
	GSS_S_CRED_UNAVAIL
	GSS_S_DEFECTIVE_CREDENTIAL
	GSS_S_DEFECTIVE_TOKEN
	GSS_S_DUPLICATE_ELEMENT
	GSS_S_DUPLICATE_TOKEN
	GSS_S_FAILURE
	GSS_S_GAP_TOKEN
	GSS_S_NAME_NOT_MN
	GSS_S_NO_CONTEXT
	GSS_S_NO_CRED
	GSS_S_OLD_TOKEN
	GSS_S_UNAUTHORIZED
	GSS_S_UNAVAILABLE
	GSS_S_UNSEQ_TOKEN
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT    = ( @{ $EXPORT_TAGS{'all'} } );

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/ || $!{EINVAL}) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined GSSAPI macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	if ($] >= 5.00561) {
	    *$AUTOLOAD = sub () { $val };
	}
	else {
	    *$AUTOLOAD = sub { $val };
	}
    }
    goto &$AUTOLOAD;
}

XSLoader::load 'GSSAPI', $VERSION;

sub import {
    my $self = shift;
    my @args = @_;
    my $package = caller;
    $self->export_to_level(1, $self, @args);
    foreach (qw(Status OID OID::Set)) {
	eval "package $package; use GSSAPI::$_ \@args; 1"
					or croak $@;
    }
}

{
    no strict 'refs';
    foreach my $pack (qw(Context Cred Name)) {
	@{"GSSAPI::${pack}::ISA"} = "GSSAPI";
    }
}

# Preloaded methods go here.

use constant GSS_C_NO_NAME		=> undef;
use constant GSS_C_NO_BUFFER		=> undef;
use constant GSS_C_NO_OID		=> undef;
use constant GSS_C_NO_OID_SET		=> undef;
use constant GSS_C_NO_CONTEXT		=> undef;
use constant GSS_C_NO_CREDENTIAL	=> undef;
use constant GSS_C_NO_CHANNEL_BINDINGS	=> undef;
use constant GSS_C_EMPTY_BUFFER		=> "";

sub GSS_C_ACCEPT();
sub GSS_C_AF_APPLETALK();
sub GSS_C_AF_BSC();
sub GSS_C_AF_CCITT();
sub GSS_C_AF_CHAOS();
sub GSS_C_AF_DATAKIT();
sub GSS_C_AF_DECnet();
sub GSS_C_AF_DLI();
sub GSS_C_AF_DSS();
sub GSS_C_AF_ECMA();
sub GSS_C_AF_HYLINK();
sub GSS_C_AF_IMPLINK();
sub GSS_C_AF_INET();
sub GSS_C_AF_LAT();
sub GSS_C_AF_LOCAL();
sub GSS_C_AF_NBS();
sub GSS_C_AF_NS();
sub GSS_C_AF_NULLADDR();
sub GSS_C_AF_OSI();
sub GSS_C_AF_PUP();
sub GSS_C_AF_SNA();
sub GSS_C_AF_UNSPEC();
sub GSS_C_AF_X25();
sub GSS_C_ANON_FLAG();
sub GSS_C_BOTH();
sub GSS_C_CALLING_ERROR_MASK();
sub GSS_C_CALLING_ERROR_OFFSET();
sub GSS_C_CONF_FLAG();
sub GSS_C_DELEG_FLAG();
sub GSS_C_GSS_CODE();
sub GSS_C_INDEFINITE();
sub GSS_C_INITIATE();
sub GSS_C_INTEG_FLAG();
sub GSS_C_MECH_CODE();
sub GSS_C_MUTUAL_FLAG();
sub GSS_C_PROT_READY_FLAG();
sub GSS_C_QOP_DEFAULT();
sub GSS_C_REPLAY_FLAG();
sub GSS_C_ROUTINE_ERROR_MASK();
sub GSS_C_ROUTINE_ERROR_OFFSET();
sub GSS_C_SEQUENCE_FLAG();
sub GSS_C_SUPPLEMENTARY_MASK();
sub GSS_C_SUPPLEMENTARY_OFFSET();
sub GSS_C_TRANS_FLAG();
sub GSS_S_BAD_BINDINGS();
sub GSS_S_BAD_MECH();
sub GSS_S_BAD_NAME();
sub GSS_S_BAD_NAMETYPE();
sub GSS_S_BAD_QOP();
sub GSS_S_BAD_SIG();
sub GSS_S_BAD_STATUS();
sub GSS_S_CALL_BAD_STRUCTURE();
sub GSS_S_CALL_INACCESSIBLE_READ();
sub GSS_S_CALL_INACCESSIBLE_WRITE();
sub GSS_S_COMPLETE();
sub GSS_S_CONTEXT_EXPIRED();
sub GSS_S_CONTINUE_NEEDED();
sub GSS_S_CREDENTIALS_EXPIRED();
sub GSS_S_CRED_UNAVAIL();
sub GSS_S_DEFECTIVE_CREDENTIAL();
sub GSS_S_DEFECTIVE_TOKEN();
sub GSS_S_DUPLICATE_ELEMENT();
sub GSS_S_DUPLICATE_TOKEN();
sub GSS_S_FAILURE();
sub GSS_S_GAP_TOKEN();
sub GSS_S_NAME_NOT_MN();
sub GSS_S_NO_CONTEXT();
sub GSS_S_NO_CRED();
sub GSS_S_OLD_TOKEN();
sub GSS_S_UNAUTHORIZED();
sub GSS_S_UNAVAILABLE();
sub GSS_S_UNSEQ_TOKEN();

1;
__END__

=head1 NAME

GSSAPI - Perl extension providing access to the GSSAPIv2 library

=head1 SYNOPSIS


  use GSSAPI;

  my $targethostname = 'HTTP@moerbsen.grolmsnet.lan';
  my $status;


  TRY: {
     my $target;
     $status = GSSAPI::Name->import( $target,
                                     $targethostname,
                                     GSSAPI::OID::gss_nt_hostbased_service);
     last if($status->major != GSS_S_COMPLETE );
     my $tname;
     $status = $target->display($tname);
     last if($status->major != GSS_S_COMPLETE );
     print "\n using Name $tname";


     my $ctx = GSSAPI::Context->new();
     my $imech = GSSAPI::OID::gss_mech_krb5;
     my $iflags = 0 ;
     my $bindings = GSS_C_NO_CHANNEL_BINDINGS;
     my $creds = GSS_C_NO_CREDENTIAL;
     my $itime = 0;
     my $itoken = '';
     my ($omech, $otoken, $oflags, $otime);

     $status = $ctx->init($creds,$target,$imech,$iflags,$itime,$bindings,$itoken,
                          $omech,$otoken,$oflags,$otime);
  }

  unless ($status->major == GSS_S_COMPLETE ) {
     print "\nErrors:\n";
     print $status->generic_message(), "\n", $status->specific_message();
  } else {
     print "\n seems everything is fine, type klist to see the ticket\n";
  }


=head1 DESCRIPTION

This module gives access to the routines of the GSSAPI library,
as described in rfc2743 and rfc2744 and implemented by the
Kerberos-1.2 distribution from MIT.

Since 0.14 it also compiles and works with Heimdal.
Lacks of Heimdal support are gss_release_oid(),
gss_str_to_oid() and fail of some tests.
Have a look test.pl file too see what tests
fail on Heimdal (test.pl is just skipping them at the moment)

The API presented by this module is a mildly object oriented
reinterpretation of the C API, where opaque C structures are
Perl objects, but the style of function call has been left
mostly untouched.  As a result, most routines modify one or
more of the parameters passed to them, reflecting the C
call-by-reference (or call-by-value-return) semantics.

All users of this module are therefore strongly advised to
localize all usage of these routines to minimize pain if and
when the API changes.

=head1 SEE ALSO

RFC2743
RFC2744
GSSAPI::Status(3p)
GSSAPI::OID(3p)
GSSAPI::OID::Set(3p)
perl(1)
LWP::Authen::Negotiate

=head2 EXPORT

  GSS_C_ACCEPT
  GSS_C_AF_APPLETALK
  GSS_C_AF_BSC
  GSS_C_AF_CCITT
  GSS_C_AF_CHAOS
  GSS_C_AF_DATAKIT
  GSS_C_AF_DECnet
  GSS_C_AF_DLI
  GSS_C_AF_DSS
  GSS_C_AF_ECMA
  GSS_C_AF_HYLINK
  GSS_C_AF_IMPLINK
  GSS_C_AF_INET
  GSS_C_AF_LAT
  GSS_C_AF_LOCAL
  GSS_C_AF_NBS
  GSS_C_AF_NS
  GSS_C_AF_NULLADDR
  GSS_C_AF_OSI
  GSS_C_AF_PUP
  GSS_C_AF_SNA
  GSS_C_AF_UNSPEC
  GSS_C_AF_X25
  GSS_C_ANON_FLAG
  GSS_C_BOTH
  GSS_C_CALLING_ERROR_MASK
  GSS_C_CALLING_ERROR_OFFSET
  GSS_C_CONF_FLAG
  GSS_C_DELEG_FLAG
  GSS_C_EMPTY_BUFFER
  GSS_C_GSS_CODE
  GSS_C_INDEFINITE
  GSS_C_INITIATE
  GSS_C_INTEG_FLAG
  GSS_C_MECH_CODE
  GSS_C_MUTUAL_FLAG
  GSS_C_NO_BUFFER
  GSS_C_NO_CHANNEL_BINDINGS
  GSS_C_NO_CONTEXT
  GSS_C_NO_CREDENTIAL
  GSS_C_NO_NAME
  GSS_C_NO_OID
  GSS_C_NO_OID_SET
  GSS_C_PROT_READY_FLAG
  GSS_C_QOP_DEFAULT
  GSS_C_REPLAY_FLAG
  GSS_C_ROUTINE_ERROR_MASK
  GSS_C_ROUTINE_ERROR_OFFSET
  GSS_C_SEQUENCE_FLAG
  GSS_C_SUPPLEMENTARY_MASK
  GSS_C_SUPPLEMENTARY_OFFSET
  GSS_C_TRANS_FLAG
  GSS_S_BAD_BINDINGS
  GSS_S_BAD_MECH
  GSS_S_BAD_NAME
  GSS_S_BAD_NAMETYPE
  GSS_S_BAD_QOP
  GSS_S_BAD_SIG
  GSS_S_BAD_STATUS
  GSS_S_CALL_BAD_STRUCTURE
  GSS_S_CALL_INACCESSIBLE_READ
  GSS_S_CALL_INACCESSIBLE_WRITE
  GSS_S_COMPLETE
  GSS_S_CONTEXT_EXPIRED
  GSS_S_CONTINUE_NEEDED
  GSS_S_CREDENTIALS_EXPIRED
  GSS_S_CRED_UNAVAIL
  GSS_S_DEFECTIVE_CREDENTIAL
  GSS_S_DEFECTIVE_TOKEN
  GSS_S_DUPLICATE_ELEMENT
  GSS_S_DUPLICATE_TOKEN
  GSS_S_FAILURE
  GSS_S_GAP_TOKEN
  GSS_S_NAME_NOT_MN
  GSS_S_NO_CONTEXT
  GSS_S_NO_CRED
  GSS_S_OLD_TOKEN
  GSS_S_UNAUTHORIZED
  GSS_S_UNAVAILABLE
  GSS_S_UNSEQ_TOKEN

=head2 Exportable functions

    $status = indicate_mechs($oidset)

    # Constant OIDs provided:
    $oid = gss_nt_user_name;
    $oid = gss_nt_machine_uid_name;
    $oid = gss_nt_string_uid_name;
    $oid = gss_nt_service_name;
    $oid = gss_nt_exported_name;
    $oid = gss_nt_service_name_v2;
    $oid = gss_nt_krb5_name;
    $oid = gss_nt_krb5_principal;
    $oid = gss_mech_krb5;
    $oid = gss_mech_krb5_old;
    $oid = gss_mech_krb5_v2;

    # Constant OID sets provided:
    $oidset = gss_mech_set_krb5;
    $oidset = gss_mech_set_krb5_old;
    $oidset = gss_mech_set_krb5_both;
    $oidset = gss_mech_set_krb5_v2;
    $oidset = gss_mech_set_krb5_v1v2;

All other functions are class or instance methods.


=head1 SUPPORT

See our project home at <http://perlgssapi.sourceforge.net/>

Mailinglist perlgssapi-users@lists.sourceforge.net

=head1 AUTHOR

The module ist maintained by
Achim Grolms <perl@grolmsnet.de>

originally written by
Philip Guenther <pguen@cpan.org>

=head1 THANKS TO

=over

=item Philip Guenther

=item Leif Johansson

=item Merijn Broeren

=item Harald Joerg

=item Christopher Odenbach

=item Dax Kelson

=back

=head1 COPYRIGHT

Copyright (c) 2006 Achim Grolms

Copyright (c) 2000,2001,2005 Philip Guenther. All rights reserved.
This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
