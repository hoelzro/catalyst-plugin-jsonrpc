use strict;
use warnings;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More tests => 34;
use Test::JSONRPC qw(null jsonrpc_test);

my $id = 0;

jsonrpc_test(\'{id: 1', 500, {
    jsonrpc => '2.0',
    error => {
        code => -32700,
        message => 'Parse error.',
    },
});

jsonrpc_test({
    id => ++$id,
    method => 'echo',
    params => ['hello'],
}, 400, {
    jsonrpc => '2.0',
    id => $id,
    error => {
        code => -32600,
        message => 'Invalid Request.',
    },
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    params => ['hello'],
}, 404, {
    jsonrpc => '2.0',
    id => $id,
    error => {
        code => -32601,
        message => 'Method not found.',
    },
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'add',
    params => [2, 3],
}, 200, {
    jsonrpc => '2.0',
    id => $id,
    result => 5,
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'echo',
    params => ['hello'],
}, 200, {
    jsonrpc => '2.0',
    id => $id,
    result => 'hello',
});

jsonrpc_test({
    jsonrpc => '2.0',
    method => 'inform',
    params => ['hello'],
}, 204, sub {
    my ( $req ) = @_;

    return $req->code, 204;
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'subtract',
    params => {
        minuend => 20,
        subtrahend => 10,
    },
}, 200, {
    jsonrpc => '2.0',
    id => $id,
    result => 10,
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'tunnels',
}, 200, {
    jsonrpc => '2.0',
    id => $id,
    result => [qw/tom dick harry/],
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'fail',
}, 500, {
    jsonrpc => '2.0',
    id => $id,
    error => {
        code => -32603,
        message => 'Internal error.',
    },
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'no_method_like_this',
}, 404, {
    jsonrpc => '2.0',
    id => $id,
    error => {
        code => -32601,
        message => 'Method not found.',
    },
});

jsonrpc_test({
    jsonrpc => '2.0',
    id => ++$id,
    method => 'add',
    params => 'bad params',
}, 500, {
    jsonrpc => '2.0',
    id => $id,
    error => {
        code => -32602,
        message => 'Invalid params.',
    },
});

my $first = ++$id;
my $second = ++$id;
my $third = ++$id;
my $fourth = ++$id;

jsonrpc_test([{
    jsonrpc => '2.0',
    id => $first,
    method => 'add',
    params => [10, 20],
}, {
    jsonrpc => '2.0',
    id => $second,
    method => 'subtract',
    params => {
        minuend => 100,
        subtrahend => 30,
    },
}, {
    jsonrpc => '2.0',
    id => $third,
    method => 'tunnels',
}, {
    jsonrpc => '2.0',
    id => $fourth,
    method => 'fail',
}], 200, [{
    jsonrpc => '2.0',
    id => $first,
    result => 30,
}, {
    jsonrpc => '2.0',
    id => $second,
    result => 70,
}, {
    jsonrpc => '2.0',
    id => $third,
    result => [qw/tom dick harry/],
}, {
    jsonrpc => '2.0',
    id => $fourth,
    error => {
        code => -32603,
        message => 'Internal error.',
    },
}]);
