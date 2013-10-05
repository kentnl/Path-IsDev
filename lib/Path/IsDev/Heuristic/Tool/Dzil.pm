use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::Dzil;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::Dzil",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic::AnyFile"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is a Dist::Zilla Source tree

use Role::Tiny::With;

with 'Path::IsDev::Role::Heuristic::AnyFile';

=method C<files>

Files relevant to this heuristic:

    dist.ini

=cut

sub files { return qw( dist.ini ) }

1;

