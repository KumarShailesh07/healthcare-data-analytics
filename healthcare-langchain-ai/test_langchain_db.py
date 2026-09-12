from database import conn


print("Testing DuckDB connection...")

result = conn.execute(
    "SELECT COUNT(*) FROM health_care_data"
).fetchone()

print("Total records:", result[0])

print("\nTesting sample query...")

result = conn.execute(
    """
    SELECT AVG(Billing_Amount)
    FROM health_care_data
    """
).fetchone()

print("Average billing:", result[0])

print("\nDatabase test successful!")