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
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::Heuristic';
sub _path { require Path::Tiny; goto &Path::Tiny::path }

=method C<matches>

Indicators for this heuristic is the existence of a file such as:

    Changes             (i)
    Changes.anyext      (i)
    Changelog           (i)
    Changelog.anyext    (i)

=cut

sub matches {
  my ( $self, $path ) = @_;
  for my $child ( _path($path)->children ) {
    next unless -f $child;
    return 1 if $child->basename =~ /\AChange(s|log)(|[.][^.\s]+)\z/isxm;
  }
  return;
}

1;

