import os
import logging

import pandas as pd

from dotenv import load_dotenv
from sqlalchemy import create_engine


# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)


def load_to_mysql(csv_path, table_name):
    """
    Load CSV dataset into MySQL table.
    """

    try:
        # Database credentials from .env
        db_user = os.getenv("DB_USER")
        db_password = os.getenv("DB_PASSWORD")
        db_host = os.getenv("DB_HOST")
        db_port = os.getenv("DB_PORT")
        db_name = os.getenv("DB_NAME")

        # MySQL connection string
        database_url = (
            f"mysql+pymysql://{db_user}:{db_password}"
            f"@{db_host}:{db_port}/{db_name}"
        )

        # Create SQLAlchemy engine
        engine = create_engine(database_url)

        # Read CSV
        df = pd.read_csv(csv_path)

        logging.info(f"Loaded CSV: {csv_path}")
        logging.info(f"Dataset shape: {df.shape}")

        # Upload to MySQL
        df.to_sql(
            name=table_name,
            con=engine,
            if_exists="replace",   
            index=False,
            chunksize=5000        
        )

        logging.info(
            f"Successfully loaded data into table: {table_name}"
        )

        return "Success"

    except Exception as e:

        logging.error(f"MySQL load failed: {e}")

        raise e


if __name__ == "__main__":

    # Upload 2020 dataset
    load_to_mysql(
        csv_path="data_health_2020.csv",
        table_name="stg_health_2020"
    )

    # Upload 2021 dataset
    load_to_mysql(
        csv_path="data_health_2021.csv",
        table_name="stg_health_2021"
    )

    # Upload 2023 dataset
    load_to_mysql(
        csv_path="data_health_2023.csv",
        table_name="stg_health_2023"
    )

    logging.info("All datasets uploaded successfully.")