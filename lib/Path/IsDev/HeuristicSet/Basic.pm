use strict;
use warnings;

package Path::IsDev::HeuristicSet::Basic;
BEGIN {
  $Path::IsDev::HeuristicSet::Basic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::HeuristicSet::Basic::VERSION = '0.2.2';
}

# ABSTRACT: Basic C<IsDev> set of Heuristics


use parent 'Path::IsDev::HeuristicSet';


sub heuristics {
  return qw(
    Tool::Dzil Tool::MakeMaker Tool::ModuleBuild
    META Changelog TestDir DevDirMarker MYMETA Makefile
  );
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::HeuristicSet::Basic - Basic C<IsDev> set of Heuristics

=head1 VERSION

version 0.2.2

=head1 METHODS

=head2 C<heuristics>

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

=back

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::Basic",
    "interface":"single_class",
    "inherits":"Path::IsDev::HeuristicSet"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
