// A simple U shaped "maze"
segments = [
   [[0, -1, 0], [0, 1, 0]],
   [[0, 1, 0], [0, 1, 2]],
   [[0, 1, 2], [0, -1, 2]]
];

size=[1,2,3];

title = "U";

include <marble_maze.scad>;

generate_maze(title, size, segments);
//generate_maze_path(segments);
