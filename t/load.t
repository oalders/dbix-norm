use strict;
use warnings;

use DBIx::Norm;
use Test2::V0;

my $norm = DBIx::Norm->new;
ok( $norm, 'compiles' );

my ( $sql, @bind ) = $norm->to_sql(
    'select', '*', 'activity_log',
    { id => { '>' => 100 } }
);
is( $sql, q{SELECT * FROM activity_log WHERE ( id > ? )}, 'SELECT' );
is( \@bind, [100], 'bind' );

done_testing();
