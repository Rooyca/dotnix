from .utils import read_transactions, get_color
from datetime import datetime
from rich.console import Console
from rich.table import Table
from rich import print

def list_transactions(range_date=None):
    transactions = read_transactions()
    if not transactions:
        print("[bold red]No transactions found.[/bold red]")
        return

    # Filter transactions by date range if provided
    if range_date:
        start_date, end_date = range_date
        transactions = [
            transaction for transaction in transactions
            if start_date <= datetime.fromtimestamp(transaction['date'] / 1000).strftime('%m/%d/%Y') <= end_date
        ]

    if not transactions:
        print("[bold yellow]No transactions found in the specified range.[/bold yellow]")
        return

    # Sort transactions by date
    transactions = sorted(transactions, key=lambda x: x['date'])

    table = Table(title="Summary")
    table.add_column("ID", justify="right", style="cyan", no_wrap=True)
    table.add_column("Date", style="magenta")
    table.add_column("Category", style="yellow")
    table.add_column("Description", style="green")
    table.add_column("Amount", justify="right", style="white")

    total_transaction = 0
    total_income = 0

    for transaction in transactions:
        date = datetime.fromtimestamp(transaction['date'] / 1000).strftime('%Y-%m-%d')
        amount = int(f"{transaction['amount']}")

        color = get_color(amount)

        if amount < 0:
            total_transaction += amount
        else:
            total_income += amount

        table.add_row(
            str(transaction['id']),
            date,
            transaction['category'],
            transaction['summary'],
            f"[bold {color}]{amount}[/bold {color}]"
        )

    table2 = Table(title="Overall")
    table2.add_column("Income", style="green")
    table2.add_column("Transaction", style="red")
    table2.add_column("Total", style="purple")
    table2.add_row(str(total_income), str(total_transaction), str(total_income + total_transaction))

    console = Console()
    console.print(table)
    console.print(table2)
