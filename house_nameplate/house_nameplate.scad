address = "123 Main St #9";
names = ["Srlm", "Alice", "Carol"];

letter_thickness = 20;
address_letter_height = 12;
name_letter_height = 15;
row_height = name_letter_height * 1.5;
random_base_height = 4;
outset_clearance = 0.5;

// Shared variables (must also change random script)
width = 120;
length = 120;
height = 20;

text_base_thickness = 10;

use <vendor/scad-utils/morphology.scad>

module generate_text(address, address_height, names, name_height, row_height){
   text(address, halign="center", valign="top", size=address_height, font="Noto Sans CJK JP:style=Black");
   
   for(i = [0:len(names)-1]){
      name = names[i];
      translate([0, -row_height*(i+1.25), 0]) text(name, halign="center", valign="top", size=name_height, font="Noto Sans CJK JP:style=Black");
   }
}

use <chamfer_base.scad>;
module generate_insert(thickness){
   union(){
      // Text
      translate([width/2, length*7/8, 0]) generate_text(address, address_letter_height, names, name_letter_height, row_height);
      
      // "Random" text color elements
      translate([width*.1, length*.22, 0]) rotate([0, 0, 45/2]) circle(10, $fn=8);
      translate([width*.8, length*.57, 0]) circle(6, $fn=6);
      translate([width*.86, length*.48, 0]) rotate([0, 0, 45/2]) circle(4, $fn=8);
   }
}

// Shapes taken from http://svn.clifford.at/openscad/trunk/libraries/shapes.scad

// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}

// size is the XY plane size, height in Z
module octagon(size, height) {
  intersection() {
    cube([size, size, height], true);
    rotate([0,0,45]) cube([size, size, height], true);
  }
}

module random_base(){
   include <house_nameplate_shapes.scad>
   union(){
      cube([width, length, random_base_height]);
      for(i = shapes){
         type = i[0];
         x = i[1];
         y = i[2];
         size = i[3];
         height = i[4];
         translate([x, y, height/2]) {
            if(type == 0){
               hexagon(size, height);
            }
            if(type == 1){
               octagon(size, height);
            }
         }
      }
   }
}

module outsert(){
   difference(){
      random_base();
      translate([0,0,-1]) linear_extrude(1000) outset(d=outset_clearance) generate_insert();
   }
}

module insert(){
   union(){
      linear_extrude(letter_thickness) generate_insert();
      // Base
      translate([0, 0, -text_base_thickness + 0.01]) chamfer_base(width, length, text_base_thickness, text_base_thickness - 1);
   }
}

//outsert();
color([1,0,0]) insert();
