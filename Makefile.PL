use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'Catalyst::Plugin::JSONRPC',
    'VERSION_FROM' => 'lib/Catalyst/Plugin/JSONRPC.pm', # finds $VERSION
    'PREREQ_PM' => {
	Test::More => 0.32,
        JSON => 2.00,
        Catalyst => 5.60,
    },
);
