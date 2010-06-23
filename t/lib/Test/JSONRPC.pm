package Test::JSONRPC;

use strict;
use warnings;
use parent 'Exporter';

use Catalyst::Test 'TestApp';
use JSON ();
use Test::More;

our @EXPORT = qw(null jsonrpc_test);

*null = \&JSON::null;

my $entrypoint = 'http://localhost/rpc';

sub jsonrpc_test {
    my ( $input, $expected_code, $expected ) = @_;

    my $content;

    if(ref($input) eq 'SCALAR') {
        $content = $$input;
    } else {
        $content = JSON::to_json($input);
    }
    my $request = HTTP::Request->new( POST => $entrypoint );
    $request->header( 'Content-Length' => length($content) );
    $request->header( 'Content-Type' => 'application/json' );
    $request->content($content);

    my $response = request($request);

    if(ref($expected) eq 'CODE') {
        my ( $g, $e) = $expected->($response);
        is($g, $e);
    } else {
        ok($response);
        is($response->code, $expected_code);
        $response = JSON::from_json($response->content);
        if(ref($response) eq 'HASH') {
            if(exists $response->{error}) {
                # data is implementation-dependent!
                delete $response->{error}{data};
            }
        } else {
            foreach my $member (@$response) {
                if(ref($member) eq 'HASH' && exists $member->{error}) {
                    # data is implementation-dependent!
                    delete $member->{error}{data};
                }
            }
        }
        is_deeply($response, $expected);
    }
}

1;
