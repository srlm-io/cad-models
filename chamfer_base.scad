// Use like
//
// use <chamfer_base.scad>;

module chamfer_base(length, width, height, chamfer_height){
      ch = chamfer_height;
      hull(){ // transition the corners from round to sharp
         translate([0, 0, ch]) cube([length, width, height - ch]); // top potion
         intersection(){ // chamfer section
            translate([ch, ch, ch]) minkowski() {
               cube([length-2*ch, width-2*ch, ch]);
               sphere(ch, $fn=60);
            }
            cube([length, width, ch]); // Make sure that we include just the bottom chamfer
         }
      }
}


chamfer_base(50, 100, 20, 19);
