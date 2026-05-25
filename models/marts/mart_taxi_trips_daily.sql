{{ config(materialized='table') }}

with trips as (

    select * from {{ ref('stg_taxi_trips') }}

),

final as (

    select
        trip_date,
        count(taxi_id)              as total_trips,
        round(avg(fare), 2)         as avg_fare,
        round(avg(tips), 2)         as avg_tip,
        round(sum(trip_total), 2)   as total_revenue
    from trips
    group by trip_date
    order by trip_date

)

select * from final