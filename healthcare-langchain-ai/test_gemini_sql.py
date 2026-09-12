from app import generate_sql, execute_sql


question = "What is the total billing amount?"

print("Question:")
print(question)

print("\nGenerating SQL...")

sql = generate_sql(question)

print("Generated SQL:")
print(sql)

print("\nExecuting SQL...")

result = execute_sql(sql)

print("Database Result:")
print(result)

print("\nGemini + SQL + DuckDB test successful!")