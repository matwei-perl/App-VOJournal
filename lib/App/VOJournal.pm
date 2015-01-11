package App::VOJournal;

# vim: set sw=4 ts=4:

use 5.006;
use strict;
use warnings FATAL => 'all';

=head1 NAME

App::VOJournal - The great new App::VOJournal!

=head1 VERSION

Version 0.1.0

=cut

use version; our $VERSION = qv('0.1.0');

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use App::VOJournal;

    App::VOJournal->run;

or, on the command line

  perl -MApp::VOJournal -e App::VOJournal->run

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 run

=cut

sub run {
    my $basedir = qq($ENV{HOME}/journal);
    my $vim = 'vim';

    my ($day,$month,$year) = (localtime)[3,4,5];

    $year += 1900;
    $month += 1;

    my $path = sprintf("%s/%4.4d/%2.2d/%4.4d%2.2d%2.2d.otl",
                       $basedir, $year, $month, $year, $month, $day);
    _make_dir($path);
    system($vim, $path);
    return $?;
} # run()

# _make_dir($path)
#
# verify that all directories up to the last '/' in $path exist and
# create the missing directories.
#
# May die, if unable to create a directory.
#
sub _make_dir {
    my ($path) = @_;

    my $dir = '';

    while ($path =~ s{^([^/]*)/}{}) {
        if ($1) {
            $dir .= $1;
            (-d $dir)
             || mkdir($dir, 0777)
             || die qq(can't mkdir $dir);
            $dir .= '/';
        }
        else {
            $dir = '/' unless ($dir);
        }
    }
} # _make_dir()

=head1 AUTHOR

Mathias Weidner, C<< <mamawe at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-vojournal at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-VOJournal>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::VOJournal


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-VOJournal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-VOJournal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-VOJournal>

=item * Search CPAN

L<http://search.cpan.org/dist/App-VOJournal/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Mathias Weidner.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of App::VOJournal
