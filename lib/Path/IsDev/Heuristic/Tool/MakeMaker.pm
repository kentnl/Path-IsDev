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

# ABSTRACT: Determine if a path is an C<EUMM> Tooled source directory

use parent 'Path::IsDev::Heuristic';

=method C<files>

Files relevant to this heuristic:

    Makefile.PL

=cut

sub files { return qw( Makefile.PL ) }

1;
