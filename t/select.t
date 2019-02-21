use strict;
use warnings;

use DBI        ();
use DBIx::Norm ();
use Test2::V0;
use Test::Needs qw( DBD::SQLite );

my $dbh = DBI->connect('dbi:SQLite:dbname=:memory:');

my $schema = <<'SQL';
CREATE TABLE user(
first_name text NOT NULL,
last_name test NOT NULL
)
SQL

is( $dbh->do($schema), '0E0', 'create schema' );

my $norm = DBIx::Norm->new( dbh => $dbh );

is( $norm->select( '*', 'user' )->select_all, [], 'empty set' );
my %user = (
    first_name => 'Siouxsie',
    last_name  => 'Sioux',
);

is(
    $norm->insert( 'user', \%user )->do,
    1,
    'insert'
);

is( $norm->select( '*', 'user' )->select_all, [ \%user ], 'empty set' );

my %second_user = (
    first_name => 'Peter',
    last_name  => 'Hook',
);

is(
    $norm->insert( 'user', \%second_user )->do,
    1,
    'insert'
);

is(
    $norm->select( '*', 'user', undef, 'first_name ASC' )->select_all,
    [ \%second_user, \%user ], 'empty set'
);

done_testing();
