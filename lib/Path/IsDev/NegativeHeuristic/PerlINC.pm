use strict;
use warnings;

package Path::IsDev::NegativeHeuristic::PerlINC;
BEGIN {
  $Path::IsDev::NegativeHeuristic::PerlINC::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::NegativeHeuristic::PerlINC::VERSION = '1.000000';
}

# ABSTRACT: White-list paths in C<Config.pm> as being non-development roots.

## no critic (RequireArgUnpacking, ProhibitSubroutinePrototypes)
sub _uniq (@) {
  my %seen = ();
  return grep { not $seen{$_}++ } @_;
}

use Role::Tiny::With;
use Config;

with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::FullPath::Is::Any';

sub excludes {
  my ( $self, $result_object ) = @_;
  my @sources;

  push @sources, $Config{archlibexp}, $Config{privlibexp}, $Config{sitelibexp}, $Config{vendorlibexp};

  return unless $self->fullpath_is_any( $result_object, _uniq grep { defined and length } @sources );
  return 1;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::NegativeHeuristic::PerlINC - White-list paths in C<Config.pm> as being non-development roots.

=head1 VERSION

version 1.000000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
