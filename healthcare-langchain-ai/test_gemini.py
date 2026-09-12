from dotenv import load_dotenv
import os

print("1. Starting...")

load_dotenv()

print("2. API key loaded:", bool(os.getenv("GEMINI_API_KEY")))

from langchain_google_genai import ChatGoogleGenerativeAI

print("3. LangChain Gemini imported")

llm = ChatGoogleGenerativeAI(
    model="gemini-3.5-flash",
    temperature=0
)

print("4. LLM created")

response = llm.invoke(
    "Say only: Gemini connection successful"
)

print("5. Response received")
print(response.content)