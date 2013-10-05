use strict;
use warnings;

package Path::IsDev::Role::Heuristic::RegexpFile;
BEGIN {
  $Path::IsDev::Role::Heuristic::RegexpFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Heuristic::RegexpFile::VERSION = '0.5.1';
}


sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny;

sub _matches_basename_regexp {
  my ( $self, $result_object ) = @_;
  my $regexp = $self->basename_regexp;
  for my $child ( $result_object->path->children ) {
    next unless -f $child;
    if ( $child->basename =~ $regexp ) {
      _debug("$child matches expression for $self");
      $result_object->add_reason( $self, 1, { 'child_basename_matches_expression?' => $child } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'child_basename_matches_expression?' => $child } );
  }
  $result_object->result(undef);
  return;
}

sub matches {
  my ( $self, $result_object ) = @_;
  return $self->_matches_basename_regexp($result_object);
}

with 'Path::IsDev::Role::Heuristic';
requires 'basename_regexp';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Heuristic::RegexpFile

=head1 VERSION

version 0.5.1

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic::RegexpFile",
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
