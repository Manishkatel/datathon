import os
import smtplib

from dotenv import load_dotenv
from email.message import EmailMessage


load_dotenv()


def send_success_email():
    sender = os.getenv("EMAIL_SENDER")
    password = os.getenv("EMAIL_PASSWORD")
    receiver = os.getenv("EMAIL_RECEIVER")

    msg = EmailMessage()

    msg["Subject"] = "Data Integration Completed Successfully"
    msg["From"] = sender
    msg["To"] = receiver

    msg.set_content(
        """
Hello,

Your data engineering pipeline completed successfully.

Tasks completed:
1. Extracted 5 datasets
2. Integrated datasets
3. Preprocessed data
4. Loaded clean data into MySQL
5. Updated table: integrated_health_data

Status: SUCCESS
        """
    )

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
        smtp.login(sender, password)
        smtp.send_message(msg)


def send_failure_email(error_message):
    sender = os.getenv("EMAIL_SENDER")
    password = os.getenv("EMAIL_PASSWORD")
    receiver = os.getenv("EMAIL_RECEIVER")

    msg = EmailMessage()

    msg["Subject"] = "Data Pipeline Failed"
    msg["From"] = sender
    msg["To"] = receiver

    msg.set_content(
        f"""
Hello,

Your data engineering pipeline failed.

Error:
{error_message}

Status: FAILED
        """
    )

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
        smtp.login(sender, password)
        smtp.send_message(msg)
        