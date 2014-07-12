use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Role::Matcher::Child::Exists::Any::File;

our $VERSION = '1.001002';

# ABSTRACT: Match if a path contains one of any of a list of files

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::Child::Exists::Any::File",
    "interface":"role",
    "does":"Path::IsDev::Role::Matcher::Child::Exists::Any"
}

=end MetaPOD::JSON

=cut

use Role::Tiny qw( with );
with 'Path::IsDev::Role::Matcher::Child::Exists::Any';

=method C<child_exists_file>

    $class->child_exists_file( $result_object, $childname );

Return match if C<$childname> exists as a file child of C<< $result_object->path >>

=cut

sub child_exists_file {
  my ( $self, $result_object, $child ) = @_;

  my $child_path = $result_object->path->child($child);
  my $ctx        = { 'child_name' => $child, child_path => "$child_path", tests => [] };
  my $tests      = $ctx->{tests};

  # For now, yes, files, not things usable as files
  ## no critic (ValuesAndExpressions::ProhibitFiletest_f)
  if ( -f $child_path ) {
    push @{$tests}, { 'child_path_isfile?' => 1 };
    $result_object->add_reason( $self, 1, "$child_path is a file", $ctx );
    return 1;
  }
  push @{$tests}, { 'child_path_isfile?' => 1 };
  $result_object->add_reason( $self, 0, "$child_path is not a file", $ctx );

  return;
}

=method C<child_exists_any_file>

    $class->child_exists_any_file( $result_object, @childnames );

Return match if any of C<@childnames> exist under C<< $result_object->path >> and are files.

=cut

sub child_exists_any_file {
  my ( $self, $result_object, @children ) = @_;
  for my $child (@children) {
    return 1 if $self->child_exists( $result_object, $child ) and $self->child_exists_file( $result_object, $child );
  }
  return;
}

1;
