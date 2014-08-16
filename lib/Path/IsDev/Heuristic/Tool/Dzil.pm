use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Heuristic::Tool::Dzil;

our $VERSION = '1.001003';

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::Dzil",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is a Dist::Zilla Source tree

# AUTHORITY

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';

=method C<files>

Files relevant to this heuristic:

    dist.ini

=cut

sub files { return qw( dist.ini ) }

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

