use strict;
use warnings;

package Path::IsDev::Heuristic::DevDirMarker;

# ABSTRACT: Determine if a path contains a C<.devdir> file

=head1 DESCRIPTION

This Heuristic is a workaround that is likely viable in the event none of the other Heuristics work.

All this heuristic checks for is the presence of a special file called C<.devdir>, which is intended as an explicit notation that "This directory is a project root".

An example case where you might need such a Heuristic, is the scenario where you're not working
with a Perl C<CPAN> dist, but are instead working on a project in a different language, where Perl is simply there for build/test purposes.


=cut

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::Heuristic';

=method C<files>

Files relevant for this heuristic:

    .devdir

=cut

sub files { return qw( .devdir ) }

1;

