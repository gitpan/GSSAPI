#! /usr/bin/perl -w

use strict;

use ExtUtils::testlib;

use GSSAPI qw(:all);
use Test::More tests => 28;


my $status;
my $okay;

my($name, $name2, $same, $export, $display, $type);

$status = GSSAPI::Name->import($name, 'chpasswd@mars.gac.edu',
				gss_nt_service_name);

ok($status, 'GSSAPI::Name->import of chpasswd@mars.gac.edu' );

ok(ref $name eq "GSSAPI::Name",  'ref $name eq "GSSAPI::Name"');



#------------------------------------------
$status = $name->duplicate($name2);
ok($status->major == GSS_S_COMPLETE, '$name->duplicate($name2)');

$status = $name->compare($name2, $same);
ok($status->major == GSS_S_COMPLETE, '$name->compare($name2, $same)');

eval {
	$status = $name->compare($name2, 0);
};
ok( $@ =~ /Modification of a read-only value/ , 'Modification of a read-only value');


#------------------------------------------

my $oid = gss_nt_user_name;
my $str;

SKIP:
{
   skip('oid_to_str not supportetd on Heimdal', 2) if GSSAPI::gssapi_implementation_is_heimdal();

   $status = $oid->to_str($str);
   ok($status, ' $oid->to_str($str) ');
   ok($str eq '{ 1 2 840 113554 1 2 1 1 }', q{ $str eq '{ 1 2 840 113554 1 2 1 1 }' });
}

    { my(@oidss); foreach(1..1000) { push @oidss, GSSAPI::OID::Set->new() };
    }

        my($oidset);

$status = gss_mech_krb5->inquire_names($oidset);
ok(ref $status eq 'GSSAPI::Status', q{ref $status eq 'GSSAPI::Status'});
ok($status, 'gss_mech_krb5->inquire_names($oidset);');


undef $oidset;




#
#	GSSAPI::Binding
#
    my($binding);

    $binding = GSSAPI::Binding->new();
    ok(ref $binding eq "GSSAPI::Binding");;
    ok($binding->get_initiator_addrtype == GSS_C_AF_NULLADDR,
       '$binding->get_initiator_addrtype == GSS_C_AF_NULLADDR');
    ok(! defined $binding->get_initiator_address);
    ok($binding->get_acceptor_addrtype  == GSS_C_AF_NULLADDR,
       '$binding->get_acceptor_addrtype  == GSS_C_AF_NULLADDR');
    ok(! defined $binding->get_acceptor_address);
    ok(! defined $binding->get_appl_data);

    $okay = 1;
    foreach (1 .. 1000) {
	$binding = GSSAPI::Binding->new();
	ref $binding eq "GSSAPI::Binding"		or $okay = 0, last;
    }
    ok($okay, 'GSSAPI::Binding->new()');


    # first, just random types
    $okay = 1;
    foreach (1 .. 1000) {
	my($type1, $type2);
	$binding = GSSAPI::Binding->new();
	ref $binding eq "GSSAPI::Binding"		or $okay = 0, last;
	$type1 = int(rand(0x7fffffff));
	$type2 = int(rand(0x7fffffff));

	$binding->set_initiator($type1, undef);
	$binding->set_acceptor($type2, undef);
	$binding->get_initiator_addrtype == $type1	&&
	! defined $binding->get_initiator_address	&&
	$binding->get_acceptor_addrtype  == $type2	&&
	! defined $binding->get_acceptor_address	or $okay = 0, last;
    }
    ok($okay, 'random types as input of GSSAPI::Binding');
     # Now, random types and values
    $okay = 1;
    foreach (1 .. 1000) {
    	my($type1, $addr1, $type2, $addr2, $appl);

	$type1 = int(rand(0x7fffffff));
	$addr1 = rand_string();
	$type2 = int(rand(0x7fffffff));
	$addr2 = rand_string();
	$appl = rand_string();

	$binding = GSSAPI::Binding->new();
	ref $binding eq "GSSAPI::Binding"		or $okay = 0, last;

	$binding->set_initiator($type1, $addr1);
	$binding->set_acceptor($type2, $addr2);
	$binding->set_appl_data($appl);

	$binding->get_initiator_addrtype == $type1	&&
	$binding->get_initiator_address  eq $addr1	&&
	$binding->get_acceptor_addrtype  == $type2	&&
	$binding->get_acceptor_address   eq $addr2	&&
	$binding->get_appl_data          eq $appl	or $okay = 0, last;
	undef $binding;
    }
    ok($okay, 'random types and values as input of GSSAPI::Binding');

#
#	GSSAPI::Cred
#

    my($cred1, $time);

    $status = GSSAPI::Cred::acquire_cred(undef, 120, undef, GSS_C_INITIATE,
				$cred1, $oidset, $time);

SKIP: {
    if ( $status->major != GSS_S_COMPLETE ) {
        skip( 'This tests only work if user has run kinit succesfully', 6 );
    }
    ok($status, 'GSSAPI::Cred::acquire_cred');
    ok(ref $cred1 eq "GSSAPI::Cred");
    ok(ref $oidset eq "GSSAPI::OID::Set");

    my($lifetime, $cred_usage);
    $status = $cred1->inquire_cred($name, $lifetime, $cred_usage, $oidset);



    ok( $status, '$cred1->inquire_cred($name, $lifetime, $cred_usage, $oidset' );

    ok(ref $oidset eq "GSSAPI::OID::Set");
    ok($cred_usage & GSS_C_INITIATE);

}



{
  my $oidset;
  my $isin = 0;
  my $supportresponse;
  my $status = GSSAPI::indicate_mechs( $oidset );
  ok ( $status, q{ GSSAPI::indicate_mechs( $oidset ) } );

  $status = $oidset->contains( gss_mech_krb5_old, $isin );
  $supportresponse = $isin ? ' supports KRB5 old Mechtype' :  ' does not support KRB5 old Mechtype';
  ok ( $status, q{ $oidset->contains( gss_mech_krb5_old, $isin ) - implementation } . $supportresponse );


  $status = $oidset->contains( gss_mech_krb5, $isin );
  $supportresponse = $isin ? ' supports Kerberos 5' :  ' does not support Kerberos 5';
  ok ( $status, q{ $oidset->contains( gss_mech_krb5, $isin ) - implementation } . $supportresponse );

  $status = $oidset->contains( gss_mech_spnego, $isin );
  $supportresponse = $isin ? ' supports SPNEGO' :  ' does not support SPNEGO';
  ok ( $status, q{ $oidset->contains( gss_mech_spnego, $isin ) - implementation } . $supportresponse );

}
print "\n\n if you want to run tests that do a realworld *use* of your GSSAPI",
      "\n start a kinit and try to run",
      "\n./examples/getcred_hostbased.pl \n\n";

#-------------------------------------------------------------

sub rand_string {
    my($length, $buf);
    $length = int(rand(64));
    $buf = '';
    foreach (1..$length) {
	$buf .= chr(rand(0xFF));
    }
    $buf
}