# AirStats dbt Capstone Project

A dbt project analyzing global airport data on Snowflake, sourced from [OurAirports](https://ourairports.com/data/).

---

## Project Structure

```
airstats/
├── analyses/
│   └── la_heliport_closed.sql       # Exercise 9 validation query
├── models/
│   ├── sources.yml                  # RAW source definitions
│   ├── docs.md                      # All {% docs %} blocks
│   ├── bronze/                      # Staging layer (ephemeral)
│   │   ├── src_airports.sql
│   │   ├── src_airport_comments.sql
│   │   └── src_runways.sql
│   └── silver/                      # Core tables (materialized as table)
│       ├── silver_airports.sql
│       ├── silver_runways.sql
│       ├── silver_airport_comments.sql  # incremental
│       └── silver_tables.yml        # tests + column docs
├── snapshots/
│   ├── scd_silver_airports.sql      # SCD Type 2 on airports
│   └── scd_silver_runways.sql       # SCD Type 2 on runways
├── tests/
│   ├── assert_no_future_comment_timestamps.sql
│   └── assert_no_duplicate_airport_names_per_country.sql
├── dbt_project.yml
├── packages.yml
└── profiles.yml
```

---

## Setup

### 1. Configure credentials

Edit `profiles.yml` and fill in your Snowflake `account` and `private_key`.

### 2. Install packages

```sh
dbt deps
```

### 3. Verify connection

```sh
dbt debug
```

### 4. Build all models

```sh
dbt run
```

### 5. Run snapshots

```sh
dbt snapshot
```

### 6. Run tests

```sh
dbt test
```

---

## Exercise Answers

### Exercise 8 — Add incremental record

**SQL to insert a new record into `RAW.airport_comments`:**

```sql
INSERT INTO AIRSTATS.RAW.airport_comments
    (id, airport_ref, airport_ident, date, member_id, member_nickname, subject, body)
VALUES
    (999999, 1, 'KLAX', current_timestamp(), 1, 'test_user',
     'Great airport', 'This is a test comment for the incremental model.');
```

**Run only the incremental model:**

```sh
dbt run --select silver_airport_comments
```

**Verify the new record was loaded:**

```sql
SELECT * FROM AIRSTATS.DEV.silver_airport_comments
WHERE comment_id = 999999;
```

---

### Exercise 9 — Snapshot the heliport closure

**Update the heliport type to `closed` in the source:**

```sql
UPDATE AIRSTATS.RAW.airports
SET type = 'closed'
WHERE ident = '01CN';
```

**Rebuild silver and re-run the snapshot:**

```sh
dbt run --select silver_airports
dbt snapshot
```

**Validate via the analysis file:**

```sh
dbt show --select la_heliport_closed
```

---

## Layer Architecture

```
RAW (Snowflake source tables)
    └── Bronze (ephemeral CTEs — no physical tables)
            └── Silver (persisted tables + incremental)
                    └── Snapshots (SCD Type 2 history tables)
```

Test failures are stored in `AIRSTATS.DEV_test_failures` for debugging.
