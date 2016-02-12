var fs = require('fs');

function readInput(path, callback) {
	fs.readFile(path, function(err, data) {
		if(err) {
			console.log({ 'error': 'Input not found' });
			process.exit(1);
		}
		var json;
		try {
			json = JSON.parse(data);
		} catch(e) {
			console.log({ 'error': 'Input not valid' });
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

function max(a, b) {
	if(a > b) {
		return a;
	}
	return b;
}

function usedVents(airvents, c) {
	console.log(c);
	var i = airvents.length;
	var current = c[0].length;
	var used = [];
	while(i >= 0 && current >= 0) {
		if((i == 0 && c[i][current] > 0) || (i > 0 && (c[i][current] != c[i - 1][current]))) {
			used.push(airvents[i]);
			current -= airvents[i].z;
		}
		i -= 1;
	}
	console.log(used);
	return used;
}

function processAirvents(input, callback) {
	var max_z = input.max_z;
	var airvents = input.airvents;
	var c = newMatrix(airvents.length, max_z);
	for(var i = 1; i < airvents.length; i++) {
		for(var j = 0; j < max_z; j++) {
			// console.log(c[i][j]);
			if(airvents[i - 1].z <= j) {
				c[i][j] = max(c[i-1][j], c[i - 1][j - airvents[i - 1].z] + airvents[i - 1].o2);
			} else {
				c[i][j] = c[i - 1][j];
			}
			// console.log(c[i][j]);
		}
	}
	callback(c[airvents.length - 1][max_z], usedVents(airvents, c));
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
		console.log(n);
		console.log(items);
	});
});

// trouver l'optimal pour la journée sachant
//	population
//	power
//	airvents
//
// afficher alertes:
//	pas assez o2
//	pas assez vents
//	pas assez z
//
// var dc = day_conso(0.45, pop)
// var ac = day_conc(80, dc)

