use strict;
use warnings;

package Path::IsDev::Heuristic::META;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::META",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic::AnyFile"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path contains META.(json|yml)

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic::AnyFile';

=method C<files>

files relevant to this heuristic:

    META.json
    META.yml

=cut

sub files { return qw( META.json META.yml ) }

1;

