
GSSAPI::OID_out
new(class)
	char *		class
    CODE:
	RETVAL = NULL;
    OUTPUT:
	RETVAL

void
DESTROY(oid)
	GSSAPI::OID	oid
    PREINIT:
	OM_uint32	minor;
    CODE:
	if (oid != NULL) {
	    (void)gss_release_oid(&minor, &oid);
	}

GSSAPI::Status
from_str(class, oid, str)
	char *		class
	GSSAPI::OID_out	oid
	gss_buffer_str	str
    CODE:
	RETVAL.major = gss_str_to_oid(&RETVAL.minor, &str, &oid);
    OUTPUT:
	RETVAL
	oid

GSSAPI::Status
to_str(oid, str)
	GSSAPI::OID		oid
	gss_buffer_str_out	str
    CODE:
	if (oid == NULL) {
	    sv_setsv_mg(ST(1), &PL_sv_undef);
	    XSRETURN_UNDEF;
	}
	RETVAL.major = gss_oid_to_str(&RETVAL.minor, oid, &str);
    OUTPUT:
	RETVAL
	str

GSSAPI::Status
inquire_names(oid, oidset)
	GSSAPI::OID		oid
	GSSAPI::OID::Set_out	oidset
    CODE:
	RETVAL.major =
		gss_inquire_names_for_mech(&RETVAL.minor, oid, &oidset);
    OUTPUT:
	RETVAL
	oidset


#
#	generic OIDs
#

GSSAPI::OID_const
gss_nt_user_name()
    CODE:
	RETVAL = gss_nt_user_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_machine_uid_name()
    CODE:
	RETVAL = gss_nt_machine_uid_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_string_uid_name()
    CODE:
	RETVAL = gss_nt_string_uid_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_service_name()
    CODE:
	RETVAL = gss_nt_service_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_exported_name()
    CODE:
	RETVAL = gss_nt_exported_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_service_name_v2()
    CODE:
	RETVAL = gss_nt_service_name_v2;
    OUTPUT:
	RETVAL


#	
#	Kerberos OIDs
#

GSSAPI::OID_const
gss_nt_krb5_name()
    CODE:
	RETVAL = gss_nt_krb5_name;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_nt_krb5_principal()
    CODE:
	RETVAL = gss_nt_krb5_principal;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_mech_krb5()
    CODE:
	RETVAL = gss_mech_krb5;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_mech_krb5_old()
    CODE:
	RETVAL = gss_mech_krb5_old;
    OUTPUT:
	RETVAL

GSSAPI::OID_const
gss_mech_krb5_v2()
    CODE:
	RETVAL = gss_mech_krb5_v2;
    OUTPUT:
	RETVAL
