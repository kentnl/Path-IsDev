use strict;
use warnings;

package Path::IsDev::Result;

# ABSTRACT: Result container

use Class::Tiny 'path', 'result', {
  reasons => sub { [] }
};
sub _path { require Path::Tiny; goto &Path::Tiny::path }

sub BUILD {
  my ( $self, $args ) = @_;
  if ( not $self->path ) {
    die "<path> is a mandatory parameter";
  }
  if ( not ref $self->path ) {
    $self->path( _path( $self->path ) );
  }
  if ( not -e $self->path ) {
    die "<path> parameter must exist for heuristics to be performed";
  }
}
my %type_map = (
  'Path::IsDev::Heuristic'         => 'positive heuristic',
  'Path::IsDev::NegativeHeuristic' => 'negative heuristic',
);

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
}

1;
