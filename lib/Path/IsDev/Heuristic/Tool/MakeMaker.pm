use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::MakeMaker;
BEGIN {
  $Path::IsDev::Heuristic::Tool::MakeMaker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Tool::MakeMaker::VERSION = '0.5.0';
}


# ABSTRACT: Determine if a path is an C<EUMM> Tooled source directory

use parent 'Path::IsDev::Heuristic';


sub files { return qw( Makefile.PL ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::Tool::MakeMaker - Determine if a path is an C<EUMM> Tooled source directory

=head1 VERSION

version 0.5.0

=head1 METHODS

=head2 C<files>

Files relevant to this heuristic:

    Makefile.PL

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::MakeMaker",
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
