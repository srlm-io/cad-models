
// Derrived from http://www.thingiverse.com/thing:6095
// Commercial version as inspiration: http://www.nuovaceva.it/prodotto-ing.php?cat=7&sc=17&prod=77

blade_radius=50;
blade_thickness=4;
blade_height=60;
blade_angle=15;
arm_straight=60;
num_blades=3;
wheel_base_height=1.05;
hub_height=blade_height+5;
axle_radius=6;
axle_height=hub_height+80;
hub_radius=axle_radius+4;

$fa=1;
$fs=0.5;

wheel();
//blade();

module wheel() {
	union() {
	    // blades
		for (a=[1:num_blades]) rotate([0,0,a*(360/num_blades)]) translate([blade_radius-hub_radius,0,0]) blade();
		
		// hub
		cylinder(r=hub_radius, h=hub_height);
	
		// Center axle
		cylinder(r=axle_radius,h=axle_height);
	}
}

module blade() {
union(){
	translate([0,arm_straight,0]) /*rotate([0,0,angle])*/ difference() {
	    //Round edge body
	    cylinder(r=blade_radius, h=blade_height);
		
		// Inside radius
		translate([0, 0, -0.1]) cylinder(r=blade_radius-blade_thickness, h=blade_height+.2);
		
		// outside cut off
		rotate([0,0,blade_angle]) translate([0,-blade_radius*2,-0.1]) cube([blade_radius*4, blade_radius*4, blade_height+0.2]);
		
		// Inside cut off
		translate([-blade_radius*2, -blade_radius*4, -0.1]) cube([blade_radius*4, blade_radius*4, blade_height+0.2]);
	}
	
	
	difference(){
	    // Straight edge body
    	translate([-blade_radius, 0, 0]) cube([blade_radius, arm_straight+0.1, blade_height]);
    	// Cut off the straight edge
		translate([-blade_radius+blade_thickness +0.1, -0.1, -0.1]) cube([blade_radius-blade_thickness+0., arm_straight+0.3, blade_height+0.2]);	
    }
	

}    
}
