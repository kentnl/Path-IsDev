
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

sub _compose_module_name {
  require Module::Runtime;
  goto &Module::Runtime::compose_module_name;
}

sub _expand_heuristic {
  my ( $self, $hn ) = @_;
  return _compose_module_name( 'Path::IsDev::Heuristic', $hn );
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
  for my $heur ( $self->heuristics ) {
    push @out, $self->_expand_heuristic($heur);
  }
  return @out;
}

sub _modules_loaded {
  my ($self) = @_;
  return map { $self->_load_module($_) } $self->modules;
}

1;
