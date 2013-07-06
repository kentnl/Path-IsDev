use strict;
use warnings;

package Path::IsDev::Heuristic::MYMETA;
BEGIN {
  $Path::IsDev::Heuristic::MYMETA::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::MYMETA::VERSION = '0.1.0';
}

# ABSTRACT: Determine if a path contains MYMETA.(json|yml)



use parent 'Path::IsDev::Heuristic';

sub files { return qw( MYMETA.json MYMETA.yml ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::MYMETA - Determine if a path contains MYMETA.(json|yml)

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This heuristic is intended as a guarantee that B<SOME> kind of top level marker will
be present in a distribution, as all the main tool-chains emit this file during C<configure>.

Granted, this heuristic is expected to be B<never> needed, as in order to create such a file, you first need a C<Build.PL>/C<Makefile.PL> to generate it.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::MYMETA",
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
