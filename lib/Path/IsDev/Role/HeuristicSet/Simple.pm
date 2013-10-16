
use strict;
use warnings;

package Path::IsDev::Role::HeuristicSet::Simple;

# ABSTRACT: Simple excludes/includes set

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::HeuristicSet::Simple",
    "interface":"role",
    "does":"Path::IsDev::Role::HeuristicSet"
}

=end MetaPOD::JSON

=requires C<heuristics>

Consuming classes must provide this method,
and return a list of shorthand Heuristics.

    sub heuristics {
        return qw( MYMETA )
    }

=cut

=requires C<negative_heuristics>

Consuming classes must provide this method,
and return a list of shorthand Negative Heuristics.

    sub negative_heuristics {
        return qw( IsDev::IgnoreFile )
    }

=cut

use Role::Tiny;

with 'Path::IsDev::Role::HeuristicSet';
requires 'heuristics', 'negative_heuristics';

=method C<modules>

Returns the list of fully qualified module names that comprise this heuristic.

expands results from C<< ->heuristics >> and C<< ->negative_heuristics >>,
with negative ones preceding positive.

=cut

sub modules {
  my ($self) = @_;
  my @out;
  for my $heur ( $self->negative_heuristics ) {
    push @out, $self->_expand_negative_heuristic($heur);
  }
  for my $heur ( $self->heuristics ) {
    push @out, $self->_expand_heuristic($heur);
  }
  return @out;
}

1;
