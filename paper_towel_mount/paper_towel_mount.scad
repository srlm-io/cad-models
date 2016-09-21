
$fn=500;

rod_diameter=25.4; // 1 in rod
towel_diameter=140;

rod_offset=towel_diameter*.6 + rod_diameter/2;

mount_width=140;
mount_depth=40;

wall_thickness=8.5;
base_thickness=wall_thickness;

use <../chamfer_base.scad>;

tubes = [
/* [y offset, z offset, diameter] */
   [0, rod_offset, rod_diameter + 2*wall_thickness],
   [0, (rod_offset + rod_diameter/2 + wall_thickness)/2, (rod_offset + rod_diameter/2 + wall_thickness)],
   [0, (rod_offset-rod_diameter/2)/2, rod_offset-rod_diameter/2],
   [((rod_offset-rod_diameter/2)/2)*0.7, ((rod_offset-rod_diameter/2)/2)*0.75, (rod_offset-rod_diameter/2)*0.75],
   [-((rod_offset-rod_diameter/2)/2)*0.7, ((rod_offset-rod_diameter/2)/2)*0.75, (rod_offset-rod_diameter/2)*0.75]

];

module screw(){ // #8 screw
   screw_radius = 4.2;
   screw_length = 30;
   screw_head_radius = 7.4;
   screw_head_height = 3.4;

   translate([0,0,-screw_length - screw_head_height]) union(){
      cylinder(r=screw_radius, h=screw_length);
      translate([0,0,screw_length]) cylinder(r1=screw_radius, r2=screw_head_radius, h=screw_head_height);
      translate([0,0,screw_length+screw_head_height]) cylinder(r=screw_head_radius, h=screw_length);
   }
}

module tube(outside_diameter){
   rotate([0, 90, 0]) difference(){
      cylinder(d=outside_diameter, h=mount_depth);
      translate([0,0,-0.01]) cylinder(d=outside_diameter-wall_thickness*2, h=mount_depth+0.02);
   }
}

difference(){
   for (t = tubes) {
      y_offset = t[0];
      z_offset = t[1];
      diameter = t[2];
      
      translate([0, y_offset, z_offset]) tube(diameter);
   }
   // We need to get rid of the bottom part of the rings so that they do not break through the chamfer.
   translate([0, -mount_width/2, 0]) cube([mount_depth, mount_width, base_thickness/2]);
}

module mounting_screw(side, depth_side){
   translate([mount_depth* depth_side/4, (mount_width/2-base_thickness*1.10)*side, base_thickness*0.9]) rotate([-30*side, 0, 0]) screw();
}


difference(){
   translate([0, -mount_width/2, 0]) chamfer_base(mount_depth, mount_width, base_thickness, base_thickness/4);
   

   // A bit of a leaky abstraction here, but it is concise.
   #mounting_screw(-1, 1);
   #mounting_screw(-1, 3);
   #mounting_screw(1, 1);
   #mounting_screw(1, 3);
}