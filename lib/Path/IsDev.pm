use strict;
use warnings;

package Path::IsDev;
BEGIN {
  $Path::IsDev::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::VERSION = '0.1.0';
}

# ABSTRACT: Determine if a given Path resembles a development source tree




use Sub::Exporter -setup => { exports => [ is_dev => \&_build_is_dev, ], };

sub _croak      { require Carp;            goto &Carp::croak }
sub _use_module { require Module::Runtime; goto &Module::Runtime::use_module }

sub _compose_module_name {
  require Module::Runtime;
  goto &Module::Runtime::compose_module_name;
}

our $ENV_KEY_DEFAULT = 'PATH_ISDEV_DEFAULT_SET';
our $ENV_KEY_DEBUG   = 'PATH_ISDEV_DEBUG';
our $DEFAULT         = ( exists $ENV{$ENV_KEY_DEFAULT} ? $ENV{$ENV_KEY_DEFAULT} : 'Basic' );
our $DEBUG           = ( exists $ENV{$ENV_KEY_DEBUG} ? $ENV{$ENV_KEY_DEBUG} : undef );

sub _expand_set {
  my $set = shift;
  return _compose_module_name( 'Path::IsDev::HeuristicSet', $set );
}

sub _get_set {
  my $set = shift;
  return _use_module($set)->_modules_loaded;
}

sub _shorten_module_name {
  my $name = shift;
  $name =~ s/^Path::IsDev::Heuristic:/:/;
  return $name;
}

sub _debug {
  return unless $DEBUG;
  return *STDERR->printf( q{[Path::IsDev] %s}, $_[0] );
}

sub _build_is_dev {
  my ( $class, $name, $arg ) = @_;

  my $set;
  if ( not $arg->{set} ) {
    $set = $DEFAULT;
  }
  else {
    $set = $arg->{set};
  }
  my $set_class = _expand_set($set);
  my (@modules) = _get_set($set_class);
  return sub {
    my ($path) = @_;
    for my $module (@modules) {
      if ( $module->matches($path) ) {
        my $name;
        if ( $module->can('name') ) {
          $name = $module->name;
        }
        else {
          $name = _shorten_module_name($module);
        }
        _debug( $name . q[ matched path ] . $path );
        return 1;
      }
    }
    _debug( ' no matches for path ' . $path );
    return;
  };
}


*is_dev = _build_is_dev( 'Path::IsDev', 'is_dev', {} );

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev - Determine if a given Path resembles a development source tree

=head1 VERSION

version 0.1.0

=head1 SYNOPSIS

    use Path::IsDev qw(is_dev);

    if( is_dev('/some/path') ) {
        ...
    } else {
        ...
    }

=head1 DESCRIPTION

This module is more or less a bunch of heuristics for determining if a given path
is a development tree root of some kind.

This has many useful applications, notably ones that require behaviours for "installed"
modules to be different to those that are still "in development" 

=head1 METHODS

=head2 is_dev

Using an C<import>'ed C<is_dev>:

    if( is_dev( $path ) ) {

    }

Though the actual heuristics used will be based on how C<import> was called.

Additionally, you can call 

    Path::IsDev::is_dev

without C<import>ing anything, and it will behave exactly the same as if you'd imported
it using 

    use Path::IsDev qw( is_dev );

That is, no C<set> specification is applicable, so you'll only get the "default".

=head1 ADVANCED USAGE

=head2 Custom Sets

C<Path::IsDev> has a system of "sets" of Heuristics, in order to allow for plugable
and flexible heuristic types.

Though, for the vast majority of cases, this is not required.

    use Path::IsDev is_dev => { set => 'Basic' };
    use Path::IsDev is_dev => { set => 'SomeOtherSet' , -as => 'is_dev_other' };

=head2 Overriding the default set

If for whatever reason the C<Basic> set is insufficient, or if it false positives on your system for some reason,
the "default" set can be overridden.

    export PATH_ISDEV_DEFAULT_SET="SomeOtherSet"

    ...
    use Path::IsDev qw( is_dev );
    is_dev('/some/path') # uses SomeOtherSet

Though this will only take priority in the event the set is not specified during C<import>

If this poses a security concern for the user, then this security hole can be eliminated by declaring the set you want in code:

    export PATH_ISDEV_DEFAULT_SET="SomeOtherSet"

    ...
    use Path::IsDev  is_dev => { set => 'Basic' };
    is_dev('/some/path') # uses Basic, regardless of ENV 

=head1 SECURITY

Its conceivable, than an evil user could construct an evil set, containing arbitrary and vulnerable code,
and possibly stash that evil set in a poorly secured priveleged users @INC 

And if they managed to achieve that, if they could poison the priveleged users %ENV, they could trick the priveleged user into executing arbitrary code.

Though granted, if you can do either of those 2 things, you're probably security vulnerable anyway, and granted, if you could do either of those 2 things you could do much more evil things by the following:

    export PERL5OPT="-MEvil::Module"

So with that in understanding, saying this modules default utility is "insecure" is mostly a bogus argument.

And to that effect, this module does nothing to "lock down" that mechanism, and this module encourages you
to B<NOT> force a set, unless you B<NEED> to, and strongly suggests that forcing a set for the purpose of security will achieve no real improvement in security, while simultaneously reducing utility.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev",
    "interface":"exporter"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
