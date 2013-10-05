use strict;
use warnings;

package Path::IsDev::Heuristic::META;
BEGIN {
  $Path::IsDev::Heuristic::META::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::META::VERSION = '0.5.1';
}


# ABSTRACT: Determine if a path contains META.(json|yml)

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic::AnyFile';


sub files { return qw( META.json META.yml ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::META - Determine if a path contains META.(json|yml)

=head1 VERSION

version 0.5.1

=head1 METHODS

=head2 C<files>

files relevant to this heuristic:

    META.json
    META.yml

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::META",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic::AnyFile"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
