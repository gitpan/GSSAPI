use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

open(MANIFEST, "MANIFEST")	or die "$0: Unable to open MANIFEST: $!";
$otherxs = join " ",
		map { substr($_, 0, -1) }
		grep { m:^xs/: }
		<MANIFEST>;
close(MANIFEST);
		


WriteMakefile(
    'NAME'		=> 'GSSAPI',
    'VERSION_FROM'	=> 'GSSAPI.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    'LIBS'		=> ['-L/usr/local/lib -lgssapi_krb5'], # e.g., '-lm'
    'DEFINE'		=> '', # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '', # e.g., '-I/usr/include/other'
    'macro'		=> { OTHER_XS => $otherxs },
    'depend'		=> { 'GSSAPI.c' => '$(OTHER_XS)' },
);

