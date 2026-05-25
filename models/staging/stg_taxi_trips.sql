{{ config(materialized='view') }}

with source as (

    select * from `bigquery-public-data.chicago_taxi_trips.taxi_trips`

),

renamed as (

    select
        taxi_id,
        trip_start_timestamp,
        trip_end_timestamp,
        DATE(trip_start_timestamp)  as trip_date,
        trip_seconds,
        trip_miles,
        fare,
        tips,
        trip_total,
        payment_type,
        company
    from source
    where trip_start_timestamp is not null
        and trip_start_timestamp >= '2023-01-01'
        and trip_start_timestamp < '2024-01-01'

)

select * from renamed