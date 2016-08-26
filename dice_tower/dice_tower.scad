tower_size=100;
tower_wall_thickness=10;
tower_min_distance=3;

tower_slices=100;

bt(tower_size, tower_wall_thickness, tower_min_distance)
rt(tower_size, tower_wall_thickness, tower_min_distance)
;

include <../print_volumes/form2.scad>

module rt(tower_size, tower_wall_thickness, tower_min_distance){
   tower_height=170;
   tower_twist=tower_height;

   tower_crossbeams=7;
   crossbeam_diameter=10;
   crossbeam_angle=60;
   crossbeam_offset=20;
   crossbeam_twist=360;

   randomizer_tower(tower_height, tower_twist, tower_size, tower_min_distance, tower_wall_thickness, tower_crossbeams, crossbeam_twist, crossbeam_offset, crossbeam_angle, crossbeam_diameter);  
}

module bt(tower_size, tower_wall_thickness, tower_min_distance){
   tower_height=110;
   tower_twist=tower_height;

   base_tower(tower_height, tower_twist, tower_size, tower_min_distance, tower_wall_thickness);
   
   translate([0,0, tower_height]) rotate([0,0,-tower_twist]) children();
}

module randomizer_tower(height, twist, size, min_distance, wall_thickness, crossbeam_n, crossbeam_twist, crossbeam_offset, crossbeam_angle, crossbeam_diameter){
   tower(height, twist, size, min_distance, wall_thickness);
   intersection(){
      tower(height, twist, size, min_distance, wall_thickness, solid=true);
      crossbeams(crossbeam_n, height, crossbeam_twist, crossbeam_offset, crossbeam_angle, crossbeam_diameter);
   }
}

module tower_shape(size, min_distance, wall_thickness, solid=false){
   difference() {
      offset(r = min_distance+wall_thickness, $fn=100) {
         square(size-2*wall_thickness-2*min_distance, center = true);
      }
      offset(r = min_distance, $fn=100) {
         if(!solid){
         square(size-2*wall_thickness-2*min_distance, center = true);
         }
      }
   }
}

module tower(height, twist, size, min_distance, wall_thickness, solid=false){
   linear_extrude(height=height, twist=twist, slices=tower_slices) {
      tower_shape(size, min_distance, wall_thickness, solid=solid);
   }
}

module crossbeams(n, tower_height, twist, c_offset, angle, diameter){
   for(i=[0:n]){
      translate([0,0, i*tower_height/n]) 
      rotate([0, 0, -i*twist/n])
      translate([c_offset, 0, 0]) 
      rotate([angle, 0, 90])
      cylinder(d=diameter, h=300, center=true);
   }
}

module tower_with_door(height, twist, size, min_distance, wall_thickness){
   //TODO: Add parameters for door size
   difference(){
      tower(height, twist, size, min_distance, wall_thickness);
      translate([0, 0, size/4])
      hull(){
         rotate([45, 90, 0]) {
              cylinder(d=size/2, h=100);
               translate([size, 0, 0]) cylinder(d=size/2, h=100);
         }
      }
   }
}

module slide(height, twist, size, min_distance, wall_thickness){
   intersection(){
      tower(height, twist, size, min_distance, wall_thickness, solid=true);
      translate([size/4, -size/4, 0])
      rotate([-45, -45, 0])
      translate([0, 0, -100]) linear_extrude(300)
      union(){
         square([size, size]);
         rotate([0,0,180]) square([size, size]);
         rotate([0,0,45]) translate([0,size*.4,0]) square([size, size], center=true);
      }
   }
}

module base_tower(height, twist, size, min_distance, wall_thickness){
   tower_with_door(height, twist, size, min_distance, wall_thickness);
   slide(height, twist, size, min_distance, wall_thickness);
}





