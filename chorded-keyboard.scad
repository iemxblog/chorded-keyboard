width=60;
height=80;
thickness=20;
cr=4;   // corner radius
db1=10; // petit diamètre du bouton
db2=12; // grand diamètre du bouton
hb1=3;  // hauteur du petit diamètre du bouton
hb2=2;  // hauteur du grand diamètre du bouton
dep=1;  // dépassement du bouton (par rapport à la surface de la boîte)
nh=4;   // nombre de boutons sur la hauteur
nw=3;   // nombre de bouton sur la largeur
deb=0.5;    // débattement du bouton (de combien il peut se déplacer maximum quand on appuie dessus)

module tac_switch(with_adjustment)
{
    union() {
        translate([0,0,-1]) {
        translate([0, 0, -3.3/2]) {
            if(with_adjustment==false)
                cube([6.2, 6.2, 3.3], center=true);
            else
                translate([0,0,-0.5]) cube([6.2+0.3, 6.2+0.3, 3.3+1], center=true);
        }
        for(v=[[-4.6/2, -4.6/2, 0], [4.6/2, -4.6/2, 0], [-4.6/2, 4.6/2, 0], [4.6/2, 4.6/2, 0]]) {
            translate(v) {
                if(with_adjustment==false)
                    cylinder(h=0.5, r=0.5);
                else
                    cylinder(h=0.6, r=0.5+0.3/2);
            }
        }
        if(with_adjustment==false)
            cylinder(h=1, r=3.5/2);
        else
            translate([0,0,-.5]) cylinder(h=1+1, r=(3.5+0.3)/2);
        }
    }   
}

module body()
{
    translate([cr, cr, cr]) {
        minkowski() {
            cube([width-2*cr, thickness-2*cr, height-2*cr]);
            sphere(cr);
        }
    }
}

module button(with_adjustment)
{
    translate([0, 0, -hb1]) {
        translate([0,0,-hb2/2]) {
            if (with_adjustment == false)
                cylinder(h=hb1+hb2/2, r=db1/2);
            else
                cylinder(h=hb1+hb2/2, r=db1/2+0.25);
        }
        if(with_adjustment==false) {
            translate([0,0,-hb2])
                cylinder(h=hb2, r=db2/2);
        }
        else {
            translate([0,0,-hb2-deb])
                cylinder(h=hb2+deb, r=db2/2+0.25);
        }
    }
}

module pin_header()
{
    phx=10;
    phy=5;
    phz=10;
    translate([(width-phx)/2, (thickness-phy)/2, -1]) cube([phx, phy, phz+2]);
}

module keyboard()
{
    difference() {
        body(width, height, thickness, cr);
        space_h=height/(nh+1);
        for(i=[1:nh]) {
            translate([0, thickness/2, i*space_h]) {
                translate([-dep, 0, 0]) 
                    rotate([0, -90, 0])
                        button(with_adjustment=true);
                translate([hb1+hb2-dep, 0, 0]) rotate([0,-90,0]) tac_switch(with_adjustment=true);
            }
                
        }
        space_w=width/(nw+1);
        for(i=[1:nw]) {
            translate([i*space_w, thickness/2, 0]) {
                translate([0, 0, height+dep])
                    button(width_adjustment=true);
                translate([0, 0, height-hb1-hb2+dep]) tac_switch(with_adjustment=true);
            }
        }
        wall_thickness1=hb1+hb2-dep+1+3.3;
        wall_thickness2=3;
        translate([wall_thickness1, wall_thickness2, wall_thickness2])
            cube([width-wall_thickness1-wall_thickness2, thickness-2*wall_thickness2, height-wall_thickness1-wall_thickness2]);
        screws();
        pin_header();
    }
}

module screw()
{
    union() {
        translate([0, 0, -thickness]) cylinder(r=2.5/2, h=thickness);
        translate([0, 0, -thickness/2]) cylinder(r=3.5/2, h=thickness/2);
        lt=3; // longueur de la tête de vis
        dt=6; // diamètre de la tête de vis
        translate([0, 0, -lt]) cylinder(r=dt/2, h=lt);
    }
}

module screws()
{
    sd= cr; // distance from screw to border
    for(v=[[sd,0,sd], [sd, 0, height-sd],[width-sd, 0, height-sd], [width-sd, 0, sd]])
        translate(v) rotate([90, 0, 0]) screw();
}

module bottom()
{
    translate ([0, 0, thickness]) rotate([-90, 0, 0])
    difference () {
        keyboard();
        cube([width, thickness/2, height]);
    }
}

module top()
{
    translate([width, 0, 0]) rotate([0, 0, 180]) rotate([90, 0, 0])
    difference () {
        keyboard();
        translate([0,thickness/2, 0]) cube([width, thickness/2, height]);
    }
}

module buttons()
{
    for(i=[1:7])
    translate([i*db2*1.1, 0, hb1+hb2]) button(with_adjustment=false);
 }

bottom();
translate([width*1.1, 0, 0]) top();
translate([0, height+db2/2+4, 0]) buttons();

//bottom();
 //top();
 //buttons();

$fn=100;
