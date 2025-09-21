import datetime
import argparse
import subprocess

# NAT: No Appointments Today
# AT: Appointments Today

path_calcurse = '/home/rooyca/.local/share/calcurse'
path_td = '/home/rooyca/.local/bin/td'

argparser = argparse.ArgumentParser(description='Calcurse')
argparser.add_argument('-a', '--apts', help='Today appointments', action='store_true')

args = argparser.parse_args()


result = subprocess.run([path_td], stdout=subprocess.PIPE)
output = result.stdout.decode()
str_no_trash = output.replace('\n', '').replace('\x1b[1m\x1b[34m', '').replace('\x1b[0m\x1b[0m\x1b[90m','').split(' ')

# title = str_no_trash[4:str_no_trash.index('items:')]
completed = str_no_trash[str_no_trash.index('items:')+1]
left = str_no_trash[str_no_trash.index('completed,')+1]
todos = " | 󰃁 "+ completed+ " | 󰧌 "+ left +" "

def get_apts():
	today = datetime.date.today().strftime("%m/%d/%Y")
	with open(path_calcurse+'/apts', 'r') as file:
		data = file.readlines()
		appointments = []
		for line in data:
			if today in line:
				appointments.append(' '.join(line.split(' ')[2:]))

		if len(appointments) > 1: return f"{len(appointments)} AT"+todos
	return ' '.join(appointments)[:7]+'..' + todos

if args.apts:
	appointments = get_apts()
	if '..' not in appointments:
		print(appointments)
	print('NAT', todos)

### LA NUEVA VERSION SOLO VA A TENER EL TOTAL DE TAREAS
### LAS TAREAS LAS ENCONTRAMOES EN ~/.var/lib/radicale/collections/
