#!/bin/bash

# sudo apt install parallel

GLOBIGNORE="marble_maze.scad"

#files[0]='u-maze-simple.scad'
#files[1]='t-maze.scad'
files[2]='lost_time_maze.scad'


for f in "${files[@]}"
do
    #sem -j +0 "openscad-nightly --render -D \\\$fn=100 $f -o ${f%.*}.stl && echo 'Rendered $f -> ${f%.*}.stl'"
    sem -j +0 "openscad-nightly --render -D \\\$fn=50 $f -D \"part=\\\"key\\\"\" -o ${f%.*}.key.stl && echo 'Rendered $f -> ${f%.*}.key.stl'"
done

sem --wait
