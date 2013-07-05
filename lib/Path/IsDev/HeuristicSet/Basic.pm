use strict;
use warnings;

package Path::IsDev::HeuristicSet::Basic;
BEGIN {
  $Path::IsDev::HeuristicSet::Basic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::HeuristicSet::Basic::VERSION = '0.1.0';
}

# ABSTRACT: Basic IsDev set of Heuristics


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

Path::IsDev::HeuristicSet::Basic - Basic IsDev set of Heuristics

=head1 VERSION

version 0.1.0

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
