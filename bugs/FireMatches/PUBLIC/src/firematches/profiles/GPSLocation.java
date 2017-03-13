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

package firematches.profiles;

import firematches.profiles.exceptions.LocationFormatException;

public class GPSLocation {

    Double lon;
    Double lat;

    public GPSLocation(Double lon, Double lat) {
        this.lon = lon;
        this.lat = lat;
    }

    public static GPSLocation parseLocation(String location) throws LocationFormatException {
        String[] parts = location.split(",");
        if(parts.length != 2) {
            throw new LocationFormatException(location);
        }
        Double lat = Double.parseDouble(parts[0]);
        Double lon = Double.parseDouble(parts[0]);
        return new GPSLocation(lat, lon);
    }

    public Double distanceFrom(GPSLocation location) {
        Double r = 6371e3;

        Double r1 = Math.toRadians(lat);
        Double r2 = Math.toRadians(location.lat);
        Double d1 = Math.toRadians(location.lat - lat);
        Double d2 = Math.toRadians(location.lon - lon);

        Double a = Math.sin(d1 / 2) * Math.sin(d1 / 2) +
                   Math.cos(r1) * Math.cos(r2) *
                   Math.sin(d2 / 2) * Math.sin(d2 / 2);

        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return r * c;
    }

    @Override
    public String toString() {
        return lon + "," + lat;
    }

}
