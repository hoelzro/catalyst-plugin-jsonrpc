package TestApp::Controller::JSON;

use strict;
use base 'Catalyst::Controller';

sub begin : Private {
    my ( $self, $c ) = @_;
    $c->res->header( 'X-Test-Class' => ref($self) );
}

sub rpc : Global {
    my ( $self, $c ) = @_;
    $c->json_rpc;
}

sub echo : Remote {
    my ( $self, $c, @args ) = @_;
    return join ' ', @args;
}

sub add : Remote {
    my ( $self, $c, $a, $b) = @_;
    return $a + $b;
}

sub inform : Remote {
    my ( $self, $c ) = @_;
    # no op!
}

sub subtract : Remote {
    my ( $self, $c, %params ) = @_;

    return $params{minuend} - $params{subtrahend};
}

sub tunnels : Remote {
    my ( $self, $c ) = @_;

    return [qw/tom dick harry/];
}

sub fail : Remote {
    my ( $self, $c ) = @_;

    die "fail";
}

1;
