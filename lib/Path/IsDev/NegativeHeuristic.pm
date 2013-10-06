use strict;
use warnings;

package Path::IsDev::NegativeHeuristic;
BEGIN {
  $Path::IsDev::NegativeHeuristic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::NegativeHeuristic::VERSION = '0.6.1';
}

# ABSTRACT: Anti-Heuristic Base class



sub _croak   { require Carp;         goto &Carp::croak }
sub _debug   { require Path::IsDev;  goto &Path::IsDev::debug }

use Role::Tiny::With;
with 'Path::IsDev::Role::NegativeHeuristic';


sub _file_excludes {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->files ) {
    my $stat = $root->child($file);
    if ( -e $stat and -f $stat ) {
      _debug("$stat exists for $self");
      $result_object->add_reason( $self, 1, { 'exclude_file_exists?' => $stat } );
      $result_object->result(undef);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'exclude_file_exists?' => $stat } );
  }
  return;
}


sub _dir_excludes {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->dirs ) {
    my $stat = $root->child($file);
    if ( -e $stat and -d $stat ) {
      _debug( "$stat exists for" . $self->name );
      $result_object->add_reason( $self, 1, { 'exclude_dir_exists?' => $stat } );
      $result_object->result(undef);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'exclude_dir_exists?' => $stat } );
  }
  return;
}


sub excludes {
  my ( $self, $result_object ) = @_;
  if ( not $self->can('files') and not $self->can('dirs') ) {
    return _croak("Heuristic $self did not implement one of : matches, files, dirs");
  }
  if ( $self->can('files') ) {
    return 1 if $self->_file_excludes($result_object);
  }
  if ( $self->can('dirs') ) {
    return 1 if $self->_dir_excludes($result_object);
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::NegativeHeuristic - Anti-Heuristic Base class

=head1 VERSION

version 0.6.1

=head1 SYNOPSIS

This class exists for compatibility.

New code should C<with> C<::Role::NegativeHeuristic::>*

=head1 METHODS

=head2 C<excludes>

Determines if the current negative heuristic excludes a given path

    my $result = $heuristic->excludes( $result_object );

The default implementation takes values from C<< ->files >> and C<< ->dirs >>
and returns true as soon as any match satisfies.

=head1 PRIVATE METHODS

=head2 C<_file_excludess>

Glue layer between C<< ->excludes >> and C<< ->files >>

    # iterate $heuristic->files looking for a match
    $heurisitic->_file_excludes( $result_object );

=head2 C<_dir_excludes>

Glue layer between C<< ->excludes >> and C<< ->dirs >>

    # iterate $heuristic->dirs looking for a match
    $heurisitic->_dir_excludes( $result_object );

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::NegativeHeuristic",
    "interface":"single_class",
    "does":"Path::IsDev::Role::NegativeHeuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
