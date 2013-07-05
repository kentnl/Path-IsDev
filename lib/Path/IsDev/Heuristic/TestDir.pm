use strict;
use warnings;

package Path::IsDev::Heuristic::TestDir;

# ABSTRACT: Determine if a path contains a t/ or xt/ dir

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::Heuristic';

sub dirs { return qw( t xt ) }

1;

