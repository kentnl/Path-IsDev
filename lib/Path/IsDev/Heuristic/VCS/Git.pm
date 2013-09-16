use strict;
use warnings;

package Path::IsDev::Heuristic::VCS::Git;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::VCS::Git",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path contains a C<.git> repository

use parent 'Path::IsDev::Heuristic';

=method C<dirs>

Directories relevant to this heuristic:

    .git

=cut

sub dirs  { return qw( .git ) }

1;

