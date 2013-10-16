use strict;
use warnings;

package Path::IsDev::Result;

# ABSTRACT: Result container

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Result",
    "interface":"class",
    "inherits":"Class::Tiny::Object"
}

=end MetaPOD::JSON

=head1 SYNOPSIS

    use Path::IsDev::Result;

    my $result = Path::IsDev::Result->new( path => '/some/path/that/exists' ):

    if ( $heuristcset->matches( $result ) ) {
        print Dumper($result);
    }

=cut

=head1 DESCRIPTION

This is a reasonably new internal component for Path::IsDev.

Its purpose is to communicate state between internal things, and give some sort of introspectable
context for why things happened in various places without resorting to spamming debug everywhere.

Now instead of turning on debug, as long as you can get a result, you can inspect and dump that result
at the point you need it.

=cut

=attr C<path>

=attr C<result>

=attr C<reasons>

=cut

use Class::Tiny 'path', 'result', {
  reasons => sub { [] }
};

sub _path  { require Path::Tiny;  goto &Path::Tiny::path }
sub _croak { require Carp;        goto &Carp::croak }
sub _debug { require Path::IsDev; shift; goto &Path::IsDev::debug }

=method C<BUILD>

=cut

sub BUILD {
  my ( $self, $args ) = @_;
  if ( not $self->path ) {
    return _croak(q[<path> is a mandatory parameter]);
  }
  if ( not ref $self->path ) {
    $self->path( _path( $self->path ) );
  }
  if ( not -e $self->path ) {
    return _croak(q[<path> parameter must exist for heuristics to be performed]);
  }
}
my %type_map = (
  'Path::IsDev::Heuristic'         => 'positive heuristic',
  'Path::IsDev::NegativeHeuristic' => 'negative heuristic',
);

=method C<add_reason>

Call this method from a heuristic to record checking of the heuristic
and the relevant meta-data.

    $result->add_reason( $heuristic, $matchvalue, \%contextinfo );

=cut

sub add_reason {
  my ( $self, $heuristic_name, $heuristic_result, $context ) = @_;
  $context ||= {};
  $context->{heuristic} = $heuristic_name;
  $context->{result}    = $heuristic_result;

  for my $type ( sort keys %type_map ) {
    if ( $heuristic_name->isa($type) ) {
      $context->{type} = $type_map{$type};
    }
  }
  push @{ $self->reasons }, $context;
  return $self;
}

1;
