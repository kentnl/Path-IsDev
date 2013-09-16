use strict;
use warnings;

package Path::IsDev::Heuristic::VCS::Git;
BEGIN {
  $Path::IsDev::Heuristic::VCS::Git::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::VCS::Git::VERSION = '0.3.0';
}


# ABSTRACT: Determine if a path contains a C<.git> repository

use parent 'Path::IsDev::Heuristic';


sub dirs  { return qw( .git ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::VCS::Git - Determine if a path contains a C<.git> repository

=head1 VERSION

version 0.3.0

=head1 METHODS

=head2 C<dirs>

Directories relevant to this heuristic:

    .git

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::VCS::Git",
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
