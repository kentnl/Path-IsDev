
use strict;
use warnings;

package Path::IsDev::HeuristicSet;
BEGIN {
  $Path::IsDev::HeuristicSet::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::HeuristicSet::VERSION = '0.6.0';
}

# ABSTRACT: Base class for sets of heuristics



sub _croak      { require Carp;            goto &Carp::croak }
sub _debug      { require Path::IsDev;     goto &Path::IsDev::debug }

use Role::Tiny::With;
with 'Path::IsDev::Role::HeuristicSet';


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

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::HeuristicSet - Base class for sets of heuristics

=head1 VERSION

version 0.6.0

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

=head1 METHODS

=head2 C<modules>

Returns the list of fully qualified module names that comprise this heuristic.

Default implementation expands results from C<< ->heuristics >>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet",
    "interface":"single_class",
    "does":"Path::IsDev::Role::HeuristicSet"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
