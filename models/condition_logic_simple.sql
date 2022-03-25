{{ config(materialized='view', tags='chronic conditions') }}

with patients as (
select
    a.patient_id
,   b.encounter_id
,   b.admit_date
from {{ ref('stg_patient') }} a
left join {{ ref('stg_encounter') }}  b
    on a.patient_id = b.patient_id    
)

, diagnosis_conditions as (
select
    a.patient_id
,   a.encounter_id
,   a.admit_date
,   c.condition_category
,   c.condition
from patients a
inner join {{ ref('stg_condition') }}  b
    on a.encounter_id = b.encounter_id
inner join {{ ref('chronic_condition') }}  c
    on b.diagnosis_code = c.code
    and c.code_type = 'ICD-10-CM'
    and c.inclusion_type = 'Include'
    and c.additional_logic = 'None'
)
    
, procedure_conditions as (
select
    a.patient_id
,   a.encounter_id
,   a.admit_date
,   c.condition_category
,   c.condition
from patients a
inner join {{ ref('stg_procedure') }} b
    on a.encounter_id = b.encounter_id
inner join {{ ref('chronic_condition') }}  c
    on b.procedure_code = c.code
    and c.code_type = 'ICD-10-PCS'
    and c.inclusion_type = 'Include'
    and c.additional_logic = 'None'
)

select *
from diagnosis_conditions

union

select *
from procedure_conditions
