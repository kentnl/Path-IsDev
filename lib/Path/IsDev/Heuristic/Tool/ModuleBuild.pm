use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::ModuleBuild;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::ModuleBuild",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is a Module::Build Source tree

use parent 'Path::IsDev::Heuristic';

=method C<files>

Files relevant to this heuristic:

    Build.PL

=cut

sub files { return qw( Build.PL ) }

1;

