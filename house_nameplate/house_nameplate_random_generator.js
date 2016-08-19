'use strict';
/*jshint node: true */
/*jshint esversion: 6 */

const type_range = [0, 1];
const x_range = [0, 120];
const y_range = [0, 120];
const height_range = [3, 20];
const size_range = [3, 15];
var count = 200;

const minimum_distance_ratio = 0.4;

const max_attempts = 10000;

const crypto = require('crypto');
// Taken from http://stackoverflow.com/a/33627342/2557842
function random(range) {
    const minimum = range[0];
    const maximum = range[1];
    var distance = maximum - minimum;

    var maxBytes = 6;
    var maxDec = 281474976710656;

    // Optimize
    maxBytes = 1;
	maxDec = 256;

    var randbytes = parseInt(crypto.randomBytes(maxBytes).toString('hex'), 16);
    var result = Math.floor(randbytes / maxDec * (maximum - minimum + 1) + minimum);

    if (result > maximum) {
        result = maximum;
    }
    return result;

}

function distance(x_1, y_1, x_2, y_2) {
    return Math.sqrt(Math.pow(x_2 - x_1, 2) + Math.pow(y_2 - y_1, 2));
}

function generate_point(index, points) {
    process.stderr.write(`[ ${index} ]: `);
    var attempts = 0;
    var try_again = true;
    var x;
    var y;
    const size = random(size_range);
    while (try_again) {
        x = random(x_range);
        y = random(x_range);

        try_again = false;
        for (const i in points) {
            const p = points[i];
            const minimum_distance = (p[3] + size) * minimum_distance_ratio;
            //console.error("Distance: " + distance(x, y, p[0], p[1]));
            //console.error(p);
            //console.error("Minimum Distance: " + minimum_distance);
            if (distance(x, y, p[1], p[2]) < minimum_distance) {
                try_again = true;
                //console.error('Trying again');
                break;
            }
        }
        attempts ++;

        if(attempts >= max_attempts){
            console.error(`${attempts} attempts, breaking.`);
            return;
        }
        //process.stderr.write('.');
    }
    console.error(`${attempts} attempts`);
    points.push([random(type_range), x, y, size, random(height_range)]);
}

var points = [];

for (var i = 0; i < count; i++) {
    generate_point(i, points);
}

console.log('//type, x, y, size, height');
console.log('shapes = [');
for (var i = points.length - 1; i >= 0; i--) {
    const p = points[i];
    console.log(`\t[${p[0]}, ${p[1]}, ${p[2]}, ${p[3]}, ${p[4]}]${i === 0 ? '' : ','}`);
}
console.log('];');
