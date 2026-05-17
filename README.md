# Mississippi Health Data Pipeline

This project contains a small data engineering workflow for Mississippi county health data. It loads raw yearly CSV files into MySQL staging tables, combines them into a final health table, and creates summary views for analysis.

## Project Overview

The repository is organized around three main tasks:

1. Load raw CSV datasets into MySQL staging tables.
2. Standardize and combine health data across years.
3. Create clean analysis views for county, measure, and yearly summaries.

The current datasets cover 2020, 2021, and 2023 health data, plus a smaller Mississippi health dataset used for analysis and notebooks.

## Repository Structure

```text
health/
|-- dags/
|   `-- five_dataset_airflow.py
|-- datasets/
|   |-- data_health_2020.csv
|   |-- data_health_2021.csv
|   |-- data_health_2023.csv
|   |-- ms_health_data.csv
|   |-- test.ipynb
|   `-- upload_data.py
|-- notebooks/
|   |-- health.ipynb
|   `-- mississippi_disease_comparison_maps.html
|-- scripts/
|   |-- extract.py
|   |-- load.py
|   |-- main_pipeline.py
|   |-- notify.py
|   `-- transform.py
|-- sql/
|   |-- analysis_queries.sql
|   `-- schema.sql
|-- .env
|-- .gitignore
`-- README.md
```

## Data Sources

The main raw datasets are stored in `datasets/`:

- `data_health_2020.csv`
- `data_health_2021.csv`
- `data_health_2023.csv`
- `ms_health_data.csv`

The larger yearly CSV files include fields such as year, state, county, measure, data value, population, geography, category, and measure identifiers.

## Requirements

This project uses Python with the following core packages:

- pandas
- SQLAlchemy
- PyMySQL
- python-dotenv

Install the dependencies in your virtual environment:

```bash
pip install pandas sqlalchemy pymysql python-dotenv
```

## Environment Variables

Create a `.env` file in the project root with the database and email settings used by the scripts:

```env
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ms_health_project

EMAIL_SENDER=your_sender_email
EMAIL_PASSWORD=your_email_app_password
EMAIL_RECEIVER=recipient_email
```

The `.env` file is ignored by Git and should not be committed.

## Database Setup

Create the MySQL database before running the load scripts:

```sql
CREATE DATABASE ms_health_project;
USE ms_health_project;
```

## Loading Raw Data

The `datasets/upload_data.py` script loads each yearly CSV into a MySQL staging table:

- `stg_health_2020`
- `stg_health_2021`
- `stg_health_2023`

Run the loader from the `datasets/` directory so the relative CSV paths resolve correctly:

```bash
cd datasets
python upload_data.py
```

The script replaces each staging table if it already exists.

## Building Final Tables and Views

After loading the staging tables, run the schema script in MySQL:

```bash
mysql -u your_mysql_user -p ms_health_project < sql/schema.sql
```

The schema script creates:

- `final_health_data`
- `clean_health_data`
- `county_summary`
- `measure_summary`
- `yearly_summary`

`final_health_data` combines the 2020, 2021, and 2023 staging tables into one table. The summary views provide aggregated values by county, measure, and year.

## Python Pipeline Scripts

The `scripts/` folder contains modular pipeline functions:

- `extract.py` reads the yearly CSV files.
- `transform.py` cleans column names, removes duplicates, merges datasets by state, fills missing values, and writes a processed CSV.
- `load.py` appends a DataFrame into the `integrated_health_data` MySQL table.
- `notify.py` sends success or failure email notifications.
- `main_pipeline.py` is currently a placeholder for connecting the pipeline steps.

## Notebooks and Output

The `notebooks/` folder contains exploratory analysis and visualization work:

- `health.ipynb`
- `mississippi_disease_comparison_maps.html`

The HTML file contains map-based disease comparison output.

## Current Status

The project currently has working pieces for CSV loading, transformation, MySQL loading, email notification, and SQL view creation. These files are placeholders and can be completed next:

- `dags/five_dataset_airflow.py`
- `scripts/main_pipeline.py`
- `sql/analysis_queries.sql`

## Suggested Workflow

1. Create and activate a Python virtual environment.
2. Install the Python dependencies.
3. Configure `.env`.
4. Create the MySQL database.
5. Run `datasets/upload_data.py` to load staging tables.
6. Run `sql/schema.sql` to build the final table and summary views.
7. Use the notebooks or SQL views for analysis.
