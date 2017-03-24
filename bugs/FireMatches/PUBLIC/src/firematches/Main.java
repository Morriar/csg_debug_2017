/*                 UQAM ON STRIKE PUBLIC LICENSE
 *                    Version 2, December 2004
 * 
 * Copyright (C) 2017 
 * Alexandre Terrasa <@>,
 * Jean Privat <@>,
 * Philippe Pepos Petitclerc <@>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 * 
 *                 UQAM ON STRIKE PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 * 
 *  0. You just do what the fuck you want to as long as you're on strike.
 * 
 * aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==
 **/

package firematches;

import firematches.requests.Request;
import firematches.requests.Match;
import firematches.profiles.ProfileBase;
import firematches.profiles.Profile;
import firematches.profiles.exceptions.LocationFormatException;
import firematches.profiles.exceptions.ProfileFormatException;
import firematches.requests.exceptions.CriteriaFormatException;
import firematches.requests.exceptions.RequestFormatException;
import java.util.List;

public class Main {

    public static void main(String[] args) throws ProfileFormatException, RequestFormatException, CriteriaFormatException, LocationFormatException {

        if(args.length != 2) {
            System.out.println("usage: firematches <profile> <request>");
            System.exit(1);
        }
        String profileId = args[0];
        String requestString = args[1];
        Integer count = 10;

		// Load some love
        ProfileBase base = new ProfileBase(".profiles/");

		// Build love profile
        Profile profile = base.findProfile(profileId);

		// Is this true love?
        if (profile == null) {
            System.out.println("Profile " + profileId + " not found");
            System.exit(1);
        }

		// Try to match love
        Request request = Request.parseProfileRequest(requestString);
        List<Match> matches = base.matchRequest(request);

		// Display love
        System.out.println("Profile:");
        System.out.println(" > " + profile);
        System.out.println("Matches for " + request);
        for (Match match : matches) {
            if (match.getProfile().equals(profile)) {
                continue;
            }
            if (count <= 0) {
                break;
            }
            System.out.println(" * " + match);
            count--;
        }
    }
}
