from .utils import read_transactions, write_transactions
from rich import print

def delete_transaction(transaction_id):
    transactions = read_transactions()
    if not transactions:
        print("[bold red]No transactions found.[/bold red]")

    if not any(transaction['id'] == transaction_id for transaction in transactions):
        print(f"[bold red]transaction with ID: {transaction_id} not found.[/bold red]")
        return
    
    transactions = [transaction for transaction in transactions if transaction['id'] != transaction_id]
    write_transactions(transactions)
    print(f"[bold green]Transaction deleted successfully[/bold green]")