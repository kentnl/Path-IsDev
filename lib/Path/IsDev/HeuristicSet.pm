
use strict;
use warnings;

package Path::IsDev::HeuristicSet;
BEGIN {
  $Path::IsDev::HeuristicSet::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::HeuristicSet::VERSION = '0.5.1';
}

# ABSTRACT: Base class for sets of heuristics



sub _croak      { require Carp;            goto &Carp::croak }
sub _use_module { require Module::Runtime; goto &Module::Runtime::use_module }
sub _debug      { require Path::IsDev;     goto &Path::IsDev::debug }
sub _com_mn     { require Module::Runtime; goto &Module::Runtime::compose_module_name; }

sub _expand_heuristic {
  my ( $self, $hn ) = @_;
  return _com_mn( 'Path::IsDev::Heuristic', $hn );
}

sub _expand_negative_heuristic {
  my ( $self, $hn ) = @_;
  return _com_mn( 'Path::IsDev::NegativeHeuristic', $hn );
}

sub _load_module {
  my ( $self, $module ) = @_;
  return _use_module($module);
}


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


sub matches {
  my ( $self, $result_object ) = @_;
TESTS: for my $module ( $self->modules ) {
    $self->_load_module($module);
    if ( $module->can('excludes') ) {
      if ( $module->excludes($result_object) ) {
        _debug( $module->name . q[ excludes path ] . $result_object->path );
        return;
      }
      next TESTS;
    }
    next unless $module->matches($result_object);
    my $name = $module->name;
    _debug( $name . q[ matched path ] . $result_object->path );
    return 1;
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::HeuristicSet - Base class for sets of heuristics

=head1 VERSION

version 0.5.1

=head1 SYNOPSIS

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

=head2 C<matches>

Determine if the C<HeuristicSet> contains a match.

    if( $hs->matches( $result_object ) ) {
        # one of hs->modules() matched $result_object->path
    }

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet",
    "interface":"single_class"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
