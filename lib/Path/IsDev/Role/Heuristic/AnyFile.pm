use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyFile;
BEGIN {
  $Path::IsDev::Role::Heuristic::AnyFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Heuristic::AnyFile::VERSION = '0.5.1';
}


sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

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
  return $self->_matches_files($result_object);
}

with 'Path::IsDev::Role::Heuristic';
requires 'files';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Heuristic::AnyFile

=head1 VERSION

version 0.5.1

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::AnyFile",
    "interface":"role",
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
