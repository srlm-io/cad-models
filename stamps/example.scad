text_lines = [
   "Willy Wonka",
   "1 Coorporate Ln",
   "Pocket, DC 99999"
];

text_size = 4;
text_spacing = 1.5; // lines
base_width = 55;
base_height = 25;

include <stamp.scad>;

if (part == "body"){
   color("White") body();
} else {
   color("Gray") stamp();
}
