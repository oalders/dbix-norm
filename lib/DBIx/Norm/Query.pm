package DBIx::Norm::Query;

use Moo;

use SQL::Abstract ();
use Types::Standard qw( ArrayRef InstanceOf Str );

has dbh => (
    is  => 'ro',
    isa => InstanceOf ['DBI::db'],
);

has bind => (
    is      => 'ro',
    isa     => ArrayRef,
    lazy    => 1,
    default => sub { shift->_sql_with_bind->[1] },
);

has cols => (
    is => 'ro',
);

has order => (
    is => 'ro',
);

has query_type => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has source => (
    is => 'ro',
);

has sql => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_sql_with_bind->[0] },
);

has _sql_with_bind => (
    is      => 'ro',
    isa     => ArrayRef,
    lazy    => 1,
    builder => '_build_sql_with_bind',
);

has values => (
    is => 'ro',
);

has where => (
    is => 'ro',
);

sub _build_sql_with_bind {
    my $self = shift;

    if ( $self->query_type eq 'select' ) {

        my ( $sql, @bind ) = SQL::Abstract->new->select(
            $self->source, $self->cols,
            $self->where,  $self->order
        );
        return [ $sql, \@bind ];
    }

    if ( $self->query_type eq 'insert' ) {

        my ( $sql, @bind ) = SQL::Abstract->new->insert(
            $self->source, $self->values,
        );
        return [ $sql, \@bind ];
    }
}

sub do {
    my $self = shift;
    return $self->dbh->do( $self->sql, undef, @{ $self->bind } );
}

sub select_all {
    my $self = shift;
    return $self->dbh->selectall_arrayref(
        $self->sql, { Slice => {} },
        @{ $self->bind }
    );
}

1;

# ABSTRACT: Norm is Not an ORM
