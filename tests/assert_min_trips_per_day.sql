-- This test fails if any day has fewer than 100 trips
-- dbt expects this query to return 0 rows if the test passes

select
    trip_date,
    total_trips
from {{ ref('mart_taxi_trips_daily') }}
where total_trips < 100