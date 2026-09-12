import streamlit as st

from app import (
    is_relevant_question,
    generate_sql,
    execute_sql,
    generate_answer
)


# ============================================================
# PAGE CONFIG
# ============================================================

st.set_page_config(
    page_title="Healthcare AI Analyst",
    page_icon="🏥",
    layout="wide",
    initial_sidebar_state="expanded"
)


# ============================================================
# SESSION STATE
# ============================================================

if "messages" not in st.session_state:
    st.session_state.messages = []

if "dark_mode" not in st.session_state:
    st.session_state.dark_mode = True

if "pending_question" not in st.session_state:
    st.session_state.pending_question = None


# ============================================================
# THEME TOKENS
# ============================================================

ACCENT = "#14b8a6"
ACCENT_DEEP = "#0f766e"

if st.session_state.dark_mode:

    BG = "#0a0e1a"
    CARD = "#131a2b"
    BORDER = "rgba(255,255,255,0.08)"
    TEXT = "#eef2f7"
    MUTED = "#8a93a6"
    ACCENT_SOFT = "rgba(20,184,166,0.14)"

else:

    BG = "#f6f8fa"
    CARD = "#ffffff"
    BORDER = "rgba(15,23,42,0.09)"
    TEXT = "#0f172a"
    MUTED = "#5b6472"
    ACCENT_SOFT = "rgba(15,118,110,0.10)"


# ============================================================
# GLOBAL CSS
# ============================================================

st.markdown(
    f"""
    <style>

    @import url('https://fonts.googleapis.com/css2?family=Sora:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');

    html, body, [class*="css"] {{
        font-family: 'Inter', sans-serif;
    }}

    .stApp {{
        background: {BG};
    }}

    .block-container {{
        padding-top: 2.2rem;
        padding-bottom: 3rem;
        max-width: 1180px;
    }}

    h1, h2, h3, .hero-title {{
        font-family: 'Sora', sans-serif;
    }}

    /* ---------- Dashboard header panel ---------- */

    .dash-panel {{
        background: {CARD};
        border: 1px solid {BORDER};
        border-radius: 18px;
        padding: 34px 38px;
        margin-bottom: 26px;
    }}

    .hero-title {{
        font-size: 34px;
        font-weight: 700;
        color: {TEXT};
        margin-bottom: 8px;
        letter-spacing: -0.5px;
    }}

    .hero-text {{
        font-size: 15.5px;
        line-height: 1.65;
        color: {MUTED};
        max-width: 640px;
        margin-bottom: 26px;
    }}

    .stat-strip {{
        display: flex;
        gap: 0;
        border-top: 1px solid {BORDER};
        padding-top: 22px;
    }}

    .stat-item {{
        flex: 1;
        padding: 0 22px;
        border-left: 1px solid {BORDER};
    }}

    .stat-item:first-child {{
        border-left: none;
        padding-left: 0;
    }}

    .stat-label {{
        font-size: 12.5px;
        color: {MUTED};
        margin-bottom: 6px;
    }}

    .stat-value {{
        font-size: 20px;
        font-weight: 600;
        font-family: 'Sora', sans-serif;
        color: {TEXT};
    }}

    .stat-value.accent {{
        color: {ACCENT};
    }}

    /* ---------- Section label ---------- */

    .section-label {{
        font-size: 15px;
        font-weight: 600;
        color: {TEXT};
        margin: 6px 0 14px 0;
        font-family: 'Sora', sans-serif;
    }}

    /* ---------- Example question chips (st.button) ---------- */

    div[data-testid="stHorizontalBlock"] .stButton > button {{
        background: {ACCENT_SOFT};
        color: {TEXT};
        border: 1px solid {BORDER};
        border-radius: 12px;
        padding: 14px 16px;
        text-align: left;
        font-size: 14px;
        font-weight: 500;
        white-space: normal;
        height: 100%;
        width: 100%;
        transition: border-color 0.15s ease, transform 0.1s ease;
    }}

    div[data-testid="stHorizontalBlock"] .stButton > button:hover {{
        border-color: {ACCENT};
        color: {TEXT};
    }}

    div[data-testid="stHorizontalBlock"] .stButton > button:active {{
        transform: scale(0.99);
    }}

    /* ---------- Sidebar buttons ---------- */

    section[data-testid="stSidebar"] .stButton > button {{
        border-radius: 10px;
        border: 1px solid {BORDER};
        background: transparent;
        color: {TEXT};
    }}

    section[data-testid="stSidebar"] .stButton > button:hover {{
        border-color: {ACCENT};
        color: {ACCENT};
    }}

    /* ---------- Status dot ---------- */

    .status-row {{
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: {TEXT};
        font-weight: 500;
    }}

    .status-dot {{
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: {ACCENT};
        box-shadow: 0 0 0 4px {ACCENT_SOFT};
    }}

    </style>
    """,
    unsafe_allow_html=True
)


# ============================================================
# SIDEBAR
# ============================================================

with st.sidebar:

    st.title("🏥 Healthcare AI")

    st.caption("Intelligent Healthcare Data Analytics")

    st.divider()

    st.success("AI Analyst Online")

    st.subheader("System")

    st.write("🐍 Python")
    st.write("🖥️ Streamlit")
    st.write("✨ Gemini")
    st.write("🔗 LangChain")
    st.write("⚡ DuckDB")
    st.write("📄 CSV")

    st.divider()

    st.subheader("Dataset")

    st.metric(
        "Healthcare Records",
        "55,500"
    )

    st.caption("CSV dataset connected through DuckDB")

    st.divider()

    st.subheader("Capabilities")

    st.write("✓ Natural language questions")
    st.write("✓ Automatic SQL generation")
    st.write("✓ Read-only SQL validation")
    st.write("✓ DuckDB query execution")
    st.write("✓ AI business insights")

    st.divider()

    if st.button(
        "☀️ Light Mode" if st.session_state.dark_mode
        else "🌙 Dark Mode",
        use_container_width=True
    ):
        st.session_state.dark_mode = not st.session_state.dark_mode
        st.rerun()

    if st.button(
        "🗑️ Clear Conversation",
        use_container_width=True
    ):
        st.session_state.messages = []
        st.rerun()


# ============================================================
# DASHBOARD HEADER (hero + stats merged into one panel)
# ============================================================

st.markdown(
    f"""
    <div class="dash-panel">
        <div class="hero-title">Ask your healthcare data anything</div>
        <div class="hero-text">
            Type a question in plain English. The analyst turns it into SQL,
            runs it against the dataset, and explains the result in
            business terms — no query writing required.
        </div>
        <div class="status-row">
            <span class="status-dot"></span> Analyst ready
        </div>
        <div class="stat-strip">
            <div class="stat-item">
                <div class="stat-label">Patient Records</div>
                <div class="stat-value">55,500</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">Query Engine</div>
                <div class="stat-value accent">DuckDB</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">AI Model</div>
                <div class="stat-value accent">Gemini</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">Framework</div>
                <div class="stat-value accent">LangChain</div>
            </div>
        </div>
    </div>
    """,
    unsafe_allow_html=True
)


# ============================================================
# EXAMPLE QUESTIONS — clickable chips
# ============================================================

st.markdown(
    '<div class="section-label">💡 Try asking</div>',
    unsafe_allow_html=True
)

example_questions = [
    "💰  What is the average billing amount?",
    "👥  What is the gender distribution?",
    "🏥  What are the most common medical conditions?",
]

ex_cols = st.columns(3)

for col, q in zip(ex_cols, example_questions):
    with col:
        if st.button(q, key=f"example_{q}", use_container_width=True):
            # strip the leading emoji before sending to the backend
            st.session_state.pending_question = q.split("  ", 1)[1]
            st.rerun()


# ============================================================
# CHAT HISTORY
# ============================================================

if st.session_state.messages:

    st.markdown(
        '<div class="section-label">💬 Analysis History</div>',
        unsafe_allow_html=True
    )

    for message in st.session_state.messages:

        with st.chat_message("user"):
            st.write(message["question"])

        with st.chat_message("assistant"):

            st.write(message["answer"])

            if message.get("sql"):

                with st.expander("🔍 Generated SQL"):
                    st.code(
                        message["sql"],
                        language="sql"
                    )

            if message.get("result"):

                with st.expander("📊 Database Result"):
                    st.write(message["result"])


# ============================================================
# CHAT INPUT
# ============================================================

typed_question = st.chat_input(
    "Ask a question about the healthcare dataset..."
)

# A clicked example chip takes priority over a freshly typed question
question = st.session_state.pending_question or typed_question
st.session_state.pending_question = None


# ============================================================
# PROCESS QUESTION
# ============================================================

if question:

    with st.chat_message("user"):
        st.write(question)

    with st.chat_message("assistant"):

        with st.spinner(
            "🤖 AI Analyst is analyzing your question..."
        ):

            try:

                # ------------------------------------------
                # RELEVANCE CHECK
                # ------------------------------------------

                if not is_relevant_question(question):

                    st.warning(
                        "Please ask a question related "
                        "to the healthcare dataset."
                    )

                    st.stop()


                # ------------------------------------------
                # GENERATE SQL
                # ------------------------------------------

                sql = generate_sql(question)


                # ------------------------------------------
                # EXECUTE SQL
                # ------------------------------------------

                result = execute_sql(sql)


                # ------------------------------------------
                # GENERATE ANSWER
                # ------------------------------------------

                answer = generate_answer(
                    question,
                    sql,
                    result
                )


                # ------------------------------------------
                # DISPLAY ANSWER
                # ------------------------------------------

                st.write(answer)


                # ------------------------------------------
                # SQL
                # ------------------------------------------

                with st.expander("🔍 Generated SQL"):

                    st.code(
                        sql,
                        language="sql"
                    )


                # ------------------------------------------
                # RESULT
                # ------------------------------------------

                with st.expander("📊 Database Result"):

                    st.write(result)


                # ------------------------------------------
                # SAVE HISTORY
                # ------------------------------------------

                st.session_state.messages.append(
                    {
                        "question": question,
                        "sql": sql,
                        "result": result,
                        "answer": answer
                    }
                )


            except Exception as e:

                st.error(
                    f"❌ Something went wrong: {str(e)}"
                )