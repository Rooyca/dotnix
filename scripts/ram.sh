#!/usr/bin/env bash

free -h | awk 'NR==2{print $3}' | tr -d 'i'

