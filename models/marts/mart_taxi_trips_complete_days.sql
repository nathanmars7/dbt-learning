{{ config(materialized='table') }}

with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2023-01-01' as date)",
        end_date="cast('2024-01-01' as date)"
    ) }}

),

trips as (

    select * from {{ ref('mart_taxi_trips_daily') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['date_spine.date_day']) }} as surrogate_key,
        date_spine.date_day                                              as trip_date,
        coalesce(trips.total_trips, 0)                                   as total_trips,
        coalesce(trips.avg_fare, 0)                                      as avg_fare,
        coalesce(trips.avg_tip, 0)                                       as avg_tip,
        coalesce(trips.total_revenue, 0)                                 as total_revenue
    from date_spine
    left join trips
        on date_spine.date_day = trips.trip_date

)

select * from final