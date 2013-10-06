use strict;
use warnings;

package Path::IsDev::Role::Heuristic::AnyDir;
BEGIN {
  $Path::IsDev::Role::Heuristic::AnyDir::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Heuristic::AnyDir::VERSION = '0.6.1';
}

# ABSTRACT: Positive Heuristic if a path contains one of any of a list of directories


sub _debug { require Path::IsDev; goto &Path::IsDev::debug }

use Role::Tiny;


sub _matches_dirs {
  my ( $self, $result_object ) = @_;
  my $root = $result_object->path;
  for my $file ( $self->dirs ) {
    my $stat = $root->child($file);
    if ( -e $stat and -d $stat ) {
      _debug("$stat exists for $self");
      $result_object->add_reason( $self, 1, { 'dir_exists?' => $stat } );
      $result_object->result(1);
      return 1;
    }
    $result_object->add_reason( $self, 0, { 'dir_exists?' => $stat } );
  }
  $result_object->result(undef);
  return;
}


sub matches {
  my ( $self, $result_object ) = @_;
  return $self->_matches_dirs($result_object);
}

with 'Path::IsDev::Role::Heuristic';


requires 'dirs';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Heuristic::AnyDir - Positive Heuristic if a path contains one of any of a list of directories

=head1 VERSION

version 0.6.1

=head1 SYNOPSIS

    package Some::Heuristic;
    use Role::Tiny::With;
    with 'Path::IsDev::Role::Heuristic::AnyDir';

    # Match if $PATH contains any of the named children as dirs
    sub dirs {
        return qw( .git .build )
    }

    1;

=head1 ROLE REQUIRES

=head2 C<dirs>

Any consuming classes must implement this method

    returns : A list of directory basenames to match

=head1 METHODS

=head2 C<matches>

Implements L<< C<matches> for C<Path::IsDev::Role::Heuristic>|Path::IsDev::Role::Heuristic/matches >>

    if ( $class->matches($result_object) ) {
      # one of the items in $class->dirs matched a directory
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
    "namespace":"Path::IsDev::Role::Heuristic::AnyDir",
    "interface":"role",
    "does":"Path::IsDev::Role::Heuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
