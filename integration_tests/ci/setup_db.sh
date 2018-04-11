
#!/bin/bash
set -x

createdb dbt
psql -c "CREATE ROLE root WITH PASSWORD 'password';"
psql -c "ALTER ROLE root WITH LOGIN;"
psql -c "GRANT CREATE, CONNECT ON DATABASE dbt TO root;"

set +x
