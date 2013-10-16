
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

## no critic (RequireArgUnpacking, ProhibitSubroutinePrototypes)
sub _uniq (@) {
  my %seen = ();
  return grep { not $seen{$_}++ } @_;
}


use Role::Tiny::With;
with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::FullPath::Is::Any';

sub _fhd { require File::HomeDir; return 'File::HomeDir' }


sub paths {
  my @sources;
  push @sources, _fhd()->my_home;
  push @sources, _fhd()->my_desktop;
  push @sources, _fhd()->my_music;
  push @sources, _fhd()->my_pictures;
  push @sources, _fhd()->my_videos;
  push @sources, _fhd()->my_data;
  return _uniq grep { defined and length } @sources;
}


sub excludes {
  my ( $self, $result_object ) = @_;
  return unless $self->fullpath_is_any( $result_object, $self->paths );
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

=head1 METHODS

=head2 C<paths>

Excludes any values returned by L<< C<File::HomeDir>|File::HomeDir >>

    uniq grep { defined and length }
      File::HomeDir->my_home,
      File::HomeDir->my_desktop,
      File::HomeDir->my_music,
      File::HomeDir->my_pictures,
      File::HomeDir->my_videos,
      File::HomeDir->my_data;

=head2 C<excludes>

Excludes any path that matches a C<realpath> of a L<< C<File::HomeDir> path|File::HomeDir >>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic::HomeDir",
    "interface":"single_class",
    "does": [
        "Path::IsDev::Role::NegativeHeuristic",
        "Path::IsDev::Role::Matcher::FullPath::Is::Any"
    ]
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
