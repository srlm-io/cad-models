include <regazza_mast_constants.scad>

difference(){
    union(){
        // Basic shelll
       difference(){
            // Outside shell
            union(){
                // Radius 1
                translate([mast_interior_circle_center_distance/2, 0, 0]) cylinder(mast_height, d=mast_exterior_diameter, center=true);
                // Radius 2
                translate([-mast_interior_circle_center_distance/2, 0, 0]) cylinder(mast_height, d=mast_exterior_diameter, center=true);
                // Interior Fill
                cube([mast_interior_circle_center_distance, mast_exterior_diameter,mast_height], center=true);
            }

            // Inside void space
            translate([0, 0, -.1]) scale([1, 1, 1.1]) union(){
                // Radius 1
                translate([mast_interior_circle_center_distance/2, 0, 0]) cylinder(mast_height, d=mast_interior_diameter, center=true);
                // Radius 2
                translate([-mast_interior_circle_center_distance/2, 0, 0]) cylinder(mast_height, d=mast_interior_diameter, center=true);
                // Interior Fill
                cube([mast_interior_circle_center_distance, mast_interior_diameter,mast_height], center=true);
            }
        }

        // Sail bolt rope track
       translate([mast_interior_circle_center_distance*3/4, 0, 0]) difference(){
            cylinder(mast_height, d=bolt_rope_outer, center=true);
            cylinder(mast_height + 2, d=bolt_rope_inner, center=true);
        }
    }

    // Sail body cutout
    translate([mast_interior_circle_center_distance/2 + mast_interior_diameter/2, 0, 0]) cube([3,2,mast_height+2], center=true);
}


