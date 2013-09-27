use strict;
use warnings;

package Path::IsDev::Heuristic::Changelog;
BEGIN {
  $Path::IsDev::Heuristic::Changelog::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Changelog::VERSION = '0.3.4';
}

# ABSTRACT: Determine if a path contains a C<Changelog> (or similar)



use parent 'Path::IsDev::Heuristic';
sub _path { require Path::Tiny; goto &Path::Tiny::path }


sub matches {
  my ( $self, $path ) = @_;
  for my $child ( _path($path)->children ) {
    next unless -f $child;
    return 1 if $child->basename =~ /\AChange(s|log)(|[.][^.\s]+)\z/isxm;
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::Changelog - Determine if a path contains a C<Changelog> (or similar)

=head1 VERSION

version 0.3.4

=head1 DESCRIPTION

This heuristic matches any case variation of C<Changes> or C<Changelog>,
including any files of that name with a suffix.

e.g.:

    Changes
    CHANGES
    Changes.mkdn

etc.

=head1 METHODS

=head2 C<matches>

Indicators for this heuristic is the existence of a file such as:

    Changes             (i)
    Changes.anyext      (i)
    Changelog           (i)
    Changelog.anyext    (i)

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Changelog",
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
