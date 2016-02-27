/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 429)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Mines of Morriar
 * * Author: Morriar
*/

var fs = require('fs');

function readInput(path, callback) {
	fs.readFile(path, function(err, data) {
		if(err) {
			console.log('error: Input not found');
			process.exit(1);
		}
		var json;
		try {
			json = JSON.parse(data);
		} catch(e) {
			console.log('error: Input not valid');
			process.exit(1);
		}
		callback(json);
	})
}

function newMatrix(n, m) {
	var c = [];
	for(var i = 0; i <= n; i++) {
		c[i] = [];
		for(var j = 0; j <= m; j++) {
			c[i][j] = 0;
		}
	}
	return c;
}

function usedVents(airvents, c) {
	var i = airvents.length;
	var current = c[0].length - 1;
	var used = [];
	while(i >= 0 && current >= 0) {
		if(i == 0) {
			break;
		} else if(c[i][current] > c[i - 1][current]) {
			used.push(airvents[i - 1]);
		}
		i -= 1;
		current -= 1;
	}
	return used;
}

function processAirvents(input, callback) {
	var max_z = input.max_z;
	var airvents = input.airvents;
	var c = newMatrix(airvents.length, max_z);
	for(var i = 1; i <= airvents.length; i++) {
		for(var j = 0; j <= max_z; j++) {
			if(airvents[i - 1].z <= j) {
				c[i][j] = Math.max(c[i-1][j], c[i - 1][j - airvents[i - 1].z] + airvents[i - 1].o2);
			} else {
				c[i][j] = c[i - 1][j];
			}
		}
	}
	callback(c[airvents.length][max_z], usedVents(airvents, c));
}

// Read args
if(process.argv.length != 3) {
	console.log('usage:\n');
	console.log('node airvents.js input.file');
	process.exit(1)
}

var input = process.argv[2];
readInput(input, function(data) {
	processAirvents(data, function(n, items) {
		items.sort(function(a, b) {
			if(a.name > b.name) {
				return 1;
			} else if(a.name < b.name) {
				return 1;
			} else {
				return 0;
			}
		});
		console.log("Maximum O2 output: " + n);
		for(var i in items) {
			var item = items[i];
			console.log(" * " + item.name + "\tz: " + item.z + "\tO2: " + item.o2);
		}
	});
});
