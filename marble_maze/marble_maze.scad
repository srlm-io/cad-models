

//$fn=100;
//NB: tunnel size seems to be undersized by 0.3mm due to printing
tunnel_diameter=16+2; // mm, based on http://glassmarbles.com/size.htm
tunnel_offset=tunnel_diameter+4;

maze_boundary_padding=[8, 8, 8];

title_size = 8;
title_depth = 1;

module generate_maze_path(segments){
   for(segment = segments){  
      hull() for(terminal = segment){
         scaled_offset = terminal * tunnel_offset;
         
         translate([
            scaled_offset[0] + tunnel_offset/2,
            scaled_offset[1] + tunnel_offset/2,
            scaled_offset[2] + tunnel_offset/2]) sphere(d=tunnel_diameter);    
      }
   }
}

module generate_maze(title, size, segments){
   box_roundness = tunnel_diameter/4;
   t = [box_roundness, box_roundness, box_roundness];
   cube_size_scaled = size*tunnel_offset;

   difference(){
      translate(t/2-maze_boundary_padding/2) minkowski(){
         cube(cube_size_scaled - t + maze_boundary_padding);
         sphere(d=box_roundness);
      }

      translate([
         cube_size_scaled[0]/2, 
         cube_size_scaled[1]/2, 
         cube_size_scaled[2] - title_depth + 0.01 + maze_boundary_padding[2]/2
      ]) 
      linear_extrude(title_depth + 0.01) 
      text(title, size=title_size, halign="center", valign="center");

      generate_maze_path(segments, tunnel_diameter, tunnel_offset);
   }
}


// A simple U shaped "maze"
/*
$fn=20;

segments = [
   [[0, -1, 0], [0, 1, 0]],
   [[0, 1, 0], [0, 1, 2]],
   [[0, 1, 2], [0, -1, 2]]
];

size=[1,2,3];

title = "U Maze";


generate_maze(title, size, segments);
//generate_maze_path(segments);

*/

