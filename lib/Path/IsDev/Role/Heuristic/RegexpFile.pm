use strict;
use warnings;

package Path::IsDev::Role::Heuristic::RegexpFile;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::RegexpFile",
    "interface":"role",
    "does":"Path::IsDev::Role::Heuristic"
}

=end MetaPOD::JSON

=cut

sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny;

sub _matches_basename_regexp {
  my ( $self, $result_object ) = @_;
  my $regexp = $self->basename_regexp;
  for my $child ( $result_object->path->children ) {
    next unless -f $child;
    if ( $child->basename =~ $regexp ) {
      _debug("$child matches expression for $self");
      $result_object->add_reason( $self, 1, { 'child_basename_matches_expression?' => $child } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'child_basename_matches_expression?' => $child } );
  }
  $result_object->result(undef);
  return;
}

sub matches {
  my ( $self, $result_object ) = @_;
  return $self->_matches_basename_regexp($result_object);
}

with 'Path::IsDev::Role::Heuristic';
requires 'basename_regexp';

1;
