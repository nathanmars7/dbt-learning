# dbt Learning Project

A hands-on dbt project built to develop real-world data engineering skills using **dbt Core** and **Google BigQuery**.

## Project Overview

This project transforms raw Chicago taxi trip data (2023) from BigQuery's public datasets into clean, tested, and documented analytical models — following professional dbt conventions.

## Tech Stack

- **dbt Core** 1.11
- **Google BigQuery**
- **Python** 3.13
- **dbt_utils** package

## Project Structure

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

## Models

| Model | Materialization | Description |
|-------|----------------|-------------|
| `stg_taxi_trips` | View | Cleans and renames raw Chicago taxi data filtered to 2023 |
| `mart_taxi_trips_daily` | Table | Daily aggregation — trips, fares, tips, revenue |
| `mart_taxi_trips_daily_incremental` | Incremental | Processes only new dates on each run |
| `mart_taxi_trips_by_company` | Table | Aggregation by taxi company with tip-to-fare ratio |
| `mart_taxi_trips_complete_days` | Table | Complete date spine with surrogate keys |

## Key Concepts Demonstrated

- **Staging + Marts layering** — separation of raw data access from business logic
- **`ref()` and `source()`** — dbt dependency management and source declaration
- **Generic tests** — `not_null`, `unique` configured in YAML
- **Singular tests** — custom SQL business logic validation
- **Incremental models** — efficient processing of only new data
- **Macros** — reusable Jinja SQL snippets (DRY principle)
- **dbt_utils** — `date_spine()` and `generate_surrogate_key()`
- **Source freshness** — monitoring upstream data staleness
- **dbt docs** — auto-generated documentation and lineage graph

## Getting Started

### Prerequisites

- Python 3.13+
- Google Cloud account with BigQuery enabled
- dbt Core with BigQuery adapter

### Setup

    git clone https://github.com/nathanmars7/dbt-learning.git
    cd dbt-learning
    python3 -m venv venv
    source venv/bin/activate
    pip install dbt-bigquery
    dbt deps
    gcloud auth application-default login
    dbt debug

### Running the Project

    dbt run
    dbt test
    dbt source freshness
    dbt docs generate
    dbt docs serve

## Data Source

This project uses the Chicago Taxi Trips public dataset available on Google BigQuery, provided by the City of Chicago.