use strict;
use warnings;

package Path::IsDev::Heuristic::Makefile;
BEGIN {
  $Path::IsDev::Heuristic::Makefile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Makefile::VERSION = '0.3.4';
}


# ABSTRACT: Determine if a path contains a C<Makefile>

use parent 'Path::IsDev::Heuristic';


sub files { return qw( GNUmakefile makefile Makefile ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::Makefile - Determine if a path contains a C<Makefile>

=head1 VERSION

version 0.3.4

=head1 METHODS

=head2 C<files>

Files relevant to this heuristic:

    GNUmakefile
    makefile
    Makefile

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Makefile",
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
