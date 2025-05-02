{{
    config(
        materialized="table",
        partition_by={
            "field": "date",
            "data_type": "date",
            "granularity": "day",
        },
        cluster_by=[
            "voted_as",
            "sos_voterid",
        ],
    )
}}
-- TODO: add partitioning
with
    unpivoted_elections as (
        select
            sos_voterid,
            split(election_name, '_')[0] as election_type,
            cast(
                replace(
                    regexp_extract(election_name, r"_(.*)"), '_', '-'
                ) as date format 'MM-DD-YYYY'
            ) as date,
            voted_as
        from
            {{ ref("stg_ohio_sos__statewide_voter_file") }} unpivot (
                voted_as for election_name in (
                    primary_03_07_2000,
                    general_11_07_2000,
                    special_05_08_2001,
                    general_11_06_2001,
                    primary_05_07_2002,
                    general_11_05_2002,
                    special_05_06_2003,
                    general_11_04_2003,
                    primary_03_02_2004,
                    general_11_02_2004,
                    special_02_08_2005,
                    primary_05_03_2005,
                    primary_09_13_2005,
                    general_11_08_2005,
                    special_02_07_2006,
                    primary_05_02_2006,
                    general_11_07_2006,
                    primary_05_08_2007,
                    primary_09_11_2007,
                    general_11_06_2007,
                    primary_11_06_2007,
                    general_12_11_2007,
                    primary_03_04_2008,
                    primary_10_14_2008,
                    general_11_04_2008,
                    general_11_18_2008,
                    primary_05_05_2009,
                    primary_09_08_2009,
                    primary_09_15_2009,
                    primary_09_29_2009,
                    general_11_03_2009,
                    primary_05_04_2010,
                    primary_07_13_2010,
                    primary_09_07_2010,
                    general_11_02_2010,
                    primary_05_03_2011,
                    primary_09_13_2011,
                    general_11_08_2011,
                    primary_03_06_2012,
                    general_11_06_2012,
                    primary_05_07_2013,
                    primary_09_10_2013,
                    primary_10_01_2013,
                    general_11_05_2013,
                    primary_05_06_2014,
                    general_11_04_2014,
                    primary_05_05_2015,
                    primary_09_15_2015,
                    general_11_03_2015,
                    primary_03_15_2016,
                    general_06_07_2016,
                    primary_09_13_2016,
                    general_11_08_2016,
                    primary_05_02_2017,
                    primary_09_12_2017,
                    general_11_07_2017,
                    primary_05_08_2018,
                    general_08_07_2018,
                    general_11_06_2018,
                    primary_05_07_2019,
                    primary_09_10_2019,
                    general_11_05_2019,
                    primary_03_17_2020,
                    general_11_03_2020,
                    primary_05_04_2021,
                    primary_08_03_2021,
                    primary_09_14_2021,
                    general_11_02_2021,
                    primary_05_03_2022,
                    primary_08_02_2022,
                    general_11_08_2022,
                    special_02_28_2023,
                    primary_05_02_2023,
                    special_08_08_2023,
                    special_09_12_2023,
                    primary_10_03_2023,
                    general_11_07_2023,
                    special_12_05_2023,
                    special_02_27_2024,
                    primary_03_19_2024,
                    general_06_11_2024,
                    general_11_05_2024,
                    special_01_07_2025
                )
            ) v
        where voted_as != ""
    )

select sos_voterid, upper(election_type) as election_type, date, voted_as
from unpivoted_elections
