use strict;
use warnings;

package Path::IsDev::Heuristic::META;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::META",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut


# ABSTRACT: Determine if a path contains META.(json|yml)

use parent 'Path::IsDev::Heuristic';

sub files { return qw( META.json META.yml ) }

1;

