use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile;

our $VERSION = '1.001002';

# ABSTRACT: An explicit exclusion file heuristic

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::NegativeHeuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}

=end MetaPOD::JSON

=head1 SYNOPSIS

In a C<::HeuristicSet>:

    sub negative_heuristics { return 'IsDev::IgnoreFile' }

Then on your file system:

    touch .path_isdev_ignore

Then the given location will no longer be a possible candidate for being deemed a C<dev> root directory.

However:

=over 4

=item * Its parents can still be deemed C<dev> directories

=item * Its children can still be deemed C<dev> directories

=back

=cut

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::NegativeHeuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';

=method C<excludes_files>

Files valid for triggering this heuristic:

    .path_isdev_ignore

=cut

sub excludes_files {
  return ('.path_isdev_ignore');
}

=method C<excludes>

Returns an exclusion if any of C<excludes_files> exists, and are files.

=cut

sub excludes {
  my ( $self, $result_object ) = @_;
  if ( $self->child_exists_any_file( $result_object, $self->excludes_files ) ) {
    return 1;
  }
  return;
}
1;

