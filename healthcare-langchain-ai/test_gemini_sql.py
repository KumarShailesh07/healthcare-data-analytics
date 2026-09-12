import os

from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import create_sql_agent

from database import engine

load_dotenv()

llm = ChatGoogleGenerativeAI(
    model="gemini-3.5-flash"
)

db = SQLDatabase(engine)

agent = create_sql_agent(
    llm=llm,
    db=db,
    agent_type="tool-calling",
    verbose=True
)

question = "What is the total billing amount?"

response = agent.invoke({
    "input": question
})

print("\nFinal Answer:")
print(response["output"])