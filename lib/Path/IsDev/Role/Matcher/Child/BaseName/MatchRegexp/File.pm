use strict;
use warnings;

package Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File;
BEGIN {
  $Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File::VERSION = '1.000000';
}

use Role::Tiny;
with 'Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp';


sub _this_child_isfile {
  my ( $self, $result_object, $child ) = @_;
  my $ctx = { 
        'child' => "$child", 
        tests => [] 
  };
  my $tests = $ctx->{tests};

  if ( -f $child ) {
    push @{$tests} , { 'child_isfile?' => 1 };
    $result_object->add_reason( $self, 1, "$child is a file", $ctx );
    return 1;
  }
   push @{$tests} , { 'child_isfile?' => 0 };
   $result_object->add_reason( $self, 0, "$child is not a file", $ctx );

  return;
}

sub child_basename_matchregexp_file {
  my ( $self, $result_object, $regexp ) = @_;
  for my $child ( $result_object->path->children ) {
    return 1
      if $self->_this_child_matchregexp( $result_object, $child, $regexp )
      and $self->_this_child_isfile( $result_object, $child );
  }
  return;

}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File

=head1 VERSION

version 1.000000

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File",
    "interface":"role",
    "does":"Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
