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
package firematches.profiles;

import firematches.profiles.exceptions.LocationFormatException;
import firematches.profiles.exceptions.ProfileFormatException;
import java.nio.file.Path;
import java.util.List;

public class Profile {

    private String id;

    private String name;

    private Boolean sex;

    private Integer age;

    private GPSLocation location;

    private String mood;

    public Profile(String id, String name, Boolean sex, Integer age, GPSLocation location, String mood) {
        this.id = id;
        this.name = name;
        this.sex = sex;
        this.age = age;
        this.location = location;
        this.mood = mood;
    }

    public static Profile parseProfile(Path filePath, List<String> profileLines) throws ProfileFormatException, LocationFormatException {
        String id = parseId(filePath);
        return parseContent(id, profileLines);
    }

    public static Profile parseContent(String id, List<String> profileLines) throws ProfileFormatException, LocationFormatException {
        String name = "";
        Boolean sex = false;
        Integer age = 0;
        GPSLocation location = null;
        String mood = "";

        for (String line : profileLines) {
            String[] parts = line.split("=");
            if (parts.length != 2) {
                throw new ProfileFormatException(id);
            }
            String key = parts[0];
            String value = parts[1];

            switch (key.trim()) {
                case "name":
                    name = value.trim();
                    break;
                case "sex":
                    sex = Boolean.parseBoolean(value);
                    break;
                case "age":
                    age = Integer.parseInt(value);
                    break;
                case "location":
                    location = GPSLocation.parseLocation(value);
                    break;
                case "mood":
                    mood = value.trim();
                    break;
                default:
                    throw new ProfileFormatException(id);
            }
        }
        return new Profile(id, name, sex, age, location, mood);
    }

    public static String parseId(Path profileFile) throws ProfileFormatException {
        Path basename = profileFile.getFileName();
        String[] parts = basename.toString().split("\\.");
        if (parts.length != 2) {
            throw new ProfileFormatException(profileFile.toString());
        }
        return parts[0];
    }

    @Override
    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append(id);
        buffer.append(" (");
        buffer.append(name);
        buffer.append(", ");
        buffer.append(sex ? "male" : "female");
        buffer.append(", ");
        buffer.append(age);
        buffer.append(", ");
        buffer.append(location);
        buffer.append(", ");
        buffer.append(mood);
        buffer.append(")");
        return buffer.toString();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public GPSLocation getLocation() {
        return location;
    }

    public void setLocation(GPSLocation location) {
        this.location = location;
    }

    public String getMood() {
        return mood;
    }

    public void setMood(String mood) {
        this.mood = mood;
    }

    public Boolean getSex() {
        return sex;
    }

    public void setSex(Boolean sex) {
        this.sex = sex;
    }

}
