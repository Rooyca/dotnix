#!/usr/bin/python

import argparse, os
from commands.add import add_transaction
from commands.list import list_transactions
from commands.summary import show_summary
from commands.delete import delete_transaction
from datetime import datetime

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Change the current working directory to the script's directory
os.chdir(script_dir)

# Create the top-level parser
parser = argparse.ArgumentParser(description='(TRA)nsaction (TRA)cker CLI')
subparsers = parser.add_subparsers(dest='command', help='Sub-commands')

# "ADD" command
parser_add = subparsers.add_parser('add', help='Add a new transaction')
parser_add.add_argument('-c', '--category', required=True, type=str, help='Category of the transaction (e.g., Food, Transport)')
parser_add.add_argument('-s', '--summary', required=False, type=str, help='Brief description or note about the transaction')
parser_add.add_argument('-d', '--date', required=False, type=str, help='Date of the transaction in MM/DD/YYYY format')
parser_add.add_argument('-a', '--amount', required=True, type=int, help='Amount of the transaction (in whole numbers)')
parser_add.add_argument('-i', '--income', required=False, action=argparse.BooleanOptionalAction, help='Mark the entry as an income (default: False)')

# "LIST" command
parser_list = subparsers.add_parser('list', help='List all transactions')
parser_list.add_argument('-r', '--range', nargs=2, type=str, help='Date range (start end) to filter transactions in MM/DD/YYYY format')

# "SUMMARY" command
parser_summary = subparsers.add_parser('summary', help='Show summary of transactions')
parser_summary.add_argument('-m', '--month', type=int, choices=range(1, 13), help='Month (1-12) to filter transactions by month')

# "DELETE" command
parser_delete = subparsers.add_parser('delete', help='Delete a transaction')
parser_delete.add_argument('--id', required=True, type=int, help='ID of the transaction to delete')

# Parse the arguments
args = parser.parse_args()

# Helper function to validate date format
def validate_date(date_str):
    try:
        datetime.strptime(date_str, '%m/%d/%Y')
        return True
    except ValueError:
        return False

# Handle the commands
match args.command:
    case 'add':
        if args.date and not validate_date(args.date):
            print("Error: Invalid date format. Please use MM/DD/YYYY.")
        else:
            add_transaction(args.summary, args.amount, args.category, args.income, args.date)
    case 'list':
        if args.range and (not validate_date(args.range[0]) or not validate_date(args.range[1])):
            print("Error: Invalid date range format. Please use MM/DD/YYYY for both start and end dates.")
        else:
            list_transactions(args.range)
    case 'summary':
        show_summary(args.month)
    case 'delete':
        delete_transaction(args.id)
    case _:
        parser.print_help()