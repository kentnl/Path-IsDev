
use strict;
use warnings;

package Path::IsDev::HeuristicSet;

# ABSTRACT: Base class for sets of heuristics

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet",
    "interface":"single_class",
    "does":"Path::IsDev::Role::HeuristicSet"
}

=end MetaPOD::JSON

=cut

=head1 SYNOPSIS

This class exists now for compatibility reasons.

You should instead C<with> a C<::Role::HeuristicSet>*

    package Path::IsDev::HeuristicSet::Author::KENTNL;

    use parent 'Path::IsDev::HeuristicSet';

    sub heuristics {
        return 'META', 'VSC::Git'
    }

    sub negative_heuristics {
        return 'IsDev::IgnoreFile'
    }

Or alternatively:

    sub modules {
        return ( 'Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile', 'Path::IsDev::Heuristic::META', 'Path::IsDev::Heuristic::VCS::Git', )
    }

And the real work is done by:

    Path::IsDev::HeuristicSet::Author::KENTNL->matches( $result_object );

=cut

sub _croak      { require Carp;            goto &Carp::croak }
sub _debug      { require Path::IsDev;     goto &Path::IsDev::debug }

use Role::Tiny::With;
with 'Path::IsDev::Role::HeuristicSet';

=method C<modules>

Returns the list of fully qualified module names that comprise this heuristic.

Default implementation expands results from C<< ->heuristics >>

=cut

sub modules {
  my ($self) = @_;
  if ( not $self->can('heuristics') ) {
    return _croak("set $self failed to declare one of: modules, heuristics");
  }
  my @out;
  if ( $self->can('negative_heuristics') ) {
    for my $heur ( $self->negative_heuristics ) {
      push @out, $self->_expand_negative_heuristic($heur);
    }
  }
  for my $heur ( $self->heuristics ) {
    push @out, $self->_expand_heuristic($heur);
  }
  return @out;
}



1;
