# FireMatches

Language: Java

## Description

Finding the love of your life can be pretty hard. Luckily, FireMatches is here!

This program represents the backend of the now famous FireMatches app that allows
you to find single people in your area.

The backend uses a unencrypted plain file database to store people profiles
and displays match statistics for specific dating requests.

## Usage

	$ make compile
	$ java -cp bin/ firematches.Main <profile_id> <profile_request>

## Input / Output examples

The backend program accepts two arguments:
* `profile_id`: the id of the profile looking for dates
* `profile_request` the request to match other profiles with

### Profile ID

Each profile is assigned a unique ID used as the database key.
The `.profiles/` directory contains all the app profiles ordered by IDs.
To be valid, a profile ID must match an existing profile.

The profile ID is used so the profile itself does not appear in the results.

### Profile request

A profile request allows the user to specify what kind of gorgeous single people he
is looking for.
Profile requests are formatted as follow:

	<criteria_key1>=<criteria_value1>;<criteria_key2>=<criteria_key2>;...

Valid criterias are:
* `sex`: to specify the desired sex can be either `true`, `false` or `*`
* `age`: to specify a range value with `from..to`
* `mood`: to specify the current mood proximity looked for
* `radius:`: with `long,lat:radius` to specify a radius search by location

### Examples

Looking for males between 18 and 25 years old near my location with a radius of 100000m:

	java -cp bin/ firematches.Main 00001 "sex=true;age=18..25;radius=49.9,34.5:1000000"

Output:

	Profile:
	 > 00001 (Pauline, female, 32, 41.022848,41.022848, I feel anxious...)
	Matches for Request:sex=true;age=18..25;radius=49.9,49.9:1000000.0;
	 * 00043 (Chester, male, 22, 46.778105,46.778105, I feel sympathetic...) (416750.2752425488)
	 * 00015 (Ronald, male, 20, 44.855839,44.855839, I feel sinister...) (677032.4380779737)

Only criteria `radius` and `mood` will produce proximity score. Not using these
criterias result in `0` scores:

	java -cp bin/ firematches.Main 00001 "sex=true;age=18..25"

Output:

	Profile:
	 > 00001 (Pauline, female, 32, 41.022848,41.022848, I feel anxious...)
	Matches for Request:sex=true;age=18..25;
	 * 00043 (Chester, male, 22, 46.778105,46.778105, I feel sympathetic...) (0.0)
	 * 00036 (Leonard, male, 18, 90.373433,90.373433, I feel sarcastic...) (0.0)
	 * 00033 (Lee, male, 23, 25.015271,25.015271, I feel desperate...) (0.0)
	 * 00007 (Aaron, male, 19, 27.682244,27.682244, I feel belligerent...) (0.0)
	 * 00082 (Danny, male, 20, 60.897861,60.897861, I feel annoyed...) (0.0)
	 * 00081 (Erik, male, 25, 35.566649,35.566649, I feel desperate...) (0.0)
	 * 00077 (Victor, male, 25, 76.790837,76.790837, I feel forthright...) (0.0)
	 * 00025 (Alan, male, 24, 8.685724,8.685724, I feel acerbic...) (0.0)
	 * 00015 (Ronald, male, 20, 44.855839,44.855839, I feel sinister...) (0.0)
	 * 00092 (Shawn, male, 24, 63.218588,63.218588, I feel paranoid...) (0.0)

## Developers

Usefull commands:

	make compile
	make check
