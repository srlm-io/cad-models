
$fn=40;

mast_height=50;

module mast2d(){
    outside_width=8.84;
    inside_width=6.94;
    center_distance=6.7; // The distance between the two centers that make up the mast
    rope_inside_diameter=3.32;
    rope_outside_diameter=5.22;
    
    module mastOval(diameter){
        hull(){
            translate([center_distance/2,0]) circle(d=diameter);
            translate([-center_distance/2,0]) circle(d=diameter);
        }
    }
    
    // Outer shell
    difference(){
        mastOval(outside_width);
        mastOval(inside_width);
    }
    
    translate([center_distance/2+outside_width/2-rope_outside_diameter/2, 0])
        difference(){
            circle(d=rope_outside_diameter);
            circle(d=rope_inside_diameter);
        }
}

module ma3(){
    // Attachment point is bottom of thread area.
    height=14.98;
    diameter=12.19;
    thread_height=7.62;
    thread_diameter=9.5;
    shaft_height=9.65;
    shaft_diameter=3.14;
    
    translate([0,0,-height]) cylinder(d=diameter, h=height);
    cylinder(d=thread_diameter, h=thread_height);
    translate([0,0,thread_height]) cylinder(d=shaft_diameter, h=shaft_height);
}

 crane_length=40;
crane_height=12;
crane_thickness=5;
ma3_holder_diameter=16;
ma3_holder_height=17;

difference(){
    union(){
        mast_overlap_distance=15;
        translate([0,0,-mast_overlap_distance]) hull() linear_extrude(mast_overlap_distance+0.01) mast2d();

       
        // ma3 shell
        cylinder(d=ma3_holder_diameter, h=ma3_holder_height);

        // crane
        corners = [
            //top
            [0,0,crane_height],
            //right
            [crane_length,0,0],
            //bottom
            [0,0,0]
        ];


        hull() for(corner=corners){
            translate(corner) sphere(d=crane_thickness);
        }
    }
    #translate([0,0,ma3_holder_height+0.01]) ma3();
    #translate([0,0,-mast_height]) linear_extrude(mast_height) mast2d();
}










