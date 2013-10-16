use strict;
use warnings;

package Path::IsDev::Heuristic::TestDir;

# ABSTRACT: Determine if a path contains a t/ or xt/ directory

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::Dir"
    ]
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With;

with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::Dir';

=method C<dirs>

Directories relevant to this heuristic:

    t/
    xt/

=cut

sub dirs {
  return qw( xt t );
}

=method C<matches>

    if ( $heuristic->matches( $result_object ) ) {
        # one of the directories in ->dirs exists
    }

=cut

sub matches {
  my ( $self, $result_object ) = @_;
  if ( $self->child_exists_any_dir( $result_object, $self->dirs ) ) {
    $result_object->result(1);
    return 1;
  }
  return;
}

1;

