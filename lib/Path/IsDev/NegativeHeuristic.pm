use strict;
use warnings;

package Path::IsDev::NegativeHeuristic;

# ABSTRACT: Anti-Heuristic Base class

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic",
    "interface":"single_class"
}

=end MetaPOD::JSON

=cut

sub _path    { require Path::Tiny;   goto &Path::Tiny::path }
sub _croak   { require Carp;         goto &Carp::croak }
sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }
sub _debug   { require Path::IsDev;  goto &Path::IsDev::debug }

=method C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDNH> prefix removed:

    Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile->name() # → Negative ::IsDev::IgnoreFile

=cut

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::NegativeHeuristic:/Negative :/msx;
  return $name;
}

=p_method C<_file_excludess>

Glue layer between C<< ->excludes >> and C<< ->files >>

    # iterate $heuristic->files looking for a match
    $heurisitic->_file_excludes($path);

=cut

sub _file_excludes {
  my ( $self, $path ) = @_;
  my $root = _path($path);
  for my $file ( $self->files ) {
    my $stat = $root->child($file);
    next unless -e $stat;
    next unless -f $stat;
    _debug("$stat exists for $self");
    return 1;
  }
  return;
}

=p_method C<_dir_excludes>

Glue layer between C<< ->excludes >> and C<< ->dirs >>

    # iterate $heuristic->dirs looking for a match
    $heurisitic->_dir_excludes($path);


=cut

sub _dir_excludes {
  my ( $self, $path ) = @_;
  my $root = _path($path);
  for my $file ( $self->dirs ) {
    my $stat = $root->child($file);
    next unless -e $stat;
    next unless -d $stat;
    _debug( "$stat exists for" . $self->name );
    return 1;
  }
  return;
}

=method C<excludes>

Determines if the current negative heuristic excludes a given path

    my $result = $heuristic->excludes( $path );

The default implementation takes values from C<< ->files >> and C<< ->dirs >>
and returns true as soon as any match satisfies.

=cut

sub excludes {
  my ( $self, $path ) = @_;
  if ( not $self->can('files') and not $self->can('dirs') ) {
    return _croak("Heuristic $self did not implement one of : matches, files, dirs");
  }
  if ( $self->can('files') ) {
    return 1 if $self->_file_excludes($path);
  }
  if ( $self->can('dirs') ) {
    return 1 if $self->_dir_excludes($path);
  }
  return;
}

1;
