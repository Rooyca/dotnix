#!/usr/bin/python3
import sys
import subprocess
import os

HOME = os.getenv("HOME")
REM_FILE = HOME+"/.reminders/events.rem"

from datetime import datetime, timedelta

# Function to convert relative time expression to formatted string
def convert_relative_time(relative_time):
    now = datetime.now()
    target_time = now + timedelta(minutes=int(relative_time.split('+')[-1].strip()))

    # Format the time string as per your requirement
    formatted_time = target_time.strftime("%Y-%m-%d %H:%M:%S")

    return formatted_time

def list_reminders():
    jobs = subprocess.run(["atq"], stdout=subprocess.PIPE, text=True).stdout.strip().split('\n')
    if jobs == [""]:
        print("No reminders scheduled.")
        return
    print()
    for job in jobs:
        job_id = job.split()[0]
        job_date = ' '.join(job.split()[1:5])
        job_detail = subprocess.run(["at", "-c", job_id], stdout=subprocess.PIPE, text=True).stdout.strip()
        job_detail = job_detail.split('\n')[-1]
        job_detail = job_detail.replace("notify-send 'REMINDER' '", "").replace("' -u critical", "")
        job_detail = job_detail if len(job_detail) < 37 else job_detail[:37] + "..."
        print("-" * 50)
        print(f"   📌 ID: {job_id}")
        print(f"   🗓️  {job_date}")
        print(f"   📝 \033[94m{job_detail}\033[0m")
    print("-" * 50)
    print(f"{' '*(30-len(str(len(jobs))))}🧮 \033[1mTotal reminders: {len(jobs)}\033[0m")

def remind():
    count = len(sys.argv) - 1
    command = sys.argv[1] if count > 0 else None
    message = sys.argv[1] if count > 0 else None
    op = sys.argv[2] if count > 1 else None
    when = " ".join(sys.argv[3:]) if count > 2 else ""

    # Display help if no parameters or help command
    if command == "help" or command == "--help" or command == "-h":
        print("COMMAND")
        print("    remind <message> <time>")
        print("    remind <command>")
        print("\nDESCRIPTION")
        print("    Displays notification at specified time\n")
        print("EXAMPLES")
        print('    remind "Hi there" now')
        print('    remind "Time to wake up" in 5 minutes')
        print('    remind "Dinner" in 1 hour')
        print('    remind "Take a break" at noon')
        print('    remind "Are you ready?" at 13:00')
        print('    remind list')
        print('    remind clear')
        print('    remind help')
        return

    # Check presence of AT command
    at_result = subprocess.run(["which", "at"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if at_result.returncode != 0:
        print("remind: AT utility is required but not installed on your system. Install it with your package manager of choice, for example 'sudo apt install at'.")
        return

    # Run commands: list, clear
    if count == 0 or command == "list":
        list_reminders()
        return
    elif count == 1 and command == "clear":
        jobs = subprocess.run(["atq"], stdout=subprocess.PIPE, text=True).stdout.strip().split('\n')
        # check if user wants to clear all reminders
        if len(jobs) == 0:
            print("No reminders to clear!")
            return
        print("Are you sure you want to clear all reminders? (y/n)")
        answer = input()
        if answer.lower() != "y":
            print("Reminders not cleared.")
            return
        for job in jobs:
            job_id = job.split()[0]
            subprocess.run(["at", "-r", job_id])
        print("All reminders cleared!")
        return
    elif count == 2 and command == "clear":
        job_id = op
        subprocess.run(["at", "-r", job_id])
        list_reminders()
        return
    else:
        pass

    # Determine time of notification
    if op == "in":
        time = "now + " + when
    elif op == "at":
        time = when
    elif op == "now":
        time = "now"
    else:
        print(f"remind: invalid time operator {op}")
        return

    # Schedule the notification
    subprocess.run([f'echo "notify-send \'REMINDER\' \'{message}\' -u critical" | at {time}'], shell=True, stderr=subprocess.PIPE, text=True)
    list_reminders()

    with open(REM_FILE, "a") as f:
        if "now" in time:
            time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        elif "+" in time:
            time = convert_relative_time(time)
        f.write(f"REM {time} MSG {message}\n")

if __name__ == "__main__":
    remind()
