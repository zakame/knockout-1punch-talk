#!/usr/bin/env perl

use DirHandle;
use Encode;
use Mojolicious::Lite;

plugin 'PODRenderer';

my $dh = DirHandle->new('img');
my @children;
while ( defined( my $ent = $dh->read ) ) {
    next if $ent eq '.' or $ent eq '..';
    next if $ent !~ /(png|jpg|gif)$/;
    push @children, join '/' => 'img', Encode::decode_utf8($ent);
}

push @{ app->static->paths }, '.';

get '/' => sub { shift->redirect_to('/1punch.html') };

get '/all' => sub {
    my $self = shift;
    $self->render( json => [@children] );
};

any '/search' => sub {
    my $self = shift;
    my @terms = split / / => $self->param('words');

    my @res;
    for my $term (@terms) {
        push @res, grep {/$term/} @children;
    }

    $self->render( json => [@res] );
};

any '/random' => sub {
    my $self = shift;
    $self->render( json => [ $children[ int rand @children ] ] );
};

app->start;
