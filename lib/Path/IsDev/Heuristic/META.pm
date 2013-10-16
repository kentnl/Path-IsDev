use strict;
use warnings;

package Path::IsDev::Heuristic::META;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::META",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path contains META.(json|yml)

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';

=method C<files>

files relevant to this heuristic:

    META.json
    META.yml

=cut

sub files {
  return qw( META.json META.yml );
}

=method C<matches>

Matches if any of the files in C<files> exist as children of the C<path>

=cut

sub matches {
  my ( $self, $result_object ) = @_;
  if ( $self->child_exists_any_file( $result_object, $self->files ) ) {
    $result_object->result(1);
    return 1;
  }
  return;
}

1;

