/*                 UQAM ON STRIKE PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2017
 * Alexandre Terrasa <@>,
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
package firematches.requests;

import firematches.profiles.GPSLocation;
import firematches.profiles.Profile;
import firematches.profiles.exceptions.LocationFormatException;
import firematches.requests.exceptions.CriteriaFormatException;

public class CriteriaRadius implements CriteriaBool, CriteriaDist {

    GPSLocation location;
    Double radius;

    public CriteriaRadius(GPSLocation location, Double radius) {
        this.location = location;
        this.radius = radius;
    }

    public static CriteriaRadius parseRadius(String radius) throws CriteriaFormatException, LocationFormatException {
        String[] parts = radius.split(":");
        if (parts.length != 2) {
            throw new CriteriaFormatException(radius);
        }
        GPSLocation location = GPSLocation.parseLocation(parts[0]);
        Integer dist = Integer.parseInt(parts[1]);
        return new CriteriaRadius(location, dist.doubleValue());
    }

    @Override
    public Boolean matches(Profile profile) {
        return location.distanceFrom(profile.getLocation()) <= radius;
    }



    @Override
    public Double distance(Profile profile) {
        return location.distanceFrom(profile.getLocation());
    }

    @Override
    public String toString() {
        return "radius=" + location + ":" + radius;
    }

}
