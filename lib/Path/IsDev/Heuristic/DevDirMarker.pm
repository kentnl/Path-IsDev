use strict;
use warnings;

package Path::IsDev::Heuristic::DevDirMarker;

# ABSTRACT: Determine if a path contains a .devdir file

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::Heuristic';

sub files { return qw( .devdir ) }

1;

