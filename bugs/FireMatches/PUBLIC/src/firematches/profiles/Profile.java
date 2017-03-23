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

    @Override
    public boolean equals(Object o) {
        return o instanceof Profile && id == ((Profile)o).id;
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
        return -age;
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
        return !sex;
    }

    public void setSex(Boolean sex) {
        this.sex = sex;
    }

}
