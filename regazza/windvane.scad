pointyEndLength=90;
vaneEndLength=75;
vaneHeight=60;
vaneStraightLength=20;
backboneDiameter=6;
vaneThickness=3;
vaneRiseDistance=60;

shaftDiameter=3.175;
shaftMatingLength=15;
shaftWallThickness=1.5;


volumePointyEnd = pointyEndLength * pow(backboneDiameter/2, 2) *3.14 + pow(backboneDiameter/2, 3)*3.14*4/3;

echo("Volume Pointy End: ", volumePointyEnd);

volumeVaneEnd = vaneEndLength * pow(backboneDiameter/2, 2) *3.14 + (vaneHeight * vaneStraightLength * vaneThickness / 2) + (vaneStraightLength * vaneHeight * vaneThickness);

echo("Volume Vane End: ", volumeVaneEnd);


module triangle(o_len, a_len, depth){
    linear_extrude(height=depth){
        polygon(points=[[0,0], [a_len, 0], [0, o_len]], paths=[[0,1,2]]);
    }
}

$fn = 100;



difference(){
    union(){
        
        // Tip
        translate([-pointyEndLength, 0,0]) sphere(d=backboneDiameter);
        
        //Tail
        translate([vaneEndLength, 0,0]) sphere(d=backboneDiameter);

        // Backbone
        translate([-pointyEndLength, 0, 0]) rotate([0, 90, 0]) cylinder(h=pointyEndLength + vaneEndLength, d=backboneDiameter);

        // Straight portion
        translate([vaneEndLength - vaneStraightLength, -vaneThickness/2, 0]) cube([vaneStraightLength, vaneThickness, vaneHeight]);

        // Sloped portion
        translate([vaneEndLength - vaneStraightLength, -vaneThickness/2, 0]) rotate([90, 0, 180]) triangle(vaneHeight, vaneRiseDistance, vaneThickness);
        
        // axis shaft shell
        translate([0,0,-shaftMatingLength/2]) cylinder(h=shaftMatingLength, d=shaftDiameter+2*shaftWallThickness);

    }
    
    translate([0,0,-shaftMatingLength/2 -0.1]) cylinder(h=shaftMatingLength+0.2, d=shaftDiameter);
}
