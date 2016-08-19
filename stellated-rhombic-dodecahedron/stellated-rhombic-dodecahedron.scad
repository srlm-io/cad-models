// stellated rhombic dodecahedron

h=10;
b=15;

module diamond(h, b){
   rotate([0, 0, 45]) {
      cylinder(h, b, 0, $fn=4);
      translate([0, 0, -h]) cylinder(h, 0, b, $fn=4);
   }
}

module srd(h, b){
   diamond(h, b);
   rotate([90, 0, 0]) diamond(h, b);
   rotate([0, 90, 0]) diamond(h, b);
}

srd(h, b);