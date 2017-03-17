boundary = 5;
depth = 3;
base_depth = depth*2;
stem_height = 15;
grip_dia = 25;
stem_dia = grip_dia/2;
stamp_wall_thickness = 2.5;

$fn=40;

module make_stamped(depth){
   echo("Making stamped");
   // For development, comment out the minkowski and set the extrude to depth
   minkowski(){
      linear_extrude(/*depth/**/0.001)  children(0);
      cylinder(r1=0.5*depth, r2=0, h=depth);
   }
}

module stamp(){
   echo("Children: ", $children);
   translate([base_width-boundary, base_height-boundary, base_depth]) mirror([1,0,0]) {
      for (j = [0 : 1 : $children - 1]){
         make_stamped(depth) children(j);
      }
   }

   cube([base_width, base_height, base_depth]);
}

module body(){
   difference(){
      translate([-stamp_wall_thickness, -stamp_wall_thickness, -2*stamp_wall_thickness-0.001]) cube([base_width + 2*stamp_wall_thickness, base_height+2*stamp_wall_thickness, base_depth + 2*stamp_wall_thickness]);
      // Use a cube here instead of the child so that we aren't dependent on a Minkowski
      cube([base_width, base_height, base_depth]);
   }

   translate([base_width/2, base_height/2, -2*stamp_wall_thickness + 0.001])  rotate([180, 0, 0]){
      cylinder(h=stem_height, d=stem_dia, $fn=10);
      translate([0, 0, stem_height]) sphere(d=grip_dia, $fn=10);
   };
}
