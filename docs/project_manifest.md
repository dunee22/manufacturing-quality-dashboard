# Manufacturing Quality & Production Dashboard

## Project Manifest

## 1. Project Context

This project simulates a real-world data analytics scenario for a manufacturing plant that produces electronic control boards for home appliances.

The plant manufactures boards for:

* Washing machines
* Ovens
* Refrigerators

The production process operates across 4 production lines and 3 daily shifts:

* Morning
* Afternoon
* Night

Management is concerned about quality issues and downtime affecting production performance. The main goal of this project is to analyze production data, identify operational problems, and build a dashboard that supports better decision-making.

## 2. Business Problem

The manufacturing plant wants to understand why some production lines, shifts, or products generate more defects and downtime than others.

The operations team needs a clear dashboard and analysis report to identify:

* Which production lines produce the most units.
* Which production lines generate the most defects.
* Which shifts are associated with more quality issues.
* Which products generate more rework or defective units.
* Which defect types are most frequent.
* Whether downtime is related to defect volume.
* What actions could reduce defects and downtime.

## 3. Main Business Questions

1. Which production lines generate the highest number of defects?
2. Which production lines have the highest downtime?
3. Which shifts perform worse in terms of defects and downtime?
4. Which products are more likely to present quality issues?
5. What are the most common defect types?
6. Is there a relationship between downtime and defective units?
7. What recommendations can be made to improve production quality?

## 4. Main KPIs

The project will analyze the following KPIs:

### Total Production

Total number of produced units.

Formula:

```text
SUM(produced_units)
```

### Total Defects

Total number of defective units.

Formula:

```text
SUM(defective_units)
```

### Defect Rate

Percentage of produced units that were defective.

Formula:

```text
(defective_units / produced_units) * 100
```

### Total Downtime

Total downtime minutes recorded during production.

Formula:

```text
SUM(downtime_minutes)
```

### Defect Quantity by Type

Total number of defects grouped by defect type.

Formula:

```text
SUM(defect_quantity)
```

## 5. Data Model v1

The database will be designed using a relational model. The main table will store production records, while supporting tables will store products, shifts, production lines, and defect types.

### production_records

Main table that records production activity by date, line, shift, and product.

Columns:

* production_record_id | PK
* production_date
* production_line_id | FK
* shift_id | FK
* product_id | FK
* produced_units
* defective_units
* downtime_minutes

### production_lines

Catalog table for production lines.

Columns:

* production_line_id | PK
* line_name
* area

### shifts

Catalog table for production shifts.

Columns:

* shift_id | PK
* shift_name
* start_time
* end_time

### products

Catalog table for manufactured products.

Columns:

* product_id | PK
* product_name
* appliance_type

### defect_types

Catalog table for possible defect types.

Columns:

* defect_type_id | PK
* defect_name

### defect_records

Detail table that records defect quantities by production record and defect type.

Columns:

* defect_record_id | PK
* production_record_id | FK
* defect_type_id | FK
* defect_quantity

## 6. Table Relationships

The initial relationships are:

```text
production_lines  1 ─── N  production_records
shifts            1 ─── N  production_records
products          1 ─── N  production_records

production_records 1 ─── N defect_records
defect_types       1 ─── N defect_records
```

In human terms:

* One production line can have many production records.
* One shift can have many production records.
* One product can appear in many production records.
* One production record can have many defect records.
* One defect type can appear in many defect records.

## 7. Defect Modeling Decision

The project will use a separate table called `defect_records` instead of storing only one defect type directly in `production_records`.

Reason:

A single production record can have multiple defect types. For example, during the same day, line, shift, and product, there may be defective soldering, programming errors, and missing components.

Using `defect_records` allows the project to store multiple defect types and quantities for the same production event.

For this first version, the project will assume that each defective unit has one main defect type.

Validation rule:

```text
For each production_record_id:
SUM(defect_quantity) should be equal to defective_units.
```

## 8. Expected Deliverables

The final project should include:

* Relational database in SQLite
* SQL schema file
* Insert scripts or generated sample data
* Business SQL queries
* Python/Pandas exploratory analysis
* Clean dataset for dashboarding
* Matplotlib charts
* Power BI dashboard
* Executive summary
* GitHub README
* Images/screenshots for portfolio presentation

## 9. Tools

The project will use:

* SQLite
* DB Browser for SQLite
* SQL
* Python
* Pandas
* NumPy
* Matplotlib
* Power BI
* Git/GitHub

## 10. Portfolio Goal

This project is designed to demonstrate practical data analytics skills in a manufacturing context.

It connects technical manufacturing knowledge with data analysis, business questions, SQL, Python, dashboarding, and storytelling.

The final version should be suitable for a GitHub portfolio and could be mentioned in a Data Analyst / BI Analyst junior resume.
