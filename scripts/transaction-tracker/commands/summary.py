from .utils import read_transactions, get_color
from .utils import get_month_text
from datetime import datetime
from rich.console import Console
from rich import print

def show_summary(month=None):
    transactions = read_transactions()
    if not transactions:
        print("[bold red]No transactions found.[/bold red]")
        return
    
    month_text = ""
    if month:
        transactions = [transaction for transaction in transactions if int(datetime.fromtimestamp(transaction['date'] / 1000).strftime('%m')) == month]
        month_text = f" for {get_month_text(month)}"

    total_amount = sum((transaction['amount']) for transaction in transactions)
    color = get_color(total_amount)
    
    console = Console()
    console.print(f"[bold]Summary{month_text}[/bold]")
    console.print(f"Closing Balance: [bold {color}]{total_amount:.0f}[/bold {color}]")