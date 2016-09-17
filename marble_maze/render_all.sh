#!/bin/bash

# sudo apt install parallel

GLOBIGNORE="marble_maze.scad"

for f in *.scad
do
    sem -j +0 "openscad-nightly --render -D \\\$fn=100 $f -o ${f%.*}.stl && echo 'Rendered $f -> ${f%.*}.stl'"
done

sem --wait
