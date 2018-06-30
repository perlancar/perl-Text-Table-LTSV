package Text::Table::LTSV;

# DATE
# VERSION

#IFUNBUILT
use 5.010001;
use strict;
use warnings;
#END IFUNBUILT

sub _encode {
    my $val = shift;
    $val =~ s/\t/    /g;
    $val;
}

sub table {
    my %params = @_;
    my $rows = $params{rows} or die "Must provide rows!";

    my $max_index = _max_array_index($rows);

    my @labels;

    # here we go...
    my @table;

    # then the data
    my $i = 0;
    foreach my $row ( @{ $rows }[0..$#$rows] ) {
        $i++;
        if ($i==1) {
            for (@$row) {
                if (/\t|:/) {
                    die "Invalid label '$_', cannot contain tab or colon";
                }
            }
            @labels = @$row;
            next;
        }
        push @table, join(
	    "\t",
	    map { _encode("$labels[$_]:" . defined($row->[$_]) ? $row->[$_] : '') } (0..$max_index)
	), "\n";
    }

    return join("", grep {$_} @table);
}

# FROM_MODULE: PERLANCAR::List::Util::PP
# BEGIN_BLOCK: max
sub max {
    return undef unless @_;
    my $res = $_[0];
    my $i = 0;
    while (++$i < @_) { $res = $_[$i] if $_[$i] > $res }
    $res;
}
# END_BLOCK: max

# return highest top-index from all rows in case they're different lengths
sub _max_array_index {
    my $rows = shift;
    return max( map { $#$_ } @$rows );
}

1;
#ABSTRACT: Generate LTSV

=for Pod::Coverage ^(max)$

=head1 SYNOPSIS

 use Text::Table::LTSV;

 my $rows = [
     # header row
     ['Name', 'Rank', 'Serial'],
     # rows
     ['alice', 'pvt', '123456'],
     ['bob',   'cpl', '98765321'],
     ['carol', 'brig gen', '8745'],
 ];
 print Text::Table::LTSV::table(rows => $rows);


=head1 DESCRIPTION

This module provides a single function, C<table>, which formats a
two-dimensional array of data as LTSV. This is basically a way to generate LTSV
using the same interface as that of L<Text::Table::Tiny> (v0.03) or
L<Text::Table::Org>.

The example shown in the SYNOPSIS generates the following table (Tab might be
shown as spaces):

 Name:alice   Rank:pvt     Serial:123456
 Name:bob     Rank:cpl     Serial:98765321
 Name:carol   Rank:brig gen        Serial:8745


=head1 FUNCTIONS

=head2 table(%params) => str


=head2 OPTIONS

The C<table> function understands these arguments, which are passed as a hash.

=over

=item * rows (aoaos)

Takes an array reference which should contain one or more rows of data, where
each row is an array reference.

=back


=head1 SEE ALSO

L<http://ltsv.org>

L<Text::Table::Tiny>

See also L<Bencher::Scenario::TextTableModules>.

=cut
