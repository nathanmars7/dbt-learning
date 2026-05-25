{{ config(materialized='table') }}

with trips as (

    select * from {{ ref('stg_taxi_trips') }}

),

final as (

    select
        company,
        count(taxi_id)                                      as total_trips,
        {{ round_money('avg(fare)') }}                      as avg_fare,
        {{ round_money('avg(tips)') }}                      as avg_tip,
        {{ round_money('sum(trip_total)') }}                as total_revenue,
        {{ safe_divide('sum(tips)', 'sum(fare)') }}         as tip_to_fare_ratio
    from trips
    where company is not null
    group by company
    order by total_trips desc

)

select * from final