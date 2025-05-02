{{
    config(
        materialized="table",
        cluster_by=[
            "residential_address1",
            "residential_zip",
            "residential_city",
            "residential_secondary_addr",
        ],
    )
}}

-- TODO: due to address variations, the next step should be to implement normalizing
-- and/or fuzzy matching
select distinct
    residential_address1,
    residential_secondary_addr,
    residential_city,
    residential_state,
    residential_zip,

from {{ ref("stg_ohio_sos__statewide_voter_file") }}
