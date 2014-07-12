use 5.008;    # utf8;
use strict;
use warnings;
use utf8;

package Path::IsDev::Role::HeuristicSet;

our $VERSION = '1.001001';

# ABSTRACT: Role for sets of Heuristics.

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::HeuristicSet",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

sub _use_module { require Module::Runtime; goto &Module::Runtime::use_module }
sub _com_mn     { require Module::Runtime; goto &Module::Runtime::compose_module_name; }
## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny qw( requires );

=requires C<modules>

Please provide a method that returns a list of modules that comprise heuristics.

=cut

requires 'modules';

sub _expand_heuristic {
  my ( undef, $hn ) = @_;
  return _com_mn( 'Path::IsDev::Heuristic', $hn );
}

sub _expand_negative_heuristic {
  my ( undef, $hn ) = @_;
  return _com_mn( 'Path::IsDev::NegativeHeuristic', $hn );
}

sub _load_module {
  my ( undef, $module ) = @_;
  return _use_module($module);
}

=method C<matches>

Determine if the C<HeuristicSet> contains a match.

    if( $hs->matches( $result_object ) ) {
        # one of hs->modules() matched $result_object->path
    }

=cut

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
