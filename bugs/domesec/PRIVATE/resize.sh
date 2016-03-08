#!/bin/bash

for img in tests/*.in; do
 convert "$img" -resize 50% -compress none "$img"
 bin/bw "$img" "${img%.*}.res"
done
