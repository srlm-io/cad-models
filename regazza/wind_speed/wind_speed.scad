
// Derrived from http://www.thingiverse.com/thing:6095
// Commercial version: http://www.nuovaceva.it/prodotto-ing.php?cat=7&sc=17&prod=77

blade_radius=50;
blade_thickness=5;
blade_length=90;
chord_dist=sqrt(pow(blade_radius,2)-pow(blade_length/2,2));
blade_width=blade_radius-chord_dist;
blade_length2=2*sqrt(pow(blade_radius,2)-pow(chord_dist,2));
blade_height=30;
num_blades=3;
wheel_base_height=1.05;
hub_radius=12;
hub_height=blade_height+5;
axle_radius=6;
axle_height=80;

echo(str("Blade Width  is ",blade_width));
echo(str("Blade Length 2 is ",blade_length2));

wheel();
//blade();

module wheel() {
	union() {
	    // blades
		for (a=[1:num_blades]) rotate([0,0,a*(360/num_blades)]) translate([0,0,0]) blade();
		
		// hub
		cylinder(r=hub_radius, h=hub_height);
	
		// Center axle
		cylinder(r=axle_radius,h=axle_height, $fn=10);
	}
}

module blade() {
	angle=asin((blade_radius-blade_width)/blade_radius);
	translate([0,blade_radius,0]) rotate([0,0,angle]) difference() {
	    //Body
		cylinder(r=blade_radius, h=blade_height);
		
		// Inside radius
		translate([0, 0, -0.05]) cylinder(r=blade_radius-blade_thickness, h=blade_height+.1);
		
		
		translate([blade_width-blade_radius,-blade_radius,-0.05]) cube([blade_radius*2,blade_radius*2,blade_height+.1]);
	}

}
