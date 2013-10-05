use strict;
use warnings;

package Path::IsDev::Heuristic::Makefile;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Makefile",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic::AnyFile"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path contains a C<Makefile>

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic::AnyFile';

=method C<files>

Files relevant to this heuristic:

    GNUmakefile
    makefile
    Makefile

=cut

sub files { return qw( GNUmakefile makefile Makefile ) }

1;

