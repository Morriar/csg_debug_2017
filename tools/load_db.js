var fs = require("fs");
var mongo = require('mongoskin');

// Insert items into db.collection.
function load_collection(db, collection, items) {
	db.collection(collection).drop();
	for(i in items) {
		db.collection(collection).insert(items[i]);
	}
	var count = db.collection(collection).count(function(err, count) {
		console.log("Loaded " + count + " " + collection +"...")
		process.exit(0);
	});
}

// Read a file and parse it as json.
function readJsonFile(file) {
	return JSON.parse(fs.readFileSync(file, 'utf-8'));
}

var argv = process.argv;

if(argv.length != 5) {
	console.log("usage:\n");
	console.log("node load_db.js db_name collection_name path/to/json");
	process.exit(1);
}

var db_name = argv[2];
var collection_name = argv[3];
var file = argv[4];

var db = mongo.db('mongodb://localhost:27017/' + db_name)

var items = readJsonFile(file);
load_collection(db, collection_name, items)
