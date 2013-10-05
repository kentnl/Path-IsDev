use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyFile;

use Role::Tiny;

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

sub matches {
    my ( $self, $result_object ) = @_;
    return $self->_matches_files( $result_object );
}

with 'Path::IsDev::Role::Heuristic';
requires 'files';


1;
