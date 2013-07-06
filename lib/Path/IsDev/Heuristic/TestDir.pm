use strict;
use warnings;

package Path::IsDev::Heuristic::TestDir;

# ABSTRACT: Determine if a path contains a t/ or xt/ directory

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::Heuristic';

=method C<dirs>

Directories relevant to this heuristic:

    t/
    xt/

=cut

sub dirs { return qw( t xt ) }

1;

