#!/usr/bin/env perl
use Mojolicious::Lite;

plugin 'PODRenderer';

my @children;
app->home->child('img')->list->grep( sub {/(png|jpg|gif)$/} )
    ->each( sub { push @children, $_->to_rel( app->home ) } );

push @{ app->static->paths }, '.';

get '/' => sub { shift->redirect_to('/1punch.html') };

get '/all' => sub {
    my $self = shift;
    $self->render( json => [@children] );
};

any '/search' => sub {
    my $self = shift;
    return $self->render( json => [] ) unless $self->param('words');
    my @terms = split /\s+/ => $self->param('words');

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
