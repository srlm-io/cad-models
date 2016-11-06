#!/bin/bash

# sudo apt install parallel

GLOBIGNORE="stamp.scad"

files=($(ls *.secret.scad))
files+=("example.scad")

parts[0]='stamp'
parts[1]='body'

for f in "${files[@]}"
do
    for p in "${parts[@]}"
    do
        echo "Rending part $f:$p"
        sem -j +0 "openscad-nightly --render -D \"part=\\\"$p\\\"\" -o ${f%.*}.$p.stl $f && echo 'Rendered $f -> ${f%.*}.$p.stl'"
    done
done

sem --wait
