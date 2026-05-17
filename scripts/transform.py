import pandas as pd


def clean_columns(df):
    df.columns = (
        df.columns
        .str.lower()
        .str.strip()
        .str.replace(" ", "_")
    )
    return df


def transform_data(df1, df2, df3):
    datasets = [df1, df2, df3]

    cleaned_datasets = []

    for df in datasets:
        df = clean_columns(df)
        df = df.drop_duplicates()
        cleaned_datasets.append(df)

    df1, df2, df3 = cleaned_datasets

    integrated_df = (
        df1.merge(df2, on="state", how="left")
           .merge(df3, on="state", how="left")
    )

    integrated_df = integrated_df.fillna(0)

    integrated_df.to_csv(
        "data/processed/integrated_clean_data.csv",
        index=False
    )

    return integrated_df
