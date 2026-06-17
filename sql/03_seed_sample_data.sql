-- Sample production record
-- Date: 2026-06-01
-- Line: Line 1
-- Shift: Morning
-- Product: Washing Machine Control Board
-- Produced units: 1000
-- Defective units: 35
-- Downtime: 42 minutes

INSERT INTO production_records (
    production_date,
    production_line_id,
    shift_id,
    product_id,
    produced_units,
    defective_units,
    downtime_minutes
)
VALUES (
    '2026-06-01',
    1,
    1,
    1,
    1000,
    35,
    42
);


-- Defect breakdown for production_record_id = 1
-- Total defect quantity: 20 + 10 + 5 = 35

INSERT INTO defect_records (
    production_record_id,
    defect_type_id,
    defect_quantity
)
VALUES
    (1, 1, 20),
    (1, 2, 10),
    (1, 3, 5);