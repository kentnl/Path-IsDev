use strict;
use warnings;

package Path::IsDev::Heuristic;
BEGIN {
  $Path::IsDev::Heuristic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::VERSION = '0.5.1';
}

# ABSTRACT: Heuristic Base class


sub _croak   { require Carp;         goto &Carp::croak }
sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }
sub _debug   { require Path::IsDev;  goto &Path::IsDev::debug }

use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic';


sub _file_matches {
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


sub _dir_matches {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->dirs ) {
    my $stat = $root->child($file);
    if ( -e $stat and -d $stat ) {
      _debug( "$stat exists for" . $self->name );
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
  if ( not $self->can('files') and not $self->can('dirs') ) {
    return _croak("Heuristic $self did not implement one of : matches, files, dirs");
  }
  if ( $self->can('files') ) {
    return 1 if $self->_file_matches($result_object);
  }
  if ( $self->can('dirs') ) {
    return 1 if $self->_dir_matches($result_object);
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic - Heuristic Base class

=head1 VERSION

version 0.5.1

=head1 METHODS

=head2 C<matches>

Determines if the current heuristic matches a given path

    my $matched = $heuristic->matches( $result_object );

The default implementation takes values from C<< ->files >> and C<< ->dirs >>
and returns true as soon as any match satisfies.

=head1 PRIVATE METHODS

=head2 C<_file_matches>

Glue layer between C<< ->matches >> and C<< ->files >>

    # iterate $heuristic->files looking for a match
    $heurisitic->_file_matches( $result_object );

=head2 C<_dir_matches>

Glue layer between C<< ->matches >> and C<< ->dirs >>

    # iterate $heuristic->dirs looking for a match
    $heurisitic->_dir_matches( $result_object );

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic",
    "interface":"single_class",
    "does":"Path::IsDev::Role::Heuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
