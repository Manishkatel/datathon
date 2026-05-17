import pandas as pd


def extract_data():
    df1 = pd.read_csv(r"../datasets/data_health_2023.csv") 
    df2 = pd.read_csv(r"../datasets/data_health_2021.csv")
    df3 = pd.read_csv(r"../datasets/data_health_2020.csv")

    return df1, df2, df3

