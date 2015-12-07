run:
	node cron.js csg_debug

test-db:
	node ../tools/load_db.js csg_debug teams ../tests/data/teams_1.json
	node ../tools/load_db.js csg_debug bugs ../tests/data/bugs.json

test: test-db
	node cron.js csg_debug
