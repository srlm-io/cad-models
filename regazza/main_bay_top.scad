box_width_1=130;
box_width_2=120;
box_length=144;
box_height=70;
box_bottom_thickness=4;

box_top_thickness=4.55;
box_wall_thickness=3.5;

wall_top_height=40;
wall_top_inside_height=20;

arrow_diameter=9.04;
arrow_length=400;
arrow_offset_from_centerline=-44.2;
arrow_wall_thickness=2.5;

screw_free_diameter=3.6; //minimum diameter to not engage thread
screw_engage_diameter=2.5;
screw_wall_outside_diameter = screw_free_diameter + 4;

rudder_servo_offset_from_bottom = 75;
sail_servo_offset_from_bottom = 122;
sail_servo_offset_from_centerline = 34;

screw_axis_from_wall=sqrt(pow(screw_wall_outside_diameter/2,2)/2); // Get it so that not space appears in the corner.

$fn=60;

arrow_translate=[arrow_offset_from_centerline,0, box_top_thickness-arrow_diameter/2 - arrow_wall_thickness];
arrow_rotate=[90, 0, 0];

wall_bottom_outside_height=box_height - (box_bottom_thickness + wall_top_height + box_top_thickness);
wall_bottom_inside_height=(wall_top_height+wall_bottom_outside_height)-wall_top_inside_height;
if(wall_bottom_outside_height < 0){
    echo("Error! wall_bottom_height too small for given parameters.");
    error=error; //force error
}


module servo(length, width, height, axis_offset_length, screw_distance_from_body, screw_distance_from_centerline, height_above_deck){
    
    translate([length/2 - axis_offset_length,0,-height/2+height_above_deck])
        cube([length, width, height], center=true);
    
    tab_length=screw_distance_from_body + 3.5;
    translate([-axis_offset_length-tab_length, -width/2, 0])
        cube([tab_length,width,3.5]);
    
    translate([-axis_offset_length+length, -width/2, 0])
        cube([tab_length,width,3.5]);
    
    shaft_diameter=5.7;
    cylinder(d=shaft_diameter, 20);
    
    // Mounting holes
    locations = [
        [-axis_offset_length-screw_distance_from_body,screw_distance_from_centerline,0],
        [-axis_offset_length-screw_distance_from_body,-screw_distance_from_centerline,0],
        [-axis_offset_length+length+screw_distance_from_body,screw_distance_from_centerline,0],
        [-axis_offset_length+length+screw_distance_from_body,-screw_distance_from_centerline,0]
    ];
    
    for(location=locations){
        translate(location) cylinder(d=1.9, h=15, center=true);
    }
}

module gps(){
    cube([50,50,10], center=true); // Current GPS
    //cylinder(d=100, h=10); // PRO GPS http://www.csgshop.com/product.php?id_product=211
}
%translate([25,-40,0]) gps();

module sailServo(){
    // Winding drum
    winding_drum_diameter=47;
    winding_drum_thickness=11.3;
    winding_drum_deck_height=16.5;
    translate([0,0,winding_drum_deck_height]) cylinder(d=winding_drum_diameter, h=winding_drum_thickness);
    
    servo(
        length=58.93,
        width=29.1,
        height=30,
        axis_offset_length = 13, // axis disance from edge
        screw_distance_from_body=4.23,
        screw_distance_from_centerline=7.75,
        height_above_deck=12.3
    );
}

module rudderServo(){
    arm_length=60;
    arm_width=13;
    arm_thickness=3.3;
    arm_deck_height=15.5;
    
    axis_offset_length = 10.6; // axis disance from edge
    
    rotate([0,0,$t*200]) translate([0, 0, arm_deck_height+arm_thickness/2]) cube([arm_length, arm_width, arm_thickness], center=true);
    
    servo(
        length=40.5,
        width=20.5,
        height=39.5,
        axis_offset_length=axis_offset_length, // axis disance from edge
        screw_distance_from_body=4,
        screw_distance_from_centerline=5,
        height_above_deck=10
    );
}

// Store the XY coordinates of the screws, for use in translate
screwLocations = [
    [ // Bottom right
        box_width_1/2-2*box_wall_thickness-screw_axis_from_wall,
        -box_length/2+2*box_wall_thickness+screw_axis_from_wall,
        0
    ],
    [ // Top right (uses fudge factors to work around sail servo)
        box_width_2/2-2*box_wall_thickness-screw_axis_from_wall+2,
        -box_length/2+sail_servo_offset_from_bottom-25,
        0
    ],
    [ // Top Left
        arrow_offset_from_centerline+arrow_diameter/2 + arrow_wall_thickness*2,
        box_length/2-2*box_wall_thickness-screw_axis_from_wall,
        0
    ],
    [ // Bottom Left
        -box_width_1/2+2*box_wall_thickness+screw_axis_from_wall,
        -box_length/2+2*box_wall_thickness+screw_axis_from_wall,
        0
    ]
];

module fourSided(width_bottom, width_top, length){
    polygon([
        [width_bottom/2, -length/2],
        [width_top/2, length/2], 
        [-width_top/2, length/2],
        [-width_bottom/2, -length/2]
    ]);
}

module screwMount(inside_diameter, outside_diameter){
    difference(){
        circle(d=outside_diameter);
        circle(d=inside_diameter);
    }
}

module wall(width_bottom, width_top, length, height, wall_thickness, screw_diameter){
    translate([0,0,-height+0.01]) // Fudge factor to make sure things overlap
    linear_extrude(height=height+0.01)
    union(){
        difference(){
            fourSided(width_bottom, width_top, length);
            fourSided(width_bottom-2*wall_thickness, width_top-2*wall_thickness, length-2*box_wall_thickness);
        }
        
        if(screw_diameter > 0){
            for(location = screwLocations){
                translate(location) screwMount(screw_diameter, screw_wall_outside_diameter);
            }
        }
    }
}

module boxTop(){
    //Top
    difference(){
        linear_extrude(height=box_top_thickness) difference(){
            // Lid surface
            fourSided(box_width_1, box_width_2, box_length);
            
            // Screw holes
            for(location = screwLocations){
                translate(location) circle(d=screw_free_diameter);
            }
        }

        // Sail Servo
        translate([
            sail_servo_offset_from_centerline,
            -box_length/2+sail_servo_offset_from_bottom,
            box_top_thickness
        ]) rotate([0,0,180]) #sailServo();
        
        // Rudder Servo
        translate([
            0,
            -box_length/2+rudder_servo_offset_from_bottom,
            box_top_thickness
        ]) #rudderServo();
    }
    // Outer wall
    wall(box_width_1, box_width_2, box_length, wall_top_height, box_wall_thickness);

    // Inner Wall
    wall(box_width_1-2*box_wall_thickness, box_width_2-2*box_wall_thickness, box_length-2*box_wall_thickness, wall_top_inside_height, box_wall_thickness, screw_diameter=screw_free_diameter);
    
    // Arrow support block
    translate(arrow_translate) rotate(arrow_rotate) {
        cylinder(h=box_length, d=arrow_diameter+2*arrow_wall_thickness, center=true);
                
        // y and z cube sizes are swapped because this whole thing gets rotated.
        // fudge factor to make sure that things intersect.
        translate([0,(arrow_diameter/2+arrow_wall_thickness)/2+0.01,0])
            cube([
                arrow_diameter+2*arrow_wall_thickness,
                arrow_diameter/2+arrow_wall_thickness,
                box_length+0.01
            ], center=true);
    }
}
//boxTop();
difference(){
    boxTop();
    #translate(arrow_translate) rotate(arrow_rotate) cylinder(h=arrow_length, d=arrow_diameter, center=true);
}



// Bottom shell
translate([0,0,-150])
mirror([0,0,1]){
    // Bottom surface
    linear_extrude(height=box_bottom_thickness) fourSided(box_width_1, box_width_2, box_length);
    // Outer wall
    wall(box_width_1, box_width_2, box_length, wall_bottom_outside_height, box_wall_thickness);

    // Inner Wall
    wall(box_width_1-2*box_wall_thickness, box_width_2-2*box_wall_thickness, box_length-2*box_wall_thickness, wall_bottom_inside_height, box_wall_thickness, screw_diameter=screw_engage_diameter);
}

// Show the screws
%for(location=screwLocations){
    height = 150;
    translate([0,0,-height+20]) translate(location) cylinder(h=height, d=screw_free_diameter);
}




