use strict;
use warnings;

package Path::IsDev::Role::NegativeHeuristic;

# ABSTRACT: Base role for Negative Heuristic things.

use Role::Tiny;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::NegativeHeuristic",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }

=method C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDH> prefix removed:

    Path::IsDev::NegativeHeuristic::Tool::Dzil->name() # → ::Tool::Dzil

=cut

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::NegativeHeuristic:/Negative :/msx;
  return $name;
}

=requires C<excludes>

Implementing classes must provide this method.

    return : 1 / undef
             1     -> this path is not a development directory as far as this heuristic is concerned
             undef -> this path is a development directory as far as this heuristic is concerned

    args : ( $class , $result_object )
        $class         -> method will be invoked on packages, not objects
        $result_object -> will be a Path::IsDev::Result

=cut

requires 'excludes';

1;
