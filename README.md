# NAME

DBIx::Norm - Norm is Not an ORM

# VERSION

version 0.001

## to\_sql

    my $stmt = $norm->to_sql( 'select', '*', 'activity_log', { id => { '>' => 100 } });

# AUTHOR

Olaf Alders <olaf@wundercounter.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Olaf Alders.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
