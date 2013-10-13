
use strict;
use warnings;

package Path::IsDev::Role::Matcher::FullPath::Is::Any;
BEGIN {
  $Path::IsDev::Role::Matcher::FullPath::Is::Any::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Matcher::FullPath::Is::Any::VERSION = '1.000000';
}

# ABSTRACT: Match if the current directory is the same directory from a list of absolute paths.

sub _path { require Path::Tiny; goto &Path::Tiny::path }

use Role::Tiny;

sub _fullpath_is {
  my ( $self, $result_object, $this, $comparator ) = @_;

  my $context = {};

  $context->{tests} = [];

  $context->{test_path} = "$comparator";

  my $path = _path($comparator);

  if ( not $path->exists ) {
    push @{ $context->{tests} }, { 'test_path_exists?' => 0 };
    $result_object->add_reason( $self, 0, "comparative path $comparator does not exist", $context );
    return;
  }

  push @{ $context->{tests} }, { 'test_path_exists?' => 1 };

  my $realpath = $path->realpath;

  $context->{source_realpath} = "$this";
  $context->{test_realpath}   = "$realpath";

  if ( not $realpath eq $this ) {
    push @{ $context->{tests} }, { 'test_realpath_eq_source_realpath?' => 0 };
    $result_object->add_reason( $self, 0, "$this ne $realpath", $context );
    return;
  }
  push @{ $context->{tests} }, { 'test_realpath_eq_source_realpath?' => 1 };
  $result_object->add_reason( $self, 1, "$this eq $realpath", $context );
  return 1;
}


sub fullpath_is_any {
  my ( $self, $result_object, @dirnames ) = @_;
  my $current = $result_object->path->realpath;
  for my $dirname (@dirnames) {
    return 1 if $self->_fullpath_is( $result_object, $current, $dirname );
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Matcher::FullPath::Is::Any - Match if the current directory is the same directory from a list of absolute paths.

=head1 VERSION

version 1.000000

=head1 METHODS

=head2 C<fullpath_is_any>

Note, this is usually invoked on directories anyway.

    if ( $self->fullpath_is_any( $result_object, '/usr/', '/usr/bin/foo' )) {

    }

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut