use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::Dzil;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::Dzil",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is a Dist::Zilla Source tree

use parent 'Path::IsDev::Heuristic';

=method C<files>

Files relevant to this heuristic:

    dist.ini

=cut

sub files { return qw( dist.ini ) }

1;

