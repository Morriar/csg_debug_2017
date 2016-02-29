if [ "$#" -ne 2 ]; then
	echo "usage: clone_team ip teamid"
	exit 1
fi

teamip=$1
teamid=$2

mkdir -p $teamid
cd $teamid

git clone ssh://$teamid@$teamip:/home/$teamid/access_panel
git clone ssh://$teamid@$teamip:/home/$teamid/alu_sim
git clone ssh://$teamid@$teamip:/home/$teamid/atomic_engine
git clone ssh://$teamid@$teamip:/home/$teamid/bug_hello
git clone ssh://$teamid@$teamip:/home/$teamid/domesec
git clone ssh://$teamid@$teamip:/home/$teamid/doors
git clone ssh://$teamid@$teamip:/home/$teamid/irrigations
git clone ssh://$teamid@$teamip:/home/$teamid/power_grid
git clone ssh://$teamid@$teamip:/home/$teamid/shield_gen
git clone ssh://$teamid@$teamip:/home/$teamid/thermal_reactor
git clone ssh://$teamid@$teamip:/home/$teamid/ventilation
git clone ssh://$teamid@$teamip:/home/$teamid/water_supply
