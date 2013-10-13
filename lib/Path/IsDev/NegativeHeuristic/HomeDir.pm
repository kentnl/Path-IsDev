
use strict;
use warnings;

package Path::IsDev::NegativeHeuristic::HomeDir;
BEGIN {
  $Path::IsDev::NegativeHeuristic::HomeDir::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::NegativeHeuristic::HomeDir::VERSION = '1.000000';
}

# ABSTRACT: User home directories are not development roots

sub _uniq (@) {
  my %seen = ();
  grep { not $seen{$_}++ } @_;
}

use Role::Tiny::With;
with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::FullPath::Is::Any';

sub _fhd { require File::HomeDir; return 'File::HomeDir' }

sub excludes {
  my ( $self, $result_object ) = @_;
  my @sources;
  push @sources, _fhd()->my_home;
  push @sources, _fhd()->my_desktop;
  push @sources, _fhd()->my_music;
  push @sources, _fhd()->my_pictures;
  push @sources, _fhd()->my_videos;
  push @sources, _fhd()->my_data;

  return unless $self->fullpath_is_any( $result_object, _uniq @sources );
  return 1;
}
1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::NegativeHeuristic::HomeDir - User home directories are not development roots

=head1 VERSION

version 1.000000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
