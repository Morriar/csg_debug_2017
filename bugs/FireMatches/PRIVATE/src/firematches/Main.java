/*
 * Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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

        ProfileBase base = new ProfileBase("profiles/");
        Profile profile = base.findProfile(profileId);

        if (profile == null) {
            System.out.println("Profile " + profileId + " not found");
            System.exit(1);
        }

        Request request = Request.parseProfileRequest(requestString);
        List<Match> matches = base.matchRequest(request);

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
