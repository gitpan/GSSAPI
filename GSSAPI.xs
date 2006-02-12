#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define __KRB5_MECHTYPE_OID &mygss_mech_krb5
#define __KRB5_OLD_MECHTYPE_OID &mygss_mech_krb5_old
#define __SPNEGO_MECHTYPE_OID &myspnego_oid_desc

#if defined(HEIMDAL)
#include <gssapi.h>
#endif

#if !defined(HEIMDAL)

#include <gssapi/gssapi_generic.h>
#include <gssapi/gssapi_krb5.h>
#endif

static gss_OID_desc  mygss_mech_krb5  = {9, (void *) "\x2a\x86\x48\x86\xf7\x12\x01\x02\x02"};
static gss_OID_desc  mygss_mech_krb5_old  = {5, (void *) "\x2b\x05\x01\x05\x02"};

static gss_OID_desc myspnego_oid_desc = {6, (void *) "\x2b\x06\x01\x05\x05\x02"};


static double
constant_GSS_S_NO(char *name, int len, int arg)
{
    if (8 + 2 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 2]) {
    case 'O':
	if (strEQ(name + 8, "_CONTEXT")) {	/* GSS_S_NO removed */
#ifdef GSS_S_NO_CONTEXT
	    return GSS_S_NO_CONTEXT;
#else
	    goto not_there;
#endif
	}
    case 'R':
	if (strEQ(name + 8, "_CRED")) {	/* GSS_S_NO removed */
#ifdef GSS_S_NO_CRED
	    return GSS_S_NO_CRED;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_N(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'A':
	if (strEQ(name + 7, "AME_NOT_MN")) {	/* GSS_S_N removed */
#ifdef GSS_S_NAME_NOT_MN
	    return GSS_S_NAME_NOT_MN;
#else
	    goto not_there;
#endif
	}
    case 'O':
	return constant_GSS_S_NO(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_BAD_N(char *name, int len, int arg)
{
    if (11 + 3 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[11 + 3]) {
    case '\0':
	if (strEQ(name + 11, "AME")) {	/* GSS_S_BAD_N removed */
#ifdef GSS_S_BAD_NAME
	    return GSS_S_BAD_NAME;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 11, "AMETYPE")) {	/* GSS_S_BAD_N removed */
#ifdef GSS_S_BAD_NAMETYPE
	    return GSS_S_BAD_NAMETYPE;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_BAD_S(char *name, int len, int arg)
{
    switch (name[11 + 0]) {
    case 'I':
	if (strEQ(name + 11, "IG")) {	/* GSS_S_BAD_S removed */
#ifdef GSS_S_BAD_SIG
	    return GSS_S_BAD_SIG;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 11, "TATUS")) {	/* GSS_S_BAD_S removed */
#ifdef GSS_S_BAD_STATUS
	    return GSS_S_BAD_STATUS;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_B(char *name, int len, int arg)
{
    if (7 + 3 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[7 + 3]) {
    case 'B':
	if (strEQ(name + 7, "AD_BINDINGS")) {	/* GSS_S_B removed */
#ifdef GSS_S_BAD_BINDINGS
	    return GSS_S_BAD_BINDINGS;
#else
	    goto not_there;
#endif
	}
    case 'M':
	if (strEQ(name + 7, "AD_MECH")) {	/* GSS_S_B removed */
#ifdef GSS_S_BAD_MECH
	    return GSS_S_BAD_MECH;
#else
	    goto not_there;
#endif
	}
    case 'N':
	if (!strnEQ(name + 7,"AD_", 3))
	    break;
	return constant_GSS_S_BAD_N(name, len, arg);
    case 'Q':
	if (strEQ(name + 7, "AD_QOP")) {	/* GSS_S_B removed */
#ifdef GSS_S_BAD_QOP
	    return GSS_S_BAD_QOP;
#else
	    goto not_there;
#endif
	}
    case 'S':
	if (!strnEQ(name + 7,"AD_", 3))
	    break;
	return constant_GSS_S_BAD_S(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_CON(char *name, int len, int arg)
{
    if (9 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[9 + 1]) {
    case 'E':
	if (strEQ(name + 9, "TEXT_EXPIRED")) {	/* GSS_S_CON removed */
#ifdef GSS_S_CONTEXT_EXPIRED
	    return GSS_S_CONTEXT_EXPIRED;
#else
	    goto not_there;
#endif
	}
    case 'I':
	if (strEQ(name + 9, "TINUE_NEEDED")) {	/* GSS_S_CON removed */
#ifdef GSS_S_CONTINUE_NEEDED
	    return GSS_S_CONTINUE_NEEDED;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_CO(char *name, int len, int arg)
{
    switch (name[8 + 0]) {
    case 'M':
	if (strEQ(name + 8, "MPLETE")) {	/* GSS_S_CO removed */
#ifdef GSS_S_COMPLETE
	    return GSS_S_COMPLETE;
#else
	    goto not_there;
#endif
	}
    case 'N':
	return constant_GSS_S_CON(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_CALL_I(char *name, int len, int arg)
{
    if (12 + 12 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[12 + 12]) {
    case 'R':
	if (strEQ(name + 12, "NACCESSIBLE_READ")) {	/* GSS_S_CALL_I removed */
#ifdef GSS_S_CALL_INACCESSIBLE_READ
	    return GSS_S_CALL_INACCESSIBLE_READ;
#else
	    goto not_there;
#endif
	}
    case 'W':
	if (strEQ(name + 12, "NACCESSIBLE_WRITE")) {	/* GSS_S_CALL_I removed */
#ifdef GSS_S_CALL_INACCESSIBLE_WRITE
	    return GSS_S_CALL_INACCESSIBLE_WRITE;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_CA(char *name, int len, int arg)
{
    if (8 + 3 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 3]) {
    case 'B':
	if (strEQ(name + 8, "LL_BAD_STRUCTURE")) {	/* GSS_S_CA removed */
#ifdef GSS_S_CALL_BAD_STRUCTURE
	    return GSS_S_CALL_BAD_STRUCTURE;
#else
	    goto not_there;
#endif
	}
    case 'I':
	if (!strnEQ(name + 8,"LL_", 3))
	    break;
	return constant_GSS_S_CALL_I(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_CR(char *name, int len, int arg)
{
    if (8 + 2 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 2]) {
    case 'E':
	if (strEQ(name + 8, "EDENTIALS_EXPIRED")) {	/* GSS_S_CR removed */
#ifdef GSS_S_CREDENTIALS_EXPIRED
	    return GSS_S_CREDENTIALS_EXPIRED;
#else
	    goto not_there;
#endif
	}
    case '_':
	if (strEQ(name + 8, "ED_UNAVAIL")) {	/* GSS_S_CR removed */
#ifdef GSS_S_CRED_UNAVAIL
	    return GSS_S_CRED_UNAVAIL;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_C(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'A':
	return constant_GSS_S_CA(name, len, arg);
    case 'O':
	return constant_GSS_S_CO(name, len, arg);
    case 'R':
	return constant_GSS_S_CR(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_DU(char *name, int len, int arg)
{
    if (8 + 8 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 8]) {
    case 'E':
	if (strEQ(name + 8, "PLICATE_ELEMENT")) {	/* GSS_S_DU removed */
#ifdef GSS_S_DUPLICATE_ELEMENT
	    return GSS_S_DUPLICATE_ELEMENT;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 8, "PLICATE_TOKEN")) {	/* GSS_S_DU removed */
#ifdef GSS_S_DUPLICATE_TOKEN
	    return GSS_S_DUPLICATE_TOKEN;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_DE(char *name, int len, int arg)
{
    if (8 + 8 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 8]) {
    case 'C':
	if (strEQ(name + 8, "FECTIVE_CREDENTIAL")) {	/* GSS_S_DE removed */
#ifdef GSS_S_DEFECTIVE_CREDENTIAL
	    return GSS_S_DEFECTIVE_CREDENTIAL;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 8, "FECTIVE_TOKEN")) {	/* GSS_S_DE removed */
#ifdef GSS_S_DEFECTIVE_TOKEN
	    return GSS_S_DEFECTIVE_TOKEN;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_D(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'E':
	return constant_GSS_S_DE(name, len, arg);
    case 'U':
	return constant_GSS_S_DU(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_UNA(char *name, int len, int arg)
{
    switch (name[9 + 0]) {
    case 'U':
	if (strEQ(name + 9, "UTHORIZED")) {	/* GSS_S_UNA removed */
#ifdef GSS_S_UNAUTHORIZED
	    return GSS_S_UNAUTHORIZED;
#else
	    goto not_there;
#endif
	}
    case 'V':
	if (strEQ(name + 9, "VAILABLE")) {	/* GSS_S_UNA removed */
#ifdef GSS_S_UNAVAILABLE
	    return GSS_S_UNAVAILABLE;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_U(char *name, int len, int arg)
{
    if (7 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[7 + 1]) {
    case 'A':
	if (!strnEQ(name + 7,"N", 1))
	    break;
	return constant_GSS_S_UNA(name, len, arg);
    case 'S':
	if (strEQ(name + 7, "NSEQ_TOKEN")) {	/* GSS_S_U removed */
#ifdef GSS_S_UNSEQ_TOKEN
	    return GSS_S_UNSEQ_TOKEN;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_S_(char *name, int len, int arg)
{
    switch (name[6 + 0]) {
    case 'B':
	return constant_GSS_S_B(name, len, arg);
    case 'C':
	return constant_GSS_S_C(name, len, arg);
    case 'D':
	return constant_GSS_S_D(name, len, arg);
    case 'F':
	if (strEQ(name + 6, "FAILURE")) {	/* GSS_S_ removed */
#ifdef GSS_S_FAILURE
	    return GSS_S_FAILURE;
#else
	    goto not_there;
#endif
	}
    case 'G':
	if (strEQ(name + 6, "GAP_TOKEN")) {	/* GSS_S_ removed */
#ifdef GSS_S_GAP_TOKEN
	    return GSS_S_GAP_TOKEN;
#else
	    goto not_there;
#endif
	}
    case 'N':
	return constant_GSS_S_N(name, len, arg);
    case 'O':
	if (strEQ(name + 6, "OLD_TOKEN")) {	/* GSS_S_ removed */
#ifdef GSS_S_OLD_TOKEN
	    return GSS_S_OLD_TOKEN;
#else
	    goto not_there;
#endif
	}
    case 'U':
	return constant_GSS_S_U(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF_N(char *name, int len, int arg)
{
    switch (name[10 + 0]) {
    case 'B':
	if (strEQ(name + 10, "BS")) {	/* GSS_C_AF_N removed */
#ifdef GSS_C_AF_NBS
	    return GSS_C_AF_NBS;
#else
	    goto not_there;
#endif
	}
    case 'S':
	if (strEQ(name + 10, "S")) {	/* GSS_C_AF_N removed */
#ifdef GSS_C_AF_NS
	    return GSS_C_AF_NS;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 10, "ULLADDR")) {	/* GSS_C_AF_N removed */
#ifdef GSS_C_AF_NULLADDR
	    return GSS_C_AF_NULLADDR;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF_C(char *name, int len, int arg)
{
    switch (name[10 + 0]) {
    case 'C':
	if (strEQ(name + 10, "CITT")) {	/* GSS_C_AF_C removed */
#ifdef GSS_C_AF_CCITT
	    return GSS_C_AF_CCITT;
#else
	    goto not_there;
#endif
	}
    case 'H':
	if (strEQ(name + 10, "HAOS")) {	/* GSS_C_AF_C removed */
#ifdef GSS_C_AF_CHAOS
	    return GSS_C_AF_CHAOS;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF_D(char *name, int len, int arg)
{
    switch (name[10 + 0]) {
    case 'A':
	if (strEQ(name + 10, "ATAKIT")) {	/* GSS_C_AF_D removed */
#ifdef GSS_C_AF_DATAKIT
	    return GSS_C_AF_DATAKIT;
#else
	    goto not_there;
#endif
	}
    case 'E':
	if (strEQ(name + 10, "ECnet")) {	/* GSS_C_AF_D removed */
#ifdef GSS_C_AF_DECnet
	    return GSS_C_AF_DECnet;
#else
	    goto not_there;
#endif
	}
    case 'L':
	if (strEQ(name + 10, "LI")) {	/* GSS_C_AF_D removed */
#ifdef GSS_C_AF_DLI
	    return GSS_C_AF_DLI;
#else
	    goto not_there;
#endif
	}
    case 'S':
	if (strEQ(name + 10, "SS")) {	/* GSS_C_AF_D removed */
#ifdef GSS_C_AF_DSS
	    return GSS_C_AF_DSS;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF_I(char *name, int len, int arg)
{
    switch (name[10 + 0]) {
    case 'M':
	if (strEQ(name + 10, "MPLINK")) {	/* GSS_C_AF_I removed */
#ifdef GSS_C_AF_IMPLINK
	    return GSS_C_AF_IMPLINK;
#else
	    goto not_there;
#endif
	}
    case 'N':
	if (strEQ(name + 10, "NET")) {	/* GSS_C_AF_I removed */
#ifdef GSS_C_AF_INET
	    return GSS_C_AF_INET;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF_L(char *name, int len, int arg)
{
    switch (name[10 + 0]) {
    case 'A':
	if (strEQ(name + 10, "AT")) {	/* GSS_C_AF_L removed */
#ifdef GSS_C_AF_LAT
	    return GSS_C_AF_LAT;
#else
	    goto not_there;
#endif
	}
    case 'O':
	if (strEQ(name + 10, "OCAL")) {	/* GSS_C_AF_L removed */
#ifdef GSS_C_AF_LOCAL
	    return GSS_C_AF_LOCAL;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_AF(char *name, int len, int arg)
{
    if (8 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 1]) {
    case 'A':
	if (strEQ(name + 8, "_APPLETALK")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_APPLETALK
	    return GSS_C_AF_APPLETALK;
#else
	    goto not_there;
#endif
	}
    case 'B':
	if (strEQ(name + 8, "_BSC")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_BSC
	    return GSS_C_AF_BSC;
#else
	    goto not_there;
#endif
	}
    case 'C':
	if (!strnEQ(name + 8,"_", 1))
	    break;
	return constant_GSS_C_AF_C(name, len, arg);
    case 'D':
	if (!strnEQ(name + 8,"_", 1))
	    break;
	return constant_GSS_C_AF_D(name, len, arg);
    case 'E':
	if (strEQ(name + 8, "_ECMA")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_ECMA
	    return GSS_C_AF_ECMA;
#else
	    goto not_there;
#endif
	}
    case 'H':
	if (strEQ(name + 8, "_HYLINK")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_HYLINK
	    return GSS_C_AF_HYLINK;
#else
	    goto not_there;
#endif
	}
    case 'I':
	if (!strnEQ(name + 8,"_", 1))
	    break;
	return constant_GSS_C_AF_I(name, len, arg);
    case 'L':
	if (!strnEQ(name + 8,"_", 1))
	    break;
	return constant_GSS_C_AF_L(name, len, arg);
    case 'N':
	if (!strnEQ(name + 8,"_", 1))
	    break;
	return constant_GSS_C_AF_N(name, len, arg);
    case 'O':
	if (strEQ(name + 8, "_OSI")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_OSI
	    return GSS_C_AF_OSI;
#else
	    goto not_there;
#endif
	}
    case 'P':
	if (strEQ(name + 8, "_PUP")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_PUP
	    return GSS_C_AF_PUP;
#else
	    goto not_there;
#endif
	}
    case 'S':
	if (strEQ(name + 8, "_SNA")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_SNA
	    return GSS_C_AF_SNA;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 8, "_UNSPEC")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_UNSPEC
	    return GSS_C_AF_UNSPEC;
#else
	    goto not_there;
#endif
	}
    case 'X':
	if (strEQ(name + 8, "_X25")) {	/* GSS_C_AF removed */
#ifdef GSS_C_AF_X25
	    return GSS_C_AF_X25;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_A(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'C':
	if (strEQ(name + 7, "CCEPT")) {	/* GSS_C_A removed */
#ifdef GSS_C_ACCEPT
	    return GSS_C_ACCEPT;
#else
	    goto not_there;
#endif
	}
    case 'F':
	return constant_GSS_C_AF(name, len, arg);
    case 'N':
	if (strEQ(name + 7, "NON_FLAG")) {	/* GSS_C_A removed */
#ifdef GSS_C_ANON_FLAG
	    return GSS_C_ANON_FLAG;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_RO(char *name, int len, int arg)
{
    if (8 + 12 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 12]) {
    case 'M':
	if (strEQ(name + 8, "UTINE_ERROR_MASK")) {	/* GSS_C_RO removed */
#ifdef GSS_C_ROUTINE_ERROR_MASK
	    return GSS_C_ROUTINE_ERROR_MASK;
#else
	    goto not_there;
#endif
	}
    case 'O':
	if (strEQ(name + 8, "UTINE_ERROR_OFFSET")) {	/* GSS_C_RO removed */
#ifdef GSS_C_ROUTINE_ERROR_OFFSET
	    return GSS_C_ROUTINE_ERROR_OFFSET;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_R(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'E':
	if (strEQ(name + 7, "EPLAY_FLAG")) {	/* GSS_C_R removed */
#ifdef GSS_C_REPLAY_FLAG
	    return GSS_C_REPLAY_FLAG;
#else
	    goto not_there;
#endif
	}
    case 'O':
	return constant_GSS_C_RO(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_SU(char *name, int len, int arg)
{
    if (8 + 12 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 12]) {
    case 'M':
	if (strEQ(name + 8, "PPLEMENTARY_MASK")) {	/* GSS_C_SU removed */
#ifdef GSS_C_SUPPLEMENTARY_MASK
	    return GSS_C_SUPPLEMENTARY_MASK;
#else
	    goto not_there;
#endif
	}
    case 'O':
	if (strEQ(name + 8, "PPLEMENTARY_OFFSET")) {	/* GSS_C_SU removed */
#ifdef GSS_C_SUPPLEMENTARY_OFFSET
	    return GSS_C_SUPPLEMENTARY_OFFSET;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_S(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'E':
	if (strEQ(name + 7, "EQUENCE_FLAG")) {	/* GSS_C_S removed */
#ifdef GSS_C_SEQUENCE_FLAG
	    return GSS_C_SEQUENCE_FLAG;
#else
	    goto not_there;
#endif
	}
    case 'U':
	return constant_GSS_C_SU(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_CA(char *name, int len, int arg)
{
    if (8 + 12 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[8 + 12]) {
    case 'M':
	if (strEQ(name + 8, "LLING_ERROR_MASK")) {	/* GSS_C_CA removed */
#ifdef GSS_C_CALLING_ERROR_MASK
	    return GSS_C_CALLING_ERROR_MASK;
#else
	    goto not_there;
#endif
	}
    case 'O':
	if (strEQ(name + 8, "LLING_ERROR_OFFSET")) {	/* GSS_C_CA removed */
#ifdef GSS_C_CALLING_ERROR_OFFSET
	    return GSS_C_CALLING_ERROR_OFFSET;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_C(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'A':
	return constant_GSS_C_CA(name, len, arg);
    case 'O':
	if (strEQ(name + 7, "ONF_FLAG")) {	/* GSS_C_C removed */
#ifdef GSS_C_CONF_FLAG
	    return GSS_C_CONF_FLAG;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_I(char *name, int len, int arg)
{
    if (7 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[7 + 1]) {
    case 'D':
	if (strEQ(name + 7, "NDEFINITE")) {	/* GSS_C_I removed */
#ifdef GSS_C_INDEFINITE
	    return GSS_C_INDEFINITE;
#else
	    goto not_there;
#endif
	}
    case 'I':
	if (strEQ(name + 7, "NITIATE")) {	/* GSS_C_I removed */
#ifdef GSS_C_INITIATE
	    return GSS_C_INITIATE;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 7, "NTEG_FLAG")) {	/* GSS_C_I removed */
#ifdef GSS_C_INTEG_FLAG
	    return GSS_C_INTEG_FLAG;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C_M(char *name, int len, int arg)
{
    switch (name[7 + 0]) {
    case 'E':
	if (strEQ(name + 7, "ECH_CODE")) {	/* GSS_C_M removed */
#ifdef GSS_C_MECH_CODE
	    return GSS_C_MECH_CODE;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 7, "UTUAL_FLAG")) {	/* GSS_C_M removed */
#ifdef GSS_C_MUTUAL_FLAG
	    return GSS_C_MUTUAL_FLAG;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_GSS_C(char *name, int len, int arg)
{
    if (5 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[5 + 1]) {
    case 'A':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_A(name, len, arg);
    case 'B':
	if (strEQ(name + 5, "_BOTH")) {	/* GSS_C removed */
#ifdef GSS_C_BOTH
	    return GSS_C_BOTH;
#else
	    goto not_there;
#endif
	}
    case 'C':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_C(name, len, arg);
    case 'D':
	if (strEQ(name + 5, "_DELEG_FLAG")) {	/* GSS_C removed */
#ifdef GSS_C_DELEG_FLAG
	    return GSS_C_DELEG_FLAG;
#else
	    goto not_there;
#endif
	}
    case 'G':
	if (strEQ(name + 5, "_GSS_CODE")) {	/* GSS_C removed */
#ifdef GSS_C_GSS_CODE
	    return GSS_C_GSS_CODE;
#else
	    goto not_there;
#endif
	}
    case 'I':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_I(name, len, arg);
    case 'M':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_M(name, len, arg);
    case 'P':
	if (strEQ(name + 5, "_PROT_READY_FLAG")) {	/* GSS_C removed */
#ifdef GSS_C_PROT_READY_FLAG
	    return GSS_C_PROT_READY_FLAG;
#else
	    goto not_there;
#endif
	}
    case 'Q':
	if (strEQ(name + 5, "_QOP_DEFAULT")) {	/* GSS_C removed */
#ifdef GSS_C_QOP_DEFAULT
	    return GSS_C_QOP_DEFAULT;
#else
	    goto not_there;
#endif
	}
    case 'R':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_R(name, len, arg);
    case 'S':
	if (!strnEQ(name + 5,"_", 1))
	    break;
	return constant_GSS_C_S(name, len, arg);
    case 'T':
	if (strEQ(name + 5, "_TRANS_FLAG")) {	/* GSS_C removed */
#ifdef GSS_C_TRANS_FLAG
	    return GSS_C_TRANS_FLAG;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_G(char *name, int len, int arg)
{
    if (1 + 3 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[1 + 3]) {
    case 'C':
	if (!strnEQ(name + 1,"SS_", 3))
	    break;
	return constant_GSS_C(name, len, arg);
    case 'S':
	if (!strnEQ(name + 1,"SS_S_", 5))
	    break;
	return constant_GSS_S_(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant(char *name, int len, int arg)
{
    errno = 0;
    switch (name[0 + 0]) {
    case 'G':
	return constant_G(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

/*
 * These are not part of the GSSAPI C bindings, so we can't count on
 * them being defined.  They are part of the Kerberos 1.2 GSSAPI binding
 * so we'll provide them
 */
#ifndef GSS_CALLING_ERROR_FIELD
#define GSS_CALLING_ERROR_FIELD(x) \
   (((x) >> GSS_C_CALLING_ERROR_OFFSET) & GSS_C_CALLING_ERROR_MASK)
#endif
#ifndef GSS_ROUTINE_ERROR_FIELD
#define GSS_ROUTINE_ERROR_FIELD(x) \
   (((x) >> GSS_C_ROUTINE_ERROR_OFFSET) & GSS_C_ROUTINE_ERROR_MASK)
#endif
#ifndef GSS_SUPPLEMENTARY_INFO_FIELD
#define GSS_SUPPLEMENTARY_INFO_FIELD(x) \
   (((x) >> GSS_C_SUPPLEMENTARY_OFFSET) & GSS_C_SUPPLEMENTARY_MASK)
#endif


typedef struct {
    OM_uint32	major, minor;
} gss_status_desc;
typedef gss_status_desc			GSSAPI__Status;

typedef gss_name_t			GSSAPI__Name;
typedef gss_OID				GSSAPI__OID;
typedef gss_OID_set			GSSAPI__OID__Set;
typedef gss_cred_id_t			GSSAPI__Cred;
typedef gss_ctx_id_t			GSSAPI__Context;
typedef gss_channel_bindings_t		GSSAPI__Binding;

typedef const gss_OID_desc	*	GSSAPI__OID_const;
typedef const gss_OID_set_desc	*	GSSAPI__OID__Set_const;

typedef gss_ctx_id_t			GSSAPI__Context_Iopt;

typedef gss_name_t			GSSAPI__Name_out;
typedef gss_OID				GSSAPI__OID_out;
typedef gss_OID_set			GSSAPI__OID__Set_out;
typedef gss_cred_id_t			GSSAPI__Cred_out;
typedef gss_ctx_id_t			GSSAPI__Context_out;
typedef gss_channel_bindings_t		GSSAPI__Binding_out;
typedef I32				I32_out;
typedef int				int_out;
typedef gss_cred_usage_t		gss_cred_usage_t_out;
typedef U32				U32_out;
typedef OM_uint32			OM_uint32_out;

typedef gss_name_t		*	GSSAPI__Name_optout;
typedef gss_OID			*	GSSAPI__OID_optout;
typedef gss_OID_set		*	GSSAPI__OID__Set_optout;
typedef gss_cred_id_t		*	GSSAPI__Cred_optout;
typedef I32			*	I32_optout;
typedef int			*	int_optout;
typedef gss_cred_usage_t	*	gss_cred_usage_t_optout;
typedef U32			*	U32_optout;
typedef OM_uint32		*	OM_uint32_optout;

typedef gss_name_t			GSSAPI__Name_opt;
typedef gss_OID				GSSAPI__OID_opt;
typedef gss_OID_set			GSSAPI__OID__Set_opt;
typedef gss_channel_bindings_t		GSSAPI__Binding_opt;
typedef gss_cred_id_t			GSSAPI__Cred_opt;
typedef gss_ctx_id_t			GSSAPI__Context_opt;

typedef gss_buffer_desc			gss_buffer_desc_out;
typedef gss_buffer_desc			gss_buffer_desc_copy;
typedef gss_buffer_desc			gss_buffer_str;
typedef gss_buffer_desc			gss_buffer_str_out;

typedef void *				GSSAPI_obj;


int
oid_set_is_dynamic(GSSAPI__OID__Set oidset)
{
    return 1; /* 2006-02-13 all static sets are deleted */
}


MODULE = GSSAPI		PACKAGE = GSSAPI

PROTOTYPES: ENABLE

int
gssapi_implementation_is_heimdal()
CODE:
#if defined(HEIMDAL)
      RETVAL = 1;
#endif
#if !defined(HEIMDAL)
      RETVAL = 0;
#endif
OUTPUT:
        RETVAL


double
constant(sv,arg)
    PREINIT:
	STRLEN		len;
    INPUT:
	SV *		sv
	char *		s = SvPV(sv, len);
	int		arg
    CODE:
	RETVAL = constant(s,len,arg);
    OUTPUT:
	RETVAL


GSSAPI::Status
indicate_mechs(oidset)
	GSSAPI::OID::Set_out	oidset
    CODE:
	RETVAL.major = gss_indicate_mechs(&RETVAL.minor, &oidset);
    OUTPUT:
	RETVAL
	oidset

bool
is_valid(object)
	GSSAPI_obj	object
    CODE:
	RETVAL = (object != NULL);
    OUTPUT:
	RETVAL


MODULE = GSSAPI		PACKAGE = GSSAPI::Status

INCLUDE: xs/Status.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::Name

INCLUDE: xs/Name.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::OID

INCLUDE: xs/OID.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::OID::Set

INCLUDE: xs/OID__Set.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::Cred

INCLUDE: xs/Cred.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::Binding

INCLUDE: xs/Binding.xs


MODULE = GSSAPI		PACKAGE = GSSAPI::Context

INCLUDE: xs/Context.xs
