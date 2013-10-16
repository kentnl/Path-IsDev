use strict;
use warnings;

package Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File;

# ABSTRACT: Match if any children have C<basename>s that match a regexp and are files

use Role::Tiny;
with 'Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp';

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File",
    "interface":"role",
    "does":"Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp"
}

=end MetaPOD::JSON

=cut

=p_method C<_this_child_isfile>

    if ( $class->_this_child_isfile( $result_object, $child_path ) ) {
        ...
    }

=cut

sub _this_child_isfile {
  my ( $self, $result_object, $child ) = @_;
  my $ctx = {
    'child' => "$child",
    tests   => []
  };
  my $tests = $ctx->{tests};

  if ( -f $child ) {
    push @{$tests}, { 'child_isfile?' => 1 };
    $result_object->add_reason( $self, 1, "$child is a file", $ctx );
    return 1;
  }
  push @{$tests}, { 'child_isfile?' => 0 };
  $result_object->add_reason( $self, 0, "$child is not a file", $ctx );

  return;
}

=method C<child_basename_matchregexp_file>

    $class->child_basename_matchregexp_file( $result_object, $regexp );

Given a regexp C<$regexp>, match if any of C<< $result_object->path->children >> match the given regexp,
on the condition that those that match are also files.

    if ( $self->child_basename_matchregexp_file( $result_object, qr/^Change(.*)$/i ) ) {
        # result_object->path() contains at least one child that is a file and matches the regexp
    }

=cut

sub child_basename_matchregexp_file {
  my ( $self, $result_object, $regexp ) = @_;
  for my $child ( $result_object->path->children ) {
    return 1
      if $self->_this_child_matchregexp( $result_object, $child, $regexp )
      and $self->_this_child_isfile( $result_object, $child );
  }
  return;

}

1;
