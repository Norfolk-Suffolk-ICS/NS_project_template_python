with waitlistmetric as (
    select *
    from REPORTING_DATASETS_IF.SCRATCHPAD.TEST_INEQ_METRIC
    where "OnWaitList" = 1
)

select *,
case when "Core20CategoryList" like '%C20%' then 'C20' else 'Not C20' end as "C20indicator"
from waitlistmetric a
left join REPORTING_DATASETS_IF.SCRATCHPAD.TEST_INEQ_PERSON b using("PatientPseudonym")