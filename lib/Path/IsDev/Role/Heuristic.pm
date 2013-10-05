use strict;
use warnings;

package Path::IsDev::Role::Heuristic;

use Role::Tiny;

sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }

=method C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDH> prefix removed:

    Path::IsDev::Heuristic::Tool::Dzil->name() # → ::Tool::Dzil

=cut

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::Heuristic:/:/msx;
  return $name;
}

requires 'matches';

1;
