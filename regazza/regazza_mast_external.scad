include <regazza_mast_constants.scad>

// include <regazza_mast.scad>
$fa = 1;
$fs = 0.5;

height = 30;
thickness = 3;

difference(){
    // Outside of shell
    union(){
        // Outer radius 1
        translate([-mast_interior_circle_center_distance/2, 0, 0]) cylinder(height, d=mast_exterior_diameter + thickness, center=true);
        // Outer radius 2
        translate([mast_interior_circle_center_distance/2, 0, 0]) cylinder(height, d=mast_exterior_diameter + thickness, center=true);
        // Joiner
        cube([mast_interior_circle_center_distance, mast_exterior_diameter + thickness, height], center=true);
    }

    // Inside of shell
    translate([0, 0, -0.1]) scale([1, 1, 1.1]) union(){
        // Outer radius 1
        translate([-mast_interior_circle_center_distance/2, 0, 0]) cylinder(height, d=mast_exterior_diameter, center=true);
        // Outer radius 2
        translate([mast_interior_circle_center_distance/2, 0, 0]) cylinder(height, d=mast_exterior_diameter, center=true);
        // Joiner
        cube([mast_interior_circle_center_distance, mast_exterior_diameter, height], center=true);
    }
    
    translate([mast_interior_circle_center_distance/2 + mast_exterior_diameter/2, 0, 0]) cube([mast_interior_circle_center_distance, bolt_rope_outer, height+2], center=true);

}
