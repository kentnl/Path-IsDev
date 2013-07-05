use strict;
use warnings;

package Path::IsDev::Heuristic::Changelog;

# ABSTRACT: Determine if a path contains a Changelog (or similar)

=head1 DESCRIPTION

This hueristic matches any case variation of "Changes" or "Changelog",
including any files of that name with a suffix.

ie:

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

sub matches {
  my ( $self, $path ) = @_;
  for my $child ( _path($path)->children ) {
    next unless -f $child;
    return 1 if $child->basename =~ /^Change(s|log)(|[.][^.]+)/i;
  }
  return;
}

1;

