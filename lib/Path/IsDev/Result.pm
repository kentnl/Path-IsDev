use 5.008;
use strict;
use warnings;
use utf8;

package Path::IsDev::Result;

our $VERSION = '1.001002';

# ABSTRACT: Result container

# AUTHORITY

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Result",
    "interface":"class",
    "inherits":"Class::Tiny::Object"
}

=end MetaPOD::JSON

=head1 SYNOPSIS

    use Path::IsDev::Result;

    my $result = Path::IsDev::Result->new( path => '/some/path/that/exists' ):

    if ( $heuristcset->matches( $result ) ) {
        print Dumper($result);
    }

=cut

=attr C<path>

=attr C<result>

=attr C<reasons>

=cut

use Class::Tiny 'path', 'result', { reasons => sub { [] }, };

sub _path  { require Path::Tiny; goto &Path::Tiny::path }
sub _croak { require Carp;       goto &Carp::croak }
## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
sub _debug { require Path::IsDev; shift; goto &Path::IsDev::debug }

=method C<BUILD>

=cut

sub BUILD {
  my ( $self, ) = @_;
  if ( not $self->path ) {
    return _croak(q[<path> is a mandatory parameter]);
  }
  if ( not ref $self->path ) {
    $self->path( _path( $self->path ) );
  }
  if ( not -e $self->path ) {
    return _croak(q[<path> parameter must exist for heuristics to be performed]);
  }
  $self->path( $self->path->absolute );
  return $self;
}

=method C<add_reason>

Call this method from a heuristic to record checking of the heuristic
and the relevant meta-data.

    $result->add_reason( $heuristic, $matchvalue, $reason_summary, \%contextinfo );

For example:

    sub Foo::matches  {
        my ( $self , $result_object ) = @_;
        if ( $result_object->path->child('bar')->exists ) {
            $result_object->add_reason( $self, 1, "child 'bar' exists" , {
                child => 'bar',
                'exists?' => 1,
                child_path => $result_object->path->child('bar')
            });
            $result_object->result(1);
            return 1;
        }
        return;
    }

Note that here, C<$matchvalue> should be the result of the relevant matching logic, not the global impact.

For instance, C<excludes> compositions should still add reasons of C<< $matchvalue == 1 >>, but they should not
set C<< $result_object->result(1) >>. ( In fact, setting C<result> is the job of the individual heuristic, not the matches
that are folded into it )

=cut

sub add_reason {
  my ( $self, $heuristic_name, $heuristic_result, $summary, $context ) = @_;
  my $name = $heuristic_name;
  if ( $name->can('name') ) {
    $name = $name->name;
  }
  $self->_debug("$name => $heuristic_result : $summary ");

  # $self->_debug( " > " . $_) for _pp($context);
  my ($heuristic_type);

  if ( $heuristic_name->can(q[heuristic_type]) ) {
    $heuristic_type = $heuristic_name->heuristic_type;
  }

  my $reason = {
    heuristic => $heuristic_name,
    result    => $heuristic_result,
    ( defined $heuristic_type ? ( type => $heuristic_type ) : () ),
    %{ $context || {} },
  };
  push @{ $self->reasons }, $reason;
  return $self;
}

1;

=head1 DESCRIPTION

This is a reasonably new internal component for Path::IsDev.

Its purpose is to communicate state between internal things, and give some sort of introspectable
context for why things happened in various places without resorting to spamming debug everywhere.

Now instead of turning on debug, as long as you can get a result, you can inspect and dump that result
at the point you need it.

=cut
