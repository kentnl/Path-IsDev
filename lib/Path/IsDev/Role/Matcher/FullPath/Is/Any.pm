use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Role::Matcher::FullPath::Is::Any;

# ABSTRACT: Match if the current directory is the same directory from a list of absolute paths.

# AUTHORITY

sub _path {
  require Path::Tiny;
  Path::Tiny->VERSION('0.004');
  goto &Path::Tiny::path;
}

use Role::Tiny;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::FullPath::Is::Any",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

=p_method C<_fullpath_is>

    $class->_fullpath_is( $result_object, $source_path, $comparison_path );

Does not match if C<$comparison_path> does not exist.

Otherwise, compare C<$source_path> vs C<< $comparison_path->realpath >>, and return if they match.

=cut

sub _fullpath_is {
  my ( $self, $result_object, $this, $comparator ) = @_;

  my $context = {};

  $context->{tests} = [];

  $context->{test_path} = "$comparator";

  my $path = _path($comparator);

  if ( not $path->exists ) {
    push @{ $context->{tests} }, { 'test_path_exists?' => 0 };
    $result_object->add_reason( $self, 0, "comparative path $comparator does not exist", $context );
    return;
  }

  push @{ $context->{tests} }, { 'test_path_exists?' => 1 };

  my $realpath = $path->realpath;

  $context->{source_realpath} = "$this";
  $context->{test_realpath}   = "$realpath";

  if ( not $realpath eq $this ) {
    push @{ $context->{tests} }, { 'test_realpath_eq_source_realpath?' => 0 };
    $result_object->add_reason( $self, 0, "$this ne $realpath", $context );
    return;
  }
  push @{ $context->{tests} }, { 'test_realpath_eq_source_realpath?' => 1 };
  $result_object->add_reason( $self, 1, "$this eq $realpath", $context );
  return 1;
}

=method C<fullpath_is_any>

Note, this is usually invoked on directories anyway.

    if ( $self->fullpath_is_any( $result_object, '/usr/', '/usr/bin/foo' )) {

    }

Matches if any of the provided paths C<realpath>'s correspond to C<< $result_object->path->realpath >>

=cut

sub fullpath_is_any {
  my ( $self, $result_object, @dirnames ) = @_;
  my $current = $result_object->path->realpath;
  for my $dirname (@dirnames) {
    return 1 if $self->_fullpath_is( $result_object, $current, $dirname );
  }
  return;
}

1;
