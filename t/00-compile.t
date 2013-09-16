use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.030

use Test::More  tests => 15 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Path/IsDev.pm',
    'Path/IsDev/Heuristic.pm',
    'Path/IsDev/Heuristic/Changelog.pm',
    'Path/IsDev/Heuristic/DevDirMarker.pm',
    'Path/IsDev/Heuristic/META.pm',
    'Path/IsDev/Heuristic/MYMETA.pm',
    'Path/IsDev/Heuristic/Makefile.pm',
    'Path/IsDev/Heuristic/TestDir.pm',
    'Path/IsDev/Heuristic/Tool/Dzil.pm',
    'Path/IsDev/Heuristic/Tool/MakeMaker.pm',
    'Path/IsDev/Heuristic/Tool/ModuleBuild.pm',
    'Path/IsDev/Heuristic/VCS/Git.pm',
    'Path/IsDev/HeuristicSet.pm',
    'Path/IsDev/HeuristicSet/Basic.pm',
    'Path/IsDev/Object.pm'
);



# no fake home requested

use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stdin = '';     # converted to a gensym by open3
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, qq{$^X -Mblib -e"require q[$lib]"});
    binmode $stderr, ':crlf' if $^O; # eq 'MSWin32';
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (my @_warnings = <$stderr>)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


