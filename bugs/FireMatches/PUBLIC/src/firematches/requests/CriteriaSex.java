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

import firematches.profiles.Profile;

// You must be at least 18 years old to maintain this class.
public class CriteriaSex implements CriteriaBool {

	// Does the user have a sex?
    Boolean value;

    public CriteriaSex(Boolean value) {
        this.value = value;
    }

    public static CriteriaSex parseRange(String range) {
        if (range.equals("*")) {
            return new CriteriaSex(null);
        }
        Boolean value = Boolean.parseBoolean(range);
        return new CriteriaSex(value);
    }

    @Override
    public Boolean matches(Profile profile) {
        if (value == null) {
            return true;
        }
        return profile.getSex().equals(value);
    }

    @Override
    public String toString() {
        if (value == null) {
            return "sex=*";
        }
        return "sex=" + value.toString();
    }

}
