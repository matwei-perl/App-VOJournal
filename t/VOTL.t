#! perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    use_ok( 'App::VOJournal::VOTL' ) || print "Bail out!\n";
}

diag( "Testing App::VOJournal::VOTL $App::VOJournal::VOTL::VERSION, Perl $], $^X" );

my $votl = App::VOJournal::VOTL->new();

ok(1 == $votl->read_file('t/otl/TODO.otl'));

done_testing;
