#!/bin/bash

for bug in $(ls ../bugs/); do
	make --no-print-directory test -C "../bugs/$bug/PRIVATE"
done
