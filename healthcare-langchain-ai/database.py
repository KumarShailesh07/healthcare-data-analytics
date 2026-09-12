import duckdb
from pathlib import Path


# ============================================================
# CSV PATH
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

CSV_PATH = (
    BASE_DIR.parent
    / "Cleaned_Health Care Dataset.csv"
)


# ============================================================
# DUCKDB CONNECTION
# ============================================================

conn = duckdb.connect()


# ============================================================
# LOAD CSV
# ============================================================

conn.execute(
    f"""
    CREATE OR REPLACE VIEW health_care_data AS
    SELECT
        "Name" AS Name,
        "Age" AS Age,
        "Gender" AS Gender,
        "Blood Type" AS Blood_Type,
        "Medical Condition" AS Medical_Condition,
        "Date of Admission" AS Date_of_Admission,
        "Doctor" AS Doctor,
        "Hospital" AS Hospital,
        "Insurance Provider" AS Insurance_Provider,
        "Billing Amount" AS Billing_Amount,
        "Room Number" AS Room_Number,
        "Admission Type" AS Admission_Type,
        "Discharge Date" AS Discharge_Date,
        "Medication" AS Medication,
        "Test Results" AS Test_Results
    FROM read_csv_auto(
        '{CSV_PATH.as_posix()}',
        header=True
    )
    """
)

print("✅ CSV database loaded successfully!")


# ============================================================
# EXECUTE QUERY
# ============================================================

def execute_query(query):
    result = conn.execute(query).fetchall()
    return result