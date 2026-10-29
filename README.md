# dbt Learning Project

A dbt Core project on Google BigQuery that turns the public Chicago taxi trips dataset (2023 only) into a staging view and four marts, with YAML tests, a singular test, two small macros and an incremental model. Built to practise dbt conventions on real data.

## At a glance

| | |
|---|---|
| Stack | dbt Core 1.11, dbt-bigquery, dbt_utils 1.3.3 |
| Warehouse | Google BigQuery |
| Data | `bigquery-public-data.chicago_taxi_trips.taxi_trips`, filtered to trips starting in 2023 |
| What it shows | Staging and marts layering, generic and singular tests, an incremental model, macros, `dbt_utils.date_spine` and `generate_surrogate_key`, source freshness |
| Status | Portfolio project, complete. Last verified 2026-05 from the repo contents. |

## Project structure

    models/
    ├── staging/
    │   ├── sources.yml
    │   ├── schema.yml
    │   └── stg_taxi_trips.sql
    └── marts/
        ├── schema.yml
        ├── mart_taxi_trips_daily.sql
        ├── mart_taxi_trips_daily_incremental.sql
        ├── mart_taxi_trips_by_company.sql
        └── mart_taxi_trips_complete_days.sql
    macros/
    └── money_helpers.sql
    tests/
    └── assert_min_trips_per_day.sql
    dbt_project.yml
    packages.yml
    requirements.txt

## Run it

You need a Google Cloud project with BigQuery enabled. The source is a public dataset, so no data needs loading.

    git clone https://github.com/nathanmars7/dbt-learning.git
    cd dbt-learning
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt

`dbt_project.yml` uses the profile `dbt_learning`. Add it to `~/.dbt/profiles.yml`, with your own project and dataset:

    dbt_learning:
      target: dev
      outputs:
        dev:
          type: bigquery
          method: oauth
          project: your-gcp-project
          dataset: dbt_learning
          location: US
          threads: 4

Then authenticate and build:

    gcloud auth application-default login
    dbt debug
    dbt deps
    dbt build
    dbt source freshness
    dbt docs generate
    dbt docs serve

`dbt build` runs the models and tests together; `dbt run` then `dbt test` does the same in two steps. There are no seeds or snapshots.

`mart_taxi_trips_daily_incremental` is materialized as `incremental` with `unique_key='trip_date'`. After the first run it only reads rows where `trip_date` is later than the max already in the table. To rebuild it from scratch:

    dbt run --select mart_taxi_trips_daily_incremental --full-refresh

## Models

| Name | Type | What it does |
|---|---|---|
| `stg_taxi_trips` | view | Cleaned and renamed fields from the raw Chicago taxi trips source, filtered to 2023 only |
| `mart_taxi_trips_daily` | table | Daily aggregation of trips: total trips, average fare, average tip, total revenue. One row per day |
| `mart_taxi_trips_daily_incremental` | incremental | Same aggregation as the daily mart, processing only dates later than those already loaded |
| `mart_taxi_trips_by_company` | table | Trips, average fare and tip, revenue and tip-to-fare ratio per company, using the macros below |
| `mart_taxi_trips_complete_days` | table | Every day of 2023 from `dbt_utils.date_spine`, left joined to the daily mart with zeros for missing days, keyed by `dbt_utils.generate_surrogate_key` |
| `round_money`, `safe_divide` | macros | Round a money column to 2 decimals; divide and return null when the denominator is 0 |
| `assert_min_trips_per_day` | singular test | Fails if any day in `mart_taxi_trips_daily` has fewer than 100 trips |

Generic tests (`not_null`, `unique`) are declared in `models/staging/schema.yml` and `models/marts/schema.yml`. Source freshness on `trip_start_timestamp` warns after 365 days and errors after 1230 days, set in `models/staging/sources.yml`.

## Portfolio

Part of a set of data engineering portfolio projects:

- [dbt-analytics-engineering](https://github.com/nathanmars7/dbt-analytics-engineering): dbt on DuckDB and Snowflake from one codebase
- [jaffle-shop-snowflake](https://github.com/nathanmars7/jaffle-shop-snowflake): minimal dbt starter on Snowflake
- [dbt-nyc-citibike](https://github.com/nathanmars7/dbt-nyc-citibike): dbt on BigQuery, Citibike ridership vs weather
- [dbt-crypto-bitcoin](https://github.com/nathanmars7/dbt-crypto-bitcoin): dbt on BigQuery with snapshots, Bitcoin transactions
- [dbt-learning](https://github.com/nathanmars7/dbt-learning) (this repo): dbt on BigQuery, Chicago taxi trips, incremental models
- [pyspark-fraud-pipeline](https://github.com/nathanmars7/pyspark-fraud-pipeline): PySpark and Delta Lake medallion pipeline on Databricks
