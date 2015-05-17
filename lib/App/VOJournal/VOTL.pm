package App::VOJournal::VOTL;
#
# vim: set sw=4 ts=4 tw=76 et ai si:
#
# Author Mathias Weidner <mamawe@cpan.org>
# Version 0.1
# Copyright (C) 2015 user <user@work>
# Modified On 2015-05-15 22:18
# Created  2015-05-15 22:18
#
use strict;
use warnings;

=head1 NAME

App::VOJournal::VOTL - deal with vimoutliner files

=head1 VERSION

Version 0.2.0

=cut

use version; our $VERSION = qv('0.2.0');

=head1 SYNOPSIS

    use App::VOJournal::VOTL;

    my $votl = App::VOJournal::VOTL->new();

    $votl->read_file($infilename);

    $votl->write_file($outfilename);

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new
{
    my $class = shift;
    my $arg = shift;
    my $self = {};

    $self->{objects} = [];

    bless($self, $class);
    return $self;
}

=head2 read_file

Reads a vimoutliner file.

    $votl->read_file( $filename );

=cut

sub read_file {
    my ($self,$filename) = @_;

    if (open my $input, '<', $filename) {
        $self->{objects} = [];
        while (<$input>) {
            if (/^(\t*)([:;|<>])(.*)$/) {
                $self->_add_something($1, {
                    children => [],
                    type => $2,
                    value => $3
                });
            }
            elsif (/^(\t*)([^\t].*)$/) {
                $self->_add_something($1, {
                    children => [],
                    type => '',
                    value => $2
                });
            }
            else {
                die "unknown line: $_";
            }
        }
        close $input;
        return 1 + $#{$self->{objects}};
    }
    return;
} # read_file()

=head2 write_file

Writes a vimoutliner file.

    $votl->write_file( $filename );

=cut

sub write_file {
    my ($self,$filename) = @_;

    if (open my $output, '>', $filename) {
        foreach my $object (@{$self->{objects}}) {
            _write_object($object,0,$output);
        }
        close $output;
    }
} # write_file()

sub _add_something {
    my ($self,$tabs,$newobject) = @_;
    my $indent = length $tabs;
    my $objects = $self->_descend_objects($indent);
    push @$objects, $newobject;
} # _add_something()

sub _descend_objects {
    my ($self,$indent) = @_;
    my $objects = $self->{objects};

    while (0 < $indent) {
        if (0 > $#$objects) {
            my $newobject = {
                children => [],
            };
            push @$objects, $newobject;
            $objects = $newobject->{children};
        }
        else {
            $objects = $objects->[$#$objects]->{children};
        }
        $indent--;
    }
    return $objects;
} # _descend_objects()

sub _write_object {
    my ($object,$indent,$outfh) = @_;

    print $outfh "\t" x $indent, $object->{type}, $object->{value}, "\n";

    foreach my $co (@{$object->{children}}) {
        _write_object($co,$indent + 1,$outfh);
    }
} # _write_object()

1;
# __END__
# # Below is stub documentation for your module. You'd better edit it!
