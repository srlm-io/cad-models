// stellated rhombic dodecahedron

use <stellated-rhombic-dodecahedron.scad>;
use <../chamfer_base.scad>;
x_count = 6;
y_count = 6;

h=10;
b=15;

foundation_height=4;
chamfer_height = 3;

srd_offset=sqrt(2*b*b);
echo("srd_offset: ", srd_offset);
echo("Width: ", srd_offset*x_count);

// Generate the form with a "chisel" point faced up
module chisel_base(offset, x_count, y_count, h, b){
      intersection(){
      translate([offset/2, offset/2, offset/2]) 
            union(){
               for(j = [0:y_count-1]){
                  for(i = [0:x_count-1]){
                     translate([i*offset, j*offset, 0]) srd(h, b);
                  }
               }
            }
            translate([0, 0, offset/2-0.01]) cube([x_count*offset, y_count*offset, offset]);
      }
}

union(){
   chisel_base(srd_offset, x_count, y_count, h, b);
   translate([0, 0, -foundation_height+srd_offset/2]) 
      chamfer_base(srd_offset*x_count, srd_offset*y_count, foundation_height, chamfer_height);
}
   

//chisel_base(srd_offset, x_count, y_count, h, b);
//translate([-srd_offset/2, -srd_offset/2, -foundation_height])
  // cube([srd_offset*x_count, srd_offset*y_count, foundation_height]);

//translate([]) rotate([0, 180, 45]) cylinder(100, srd_offset*x_count, 0, $fn=4);

//// Generate the form with a "diamond" point sticking up.
//module diamond_base(offset, x_count, y_count, h, b){
//   y_offset=b;
//   echo("y_offset: ", y_offset);
//   for(j = [0:y_count-1]){
//      for(i = [0:x_count-1+j%2]){
//         translate([i*offset - ((j%2)*(offset/2)), j*y_offset, 0]) rotate([45, 0, 0]) srd(h, b);
//      }
//   }
//}
//
//union(){
//   diamond_base(srd_offset, x_count, y_count, h, b);
//   cube([srd_offset*x_count,


