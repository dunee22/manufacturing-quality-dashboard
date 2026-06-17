
import sqlite3
import random
from datetime import date, timedelta
from pathlib import Path


DB_PATH = Path("database/manufacturing.db")

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


def generate_dates(start_date, days):
    dates = []

    for i in range(days):
        current_date = start_date + timedelta(days=i)
        dates.append(current_date)

    return dates


LINE_BASE_PRODUCTION = {
    1: 1100,  # Line 1: high production
    2: 950,   # Line 2: medium-high production
    3: 850,   # Line 3: medium production
    4: 650    # Line 4: lower production / rework
}

SHIFT_MULTIPLIER = {
    1: 1.05,  # Morning: better performance
    2: 1.00,  # Afternoon: standard performance
    3: 0.90   # Night: lower performance
}

LINE_DEFECT_RATE = {
    1: 0.025,  # Line 1: moderate defect rate
    2: 0.045,  # Line 2: higher defect rate
    3: 0.035,  # Line 3: medium defect rate
    4: 0.055   # Line 4: highest defect rate / rework
}

SHIFT_DEFECT_MULTIPLIER = {
    1: 0.85,  # Morning: fewer defects
    2: 1.00,  # Afternoon: standard
    3: 1.25   # Night: more defects
}

PRODUCT_DEFECT_MULTIPLIER = {
    1: 1.00,  # Washing Machine Control Board
    2: 1.10,  # Oven Control Board
    3: 1.25   # Refrigerator Control Board
}

LINE_BASE_DOWNTIME = {
    1: 25,  # Line 1: stable
    2: 35,  # Line 2: some material/component issues
    3: 55,  # Line 3: higher downtime
    4: 40   # Line 4: rework/testing interruptions
}

SHIFT_DOWNTIME_MULTIPLIER = {
    1: 0.85,  # Morning: fewer interruptions
    2: 1.00,  # Afternoon: standard
    3: 1.30   # Night: more downtime
}

PRODUCT_DEFECT_WEIGHTS = {
    1: {1: 0.45, 2: 0.25, 3: 0.20, 4: 0.10},
    2: {1: 0.30, 2: 0.20, 3: 0.20, 4: 0.30},
    3: {1: 0.25, 2: 0.20, 3: 0.40, 4: 0.15}
}


def calculate_produced_units(line_id, shift_id):
    base = LINE_BASE_PRODUCTION[line_id]
    multiplier = SHIFT_MULTIPLIER[shift_id]
    variation = random.randint(-80, 80)

    produced_units = int(base * multiplier + variation)

    return produced_units


def calculate_defective_units(produced_units, line_id, shift_id, product_id):
    base_rate = LINE_DEFECT_RATE[line_id]
    shift_multiplier = SHIFT_DEFECT_MULTIPLIER[shift_id]
    product_multiplier = PRODUCT_DEFECT_MULTIPLIER[product_id]
    variation = random.uniform(-0.005, 0.005)
    
    defect_rate = base_rate * shift_multiplier * product_multiplier + variation
    defect_rate = max(defect_rate, 0)
    defective_units = int(produced_units * defect_rate)
    
    return defective_units


def calculate_downtime_minutes(line_id, shift_id):
    base = LINE_BASE_DOWNTIME[line_id]
    multiplier = SHIFT_DOWNTIME_MULTIPLIER[shift_id]
    variation = random.randint(-10, 15)

    calculated_downtime = int(base * multiplier + variation)
    calculated_downtime = max(calculated_downtime, 0)

    return calculated_downtime


def distribute_defects(defective_units, product_id):
    weights = PRODUCT_DEFECT_WEIGHTS[product_id]
    defect_distribution = []

    for defect_type_id, weight in weights.items():
        defect_quantity = int(defective_units * weight)
        defect_distribution.append((defect_type_id, defect_quantity))

    total_distributed = sum(quantity for _, quantity in defect_distribution)
    remaining_defects = defective_units - total_distributed

    if remaining_defects > 0:
        defect_type_id, current_quantity = defect_distribution[0]
        defect_distribution[0] = (
            defect_type_id,
            current_quantity + remaining_defects
        )

    return defect_distribution


def generate_production_record(production_date, line_id, shift_id, product_id):
    produced_units = calculate_produced_units(line_id, shift_id)

    defective_units = calculate_defective_units(
        produced_units,
        line_id,
        shift_id,
        product_id
    )

    downtime_minutes = calculate_downtime_minutes(line_id, shift_id)

    defects = distribute_defects(defective_units, product_id)

    record = {
        "production_date": production_date.isoformat(),
        "production_line_id": line_id,
        "shift_id": shift_id,
        "product_id": product_id,
        "produced_units": produced_units,
        "defective_units": defective_units,
        "downtime_minutes": downtime_minutes,
        "defects": defects
    }

    return record


def insert_production_record(conn, record):
    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO production_records (
            production_date,
            production_line_id,
            shift_id,
            product_id,
            produced_units,
            defective_units,
            downtime_minutes
        )
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """,
        (
            record["production_date"],
            record["production_line_id"],
            record["shift_id"],
            record["product_id"],
            record["produced_units"],
            record["defective_units"],
            record["downtime_minutes"]
        )
    )

    production_record_id = cursor.lastrowid

    for defect_type_id, defect_quantity in record["defects"]:
        cursor.execute(
            """
            INSERT INTO defect_records (
                production_record_id,
                defect_type_id,
                defect_quantity
            )
            VALUES (?, ?, ?);
            """,
            (
                production_record_id,
                defect_type_id,
                defect_quantity
            )
        )

    return production_record_id


LINE_IDS = [1, 2, 3, 4]
SHIFT_IDS = [1, 2, 3]
PRODUCT_IDS = [1, 2, 3]

def generate_and_insert_sample_data():
    conn = get_connection()

    dates = generate_dates(date(2026, 6, 1), 30)

    for production_date in dates:
        for line_id in LINE_IDS:
            for shift_id in SHIFT_IDS:
                product_id = random.choice(PRODUCT_IDS)

                record = generate_production_record(
                    production_date,
                    line_id,
                    shift_id,
                    product_id
                )

                insert_production_record(conn, record)

    conn.commit()
    conn.close()

generate_and_insert_sample_data()
print("Sample data generated successfully.")