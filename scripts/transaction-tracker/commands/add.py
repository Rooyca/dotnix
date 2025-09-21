from .utils import read_transactions, write_transactions
from datetime import datetime
from rich import print

def add_transaction(summary, amount, category, income, date):
    actual_date = date

    if amount <= 0:
        print("Amount must be [bold green]greater[/bold green] than 0.")
        return
    
    transactions = read_transactions()

    if len(transactions) == 0:
        transaction_id = 1
    else:
        transaction_id = transactions[-1]['id'] + 1

    if not income:
        amount = -abs(amount)

    if date:
        actual_date = datetime.strptime(date, '%m/%d/%Y')
        actual_date = int(actual_date.timestamp() * 1000)
    else:
        actual_date = int(datetime.now().timestamp() * 1000)

    transactions.append({
        'id': transaction_id,
        'date': actual_date, 
        'summary': summary,
        'category': category,
        'amount': amount
        })
    
    write_transactions(transactions)
    print(f"Transaction [bold green]added[/bold green] successfully (ID: {transaction_id})")