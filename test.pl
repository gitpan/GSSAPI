# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..52\n"; }
END {print "not ok 1\n" unless $loaded;}
use GSSAPI;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

use strict;

my $test = 1;

sub check {
    my $bool = shift;
    $test++;
    print +($bool ? "" : "not "), "ok $test\n";
}

sub rand_string {
    my($length, $buf);
    $length = int(rand(64));
    $buf = '';
    foreach (1..$length) {
	$buf .= chr(rand(0xFF));
    }
    $buf
}

sub rand_oid_str {
    my($buf, $c);
    $c = int(rand(255));
    $buf = sprintf("{ %d %d ", int($c/40), int($c % 40));
    foreach (0 .. int(rand(10))+1) {
	$buf .= int(rand(0x7fffe)) . " ";
    }
    $buf . "}"
}

my($okay);

#
#	GSSAPI::Status
#

    check(GSSAPI::Status::GSS_ERROR(GSS_S_COMPLETE) == 0);
    check(GSSAPI::Status::GSS_ERROR(GSS_S_BAD_SIG) == 1);

# try success
    my $status = GSSAPI::Status->new(GSS_S_COMPLETE, 0);

    check(ref $status eq "GSSAPI::Status");

    check($status->major == GSS_S_COMPLETE);
    check($status->minor == 0);
    check($status);

# try failure
    $status = GSSAPI::Status->new(GSS_S_BAD_SIG, 10);
    check($status->major == GSS_S_BAD_SIG);
    check($status->minor == 10);
    check(! $status);

    my @string;
    check(@string = $status->generic_message());
#    print STDERR "Generic Success:\n", join("\n", @string), "\n\n";

    check(@string = $status->specific_message());
#    print STDERR "Specific Success:\n", join("\n", @string), "\n";

#    print STDERR "$status\n";

# try random values
    $okay = 1;
    foreach (1 .. 1000) {
	my($maj, $min);
	$maj = int(rand(0xffffffff));
	$min = int(rand(0xffffffff));

	$status = GSSAPI::Status->new($maj, $min);

	$status->major == $maj && $status->minor == $min
			or $okay = 0, last;
    }
    check($okay);


#
#	GSSAPI::Name
#

    my($name, $name2, $same, $export, $display, $type);

    $status = GSSAPI::Name->import($name, 'chpasswd@mars.gac.edu');
    check($status);
    check(ref $name eq "GSSAPI::Name");

    $type = GSSAPI::OID->new;
    check(ref $type eq "GSSAPI::OID");

    $status = $name->display($display, $type);
    check($status);

#    print STDERR $display, "\n";

    if ($type->is_valid) {
	$status = $type->to_str($display);
	check(defined $status == defined $display);
    } else {
	check(1);
    }

#    if (defined $display) {
#	print STDERR $display, "\n"
#    }

    $name2 = GSSAPI::Name->new;
    check(ref $name eq "GSSAPI::Name");

    # It would be nice to check a failed import, but I'm not sure
    # what would reliably fail.  Oh well
    #$status = GSSAPI::Name->import($name2, 'blahblahblah@foo.gac.edu@djksd');
    #check(! $status);

    $status = $name->duplicate($name2);
    check($status);

    $status = $name->compare($name2, $same);
    check($status);
    check($same);

    eval {
	$status = $name->compare($name2, 0);
    };
    check( $@ =~ /Modification of a read-only value/ );

#
#	GSSAPI::OID
#
    my($oid, $str, $str2);

    $okay = 1;
    foreach ( 1 .. 1000 ) {
	$str = rand_oid_str;
	$oid = ($_ % 2) ? undef : GSSAPI::OID->new;
	$status = GSSAPI::OID->from_str($oid, $str);
	!! $status					&&
	ref $oid eq "GSSAPI::OID"			or $okay = 0, last;
	$status = $oid->to_str($str2);
	!! $status					or $okay = 0, last;
 	$str eq $str2					or $okay = 0, last;
    }
    check($okay);

    $oid = gss_nt_user_name;
    $status = $oid->to_str($str);
    check($status);
    check($str eq "{ 1 2 840 113554 1 2 1 1 }");

    { my(@oidss); foreach(1..1000) { push @oidss, GSSAPI::OID::Set->new() };
    }
    my($oidset);

    $status = gss_mech_krb5->inquire_names($oidset);
    check(ref $status eq "GSSAPI::Status");
    check($status);
    undef $oidset;

#
#	GSSAPI::OID::Set
#
    my($isin);

    $oidset = GSSAPI::OID::Set->new();
    check(ref $oidset eq "GSSAPI::OID::Set");
    $status = $oidset->insert(gss_nt_user_name);
    check($status);
    $status = $oidset->insert(gss_nt_service_name);
    check($status);

    $status = $oidset->contains(gss_nt_user_name, $isin);
    check($status);
    check($isin);
    $status = $oidset->contains(gss_nt_exported_name, $isin);
    check($status);
    check(! $isin);

    eval {
	$status = gss_mech_set_krb5->insert(gss_nt_user_name);
    };
    check( $@ =~ /is not alterable/ );

#
#	GSSAPI::Binding
#
    my($binding);

    $binding = GSSAPI::Binding->new();
    check(ref $binding eq "GSSAPI::Binding");;
    check($binding->get_initiator_addrtype == GSS_C_AF_NULLADDR);
    check(! defined $binding->get_initiator_address);
    check($binding->get_acceptor_addrtype  == GSS_C_AF_NULLADDR);
    check(! defined $binding->get_acceptor_address);
    check(! defined $binding->get_appl_data);

    $okay = 1;
    foreach (1 .. 1000) {
	$binding = GSSAPI::Binding->new();
	ref $binding eq "GSSAPI::Binding"		or $okay = 0, last;
    }
    check($okay);

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
    check($okay);

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
    check($okay);


#
#	GSSAPI::Cred
#

    my($cred1, $time);

    $status = GSSAPI::Cred::acquire_cred(undef, 120, undef, GSS_C_INITIATE,
				$cred1, $oidset, $time);
    check($status);
    check(ref $cred1 eq "GSSAPI::Cred");
    check(ref $oidset eq "GSSAPI::OID::Set");

    my($lifetime, $cred_usage);
    $status = $cred1->inquire_cred($name, $lifetime, $cred_usage, $oidset);
    check($status);
    check(ref $oidset eq "GSSAPI::OID::Set");
    check($cred_usage & GSS_C_INITIATE);
    check($time == $lifetime);

#
#	GSSAPI::Context
#

    my($context);

    print "foo\n";
