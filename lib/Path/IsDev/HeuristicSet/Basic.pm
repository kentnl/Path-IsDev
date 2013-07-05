use strict;
use warnings;

package Path::IsDev::HeuristicSet::Basic;

# ABSTRACT: Basic IsDev set of Heuristics

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::Basic",
    "interface":"single_class",
    "inherits":"Path::IsDev::HeuristicSet"
}

=end MetaPOD::JSON

=cut

use parent 'Path::IsDev::HeuristicSet';

sub heuristics {
  return qw(
    Tool::Dzil Tool::MakeMaker Tool::ModuleBuild
    META Changelog TestDir DevDirMarker Makefile
  );
}

1;
