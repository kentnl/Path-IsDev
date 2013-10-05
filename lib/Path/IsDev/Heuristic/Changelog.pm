use strict;
use warnings;

package Path::IsDev::Heuristic::Changelog;

# ABSTRACT: Determine if a path contains a C<Changelog> (or similar)

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
    "does":"Path::IsDev::Role::Heuristic::RegexpFile"
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic::RegexpFile';

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

1;

