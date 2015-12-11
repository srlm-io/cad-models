top_diameter = 9.56;
bottom_diameter = 18.78;
upper_height = 18.70;
inside_diameter = 7.31;
inside_depth = 12.99;
bottom_radius=17.04;
bottom_depth=2.82;

$fa=1;
$fs=0.5;

union(){
    difference(){
        cylinder(h=upper_height, d1=bottom_diameter, d2=top_diameter);
        translate([0, 0, upper_height - inside_depth + 0.1]) cylinder(h=inside_depth+0.1, d=inside_diameter);
    }
    difference(){
        translate([0, 0, bottom_radius - bottom_depth]) sphere(bottom_radius);
        translate([-100, -100, 0]) cube(200);
    }
}