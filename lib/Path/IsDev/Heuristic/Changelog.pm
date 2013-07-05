use strict;
use warnings;

package Path::IsDev::Heuristic::Changelog;
BEGIN {
  $Path::IsDev::Heuristic::Changelog::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Changelog::VERSION = '0.1.0';
}

# ABSTRACT: Determine if a path contains a Changelog (or similar)



use parent 'Path::IsDev::Heuristic';
sub _path { require Path::Tiny; goto &Path::Tiny::path }

sub matches {
  my ( $self, $path ) = @_;
  for my $child ( _path($path)->children ) {
    next unless -f $child;
    return 1 if $child->basename =~ /^Change(s|log)(|[.][^.]+)/i;
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::Changelog - Determine if a path contains a Changelog (or similar)

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This hueristic matches any case variation of "Changes" or "Changelog",
including any files of that name with a suffix.

ie:

    Changes
    CHANGES
    Changes.mkdn

etc.

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
