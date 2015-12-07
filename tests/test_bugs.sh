#!/bin/bash

for bug in $(ls ../bugs/); do
	make test -C "../bugs/$bug/PRIVATE"
done
