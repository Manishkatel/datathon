import os
import logging

from dotenv import load_dotenv
from sqlalchemy import create_engine


load_dotenv()

logging.basicConfig(level=logging.INFO)


def load_to_mysql(df):
    try:
        db_user = os.getenv("DB_USER")
        db_password = os.getenv("DB_PASSWORD")
        db_host = os.getenv("DB_HOST")
        db_port = os.getenv("DB_PORT")
        db_name = os.getenv("DB_NAME")

        database_url = (
            f"mysql+pymysql://{db_user}:{db_password}"
            f"@{db_host}:{db_port}/{db_name}"
        )

        engine = create_engine(database_url)

        df.to_sql(
            name="integrated_health_data",
            con=engine,
            if_exists="append",
            index=False
        )

        logging.info("Data loaded successfully into MySQL.")

        return "Success"

    except Exception as e:
        logging.error(f"MySQL load failed: {e}")
        raise e