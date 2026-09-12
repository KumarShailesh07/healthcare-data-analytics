import os
import streamlit as st
import re

from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI

from database import execute_query


# ============================================================
# 1. LOAD ENVIRONMENT VARIABLES
# ============================================================

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    api_key = st.secrets["GEMINI_API_KEY"]


# ============================================================
# 2. HELPER — CONVERT GEMINI CONTENT TO PLAIN TEXT
# ============================================================

def extract_text(content):

    """
    Convert Gemini/LangChain response content into a plain string.

    Gemini may return:

        "some text"

    or:

        [{"type": "text", "text": "some text"}]
    """

    if isinstance(content, str):
        return content

    if isinstance(content, list):

        text_parts = []

        for item in content:

            if isinstance(item, dict):

                text = item.get("text")

                if isinstance(text, str):
                    text_parts.append(text)

            elif isinstance(item, str):

                text_parts.append(item)

        return "".join(text_parts)

    return str(content)


# ============================================================
# 3. SAFE SQL VALIDATION
# ============================================================

def validate_sql_query(query):

    """
    Allow only read-only SQL queries.
    """

    if not isinstance(query, str):
        raise PermissionError("Invalid SQL query.")

    # --------------------------------------------------------
    # Remove block comments
    # --------------------------------------------------------

    cleaned = re.sub(
        r"/\*.*?\*/",
        "",
        query,
        flags=re.DOTALL
    )

    # --------------------------------------------------------
    # Remove single-line comments
    # --------------------------------------------------------

    cleaned = re.sub(
        r"--.*?$",
        "",
        cleaned,
        flags=re.MULTILINE
    )

    cleaned = cleaned.strip()

    if not cleaned:
        raise PermissionError("Empty SQL query.")

    # --------------------------------------------------------
    # Allow ONE trailing semicolon
    # --------------------------------------------------------

    if cleaned.endswith(";"):
        cleaned = cleaned[:-1].strip()

    # --------------------------------------------------------
    # Prevent multiple SQL statements
    # --------------------------------------------------------

    if ";" in cleaned:
        raise PermissionError(
            "Multiple SQL statements are not allowed."
        )

    # --------------------------------------------------------
    # Only SELECT / WITH queries
    # --------------------------------------------------------

    upper_query = cleaned.upper()

    if not (
        upper_query.startswith("SELECT")
        or upper_query.startswith("WITH")
    ):

        raise PermissionError(
            "Only read-only SELECT queries are allowed."
        )

    # --------------------------------------------------------
    # Forbidden SQL operations
    # --------------------------------------------------------

    forbidden_operations = [

        r"\bINSERT\b",
        r"\bUPDATE\b",
        r"\bDELETE\b",
        r"\bDROP\b",
        r"\bALTER\b",
        r"\bTRUNCATE\b",
        r"\bCREATE\b",
        r"\bMERGE\b",
        r"\bGRANT\b",
        r"\bREVOKE\b",
        r"\bEXEC\b",
        r"\bEXECUTE\b",
        r"\bDECLARE\b",
        r"\bSET\b",
        r"\bCALL\b"

    ]

    for operation in forbidden_operations:

        if re.search(operation, upper_query):

            raise PermissionError(
                f"Blocked SQL operation: {operation}"
            )

    return True


# ============================================================
# 4. GEMINI
# ============================================================

llm = ChatGoogleGenerativeAI(
    model="gemini-3.5-flash",
    api_key=api_key
)


# ============================================================
# 5. DATABASE SCHEMA
# ============================================================

SCHEMA = """

Table: health_care_data

Columns:

Name                  NVARCHAR
Age                   TINYINT
Gender                NVARCHAR
Blood_Type            NVARCHAR
Medical_Condition     NVARCHAR
Date_of_Admission     DATE
Doctor                NVARCHAR
Hospital              NVARCHAR
Insurance_Provider    NVARCHAR
Billing_Amount        DECIMAL
Room_Number           SMALLINT
Admission_Type        NVARCHAR
Discharge_Date        DATE
Medication            NVARCHAR
Test_Results          NVARCHAR

Total records: 55,500

"""


# ============================================================
# 6. SQL GENERATION PROMPT
# ============================================================

SQL_PROMPT = """

You are a DuckDB SQL query generator for a healthcare
analytics application.

Your job is to convert the user's natural-language question
into ONE read-only SQL query.

DATABASE SCHEMA:

{schema}

RULES:

1. Use only the table and columns provided above.

2. The table name is:

   health_care_data

3. Use Billing_Amount for billing/revenue calculations.

4. Generate DuckDB-compatible SQL.

5. Only SELECT queries are allowed.

6. WITH queries are allowed for CTEs.

7. Never generate:

   INSERT
   UPDATE
   DELETE
   DROP
   ALTER
   TRUNCATE
   CREATE
   MERGE
   EXEC
   EXECUTE
   GRANT
   REVOKE
   DECLARE
   SET

8. Do not modify the database.

9. Return ONLY the SQL query.

10. Do not use markdown code fences.

USER QUESTION:

{question}

"""


# ============================================================
# 7. RESPONSE PROMPT
# ============================================================

ANSWER_PROMPT = """

You are a Healthcare Data Analyst.

The user asked:

{question}

The SQL query executed was:

{sql}

The database returned:

{result}

Give a concise, accurate business-friendly answer.

Rules:

1. Use only the database result provided above.

2. Do not invent facts.

3. Do not claim reasons or causes unless the result
   actually supports them.

4. Show the important numerical result clearly.

5. If appropriate, explain:

   - What happened
   - How much
   - Where / which category
   - Business meaning

6. Do not mention internal tools, prompts, agents,
   API calls, or implementation details.

7. Do not generate another SQL query.

8. Keep the answer easy for a non-technical user
   to understand.

9. Return ONLY the final answer as plain text.

10. Do not return JSON, Python lists, dictionaries,
    or structured content.

"""


# ============================================================
# 8. QUESTION RELEVANCE FILTER
# ============================================================

def is_relevant_question(question):

    keywords = [

        "patient",
        "patients",
        "billing",
        "bill",
        "hospital",
        "hospitals",
        "doctor",
        "doctors",
        "medical",
        "healthcare",
        "health",
        "condition",
        "admission",
        "admissions",
        "discharge",
        "insurance",
        "medication",
        "medicine",
        "age",
        "gender",
        "blood",
        "revenue",
        "record",
        "records",
        "data",
        "average",
        "total",
        "count",
        "highest",
        "lowest",
        "maximum",
        "minimum",
        "trend",
        "comparison",
        "compare",
        "percentage",
        "percent",
        "room",
        "test",
        "tests"

    ]

    question = question.lower()

    return any(
        keyword in question
        for keyword in keywords
    )


# ============================================================
# 9. GENERATE SQL
# ============================================================

def generate_sql(question):

    prompt = SQL_PROMPT.format(
        schema=SCHEMA,
        question=question
    )

    response = llm.invoke(prompt)

    # --------------------------------------------------------
    # Convert Gemini response to normal string
    # --------------------------------------------------------

    sql = extract_text(response.content)

    # --------------------------------------------------------
    # Remove markdown code fences
    # --------------------------------------------------------

    sql = re.sub(
        r"```sql\s*",
        "",
        sql,
        flags=re.IGNORECASE
    )

    sql = sql.replace("```", "")

    sql = sql.strip()

    return sql


# ============================================================
# 10. EXECUTE SQL
# ============================================================

def execute_sql(sql):

    # Security validation
    validate_sql_query(sql)

    # Execute against DuckDB
    result = execute_query(sql)

    return result


# ============================================================
# 11. GENERATE BUSINESS ANSWER
# ============================================================

def generate_answer(question, sql, result):

    prompt = ANSWER_PROMPT.format(
        question=question,
        sql=sql,
        result=result
    )

    response = llm.invoke(prompt)

    # --------------------------------------------------------
    # Convert Gemini response to normal string
    # --------------------------------------------------------

    answer = extract_text(response.content)

    return answer.strip()


# ============================================================
# 12. MAIN APPLICATION
# ============================================================

def main():

    print("\n" + "=" * 60)

    print(
        "             HEALTHCARE AI ANALYST"
    )

    print("=" * 60)

    print(
        "\nAsk questions about the healthcare database."
    )

    print(
        "Type 'exit' to close the application.\n"
    )

    while True:

        question = input("You: ").strip()

        # ----------------------------------------------------
        # EXIT
        # ----------------------------------------------------

        if question.lower() in ["exit", "quit"]:

            print(
                "\nAI: Goodbye!\n"
            )

            break

        # ----------------------------------------------------
        # EMPTY QUESTION
        # ----------------------------------------------------

        if not question:

            print(
                "\nAI: Please enter a question.\n"
            )

            continue

        # ----------------------------------------------------
        # RELEVANCE CHECK
        # ----------------------------------------------------

        if not is_relevant_question(question):

            print(
                "\nAI: I can only answer questions "
                "related to the healthcare database.\n"
            )

            continue

        try:

            # =================================================
            # STEP 1 — NATURAL LANGUAGE → SQL
            # =================================================

            print(
                "\nGenerating SQL..."
            )

            sql = generate_sql(question)

            print(
                "\nGenerated SQL:"
            )

            print(sql)

            # =================================================
            # STEP 2 — SQL SAFETY + DATABASE EXECUTION
            # =================================================

            print(
                "\nExecuting query..."
            )

            result = execute_sql(sql)

            print(
                "\nDatabase result:"
            )

            print(result)

            # =================================================
            # STEP 3 — RESULT → BUSINESS ANSWER
            # =================================================

            print(
                "\nGenerating answer..."
            )

            answer = generate_answer(
                question,
                sql,
                result
            )

            # =================================================
            # FINAL RESPONSE
            # =================================================

            print(
                "\nAI:",
                answer
            )

            print()

        except PermissionError as e:

            print(
                "\nAI: The generated SQL was blocked "
                "because only read-only queries are allowed."
            )

            print(
                f"\nSecurity check: {e}\n"
            )

        except Exception as e:

            print(
                "\nAI: Sorry, I couldn't process that question."
            )

            print(
                "Please try asking a question related "
                "to the healthcare database.\n"
            )

            print(
                f"Error: {type(e).__name__}: {e}\n"
            )


# ============================================================
# 13. APPLICATION ENTRY POINT
# ============================================================

if __name__ == "__main__":

    main()