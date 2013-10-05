use strict;
use warnings;

package Path::IsDev::Heuristic::TestDir;
BEGIN {
  $Path::IsDev::Heuristic::TestDir::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::TestDir::VERSION = '0.4.1';
}

# ABSTRACT: Determine if a path contains a t/ or xt/ directory


use parent 'Path::IsDev::Heuristic';


sub dirs { return qw( t xt ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::TestDir - Determine if a path contains a t/ or xt/ directory

=head1 VERSION

version 0.4.1

=head1 METHODS

=head2 C<dirs>

Directories relevant to this heuristic:

    t/
    xt/

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
