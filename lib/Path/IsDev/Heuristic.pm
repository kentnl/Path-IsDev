use strict;
use warnings;

package Path::IsDev::Heuristic;
BEGIN {
  $Path::IsDev::Heuristic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::VERSION = '0.1.0';
}

# ABSTRACT: Heuristic Base class


sub _path    { require Path::Tiny;   goto &Path::Tiny::path }
sub _croak   { require Carp;         goto &Carp::croak }
sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }

sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::Heuristic:/:/msx;
  return $name;
}

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

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic - Heuristic Base class

=head1 VERSION

version 0.1.0

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic",
    "interface":"single_class"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
