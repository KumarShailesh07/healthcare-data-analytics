from app import execute_sql


invalid_queries = [
    "SELECT * FROM wrong_table",
    "SELECT WrongColumn FROM health_care_data",
]


for query in invalid_queries:

    print("\nTesting:", query)

    try:
        result = execute_sql(query)
        print("RESULT:", result)

    except Exception as e:
        print("ERROR HANDLED")
        print("Error Type:", type(e).__name__)
        print("Message:", e)