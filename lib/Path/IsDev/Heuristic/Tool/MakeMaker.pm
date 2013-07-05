use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::MakeMaker;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::MakeMaker",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is an EUMM Tooled source dir

use parent 'Path::IsDev::Heuristic';

sub files { return qw( Makefile.PL ) }

1;
