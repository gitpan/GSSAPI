package GSSAPI::OID::Set;

require 5.005_62;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter GSSAPI);

our %EXPORT_TAGS = ( 'all' => [ qw(
	gss_mech_set_krb5
	gss_mech_set_krb5_old
	gss_mech_set_krb5_both
	gss_mech_set_krb5_v2
	gss_mech_set_krb5_v1v2
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT    = ( @{ $EXPORT_TAGS{'all'} } );

1;
__END__

=head1 NAME

GSSAPI::OID::Set - methods for handling sets of GSSAPI OIDs, and some constant OID sets.

=head1 SYNOPSIS

  use GSSAPI;
  
  $oidset = GSSAPI::OID::Set->new;

  $status = $oidset->insert($oid);
  $status = $oidset->contains($oid, $isthere);
  if ($status && $isthere) {
    # blah blah blah
  }

  # Constant OID sets provided:
  $oidset = gss_mech_set_krb5;
  $oidset = gss_mech_set_krb5_old;
  $oidset = gss_mech_set_krb5_both;
  $oidset = gss_mech_set_krb5_v2;
  $oidset = gss_mech_set_krb5_v1v2;


=head1 DESCRIPTION

C<GSSAPI::OID::Set> objects are simple sets of GSSAPI:OIDs (duh).

=head1 BUGS

There's no way to list the OIDs in a set; you can only check to see
if a particular one is present.  This is really a bug in the C API,
so any fix would be implementation specific.

=head1 AUTHOR

Philip Guenther, guenther@gac.edu

=head1 SEE ALSO

perl(1)
GSSAPI(3p)
GSSAPI::OID(3p)
RFC2743

=cut
