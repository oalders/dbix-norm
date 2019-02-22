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
    'insert first user'
);

is( $norm->select( '*', 'user' )->select_all, [ \%user ], 'empty set' );

my %second_user = (
    first_name => 'Peter',
    last_name  => 'Hook',
);

is(
    $norm->insert( 'user', \%second_user )->do,
    1,
    'insert second user'
);

is(
    $norm->select( '*', 'user', undef, 'first_name ASC' )->select_all,
    [ \%second_user, \%user ], 'empty set'
);

subtest 'do_as_sql' => sub {
    my $expected = <<'EOF';
$dbh->do(
    <<'SQL', {}, 'Peter', 'Hook' );
INSERT INTO user ( first_name, last_name) VALUES ( ?, ? )
SQL
EOF

    my $do_as_sql = $norm->insert( 'user', \%second_user )->do_as_sql;
    is( $do_as_sql, $expected, 'do_as_sql' );

    my $literal_bind
        = $norm->insert( 'user', \%second_user )->do_as_sql( ['@bind'] );
    my $expected_literal_bind = <<'EOF';
$dbh->do(
    <<'SQL', {}, @bind );
INSERT INTO user ( first_name, last_name) VALUES ( ?, ? )
SQL
EOF

    is(
        $literal_bind, $expected_literal_bind,
        'do_as_sql with literal bind'
    );
};

subtest select_all_as_sql => sub {
    my $expected = <<'EOF';
$dbh->selectall_arrayref(
    <<'SQL', { Slice => {} },  );
SELECT count(*) FROM log WHERE ( created_at IS NOT NULL )
SQL
EOF

    my $query = $norm->select(
        'count(*)', 'log',
        { created_at => { '!=' => undef } }
    );
    is( $query->select_all_as_sql, $expected, 'query matches' );
};

done_testing();
