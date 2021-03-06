use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Role::NegativeHeuristic;

our $VERSION = '1.001004';

# ABSTRACT: Base role for Negative Heuristic things.

# AUTHORITY

sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }

use Role::Tiny qw( requires );

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::NegativeHeuristic",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

=method C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDNH> prefix removed:

    Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile->name()
    → "- ::IsDev::IgnoreFile"

=cut

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::NegativeHeuristic:/- :/msx;
  return $name;
}

=method C<heuristic_type>

Returns a description of the general heuristic type

    negative heuristic

=cut

sub heuristic_type {
  return 'negative heuristic';
}

=requires C<excludes>

Implementing classes must provide this method.

    return : 1 / undef
             1     -> this path is not a development directory as far as this heuristic is concerned
             undef -> this path is a development directory as far as this heuristic is concerned

    args : ( $class , $result_object )
        $class         -> method will be invoked on packages, not objects
        $result_object -> will be a Path::IsDev::Result

Additionally, consuming classes B<should> set C<< $result_object->result( undef ) >> prior to returning true.

Composing roles B<should> also invoke C<< $result_object->add_reason( $self, $result_value, $descriptive_reason_for_result, \%contextinfo ) >>.

See L<< C<Path::IsDev::Result> for details|Path::IsDev::Result >>


=cut

requires 'excludes';

1;
