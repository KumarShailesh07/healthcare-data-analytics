from app import validate_sql_query


test_queries = [
    "SELECT * FROM health_care_data;",
    
    "SELECT * FROM health_care_data; DELETE FROM health_care_data",
    
    "SELECT * FROM health_care_data WHERE Age = 30",
    
    "WITH patient_data AS (SELECT * FROM health_care_data) "
    "SELECT COUNT(*) FROM patient_data",
    
    "TRUNCATE TABLE health_care_data",
    
    "CREATE TABLE test_table (id INT)",
]


for query in test_queries:

    print("\nTesting:", query)

    try:
        validate_sql_query(query)
        print("RESULT: ALLOWED")

    except PermissionError as e:
        print("RESULT: BLOCKED")
        print("Reason:", e)