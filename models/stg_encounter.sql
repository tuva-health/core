
-- Staging model for the input layer:
-- stg_encounter input layer model.
-- This contains one row for every unique encounter in the dataset.


{{ config(materialize='view') }}



select
    cast(encounter_id as varchar) as encounter_id,
    cast(patient_id as varchar) as patient_id,
    cast(encounter_start_date as date) as admit_date,
    cast(encounter_end_date as date) as discharge_date,
    cast(discharge_disposition as varchar) as discharge_status_code,
    cast(location as varchar) as facility,
    cast(ms_drg as varchar) as ms_drg
    
from {{ var('src_encounter') }}


