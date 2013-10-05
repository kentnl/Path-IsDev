use strict;
use warnings;

package Path::IsDev::Role::Heuristic::RegexpFile;

# ABSTRACT: Positive Heuristic when a path has a child file matching an expression

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::RegexpFile",
    "interface":"role",
    "does":"Path::IsDev::Role::Heuristic"
}

=end MetaPOD::JSON

=cut

sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny;

=head1 SYNOPSIS

    package Some::Heuristic;
    use Role::Tiny::With;
    with 'Path::IsDev::Role::Heuristic::RegexpFile';

    # Match if $PATH contains a child like $PATH/.bashrc or $PATH/.bash_profile
    sub basename_regexp {
        return qr/ \A [.] bash/xism;
    }

    1;

=cut

sub _matches_basename_regexp {
  my ( $self, $result_object ) = @_;
  my $regexp = $self->basename_regexp;
  for my $child ( $result_object->path->children ) {
    next unless -f $child;
    if ( $child->basename =~ $regexp ) {
      _debug("$child matches expression for $self");
      $result_object->add_reason( $self, 1, { 'child_basename_matches_expression?' => $child } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'child_basename_matches_expression?' => $child } );
  }
  $result_object->result(undef);
  return;
}

=method C<matches>

Implements L<< C<matches> for C<Path::IsDev::Role::Heuristic>|Path::IsDev::Role::Heuristic/matches >>

    if ( $class->matches($result_object) ) {
      # one of the items in $result_object->path->children matched $class->basename_regexp
      # $result_object has been modified to reflect that
      # _debug has been done where relevant
    }
    else {
      # no matches
      # $result_object has been modified with diagnostic data
      # _debug has been done where relevant
    }

=cut

sub matches {
  my ( $self, $result_object ) = @_;
  return $self->_matches_basename_regexp($result_object);
}

with 'Path::IsDev::Role::Heuristic';

=requires C<basename_regexp>

Consuming classes must provide this method.

    returns : a regexp ref that will be matched on all of $PATH->children's $_->basename

=cut

requires 'basename_regexp';

1;
