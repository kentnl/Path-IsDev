use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyDir;

use Role::Tiny;

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

sub matches {
    my ( $self, $result_object ) = @_;
    return $self->_matches_dirs( $result_object );
}

with 'Path::IsDev::Role::Heuristic';
requires 'dirs';


1;
