use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Heuristic::DevDirMarker;

our $VERSION = '1.001004';

# ABSTRACT: Determine if a path contains a .devdir file

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::DevDirMarker",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';

=method C<files>

Matches files named:

    .devdir

=cut

sub files {
  return qw( .devdir );
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

=head1 DESCRIPTION

This Heuristic is a workaround that is likely viable in the event none of the other Heuristics work.

All this heuristic checks for is the presence of a special file called C<.devdir>, which is intended as an explicit notation that
"This directory is a project root".

An example case where you might need such a Heuristic, is the scenario where you're not working with a Perl C<CPAN> dist, but are
instead working on a project in a different language, where Perl is simply there for build/test purposes.

=cut
