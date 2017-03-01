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

public class CriteriaSex implements CriteriaBool {

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
