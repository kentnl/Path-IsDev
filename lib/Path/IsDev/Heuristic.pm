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

sub _path    { require Path::Tiny;   goto &Path::Tiny::path }
sub _croak   { require Carp;         goto &Carp::croak }
sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }

=method C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDH> prefix removed:

    Path::IsDev::Heuristic::Tool::Dzil->name() # → ::Tool::Dzil

=cut

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::Heuristic:/:/msx;
  return $name;
}

=p_method C<_file_matches>

Glue layer between C<< ->matches >> and C<< ->files >>

    # iterate $heuristic->files looking for a match
    $heurisitic->_file_matches($path);

=cut

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

=p_method C<_dir_matches>

Glue layer between C<< ->matches >> and C<< ->dirs >>

    # iterate $heuristic->dirs looking for a match
    $heurisitic->_dir_matches($path);


=cut

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

=method C<matches>

Determines if the current heuristic matches a given path

    my $result = $heuristic->matches( $path );

The default implementation takes values from C<< ->files >> and C<< ->dirs >>
and returns true as soon as any match satisfies.

=cut

sub matches {
  my ( $self, $path ) = @_;
  if ( not $self->can('files') and not $self->can('dirs') ) {
    return _croak("Heuristic $self did not implement one of : matches, files, dirs");
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
