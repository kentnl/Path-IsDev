use strict;
use warnings;

package Path::IsDev::Result;
BEGIN {
  $Path::IsDev::Result::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Result::VERSION = '0.5.1';
}

# ABSTRACT: Result container




use Class::Tiny 'path', 'result', {
  reasons => sub { [] }
};

sub _path  { require Path::Tiny; goto &Path::Tiny::path }
sub _croak { require Carp;       goto &Carp::croak }


sub BUILD {
  my ( $self, $args ) = @_;
  if ( not $self->path ) {
    return _croak(q[<path> is a mandatory parameter]);
  }
  if ( not ref $self->path ) {
    $self->path( _path( $self->path ) );
  }
  if ( not -e $self->path ) {
    return _croak(q[<path> parameter must exist for heuristics to be performed]);
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
  return $self;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Result - Result container

=head1 VERSION

version 0.5.1

=head1 SYNOPSIS

    use Path::IsDev::Result;

    my $result = Path::IsDev::Result->new( path => '/some/path/that/exists' ):

    if ( $heuristcset->matches( $result ) ) {
        print Dumper($result);
    }

=head1 DESCRIPTION

This is a reasonably new internal component for Path::IsDev.

Its purpose is to communicate state between internal things, and give some sort of introspectable
context for why things happened in various places without resorting to spamming debug everywhere.

Now instead of turning on debug, as long as you can get a result, you can inspect and dump that result
at the point you need it.

=head1 METHODS

=head2 C<BUILD>

=head2 C<add_reason>

Call this method from a heuristic to record checking of the heuristic
and the relevant meta-data.

    $result->add_reason( $heuristic, $matchvalue, \%contextinfo );

=head1 ATTRIBUTES

=head2 C<path>

=head2 C<result>

=head2 C<reasons>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Result",
    "interface":"class",
    "inherits":"Class::Tiny::Object"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
