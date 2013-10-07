use strict;
use warnings;

package Path::IsDev::Role::NegativeHeuristic::AnyFile;
BEGIN {
  $Path::IsDev::Role::NegativeHeuristic::AnyFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::NegativeHeuristic::AnyFile::VERSION = '0.6.1';
}

# ABSTRACT: Negative Heuristic if a path contains one of any of a list of files


sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny;


sub _excludes_files {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->excludes_files ) {
    my $stat = $root->child($file);
    if ( -e $stat and -f $stat ) {
      _debug("$stat exists for $self");
      $result_object->add_reason( $self, 1, { 'file_exists?' => $stat } );
      $result_object->result(undef);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'file_exists?' => $stat } );
  }
  return;
}


sub excludes {
  my ( $self, $result_object ) = @_;
  return $self->_excludes_files($result_object);
}

with 'Path::IsDev::Role::NegativeHeuristic';


requires 'excludes_files';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::NegativeHeuristic::AnyFile - Negative Heuristic if a path contains one of any of a list of files

=head1 VERSION

version 0.6.1

=head1 SYNOPSIS

    package Some::Heuristic;
    use Role::Tiny::With;
    with 'Path::IsDev::Role::NegativeHeuristic::AnyFile';

    # Match if $PATH contains any of the named children as files
    sub excludes_files {
        return qw( Foo Bar Baz .bashrc )
    }

    1;

=head1 ROLE REQUIRES

=head2 C<excludes_files>

Any consuming classes must implement this method

    returns : A list of file basenames to match

=head1 METHODS

=head2 C<excludes>

Implements L<< C<excludes> for C<Path::IsDev::Role::NegativeHeuristic>|Path::IsDev::Role::NegativeHeuristic/excludes >>

    if ( $class->matches($result_object) ) {
      # one of the items in $class->files matched
      # $result_object has been modified to reflect that
      # _debug has been done where relevant
    }
    else {
      # no matches
      # $result_object has been modified with diagnostic data
      # _debug has been done where relevant
    }

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::NegativeHeuristic::AnyFile",
    "interface":"role",
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
