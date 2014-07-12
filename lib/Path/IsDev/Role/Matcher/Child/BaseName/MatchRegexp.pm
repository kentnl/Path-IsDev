use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp;

our $VERSION = '1.001002';

# ABSTRACT: Match when a path has a child file matching an expression

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

use Role::Tiny;

=p_method C<_this_child_matchregexp>

    if ( $class->_this_child_matchregexp( $result_object, $child_path, $regexp ) ) {
        ...
    }

=cut

sub _this_child_matchregexp {
  my ( $self, $result_object, $child, $regexp ) = @_;
  my $ctx = {
    'child'          => "$child",
    'child_basename' => $child->basename,
    expression       => $regexp,
    tests            => [],
  };
  my $tests = $ctx->{tests};

  if ( $child->basename =~ $regexp ) {
    push @{$tests}, { 'child_basename_matches_expression?' => 1 };
    $result_object->add_reason( $self, 1, $child->basename . " matches $regexp", $ctx );
    return 1;
  }
  push @{$tests}, { 'child_basename_matches_expression?' => 0 };
  $result_object->add_reason( $self, 0, $child->basename . " does not match $regexp", $ctx );
  return;
}

=method C<child_basename_matchregexp>

    $class->child_basename_matchregexp( $result_object, $regexp );

Given a regexp C<$regexp>, match if any of C<< $result_object->path->children >> match the given regexp.

    if ( $self->child_basename_matchregexp( $result_object, qr/^Change(.*)$/i ) ) {
        # result_object->path() contains at least one child that matches the regexp
    }

=cut

sub child_basename_matchregexp {
  my ( $self, $result_object, $regexp ) = @_;
  for my $child ( $result_object->path->children ) {
    return 1 if $self->_this_child_matchregexp( $result_object, $child, $regexp );
  }
  return;
}

1;
