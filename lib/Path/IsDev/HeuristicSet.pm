
use strict;
use warnings;

package Path::IsDev::HeuristicSet;

# ABSTRACT: Base class for sets of heuristics

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet",
    "interface":"single_class"
}

=end MetaPOD::JSON

=cut

sub _croak      { require Carp;            goto &Carp::croak }
sub _use_module { require Module::Runtime; goto &Module::Runtime::use_module }
sub _debug      { require Path::IsDev;     goto &Path::IsDev::debug }
sub _com_mn     { require Module::Runtime; goto &Module::Runtime::compose_module_name; }

sub _expand_heuristic {
  my ( $self, $hn ) = @_;
  return _com_mn( 'Path::IsDev::Heuristic', $hn );
}

sub _load_module {
  my ( $self, $module ) = @_;
  return _use_module($module);
}

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
  for my $heur ( $self->heuristics ) {
    push @out, $self->_expand_heuristic($heur);
  }
  return @out;
}

=method C<matches>

Determine if the C<HeuristicSet> contains a match.

    if( $hs->matches($path) ) {
        # one of hs->modules() matched $path
    }

=cut

sub matches {
  my ( $self, $path ) = @_;
  for my $module ( $self->modules ) {
    $self->_load_module($module);
    next unless $module->matches($path);
    my $name = $module->name;
    _debug( $name . q[ matched path ] . $path );
    return 1;
  }
  return;
}

1;
