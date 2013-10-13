use strict;
use warnings;

package Path::IsDev::Role::HeuristicSet;
BEGIN {
  $Path::IsDev::Role::HeuristicSet::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::HeuristicSet::VERSION = '1.000000';
}

# ABSTRACT: Role for sets of Heuristics.


sub _use_module { require Module::Runtime; goto &Module::Runtime::use_module }
sub _com_mn     { require Module::Runtime; goto &Module::Runtime::compose_module_name; }
sub _debug      { require Path::IsDev;     goto &Path::IsDev::debug }

use Role::Tiny;

requires 'modules';

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

Path::IsDev::Role::HeuristicSet - Role for sets of Heuristics.

=head1 VERSION

version 1.000000

=head1 METHODS

=head2 C<matches>

Determine if the C<HeuristicSet> contains a match.

    if( $hs->matches( $result_object ) ) {
        # one of hs->modules() matched $result_object->path
    }

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::HeuristicSet",
    "interface":"role"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
