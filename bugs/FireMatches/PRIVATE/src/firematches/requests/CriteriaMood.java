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

public class CriteriaMood implements CriteriaDist {

    String mood;

    public CriteriaMood(String mood) {
        this.mood = mood;
    }

    public static CriteriaMood parseMood(String mood) {
        return new CriteriaMood(mood);
    }

    @Override
    public Double distance(Profile profile) {
        Integer dist = levenshteinDistance(mood, profile.getMood());
        return dist.doubleValue() * 10000;
    }

    private int minimum(int a, int b, int c) {
        return Math.min(Math.min(a, b), c);
    }

    public int levenshteinDistance(CharSequence lhs, CharSequence rhs) {
        int[][] distance = new int[lhs.length() + 1][rhs.length() + 1];

        for (int i = 0; i <= lhs.length(); i++) {
            distance[i][0] = i;
        }
        for (int j = 1; j <= rhs.length(); j++) {
            distance[0][j] = j;
        }

        for (int i = 1; i <= lhs.length(); i++) {
            for (int j = 1; j <= rhs.length(); j++) {
                distance[i][j] = minimum(
                        distance[i - 1][j] + 1,
                        distance[i][j - 1] + 1,
                        distance[i - 1][j - 1] + ((lhs.charAt(i - 1) == rhs.charAt(j - 1)) ? 0 : 1));
            }
        }

        return distance[lhs.length()][rhs.length()];
    }

    @Override
    public String toString() {
        return "mood=" + mood;
    }

}
