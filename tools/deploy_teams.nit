import json

if args.length != 3 then
	print "usage:\n"
	print "deploy_teams teams.json bugs/dir out/dir"
	exit 1
end

var team_list = args[0]
var bugs_dir = args[1]
var out_dir = args[2]

var json
with fr = new FileReader.open(team_list) do
	json = fr.read_all.parse_json
end
if not json isa JsonArray then
	print "Unable to read {team_list}"
	exit 1
	return
end

out_dir.mkdir

for team in json do
	if not team isa JsonObject then continue
	var id = team["id"].as(String)
	var team_dir = out_dir / id
	print "Deploy team {id}..."

	team_dir.mkdir
	system "cp -R {bugs_dir} {team_dir}"

	var team_config = new JsonObject
	team_config["id"] = id
	team_config["name"] = team["name"].as(String)
	team_config["port"] = team["port"].as(String)
	with fw = new FileWriter.open(team_dir / "team.json") do
		fw.write(team_config.to_pretty_json)
	end

	# TODO make public repos and init first commmit
	# TODO make participant folder
		# copy competition public readme
		# copy init.sh (clone all repos)
	# for file in team_dir / "bugs".files do
	#	var bug_json = team_dir / "bugs" / file / "bug.json"
	#	if not bug_json.file_exists then continue
	# end
end
