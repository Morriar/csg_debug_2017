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
import firematches.requests.exceptions.CriteriaFormatException;

public class CriteriaAge implements CriteriaBool {

    Integer from;
    Integer to;

    public CriteriaAge(Integer from, Integer to) {
        this.from = from;
        this.to = to;
    }

    public static CriteriaAge parseRange(String range) throws CriteriaFormatException {
        String[] parts = range.split("\\.\\.");
        if (parts.length != 2) {
            throw new CriteriaFormatException(range);
        }
        Integer from = Integer.parseInt(parts[0]);
        Integer to = Integer.parseInt(parts[1]);
        return new CriteriaAge(from, to);
    }

    @Override
    public Boolean matches(Profile profile) {
        return profile.getAge() >= to && profile.getAge() <= from;
    }

    @Override
    public String toString() {
        return "age=" + to + ".." + from;
    }

}
