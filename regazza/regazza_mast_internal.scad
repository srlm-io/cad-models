
height = 20;
width = 5;

smoothness = 100;

extra_height = 2;

difference(){
    union(){
        translate([5,0,0]) cylinder(height, d=width, $fn=smoothness);
        translate([-5,0,0]) cylinder(height, d=width, $fn=smoothness);
        translate([-5,-width/2,0]) cube([10,width,height]);
    }
    

    translate([0,0,-extra_height/2]) {
        translate([5+width/3,0,0]) cylinder(height+extra_height, d=width/2, $fn=smoothness);
        cylinder(height+extra_height, d=width/1.20, $fn=smoothness);
        translate([-5,0,0]) cylinder(height+extra_height, d=1, $fn=smoothness);
    }
}

