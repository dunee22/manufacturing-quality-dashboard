
INSERT INTO production_lines (line_name, area)
VALUES
('Line 1', 'SMT'),
('Line 2', 'Assembly'),
('Line 3', 'Testing'),
('Line 4', 'Rework');


INSERT INTO shifts (shift_name, start_time, end_time)
VALUES
('Morning', '06:00', '14:00'),
('Afternoon', '14:00', '22:00'),
('Night', '22:00', '06:00');


INSERT INTO products (product_name, appliance_type)
VALUES
('Washing Machine Control Board', 'Washing Machine'),
('Oven Control Board', 'Oven'),
('Refrigerator Control Board', 'Refrigerator');

INSERT INTO defect_types (defect_name)
VALUES
('Defective soldering'),
('Missing component'),
('Programming error'),
('Physical damage');