// stellated rhombic dodecahedron

use <stellated-rhombic-dodecahedron.scad>;
use <chamfer_base.scad>;
x_count = 6;
y_count = 6;

h=10;
b=15;

y_offset=b;

foundation_height=4;
chamfer_height = 3;

srd_offset=sqrt(2*b*b);
echo("srd_offset: ", srd_offset);
echo("Width: ", srd_offset*x_count);

// Generate the form with a "diamond" point sticking up.
module diamond_base(offset, x_count, y_count, y_offset, h, b){
   
   echo("y_offset: ", y_offset);
   intersection(){
   translate([offset/2, offset/2, offset/2]) 
         union(){
         for(j = [0:y_count-1]){
            for(i = [0:x_count-1-j%2]){
               translate([i*offset + ((j%2)*(offset/2)), j*y_offset, 0]) rotate([45, 0, 0]) srd(h, b);
            }
         }
      }
      translate([0, -y_offset/4, offset/2-0.01]) cube([x_count*offset, y_count*(y_offset+2.5), offset]);
   }
}

union(){
   diamond_base(srd_offset, x_count, y_count, y_offset, h, b);
   translate([0, -y_offset/4, -foundation_height+srd_offset/2]) 
      chamfer_base(srd_offset*x_count, y_offset*(y_count+1), foundation_height, chamfer_height);
}
   

