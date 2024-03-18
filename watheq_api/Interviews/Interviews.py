#!/usr/bin/env python3.9
import json
from openai import OpenAI
import time
import logging
import sys



# OpenAI API setup
client = OpenAI(api_key="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")
assistant_id = 'asst_2vPyzV0YpiKzFHYusDg4CgqZ'


# Functions for handling interview logic
def start_interview(context):
    thread, run = create_thread_and_run(context)
    

    first_question = wait_for_run_completion(client, thread.id,run.id) # Get the first question from the run

    return json.dumps({'question':  first_question, "thread_id": thread.id})



def create_thread_and_run(user_input):
    thread = client.beta.threads.create()
    run = submit_message(assistant_id, thread.id, user_input, "you will be acting as my job interviewer. Begin the interview by greeting using my first name, and ask me to introduce myself only as \"hello FirstName Could you introduce yourself?\"." )# edit format
    return thread, run


def submit_message(assistant_id, thread_id, user_message, instructions):
    client.beta.threads.messages.create(
        thread_id=thread_id, role="user", content=user_message
    )
    return client.beta.threads.runs.create(
        thread_id=thread_id,
        assistant_id=assistant_id,
        instructions=instructions, #change it in each time
    )

def next_question(thread_id, user_answer):
    # Simulate fetching next question based on thread ID and user answer
    run = submit_message(assistant_id, thread_id, user_answer, "In this interview simulation, you will be acting as my job interviewer. Your questions MUST contain at least one queastion related to my CV information, and MUST contain at least one question about the job offer details, and MUST at least contain one question about HR-related topics such as strengths, weaknesses, and motivation for applying. Do not repeat questions. Your questions should be concise, limited to a single sentence, and no longer than 100 letters. If I ask you something out of context, gently guide me back by rephrasing your last question and remind me to stay focused on the interview")
    #run = submit_message(assistant_id, thread_id, user_answer, "In this interview simulation, you will be acting as my job interviewer. Ask questions related to all aspects of my CV information, the job offer details, and HR-related topics such as strengths, weaknesses, and motivation for applying. Do not repeat questions. Your questions should be concise, limited to a single sentence, and no longer than 100 letters. If I ask you something out of context, gently guide me back by rephrasing your last question and remind me to stay focused on the interview")
    #generate_interview_question(thread_id, user_answer, "")
    next_question = wait_for_run_completion(client=client, thread_id=thread_id, run_id=run.id) # Get the first question from the run

    return json.dumps({'question': next_question, 'thread_id': thread_id})


def wait_for_run_completion(client, thread_id, run_id, sleep_interval=0.5):
    while True:
        try:
            run = client.beta.threads.runs.retrieve(thread_id=thread_id, run_id=run_id)
            if run.completed_at:
                # Get messages here once Run is completed!
                messages = client.beta.threads.messages.list(thread_id=thread_id)
                last_message = messages.data[0]
                response = last_message.content[0].text.value
                return response.strip()  # Return the response and strip any whitespace
        except Exception as e:
           # logging.error(f"An error occurred while retrieving the run: {e}")
            break
       # logging.info("Waiting for run to complete...")
        time.sleep(sleep_interval)

def generate_feedback(thread_id, user_answer):
    run =  submit_message(assistant_id, thread_id, user_answer, "This is the last answer, Stop asking any more questions and end the interview.Begin the feedback by\"This is the end of interview and here is the feedback\" and Based on our entire conversation, please provide a comprehensive evaluation of my answers to the interview, including strengths based only on my performance in my answer, areas for improvement, and suggestions for future interviews.If my answer is not clear, please tell me.")

    feedback = wait_for_run_completion(client=client, thread_id=thread_id, run_id=run.id) 
    return json.dumps({'question': feedback, 'thread_id': thread_id })
   

action = sys.argv[1]

if action == "start":
    print(start_interview(sys.argv[2]))
elif action == "next":
    thread_id = sys.argv[3]
    user_answer = sys.argv[2]
    print(next_question(thread_id, user_answer))
elif action == "last":
    thread_id = sys.argv[3]
    user_answer = sys.argv[2]
    print(generate_feedback(thread_id, user_answer))
else:
    print("Invalid action specified.")