use 5.008;
use strict;
use warnings;
use utf8;

package Path::IsDev::HeuristicSet::Basic;

# ABSTRACT: Basic C<IsDev> set of Heuristics

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::Basic",
    "interface":"single_class",
    "does":"Path::IsDev::Role::HeuristicSet::Simple"
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With;
with 'Path::IsDev::Role::HeuristicSet::Simple';

=method C<negative_heuristics>

Excluding heuristics in this set are

=over 4

=item 1. L<< C<IsDev::IgnoreFile>|Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile >>

=item 2. L<< C<HomeDir>|Path::IsDev::NegativeHeuristic::HomeDir >>

=item 3. L<< C<PerlINC>|Path::IsDev::NegativeHeuristic::PerlINC >>

=back

=cut

sub negative_heuristics {
  return qw( IsDev::IgnoreFile HomeDir PerlINC );
}

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
