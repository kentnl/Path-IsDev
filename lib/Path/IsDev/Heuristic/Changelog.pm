use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Heuristic::Changelog;

# ABSTRACT: Determine if a path contains a Changelog (or similar)

# AUTHORITY

=head1 DESCRIPTION

This heuristic matches any case variation of C<Changes> or C<Changelog>,
including any files of that name with a suffix.

e.g.:

    Changes
    CHANGES
    Changes.mkdn

etc.

=cut

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Changelog",
    "interface":"single_class",
    "does":[ "Path::IsDev::Role::Heuristic", "Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File" ]
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File';

=method C<basename_regexp>

Indicators for this heuristic is the existence of a file such as:

    Changes             (i)
    Changes.anyext      (i)
    Changelog           (i)
    Changelog.anyext    (i)

=cut

sub basename_regexp {
  return qr/\AChange(s|log)(|[.][^.\s]+)\z/isxm;
}

=method C<matches>

Returns a match if any child of C<path> exists matching the regexp C<basename_regexp>

=cut

sub matches {
  my ( $self, $result_object ) = @_;
  if ( $self->child_basename_matchregexp_file( $result_object, $self->basename_regexp ) ) {
    $result_object->result(1);
    return 1;
  }
  return;
}

1;

