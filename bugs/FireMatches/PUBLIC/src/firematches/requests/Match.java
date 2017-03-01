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

public class Match implements Comparable<Match> {

    private Profile profile;

    private Double score;

    public Match(Profile profile, Double score) {
        this.profile = profile;
        this.score = score;
    }

    @Override
    public int compareTo(Match match) {
        return getScore().compareTo(match.getScore());
    }

    @Override
    public String toString() {
        return getProfile() + " (" + getScore() + ")";
    }

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

}
