import subprocess

result = subprocess.run(["todo"], stdout=subprocess.PIPE)

output = result.stdout.decode()

str_sin_basura = output.replace('\n', '').replace('\x1b[1m\x1b[34m', '').replace('\x1b[0m\x1b[0m\x1b[90m','').split(' ')

titulo = str_sin_basura[4:str_sin_basura.index('items:')]

completed = str_sin_basura[str_sin_basura.index('items:')+1]

left = str_sin_basura[str_sin_basura.index('completed,')+1]

print("| 󰃁 ", completed, " | 󰧌 ", left, flush=True)
