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
