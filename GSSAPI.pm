package GSSAPI;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
use XSLoader;

our @ISA = qw(Exporter);
our $VERSION = '0.10';

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
# Below is stub documentation for your module. You better edit it!

=head1 NAME

GSSAPI - Perl extension for blah blah blah

=head1 SYNOPSIS

  use GSSAPI;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for GSSAPI, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

=head2 Exportable constants

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

When accessing these functions from Perl, prefix C<gss_> should be removed.

  OM_uint32   gss_accept_sec_context
  (OM_uint32   * minor_status,
            gss_ctx_id_t   * context_handle,
            gss_cred_id_t acceptor_cred_handle,
            gss_buffer_t input_token_buffer,
            gss_channel_bindings_t input_chan_bindings,
            gss_name_t   * src_name,
            gss_OID   * mech_type,
            gss_buffer_t output_token,
            OM_uint32   * ret_flags,
            OM_uint32   * time_rec,
            gss_cred_id_t   * delegated_cred_handle
           )  
  OM_uint32   gss_acquire_cred
  (OM_uint32   * minor_status,
            gss_name_t desired_name,
            OM_uint32 time_req,
            gss_OID_set desired_mechs,
            gss_cred_usage_t cred_usage,
            gss_cred_id_t   * output_cred_handle,
            gss_OID_set   * actual_mechs,
            OM_uint32   * time_rec
           )  
  OM_uint32   gss_add_cred
  (OM_uint32   * minor_status,
	    gss_cred_id_t input_cred_handle,
	    gss_name_t desired_name,
	    gss_OID desired_mech,
	    gss_cred_usage_t cred_usage,
	    OM_uint32 initiator_time_req,
	    OM_uint32 acceptor_time_req,
	    gss_cred_id_t   * output_cred_handle,
	    gss_OID_set   * actual_mechs,
	    OM_uint32   * initiator_time_rec,
	    OM_uint32   * acceptor_time_rec
	   )  
  OM_uint32   gss_add_oid_set_member
  (OM_uint32   * minor_status,
	    gss_OID member_oid,
	    gss_OID_set   * oid_set
	   )  
  OM_uint32   gss_canonicalize_name
 	(OM_uint32  * minor_status,
		 const gss_name_t input_name,
		 const gss_OID mech_type,
		 gss_name_t * output_name
	)  
  OM_uint32   gss_compare_name
  (OM_uint32   * minor_status,
            gss_name_t name1,
            gss_name_t name2,
            int   * name_equal
           )  
  OM_uint32   gss_context_time
  (OM_uint32   * minor_status,
            gss_ctx_id_t context_handle,
            OM_uint32   * time_rec
           )  
  OM_uint32   gss_create_empty_oid_set
  (OM_uint32   * minor_status,
	    gss_OID_set   * oid_set
	   )  
  OM_uint32   gss_delete_sec_context
  (OM_uint32   * minor_status,
            gss_ctx_id_t   * context_handle,
            gss_buffer_t output_token
           )  
  OM_uint32   gss_display_name
  (OM_uint32   * minor_status,
            gss_name_t input_name,
            gss_buffer_t output_name_buffer,
            gss_OID   * output_name_type
           )  
  OM_uint32   gss_display_status
  (OM_uint32   * minor_status,
            OM_uint32 status_value,
            int status_type,
            gss_OID,			 
            OM_uint32   * message_context,
            gss_buffer_t status_string
           )  
  OM_uint32   gss_duplicate_name
 	(OM_uint32  * minor_status,
		 const gss_name_t input_name,
		 gss_name_t * dest_name
	)  
  OM_uint32   gss_export_name
 	(OM_uint32  * minor_status,
		 const gss_name_t input_name,
		 gss_buffer_t exported_name
	)  
  OM_uint32   gss_export_name_object
  (OM_uint32   * minor_status,
	    gss_name_t input_name,
	    gss_OID desired_name_type,
	    void   *   * output_name
	   )  
  OM_uint32   gss_export_sec_context
  (OM_uint32   * minor_status,
	    gss_ctx_id_t   * context_handle,
	    gss_buffer_t interprocess_token
	    )  
  OM_uint32   gss_get_mic
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    gss_qop_t qop_req,
	    gss_buffer_t message_buffer,
	    gss_buffer_t message_token
	   )  
  OM_uint32   gss_import_name
  (OM_uint32   * minor_status,
            gss_buffer_t input_name_buffer,
            gss_OID,			 
            gss_name_t   * output_name
           )  
  OM_uint32   gss_import_name_object
  (OM_uint32   * minor_status,
	    void   * input_name,
	    gss_OID input_name_type,
	    gss_name_t   * output_name
	   )  
  OM_uint32   gss_import_sec_context
  (OM_uint32   * minor_status,
	    gss_buffer_t interprocess_token,
	    gss_ctx_id_t   * context_handle
	    )  
  OM_uint32   gss_indicate_mechs
  (OM_uint32   * minor_status,
            gss_OID_set   * mech_set
           )  
  OM_uint32   gss_init_sec_context
  (OM_uint32   * minor_status,
            gss_cred_id_t claimant_cred_handle,
            gss_ctx_id_t   * context_handle,
            gss_name_t target_name,
            gss_OID,			 
            OM_uint32 req_flags,
            OM_uint32 time_req,
            gss_channel_bindings_t input_chan_bindings,
            gss_buffer_t input_token,
            gss_OID   * actual_mech_type,
            gss_buffer_t output_token,
            OM_uint32   * ret_flags,
            OM_uint32   * time_rec
           )  
  OM_uint32   gss_inquire_context
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    gss_name_t   * src_name,
	    gss_name_t   * targ_name,
	    OM_uint32   * lifetime_rec,
	    gss_OID   * mech_type,
	    OM_uint32   * ctx_flags,
	    int   * locally_initiated,
	    int   * open
	   )  
  OM_uint32   gss_inquire_cred
  (OM_uint32   * minor_status,
            gss_cred_id_t cred_handle,
            gss_name_t   * name,
            OM_uint32   * lifetime,
            gss_cred_usage_t   * cred_usage,
            gss_OID_set   * mechanisms
           )  
  OM_uint32   gss_inquire_cred_by_mech
  (OM_uint32    * minor_status,
	    gss_cred_id_t cred_handle,
	    gss_OID mech_type,
	    gss_name_t   * name,
	    OM_uint32   * initiator_lifetime,
	    OM_uint32   * acceptor_lifetime,
	    gss_cred_usage_t   * cred_usage
	   )  
  OM_uint32   gss_inquire_names_for_mech
  (OM_uint32   * minor_status,
	    gss_OID mechanism,
	    gss_OID_set   * name_types
	   )  
  OM_uint32   gss_oid_to_str
  (OM_uint32   * minor_status,
	    gss_OID oid,
	    gss_buffer_t oid_str
	   )  
  OM_uint32   gss_process_context_token
  (OM_uint32   * minor_status,
            gss_ctx_id_t context_handle,
            gss_buffer_t token_buffer
           )  
  OM_uint32   gss_release_buffer
  (OM_uint32   * minor_status,
            gss_buffer_t buffer
           )  
  OM_uint32   gss_release_cred
  (OM_uint32   * minor_status,
            gss_cred_id_t   * cred_handle
           )  
  OM_uint32   gss_release_name
  (OM_uint32   * minor_status,
            gss_name_t   * input_name
           )  
  OM_uint32   gss_release_oid
  (OM_uint32   * minor_status,
	    gss_OID   * oid
	   )  
  OM_uint32   gss_release_oid_set
  (OM_uint32   * minor_status,
            gss_OID_set   * set
           )  
  OM_uint32   gss_str_to_oid
  (OM_uint32   * minor_status,
	    gss_buffer_t oid_str,
	    gss_OID   * oid
	   )  
  OM_uint32   gss_test_oid_set_member
  (OM_uint32   * minor_status,
	    gss_OID member,
	    gss_OID_set set,
	    int   * present
	   )  
  OM_uint32   gss_unwrap
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    gss_buffer_t input_message_buffer,
	    gss_buffer_t output_message_buffer,
	    int   * conf_state,
	    gss_qop_t   * qop_state
	   )  
  OM_uint32   gss_verify_mic
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    gss_buffer_t message_buffer,
	    gss_buffer_t message_token,
	    gss_qop_t * qop_state
	   )  
  OM_uint32   gss_wrap
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    int conf_req_flag,
	    gss_qop_t qop_req,
	    gss_buffer_t input_message_buffer,
	    int   * conf_state,
	    gss_buffer_t output_message_buffer
	   )  
  OM_uint32   gss_wrap_size_limit
  (OM_uint32   * minor_status,
	    gss_ctx_id_t context_handle,
	    int conf_req_flag,
	    gss_qop_t qop_req,
	    OM_uint32 req_output_size,
	    OM_uint32 * max_input_size
	   )  

=head1 AUTHOR

Philip Guenther, guenther@gac.edu

=head1 SEE ALSO

perl(1).

=cut
