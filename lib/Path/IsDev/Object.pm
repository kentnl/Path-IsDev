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

use Moo;

our $ENV_KEY_DEFAULT = 'PATH_ISDEV_DEFAULT_SET';
our $DEFAULT =
  ( exists $ENV{$ENV_KEY_DEFAULT} ? $ENV{$ENV_KEY_DEFAULT} : 'Basic' );

=attr C<set>

The name of the C<HeuristicSet::> to use.

Default is C<Basic>, or the value of C<$ENV{PATH_ISDEV_DEFAULT_SET}>

=cut

has 'set' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    return $DEFAULT;
  },
);

=attr C<set_prefix>

The C<HeuristicSet> prefix to use to expand C<set> to a module name.

Default is C<Path::IsDev::HeuristicSet>

=cut

has 'set_prefix' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    return 'Path::IsDev::HeuristicSet';
  },
);

=attr C<set_module>

The fully qualified module name.

Composed by joining C<set> and C<set_prefix>

=cut

has 'set_module' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    require Module::Runtime;
    Module::Runtime::compose_module_name( $_[0]->set_prefix => $_[0]->set );
  },
);

=attr C<loaded_set_module>

An accessor which returns a module name after loading it.

=cut

has 'loaded_set_module' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    require Module::Runtime;
    return Module::Runtime::use_module( $_[0]->set_module );
  },
);

=method C<matches>

Determine if a given path satisfies the C<set>

    if( $o->matches($path) ){
        print "We have a match!";
    }

=cut

sub matches {
  my ( $self, $path ) = @_;
  return $self->loaded_set_module->matches($path);
}

no Moo;

1;
