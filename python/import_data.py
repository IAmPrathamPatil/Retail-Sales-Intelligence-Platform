import pandas as pd
from sqlalchemy import create_engine
from tqdm import tqdm
import os

# PostgreSQL Connection
USERNAME = "postgres"
PASSWORD = "password"
HOST = "localhost"
PORT = "5432"
DATABASE = "olist_retail"

engine = create_engine(
    f"postgresql+psycopg2://{USERNAME}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}"
)

# Dataset Folder
DATA_PATH = r"C:\Users\PRATHAM\Downloads\Retail-Sales-Analytics-Platform\data\raw"

files = {
         
"order_reviews": "olist_order_reviews_dataset.csv"

         
}

for table, file in tqdm(files.items()):
    try:
        filepath = os.path.join(DATA_PATH, file)

        print(f"\nImporting {table}...")

        df = pd.read_csv(filepath)

        df.to_sql(
            table,
            engine,
            if_exists="append",
            index=False,
            chunksize=1000
        )

        print(f"✅ {table} imported ({len(df)} rows)")

    except Exception as e:
        print(f"\n❌ Error importing {table}")
        print(e)