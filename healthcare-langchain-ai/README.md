# 🏥 Healthcare AI Analyst

An AI-powered healthcare data analytics application that allows users to ask questions about healthcare data in **natural language** and receive business-friendly answers.

The application converts natural-language questions into **DuckDB SQL queries using Gemini**, executes the queries securely against a healthcare dataset, and converts the results into concise analytical insights.

---

## 📌 Project Overview

Traditional data analysis often requires users to know SQL before they can retrieve information from a database.

This project provides a natural-language interface where users can ask questions such as:

> "What is the average billing amount?"

> "Which hospital has the highest billing?"

> "What is the total billing amount?"

The application then:

```text
User Question
      ↓
Relevance Check
      ↓
Gemini + LangChain
      ↓
SQL Generation
      ↓
SQL Security Validation
      ↓
DuckDB Query Execution
      ↓
Query Result
      ↓
Gemini Business Answer
      ↓
User
```

---

## 🎯 Objectives

* Enable natural-language interaction with healthcare data
* Automatically generate SQL from user questions
* Execute analytical queries without requiring SQL knowledge
* Prevent destructive SQL operations
* Convert raw query results into understandable business insights
* Provide an interactive chat-based analytics interface
* Demonstrate practical use of **Generative AI + Data Analytics**

---

## ✨ Key Features

### 🤖 Natural Language to SQL

Users can ask analytical questions in plain English.

Example:

```text
What is the average billing amount?
```

The application can generate:

```sql
SELECT AVG(Billing_Amount) AS average_billing_amount
FROM health_care_data;
```

---

### 🔐 Read-Only SQL Security

The application validates generated SQL before execution.

Allowed:

```sql
SELECT
WITH
```

Blocked operations include:

```text
INSERT
UPDATE
DELETE
DROP
ALTER
TRUNCATE
CREATE
MERGE
GRANT
REVOKE
EXEC
EXECUTE
DECLARE
SET
CALL
```

Multiple SQL statements are also rejected.

This ensures that the AI-generated query cannot intentionally modify or destroy the underlying data.

---

### 🎯 Question Relevance Filtering

The application checks whether a question is related to the healthcare dataset before sending it through the SQL-generation workflow.

For example:

```text
Average billing       → Relevant
Highest hospital bill → Relevant
Patient information   → Relevant

Weather               → Not relevant
Cricket               → Not relevant
Joke                  → Not relevant
```

This helps prevent unnecessary AI/database calls.

---

### 💬 Business-Friendly Answers

The application does not simply return raw database results.

For example:

```text
Average billing:
25539.316097199422
```

is converted into a user-friendly response such as:

```text
The average billing amount is approximately $25,539.32.
```

---

### 🖥️ Streamlit Interface

The project includes an interactive Streamlit interface with:

* Chat-style interaction
* Conversation history
* Clear chat functionality
* Generated SQL visibility
* Query result visibility
* Error handling
* Healthcare-focused interface

---

## 📊 Dataset

The project uses a healthcare dataset containing:

* **55,500 records**
* Patient information
* Medical conditions
* Admission information
* Billing information
* Hospitals
* Doctors
* Insurance providers
* Medications
* Test results

### Important Columns

| Column             | Description        |
| ------------------ | ------------------ |
| Name               | Patient name       |
| Age                | Patient age        |
| Gender             | Patient gender     |
| Blood_Type         | Blood type         |
| Medical_Condition  | Medical condition  |
| Date_of_Admission  | Admission date     |
| Doctor             | Doctor name        |
| Hospital           | Hospital name      |
| Insurance_Provider | Insurance provider |
| Billing_Amount     | Billing amount     |
| Room_Number        | Room number        |
| Admission_Type     | Admission type     |
| Discharge_Date     | Discharge date     |
| Medication         | Medication         |
| Test_Results       | Test results       |

---

## 🧠 AI Workflow

The application follows a controlled multi-step workflow.

### 1. User Question

The user enters a natural-language question.

```text
What is the average billing amount?
```

### 2. Relevance Check

The application determines whether the question is related to the healthcare dataset.

### 3. SQL Generation

Gemini generates DuckDB-compatible SQL based on the database schema.

### 4. SQL Validation

The generated SQL is checked for:

* Allowed query type
* Multiple statements
* Destructive operations
* Basic SQL safety rules

### 5. Query Execution

The validated query is executed against the DuckDB database.

### 6. Result Processing

The database result is returned to the application.

### 7. Business Answer Generation

Gemini converts the database result into a concise, understandable answer.

---

## 🏗️ Architecture

```text
                    ┌──────────────────────┐
                    │       User           │
                    │ Natural Language     │
                    │      Question        │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │     Streamlit UI     │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Relevance Filter    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Gemini + LangChain    │
                    │    SQL Generation     │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   SQL Validation     │
                    │     Read-Only        │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       DuckDB         │
                    │  Healthcare Dataset  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │    Query Result      │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Gemini Business      │
                    │ Answer Generation    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       User           │
                    │ Business-Friendly    │
                    │       Answer         │
                    └──────────────────────┘
```

---

## 🛠️ Tech Stack

### Programming Language

* Python

### Data Analytics

* Pandas
* NumPy

### Database

* DuckDB
* CSV

### Generative AI

* Google Gemini API
* LangChain
* `langchain-google-genai`

### Frontend

* Streamlit

### Environment & Configuration

* python-dotenv

### Testing

* Python-based unit/integration tests

---

## 📂 Project Structure

```text
healthcare-data-analytics/
│
├── Dashboard Screenshot/
│
├── healthcare-langchain-ai/
│   │
│   ├── app.py
│   ├── database.py
│   ├── streamlit_app.py
│   │
│   ├── requirements.txt
│   ├── .gitignore
│   │
│   ├── test_gemini.py
│   ├── test_gemini_sql.py
│   ├── test_langchain_db.py
│   ├── test_relevance.py
│   ├── test_security.py
│   └── test_error_handling.py
│
├── Cleaned_Health Care Dataset.csv
├── Health Care Dataset.xlsx
├── Healthcare Analysis.pbix
├── Healthcare Analysis.sql
├── Messy_healthcare_dataset.csv
│
└── README.md
```

---

## 📄 Main Application Files

### `app.py`

Contains the main backend logic:

* Question relevance checking
* SQL generation
* SQL validation
* SQL execution
* Result processing
* Business answer generation
* Error handling

### `database.py`

Responsible for:

* Loading the healthcare CSV
* Creating the DuckDB connection
* Creating the `health_care_data` view
* Executing SQL queries

### `streamlit_app.py`

Responsible for the user interface:

* Chat interface
* Session state
* User input
* AI responses
* SQL/result display
* Error messages
* Clear chat functionality

---

## 🔒 Environment Variables

The Gemini API key is stored using an environment variable.

Create a `.env` file inside:

```text
healthcare-langchain-ai/
```

Add:

```env
GEMINI_API_KEY=your_api_key_here
```

The `.env` file is intentionally excluded from Git using `.gitignore`.

**Never commit API keys or other credentials to GitHub.**

---

## ⚙️ Local Setup

### 1. Clone the repository

```bash
git clone https://github.com/KumarShailesh07/healthcare-data-analytics.git
```

### 2. Navigate to the AI application

```bash
cd healthcare-data-analytics/healthcare-langchain-ai
```

### 3. Create a virtual environment

```bash
python -m venv venv
```

### 4. Activate the environment

#### Windows

```powershell
.\venv\Scripts\Activate.ps1
```

### 5. Install dependencies

```bash
pip install -r requirements.txt
```

### 6. Configure the Gemini API key

Create `.env`:

```env
GEMINI_API_KEY=your_api_key_here
```

### 7. Run the application

```bash
python -m streamlit run streamlit_app.py
```

The application will open in your browser.

---

## 🧪 Testing

The project contains tests for the major components of the application.

### Database Test

```bash
python test_langchain_db.py
```

Verifies:

* DuckDB connection
* Dataset loading
* Record count
* Sample analytical query

### Gemini + SQL Test

```bash
python test_gemini_sql.py
```

Verifies:

* Gemini SQL generation
* SQL execution
* DuckDB integration

### Gemini Connection Test

```bash
python test_gemini.py
```

Verifies that the Gemini API connection is working.

### Relevance Test

```bash
python test_relevance.py
```

Verifies that healthcare-related and unrelated questions are correctly classified.

### Security Test

```bash
python test_security.py
```

Verifies that:

* SELECT queries are allowed
* CTE queries are allowed
* Multiple statements are blocked
* Destructive SQL commands are blocked

### Error Handling Test

```bash
python test_error_handling.py
```

Verifies handling of:

* Invalid tables
* Invalid columns
* Database query errors

---

## ✅ Current Test Status

All major test modules are passing locally:

```text
Database Test          ✅ PASS
Gemini + SQL Test      ✅ PASS
Gemini Connection      ✅ PASS
Relevance Test         ✅ PASS
Security Test          ✅ PASS
Error Handling Test    ✅ PASS
```

---

## 📈 Example Questions

The application can answer analytical questions such as:

```text
What is the average billing amount?

What is the total billing amount?

Which hospital has the highest billing?

How many patients are there?

What is the average billing amount for emergency admissions?

Which medical condition has the highest number of patients?

What is the average billing by insurance provider?

How many patients were admitted for each admission type?
```

The exact questions depend on the available dataset fields.

---

## 🔐 Security Considerations

This project is designed as a **read-only analytics application**.

Security controls include:

* API key stored outside source code
* `.env` excluded from Git
* Relevance filtering
* SQL validation
* Multiple-statement prevention
* Destructive SQL keyword blocking
* Database errors handled safely

The AI-generated SQL is **validated before execution**.

---

## 🚀 Deployment

The application is designed to be deployed using **Streamlit Community Cloud**.

Deployment requires:

1. GitHub repository
2. Streamlit application entrypoint
3. Python dependencies
4. Gemini API key configured as a deployment secret

The Gemini API key should **not** be committed to GitHub.

---

## 📌 Project Highlights

This project demonstrates practical integration of:

* Data Analytics
* SQL
* Generative AI
* Large Language Models
* LangChain
* Natural Language to SQL
* Database querying
* Prompt Engineering
* SQL Security
* Python
* Streamlit
* Error Handling
* Automated Testing

Rather than building only a chatbot, the project connects an LLM to a real analytical workflow:

```text
Natural Language
       ↓
AI Reasoning
       ↓
SQL
       ↓
Database
       ↓
Data
       ↓
Business Insight
```

---

## 🎯 Learning Outcomes

Through this project, I explored how Generative AI can be integrated into a Data Analytics workflow to make structured data more accessible to non-technical users.

Key concepts explored include:

* LLM API integration
* LangChain
* Prompt-based SQL generation
* Database abstraction
* SQL validation
* Read-only query execution
* AI-generated business explanations
* Streamlit application development
* Testing AI-assisted workflows
* Environment and API-key management

---

## 👨‍💻 Author

**Shailesh Kumar**

B.Tech CSE — Artificial Intelligence & Machine Learning

Aspiring Data Analyst | Python | SQL | Power BI | Advanced Excel | Generative AI

---

## ⭐ Future Improvements

Potential future enhancements include:

* Conversation-aware follow-up questions
* More advanced analytical reasoning
* Query result visualizations
* Automatic chart generation
* Additional healthcare KPIs
* Improved SQL validation
* Query caching
* Better handling of ambiguous questions
* Production-grade authentication and access control
* Expanded test coverage

---

## ⚠️ Disclaimer

This project is created for **educational, portfolio, and data analytics demonstration purposes**.

The healthcare dataset used in this project is not intended to represent real patient records or provide medical advice.
