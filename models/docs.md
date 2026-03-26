{% docs silver_airports %}
Contains cleaned and renamed airport records sourced from OurAirports.
One row per airport worldwide, uniquely identified by `airport_ident`.
Covers all airport types including large, medium, and small airports,
heliports, seaplane bases, balloonports, and closed facilities.
{% enddocs %}

{% docs silver_runways %}
Contains runway data for airports worldwide. Each row represents a single
runway at a given airport. Null or empty surface values are replaced with
`__UNKNOWN__` to ensure the column is never null. References `silver_airports`
via `airport_ident`.
{% enddocs %}

{% docs silver_airport_comments %}
Contains user-submitted comments about airports from the OurAirports community.
Records with empty or null comment bodies are filtered out at this layer.
Member nicknames that are null are replaced with `__UNKNOWN__`. This model
is loaded incrementally — only new records (by `comment_id`) are appended
on each run. A `loaded_at` timestamp is added to track ingestion time.
{% enddocs %}

{% docs __overview__ %}
## AirStats Project

This project models global airport data sourced from [OurAirports](https://ourairports.com/data/).

### Silver Layer Overview

The silver layer consists of three interconnected tables:

| Table | Description | Rows (approx) |
|---|---|---|
| `silver_airports` | Core airport dimension | ~72K |
| `silver_runways` | Runway details per airport | ~44K |
| `silver_airport_comments` | User comments (incremental) | varies |

`silver_airports` is the central dimension, uniquely keyed by `airport_ident`.
Both `silver_runways` and `silver_airport_comments` reference it via this key.
Referential integrity is validated as a warning-level test since source data
may contain orphaned records. Comments are loaded incrementally to avoid
reprocessing the full dataset on every run.

### Layer Architecture

```
RAW (Snowflake)
    └── Bronze (ephemeral CTEs)
            └── Silver (persisted tables)
                    └── Snapshots (SCD Type 2)
```
{% enddocs %}
