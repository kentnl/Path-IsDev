use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::NegativeHeuristic::PerlINC;

our $VERSION = '1.001001';

# ABSTRACT: White-list paths in Config.pm as being non-development roots.

# AUTHORITY

## no critic (RequireArgUnpacking, ProhibitSubroutinePrototypes)
sub _uniq (@) {
  my %seen = ();
  return grep { not $seen{$_}++ } @_;
}

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic::PerlINC",
    "interface":"single_class",
    "does": [
        "Path::IsDev::Role::NegativeHeuristic",
        "Path::IsDev::Role::Matcher::FullPath::Is::Any"
    ]
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With qw( with );
use Config;

with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::FullPath::Is::Any';

=method C<paths>

Returns a unique list comprised of all the C<*exp> library paths from L<< C<Config.pm>|Config >>

    uniq grep { defined and length } $Config{archlibexp}, $Config{privlibexp}, $Config{sitelibexp}, $Config{vendorlibexp};

=cut

sub paths {
  my @sources;
  push @sources, $Config{archlibexp}, $Config{privlibexp}, $Config{sitelibexp}, $Config{vendorlibexp};
  return _uniq grep { defined and length } @sources;
}

=method C<excludes>

Excludes a path if its full path is any of C<paths>

=cut

sub excludes {
  my ( $self, $result_object ) = @_;

  return unless $self->fullpath_is_any( $result_object, $self->paths );
  return 1;
}

1;

