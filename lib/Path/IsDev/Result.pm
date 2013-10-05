use strict;
use warnings;

package Path::IsDev::Result;
BEGIN {
  $Path::IsDev::Result::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Result::VERSION = '0.4.1';
}

# ABSTRACT: Result container

use Class::Tiny 'path', 'result', {
  reasons => sub { [] }
};
sub _path { require Path::Tiny; goto &Path::Tiny::path }

sub BUILD {
  my ( $self, $args ) = @_;
  if ( not $self->path ) {
    die "<path> is a mandatory parameter";
  }
  if ( not ref $self->path ) {
    $self->path( _path( $self->path ) );
  }
  if ( not -e $self->path ) {
    die "<path> parameter must exist for heuristics to be performed";
  }
}
my %type_map = (
  'Path::IsDev::Heuristic'         => 'positive heuristic',
  'Path::IsDev::NegativeHeuristic' => 'negative heuristic',
);

sub add_reason {
  my ( $self, $heuristic_name, $heuristic_result, $context ) = @_;
  $context ||= {};
  $context->{heuristic} = $heuristic_name;
  $context->{result}    = $heuristic_result;

  for my $type ( sort keys %type_map ) {
    if ( $heuristic_name->isa($type) ) {
      $context->{type} = $type_map{$type};
    }
  }
  push @{ $self->reasons }, $context;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Result - Result container

=head1 VERSION

version 0.4.1

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
