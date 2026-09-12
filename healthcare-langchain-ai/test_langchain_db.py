from database import engine
from langchain_community.utilities import SQLDatabase

db = SQLDatabase(engine)

print("Tables:")
print(db.get_usable_table_names())

print("\nDatabase Schema:")
print(db.get_table_info())
