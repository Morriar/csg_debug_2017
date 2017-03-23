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
import firematches.profiles.exceptions.LocationFormatException;
import firematches.requests.exceptions.RequestFormatException;
import firematches.requests.exceptions.CriteriaFormatException;
import java.util.ArrayList;
import java.util.List;

public class Request {

    List<Criteria> criterias;

    public Request(List<Criteria> criterias) {
        this.criterias = criterias;
    }

    public Match matchProfile(Profile profile) {
        Double score = 0.0;
        for (Criteria criteria : criterias) {
            if (criteria instanceof CriteriaBool) {
                if (!((CriteriaBool) criteria).matches(profile)) {
                    return null;
                }
            } else if (criteria instanceof CriteriaDist) {
                score += ((CriteriaDist) criteria).distance(profile);
            }
        }
        return new Match(profile, score);
    }

    public static Request parseProfileRequest(String request) throws RequestFormatException, CriteriaFormatException, LocationFormatException {
        String[] requestCriterias = request.split(";");
        if (requestCriterias.length == 0) {
            throw new RequestFormatException(request);
        }

        List<Criteria> criterias = new ArrayList<>();
        for (String requestCriteria : requestCriterias) {
            criterias.add(Criteria.parseCriteria(requestCriteria));

        }
        return new Request(criterias);
    }

    @Override
    public String toString() {
        StringBuilder res = new StringBuilder();
        res.append("Request:");
        for (Criteria criteria : criterias) {
            res.append(criteria);
            res.append(";");
        }
        return res.toString();
    }

}
