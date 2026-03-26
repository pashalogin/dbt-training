{% snapshot scd_silver_runways %}

{{
    config(
        target_schema='DEV',
        unique_key='runway_id',
        strategy='check',
        check_cols='all'
    )
}}

select * from {{ ref('silver_runways') }}

{% endsnapshot %}
