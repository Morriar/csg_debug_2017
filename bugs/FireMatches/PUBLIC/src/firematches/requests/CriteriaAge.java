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
