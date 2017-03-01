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
