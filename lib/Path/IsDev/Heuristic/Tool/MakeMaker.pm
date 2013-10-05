use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::MakeMaker;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::MakeMaker",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic::AnyFile"
}

=end MetaPOD::JSON

=cut

# ABSTRACT: Determine if a path is an C<EUMM> Tooled source directory

use Role::Tiny::With;

with 'Path::IsDev::Role::Heuristic::AnyFile';

=method C<files>

Files relevant to this heuristic:

    Makefile.PL

=cut

sub files { return qw( Makefile.PL ) }

1;
