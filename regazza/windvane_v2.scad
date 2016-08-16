// This version of the wind vane uses a carbon fiber backbone and a delrin vane for it's
// main components, and a 3D printed shaft coupling and counterweight. To be honest, the
// 3D printed parts probably aren't needed. But it's fun and easy.

// I've also thrown in some vane holders to make glueing easier.

pointyEndLength=120;
vaneEndLength=90;
vaneHeight=60;
vaneStraightLength=20;
backboneDiameter=3.175; // 0.125 in
vaneThickness=0.9; // Nominally 0.78, ~0.31 in
vaneRiseDistance=60;

shaftDiameter=3.175;
shaftMatingLength=8;
shaftWallThickness=1.5;

vaneBracketHeight=backboneDiameter*5;
vaneBracketDiameter=backboneDiameter*3;

counterweightLeadingDiameter=8;
counterweightLength=45;
counterweightPosition=-pointyEndLength;

vaneBracketPositions=[
    vaneEndLength-vaneBracketDiameter-vaneStraightLength-vaneRiseDistance/3, 
    vaneEndLength-vaneBracketDiameter
];

module triangle(o_len, a_len, depth){
    linear_extrude(height=depth){
        polygon(points=[[0,0], [a_len, 0], [0, o_len]], paths=[[0,1,2]]);
    }
}

$fn = 100;


difference(){
    union(){
        
        // Teardrop
        %translate([counterweightPosition, 0, 0]) rotate([90, 0, 90]) hull() {
            sphere(r=counterweightLeadingDiameter);
            cylinder(h = counterweightLength, r1 = 5, r2 = 0);
        }
        
        // Vane brackets
        for(pos=vaneBracketPositions){
            translate([pos, 0, -vaneBracketDiameter/2]) cylinder(h=vaneBracketHeight, d=vaneBracketDiameter);
        }
        
        // axis shaft shell
        %translate([0,0,-shaftMatingLength-backboneDiameter/2+shaftWallThickness]) cylinder(h=shaftMatingLength+backboneDiameter/2+shaftWallThickness , d=shaftDiameter+2*shaftWallThickness);

    }
    
    // Shaft
    #translate([0,0,-shaftMatingLength-backboneDiameter/2]) cylinder(h=shaftMatingLength+backboneDiameter/2, d=shaftDiameter);
    
    // Backbone
    #translate([-pointyEndLength, 0, 0]) rotate([0, 90, 0]) cylinder(h=pointyEndLength + vaneEndLength, d=backboneDiameter);
    
    // Vane straight portion
    #translate([vaneEndLength - vaneStraightLength, -vaneThickness/2, 0]) cube([vaneStraightLength, vaneThickness, vaneHeight]);

    // Vane sloped portion
    #translate([vaneEndLength - vaneStraightLength, -vaneThickness/2, 0]) rotate([90, 0, 180]) triangle(vaneHeight, vaneRiseDistance, vaneThickness);
}
