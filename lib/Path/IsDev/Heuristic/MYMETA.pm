use strict;
use warnings;

package Path::IsDev::Heuristic::MYMETA;

# ABSTRACT: Determine if a path contains MYMETA.(json|yml)

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::MYMETA",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}

=end MetaPOD::JSON

=cut

=head1 DESCRIPTION

This heuristic is intended as a guarantee that B<SOME> kind of top level marker will
be present in a distribution, as all the main tool-chains emit this file during C<configure>.

Granted, this heuristic is expected to be B<never> needed, as in order to create such a file, you first need a C<Build.PL>/C<Makefile.PL> to generate it.

=cut

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';

=method C<files>

Files relevant to this heuristic

    MYMETA.json
    MYMETA.yml

=cut

sub files {
  return qw( MYMETA.json MYMETA.yml );
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

