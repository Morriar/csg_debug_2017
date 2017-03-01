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
