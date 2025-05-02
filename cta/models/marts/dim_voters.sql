{{
    config(
        materialized="table",
        cluster_by=["residential_address_id"],
    )
}}
select
    sos_voterid,
    sos_voter_id_suffix,
    county_number,
    county_id,
    last_name,
    first_name,
    middle_name,
    suffix,
    date_of_birth,
    registration_date,
    voter_status,
    party_affiliation,
    addresses.address_id as residential_address_id,
from {{ ref("stg_ohio_sos__statewide_voter_file") }} as voter_file
left join
    {{ ref("dim_residential_addresses") }} as addresses using (
        residential_address1,
        residential_zip,
        residential_city,
        residential_secondary_addr
    )
