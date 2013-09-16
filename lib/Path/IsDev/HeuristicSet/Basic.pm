use strict;
use warnings;

package Path::IsDev::HeuristicSet::Basic;

# ABSTRACT: Basic C<IsDev> set of Heuristics

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::Basic",
    "interface":"single_class",
    "inherits":"Path::IsDev::HeuristicSet"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::HeuristicSet';

=method C<heuristics>

Heuristics included in this set:

=over 4

=item 1. L<< C<Tool::Dzil>|Path::IsDev::Heuristic::Tool::Dzil >>

=item 2. L<< C<Tool::MakeMaker>|Path::IsDev::Heuristic::Tool::MakeMaker >>

=item 3. L<< C<Tool::ModuleBuild>|Path::IsDev::Heuristic::Tool::ModuleBuild >>

=item 4. L<< C<META>|Path::IsDev::Heuristic::META >>

=item 5. L<< C<Changelog>|Path::IsDev::Heuristic::Changelog >>

=item 6. L<< C<TestDir>|Path::IsDev::Heuristic::TestDir >>

=item 7. L<< C<DevDirMarker>|Path::IsDev::Heuristic::DevDirMarker >>

=item 8. L<< C<MYMETA>|Path::IsDev::Heuristic::MYMETA >>

=item 9. L<< C<Makefile>|Path::IsDev::Heuristic::Makefile >>

=item 10. L<< C<VCS::Git>|Path::IsDev::Heuristic::VCS::Git >>

=back

=cut

sub heuristics {
  return qw(
    Tool::Dzil Tool::MakeMaker Tool::ModuleBuild
    META Changelog TestDir DevDirMarker MYMETA Makefile
    VCS::Git
  );
}

1;
