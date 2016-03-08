#!/bin/bash

for img in tests/*.in; do
	python3.4 src/main.py "$img" > "${img%.*}.res"
done
