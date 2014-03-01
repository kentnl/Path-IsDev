use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::NegativeHeuristic::HomeDir;

# ABSTRACT: User home directories are not development roots

# AUTHORITY

## no critic (RequireArgUnpacking, ProhibitSubroutinePrototypes)
sub _uniq (@) {
  my %seen = ();
  return grep { not $seen{$_}++ } @_;
}

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

=cut

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::FullPath::Is::Any';

=method C<paths>

Excludes any values returned by L<< C<File::HomeDir>|File::HomeDir >>

    uniq grep { defined and length }
      File::HomeDir->my_home,
      File::HomeDir->my_desktop,
      File::HomeDir->my_music,
      File::HomeDir->my_pictures,
      File::HomeDir->my_videos,
      File::HomeDir->my_data;


=cut

sub paths {
  my @sources;
  require File::HomeDir;
  push @sources, File::HomeDir->my_home;
  for my $method (qw( my_home my_desktop my_music my_pictures my_videos my_data )) {
    if ( $File::HomeDir::IMPLEMENTED_BY->can($method) ) {
      push @sources, File::HomeDir->$method();
    }
  }
  return _uniq grep { defined and length } @sources;
}

=method C<excludes>

Excludes any path that matches a C<realpath> of a L<< C<File::HomeDir> path|File::HomeDir >>

=cut

sub excludes {
  my ( $self, $result_object ) = @_;
  return unless $self->fullpath_is_any( $result_object, $self->paths );
  return 1;
}
1;
