use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyFile;

# ABSTRACT: Positive Heuristic if a path contains one of any of a list of files

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::AnyFile",
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
    with 'Path::IsDev::Role::Heuristic::AnyFile';

    # Match if $PATH contains any of the named children as files
    sub files {
        return qw( Foo Bar Baz .bashrc )
    }

    1;

=cut

sub _matches_files {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->files ) {
    my $stat = $root->child($file);
    if ( -e $stat and -f $stat ) {
      _debug("$stat exists for $self");
      $result_object->add_reason( $self, 1, { 'file_exists?' => $stat } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'file_exists?' => $stat } );
  }
  $result_object->result(undef);
  return;
}

=method C<matches>

Implements L<< C<matches> for C<Path::IsDev::Role::Heuristic>|Path::IsDev::Role::Heuristic/matches >>

    if ( $class->matches($result_object) ) {
      # one of the items in $class->files matched
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
  return $self->_matches_files($result_object);
}

with 'Path::IsDev::Role::Heuristic';

=requires C<files>

Any consuming classes must implement this method

    returns : A list of file basenames to match

=cut

requires 'files';

1;
