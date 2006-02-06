#! /usr/bin/perl -w

use strict;

use ExtUtils::testlib;

use GSSAPI qw(:all);
use Test::More tests => 44;


ok( 1 == 1 , 'Dummy (1 == 1, should never fail.)' );
ok( GSSAPI::Status::GSS_ERROR(GSS_S_COMPLETE) == 0,
   'GSSAPI::Status::GSS_ERROR(GSS_S_COMPLETE) == 0' );

ok( GSSAPI::Status::GSS_ERROR(GSS_S_BAD_SIG) == 1,
    'GSSAPI::Status::GSS_ERROR(GSS_S_BAD_SIG) == 1' );

my $status = GSSAPI::Status->new(GSS_S_COMPLETE, 0);

ok(ref $status eq "GSSAPI::Status", 'created GSSAPI::Status object');

ok($status->major == GSS_S_COMPLETE, '$status->major == GSS_S_COMPLETE');
ok($status->minor == 0, '$status->minor == 0');
ok($status, '$status');

my @string;
ok(@string = $status->generic_message(),
             '$status->generic_message(): ' . join '', @string);
ok(@string = $status->specific_message(),
             '$status->specific_message(): ' . join '', @string);

my $okay = 1;
foreach (1 .. 1000) {
	my($maj, $min);
	$maj = int(rand(0xffffffff));
	$min = int(rand(0xffffffff));

	$status = GSSAPI::Status->new($maj, $min);

	$status->major == $maj && $status->minor == $min
			or $okay = 0, last;
}
ok($okay, 'GSSAPI::Status->new($maj, $min) with random values');

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
#	GSSAPI::OID::Set
#
my $isin = 0;

$oidset = GSSAPI::OID::Set->new();
    ok(ref $oidset eq "GSSAPI::OID::Set");
    $status = $oidset->insert(gss_nt_user_name);
    ok($status, '$oidset->insert(gss_nt_user_name)');
    $status = $oidset->insert(gss_nt_service_name);
    ok($status, '$oidset->insert(gss_nt_service_name)');

    $status = $oidset->contains(gss_nt_user_name, $isin);
    ok($status);
    ok($isin, '$oidset->contains(gss_nt_user_name, $isin)');
    $status = $oidset->contains(gss_nt_exported_name, $isin);
    ok($status, '$oidset->contains(gss_nt_exported_name, $isin)');
    ok(! $isin, '! $isin');

eval {
	$status = gss_mech_set_krb5->insert(gss_nt_user_name);
};
ok( $@ =~ /is not alterable/,
    'gss_mech_set_krb5->insert(gss_nt_user_name); is not alterable' );

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
    ok($status, 'GSSAPI::Cred::acquire_cred');
    ok(ref $cred1 eq "GSSAPI::Cred");
    ok(ref $oidset eq "GSSAPI::OID::Set");

    my($lifetime, $cred_usage);
    $status = $cred1->inquire_cred($name, $lifetime, $cred_usage, $oidset);



    ok( $status, '$cred1->inquire_cred($name, $lifetime, $cred_usage, $oidset' );

    ok(ref $oidset eq "GSSAPI::OID::Set");
    ok($cred_usage & GSS_C_INITIATE);

SKIP: {
   if (GSSAPI::gssapi_implementation_is_heimdal() ) {
      skip(q{"$time == $lifetime" test fails on Heimdal, I don't know if that is a problem}, 1);
   }
   # 2006-04-06
   # I don't know what is the meaning of the fail on Hemidal
   # If you know - pleas send Email to perl@grolmnsnet.de
   # Thank you!
   #
   #
   ok($time == $lifetime, '$time == $lifetime');
}

#--------------------------------------------------------
{
   my ($name, $display);
   my $keystring = 'chpasswd@mars.gac.edu';
   my $status = GSSAPI::Name->import($name, $keystring);
   $status = $name->display($display);
   ok ($keystring eq $display, 'check bugfix of <http://rt.cpan.org/Public/Bug/Display.html?id=5681>');
}
#--------------------------------------------------------
print "\n\n if you want to run tests that do a realworld *use* of your GSSAPI";
print "\n start a kinit and try to run";
print "\n./examples/getcred_hostbased.pl \n\n";

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