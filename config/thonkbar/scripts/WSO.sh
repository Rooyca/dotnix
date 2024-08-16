#!/bin/bash

wsact=$(bspc query -D -d .occupied --names)
output=""

for i in $wsact; do
    output+=" $i "
done

echo "[$output]"