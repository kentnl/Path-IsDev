use strict;
use warnings;

package Path::IsDev::Heuristic;

# ABSTRACT: Heuristic Base class

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic",
    "interface":"single_class"
}

=end MetaPOD::JSON

=cut

sub _path  { require Path::Tiny; goto &Path::Tiny::path }
sub _croak { require Carp;       goto &Carp::croak }

sub _file_matches {
    my ( $self, $path ) = @_;
    my $root = _path($path);
    for my $file ( $self->files ) {
        my $stat = $root->child($file);
        next unless -e $stat;
        next unless -f $stat;
        return 1;
    }
    return;
}

sub _dir_matches {
    my ( $self, $path ) = @_;
    my $root = _path($path);
    for my $file ( $self->dirs ) {
        my $stat = $root->child($file);
        next unless -e $stat;
        next unless -d $stat;
        return 1;
    }
    return;
}

sub matches {
    my ( $self, $path ) = @_;
    if ( not $self->can('files') and not $self->can('dirs') ) {
        return _croak(
            "Heuristic $self did not implement one of : matches, files, dirs");
    }
    if ( $self->can('files') ) {
        return 1 if $self->_file_matches($path);
    }
    if ( $self->can('dirs') ) {
        return 1 if $self->_dir_matches($path);
    }
    return;
}

1;
