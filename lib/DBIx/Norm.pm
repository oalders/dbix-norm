use strict;
use warnings;
package DBIx::Norm;

our $VERSION = '0.000001';

use Moo;

use DBIx::Norm::Query ();
use Types::Standard qw( InstanceOf );

has dbh => (
    is  => 'ro',
    isa => InstanceOf ['DBI::db'],
);

sub delete {
    my $self   = shift;
    my $source = shift;
    my $values = shift;

    return DBIx::Norm::Query->new(
        $self->dbh ? ( dbh => $self->dbh ) : (),
        query_type => 'delete',
        source     => $source,
        values     => $values,
    );
}

sub insert {
    my $self   = shift;
    my $source = shift;
    my $values = shift;

    return DBIx::Norm::Query->new(
        $self->dbh ? ( dbh => $self->dbh ) : (),
        query_type => 'insert',
        source     => $source,
        values     => $values,
    );
}

sub select {
    my $self   = shift;
    my $cols   = shift;
    my $source = shift;
    my $where  = shift;
    my $order  = shift;

    return DBIx::Norm::Query->new(
        cols => $cols,
        $self->dbh ? ( dbh => $self->dbh ) : (),
        order      => $order,
        query_type => 'select',
        source     => $source,
        where      => $where,
    );
}

sub update {
    my $self   = shift;
    my $source = shift;
    my $values = shift;
    my $where  = shift;

    return DBIx::Norm::Query->new(
        $self->dbh ? ( dbh => $self->dbh ) : (),
        query_type => 'update',
        source     => $source,
        values     => $values,
        where      => $where,
    );
}

1;

# ABSTRACT: Norm is Not an ORM
