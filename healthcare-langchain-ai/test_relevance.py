from app import is_relevant_question


test_questions = [
    "What is the average billing amount?",
    "Which hospital has the highest billing?",
    "How many patients are there?",
    "What is the weather today?",
    "Who won the cricket match?",
    "Tell me a joke",
]


for question in test_questions:

    result = is_relevant_question(question)

    print("\nQuestion:", question)
    print("Relevant:", result)