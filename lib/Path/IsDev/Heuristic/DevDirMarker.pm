use strict;
use warnings;

package Path::IsDev::Heuristic::DevDirMarker;
BEGIN {
  $Path::IsDev::Heuristic::DevDirMarker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::DevDirMarker::VERSION = '0.1.0';
}

# ABSTRACT: Determine if a path contains a .devdir file


use parent 'Path::IsDev::Heuristic';

sub files { return qw( .devdir ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::DevDirMarker - Determine if a path contains a .devdir file

=head1 VERSION

version 0.1.0

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
