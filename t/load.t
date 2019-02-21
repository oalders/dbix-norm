use strict;
use warnings;

use DBIx::Norm;
use Test2::V0;

my $norm = DBIx::Norm->new;
ok( $norm, 'compiles' );

my $query = $norm->select(
    '*',
    'user',
    { id => { '>' => 100 } },
    'first_name ASC'
);

is(
    $query->sql,
    q{SELECT * FROM user WHERE ( id > ? ) ORDER BY first_name ASC},
    'SELECT'
);
is( $query->bind, [100], 'bind' );

done_testing();
