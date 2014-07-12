use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Heuristic::VCS::Git;

our $VERSION = '1.001001';

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::VCS::Git",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::Dir"
    ]
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path contains a .git repository

# AUTHORITY

use Role::Tiny::With qw( with );

with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::Dir';

=method C<dirs>

Directories relevant to this heuristic:

    .git

=cut

sub dirs { return qw( .git ) }

=method C<matches>

Return a match if any children of C<path> exist called C<.git> and are directories

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

