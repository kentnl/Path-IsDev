use strict;
use warnings;

package Path::IsDev::Object;
BEGIN {
  $Path::IsDev::Object::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Object::VERSION = '0.1.2';
}

# ABSTRACT: Object Oriented guts for C<IsDev> export



use Moo;

our $ENV_KEY_DEFAULT = 'PATH_ISDEV_DEFAULT_SET';
our $DEFAULT =
  ( exists $ENV{$ENV_KEY_DEFAULT} ? $ENV{$ENV_KEY_DEFAULT} : 'Basic' );


has 'set' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    return $DEFAULT;
  }
);


has 'set_prefix' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    return 'Path::IsDev::HeuristicSet';
  }
);


has 'set_module' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    require Module::Runtime;
    Module::Runtime::compose_module_name( $_[0]->set_prefix => $_[0]->set );
  }
);


has 'loaded_set_module' => (
  is      => ro =>,
  lazy    => 1,
  builder => sub {
    require Module::Runtime;
    return Module::Runtime::use_module( $_[0]->set_module );
  }
);


sub matches {
  my ( $self, $path ) = @_;
  return $self->loaded_set_module->matches($path);
}

no Moo;

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Object - Object Oriented guts for C<IsDev> export

=head1 VERSION

version 0.1.2

=head1 SYNOPSIS

    use Path::IsDev::Object;

    my $dev = Path::IsDev::Object->new(); 
    my $dev = Path::IsDev::Object->new( set => 'MySet' );

    if ( $dev->matches($path) ){
        print "$path is dev";
    }

=head1 DESCRIPTION

Exporting functions is handy for end users, but quickly
becomes a huge headache when you're trying to chain them.

ie: If you're writing an exporter yourself, and you want to wrap
responses from an exported symbol, while passing through user
configuration => Huge headache.

So the exporter based interface is there for people who don't need anything fancy,
while the Object based interface is there for people with more complex requirements.

=head1 METHODS

=head2 C<matches>

Determine if a given path satisfies the C<set>

    if( $o->matches($path) ){
        print "We have a match!";
    }

=head1 ATTRIBUTES

=head2 C<set>

The name of the C<HeuristicSet::> to use.

Default is C<Basic>, or the value of C<$ENV{PATH_ISDEV_DEFAULT_SET}>

=head2 C<set_prefix>

The C<HeuristicSet> prefix to use to expand C<set> to a module name.

Default is C<Path::IsDev::HeuristicSet>

=head2 C<set_module>

The fully qualified module name.

Composed by joining C<set> and C<set_prefix>

=head2 C<loaded_set_module>

An accessor which returns a module name after loading it.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Object",
    "interface":"class",
    "inherits":"Moo::Object"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
