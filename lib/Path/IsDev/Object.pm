use strict;
use warnings;

package Path::IsDev::Object;

# ABSTRACT: Object Oriented guts for C<IsDev> export

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Object",
    "interface":"class",
    "inherits":"Moo::Object"
}

=end MetaPOD::JSON

=cut

=head1 DESCRIPTION

Exporting functions is handy for end users, but quickly
becomes a huge headache when you're trying to chain them.

e.g: If you're writing an exporter yourself, and you want to wrap
responses from an exported symbol, while passing through user
configuration => Huge headache.

So the exporter based interface is there for people who don't need anything fancy,
while the Object based interface is there for people with more complex requirements.

=head1 SYNOPSIS

    use Path::IsDev::Object;

    my $dev = Path::IsDev::Object->new();
    my $dev = Path::IsDev::Object->new( set => 'MySet' );

    if ( $dev->matches($path) ){
        print "$path is dev";
    }

=cut

our $ENV_KEY_DEBUG = 'PATH_ISDEV_DEBUG';
our $DEBUG = ( exists $ENV{$ENV_KEY_DEBUG} ? $ENV{$ENV_KEY_DEBUG} : undef );

our $ENV_KEY_DEFAULT = 'PATH_ISDEV_DEFAULT_SET';
our $DEFAULT =
  ( exists $ENV{$ENV_KEY_DEFAULT} ? $ENV{$ENV_KEY_DEFAULT} : 'Basic' );

=attr C<set>

The name of the C<HeuristicSet::> to use.

Default is C<Basic>, or the value of C<$ENV{PATH_ISDEV_DEFAULT_SET}>

=cut

use Class::Tiny {
  set        => sub { $DEFAULT },
  set_prefix => sub { 'Path::IsDev::HeuristicSet' },
  set_module => sub {
    require Module::Runtime;
    return Module::Runtime::compose_module_name( $_[0]->set_prefix => $_[0]->set );
  },
  loaded_set_module => sub {
    require Module::Runtime;
    return Module::Runtime::use_module( $_[0]->set_module );
  },
};

=attr C<set_prefix>

The C<HeuristicSet> prefix to use to expand C<set> to a module name.

Default is C<Path::IsDev::HeuristicSet>

=attr C<set_module>

The fully qualified module name.

Composed by joining C<set> and C<set_prefix>

=attr C<loaded_set_module>

An accessor which returns a module name after loading it.

=cut

my $instances   = {};
my $instance_id = 0;

=p_method C<_instance_id>

An opportunistic sequence number for help with debug messages.

Note: This is not guaranteed to be unique per instance, only guaranteed
to be constant within the life of the object.

Based on C<refaddr>, and giving out new ids when new C<refaddr>'s are seen.

=cut

sub _instance_id {
  my ($self) = @_;
  require Scalar::Util;
  my $addr = Scalar::Util::refaddr($self);
  return $instances->{$addr} if exists $instances->{$addr};
  $instances->{$addr} = sprintf '%x', $instance_id++;
  return $instances->{$addr};
}

=p_method C<_debug>

The debugger callback.

    export PATH_ISDEV_DEBUG=1

to get debug info.

=cut

sub _debug {
  my ( $self, $message ) = @_;

  return unless $DEBUG;
  my $id = $self->_instance_id;
  return *STDERR->printf( qq{[Path::IsDev=%s] %s\n}, $id, $message );
}

=p_method C<BUILD>

C<BUILD> is an implementation detail of C<Moo>/C<Moose>.

This module hooks C<BUILD> to give a self report of the object
to C<*STDERR> after C<< ->new >> when under C<$DEBUG>

=cut

sub BUILD {
  my ($self) = @_;
  return $self unless $DEBUG;
  $self->_debug('{');
  $self->_debug( ' set               => ' . $self->set );
  $self->_debug( ' set_prefix        => ' . $self->set_prefix );
  $self->_debug( ' set_module        => ' . $self->set_module );
  $self->_debug( ' loaded_set_module => ' . $self->loaded_set_module );
  $self->_debug('}');
  return $self;
}

=method C<matches>

Determine if a given path satisfies the C<set>

    if( $o->matches($path) ){
        print "We have a match!";
    }

=cut

sub matches {
  my ( $self, $path ) = @_;
  $self->_debug( 'Matching ' . $path );
  my $result;
  {
    require Path::IsDev;
    ## no critic (ProhibitNoWarnings)
    no warnings 'redefine';
    local *Path::IsDev::debug = sub {
      $self->_debug(@_);
    };
    $result = $self->loaded_set_module->matches($path);
  }
  if ( not $result ) {
    $self->_debug('no match found');
  }
  return $result;
}

1;
