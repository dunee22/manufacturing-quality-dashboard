PRAGMA foreign_keys = ON;

CREATE TABLE production_lines (
    production_line_id INTEGER PRIMARY KEY AUTOINCREMENT,
    line_name TEXT NOT NULL,
    area TEXT NOT NULL
);


CREATE TABLE shifts (
    shift_id INTEGER PRIMARY KEY AUTOINCREMENT,
    shift_name TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL
);


CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT NOT NULL,
    appliance_type TEXT NOT NULL
);


CREATE TABLE defect_types (
    defect_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    defect_name TEXT NOT NULL
);


CREATE TABLE production_records (
    production_record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    production_date TEXT NOT NULL,
    production_line_id INTEGER NOT NULL,
    shift_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    produced_units INTEGER NOT NULL,
    defective_units INTEGER NOT NULL,
    downtime_minutes INTEGER NOT NULL,

    FOREIGN KEY (production_line_id) REFERENCES production_lines(production_line_id),
    FOREIGN KEY (shift_id) REFERENCES shifts(shift_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE defect_records (
    defect_record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    production_record_id INTEGER NOT NULL,
    defect_type_id INTEGER NOT NULL,
    defect_quantity INTEGER NOT NULL,
    
    FOREIGN KEY (production_record_id) REFERENCES production_records(production_record_id),
    FOREIGN KEY (defect_type_id) REFERENCES defect_types(defect_type_id)
);