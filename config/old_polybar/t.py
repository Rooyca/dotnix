#!/usr/bin/env python

import subprocess

result = subprocess.run("todo", shell=True, stdout=subprocess.PIPE)

output = result.stdout.decode()

print(len(output.splitlines()), flush=True)
