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

ok(1 == $votl->read_file('t/otl/TODO.otl'),'number of top level elements');

$votl->write_file('t/otl/TODO.otl-out');

ok(0 == diff_files('t/otl/TODO.otl','t/otl/TODO.otl-out'),'compare read and written file');

unlink 't/otl/TODO.otl-out';

# test detection of checkboxes
#
my $ub = $votl->{objects}->[0];
my $cb = $votl->{objects}->[0]->{children}->[2];

ok(App::VOJournal::VOTL::_unchecked_box($ub),'unchecked box');
ok(! App::VOJournal::VOTL::_unchecked_box($cb),'not unchecked box');

ok(App::VOJournal::VOTL::_checked_box($cb),'checked box');
ok(! App::VOJournal::VOTL::_checked_box($ub),'not checked box');

done_testing;

sub diff_files {
	my ($fn1,$fn2) = @_;
	my $diff = 0;
	if (open my $in1, '<', $fn1) {
		if (open my $in2, '<', $fn2) {
			my @lines1 = <$in1>;
			my @lines2 = <$in2>;
			close $in2;
			if (scalar @lines1 <=> scalar @lines2) {
				$diff = 1;
			}
			else {
				for (my $i = 0; $i <= $#lines1; $i++) {
					if ($lines1[$i] cmp $lines2[$i]) {
						$diff = 1;
						last;
					}
				}
			}
		}
		else {
			$diff = 1;
		}
		close $in1;
	}
	elsif (open my $in2,'<', $fn2) {
		$diff = 1;
	}
	return $diff;
}
