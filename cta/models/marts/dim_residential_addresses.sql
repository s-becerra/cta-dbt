{{
    config(
        materialized="incremental",
        cluster_by=[
            "residential_address1",
            "residential_zip",
            "residential_city",
            "residential_secondary_addr",
        ],
    )
}}

with
    new_records as (
        select
            row_number() over ()
            {% if is_incremental() %}
                + coalesce((select max(address_id) from {{ this }}), 0)
            {% endif %} as address_id,
            unique_address.*

        from {{ ref("int_unique_residential_addresses") }} as unique_address
        {% if is_incremental() %}
            left join
                {{ this }} as current_addresses using (
                    residential_address1,
                    residential_zip,
                    residential_city,
                    residential_secondary_addr
                )
            where current_addresses.residential_address1 is null
        {% endif %}
    )

select *
from new_records
