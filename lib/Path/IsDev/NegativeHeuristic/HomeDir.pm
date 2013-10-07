
use strict;
use warnings;
 
package Path::IsDev::NegativeHeuristic::HomeDir;
BEGIN {
  $Path::IsDev::NegativeHeuristic::HomeDir::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::NegativeHeuristic::HomeDir::VERSION = '0.6.1';
}

use Role::Tiny::With;

with 'Path::IsDev::Role::NegativeHeuristic::AnyDir';

sub _uniq { require List::MoreUtils; goto &List::MoreUtils::uniq }
sub _fhd  { require File::HomeDir; return 'File::HomeDir' }

sub excludes_dirs {
    my @out;
    for my  $dir (qw( home desktop docs music pics videos data )) {
        my $method = _fhd()->can("my_$dir");
        next unless $method;
        push @out, _fhd()->$method;
    }
    return _uniq(@out);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::NegativeHeuristic::HomeDir

=head1 VERSION

version 0.6.1

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
