use strict;
use warnings;
package DBIx::Norm;

use Moo;

use SQL::Abstract ();
use Types::Standard qw( Str );

has dbh => (
    is  => 'ro',
    isa => Str,
);

=head2 to_sql

    my $stmt = $norm->to_sql( 'select', '*', 'activity_log', { id => { '>' => 100 } });

=cut

sub to_sql {
    my $self   = shift;
    my $method = shift;    # select/insert/update/delete
    my $cols   = shift;
    my $tables = shift;
    my $where  = shift || {};
    my $order  = shift;

    my ($stmt, @bind) = SQL::Abstract->new->$method( $tables, $cols, $where, $order );
    return $stmt, @bind;
}

1;

# ABSTRACT: Norm is Not an ORM
