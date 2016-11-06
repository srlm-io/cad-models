// A maze with a bunch of "t" intersections

segments = [
   [[-1, 1, 3], [2, 1, 3]],
   [[1, 0, 3], [1, 2, 3]],

   [[1, 1, 4], [1, 1, 0]],

   [[-1, 1, 1], [2, 1, 1]],
   [[1, 0, 1], [1, 2, 1]]

];

size=[3,3,5];

title = "t Maze";

include <marble_maze.scad>;

if (part == "key"){
   generate_maze_path(segments);
} else {
   generate_maze(title, size, segments);
}
