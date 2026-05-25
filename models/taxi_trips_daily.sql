{{ config(materialized='table') }}

with source as (

    select
        DATE(trip_start_timestamp) as trip_date,
        taxi_id,
        fare,
        tips,
        trip_total
    from `bigquery-public-data.chicago_taxi_trips.taxi_trips`
    where trip_start_timestamp is not null
        and trip_start_timestamp >= '2023-01-01'
        and trip_start_timestamp < '2024-01-01'

),

final as (

    select
        trip_date,
        count(taxi_id)              as total_trips,
        round(avg(fare), 2)         as avg_fare,
        round(avg(tips), 2)         as avg_tip,
        round(sum(trip_total), 2)   as total_revenue
    from source
    group by trip_date
    order by trip_date

)

select * from final