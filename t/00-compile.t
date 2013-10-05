use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.033

use Test::More  tests => 18 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



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
    'Path/IsDev/NegativeHeuristic.pm',
    'Path/IsDev/NegativeHeuristic/IsDev/IgnoreFile.pm',
    'Path/IsDev/Object.pm',
    'Path/IsDev/Result.pm'
);



# no fake home requested

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, '-Mblib', '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


