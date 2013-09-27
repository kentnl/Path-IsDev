
use strict;
use warnings;

package Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile;
BEGIN {
  $Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile::VERSION = '0.4.0';
}

# ABSTRACT: An explicit exclusion file heuristic


use parent 'Path::IsDev::NegativeHeuristic';


sub files {
  return ('.path_isdev_ignore');
}
1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile - An explicit exclusion file heuristic

=head1 VERSION

version 0.4.0

=head1 SYNOPSIS

In a C<::HeuristicSet>:

    sub negative_heuristics { return 'IsDev::IgnoreFile' }

Then on your file system:

    touch .path_isdev_ignore

Then the given location will no longer be a possible candidate for being deemed a C<dev> root directory.

However:

=over 4

=item * Its parents can still be deemed C<dev> directories

=item * Its children can still be deemed C<dev> directories

=back

=head1 METHODS

=head2 C<files>

Files valid for triggering this heuristic:

    .path_isdev_ignore

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile",
    "interface":"single_class",
    "inherits":"Path::IsDev::NegativeHeuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
