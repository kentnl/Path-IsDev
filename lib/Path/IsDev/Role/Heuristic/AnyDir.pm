use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyDir;

# ABSTRACT: Positive Heuristic if a path contains one of any of a list of directories

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::AnyDir",
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
    with 'Path::IsDev::Role::Heuristic::AnyDir';

    # Match if $PATH contains any of the named children as dirs
    sub dirs {
        return qw( .git .build )
    }

    1;

=cut

sub _matches_dirs {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->dirs ) {
    my $stat = $root->child($file);
    if ( -e $stat and -d $stat ) {
      _debug("$stat exists for $self");
      $result_object->add_reason( $self, 1, { 'dir_exists?' => $stat } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'dir_exists?' => $stat } );
  }
  $result_object->result(undef);
  return;
}

=method C<matches>

Implements L<< C<matches> for C<Path::IsDev::Role::Heuristic>|Path::IsDev::Role::Heuristic/matches >>

    if ( $class->matches($result_object) ) {
      # one of the items in $class->dirs matched a directory
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
  return $self->_matches_dirs($result_object);
}

with 'Path::IsDev::Role::Heuristic';

=requires C<dirs>

Any consuming classes must implement this method

    returns : A list of directory basenames to match

=cut

requires 'dirs';

1;
