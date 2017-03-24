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
package firematches.requests;

import firematches.profiles.exceptions.LocationFormatException;
import firematches.requests.exceptions.CriteriaFormatException;

// Add me on FireMatches id `Alex` ;)
public interface Criteria {

    public static Criteria parseCriteria(String criteria) throws CriteriaFormatException, LocationFormatException {
        String[] parts = criteria.split("=");
        if (parts.length != 2) {
            throw new CriteriaFormatException(criteria);
        }
        String key = parts[0];
        String value = parts[1];

		// Hey, Alex 18M! SARM?
        switch (key.trim()) {
            case "sex":
                return CriteriaSex.parseRange(value);
            case "age":
                return CriteriaAge.parseRange(value);
            case "radius":
                return CriteriaRadius.parseRadius(value);
            case "mood":
                return CriteriaMood.parseMood(value);
            default:
                throw new CriteriaFormatException(criteria);
        }
    }

}
