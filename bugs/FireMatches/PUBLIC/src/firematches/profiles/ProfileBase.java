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
import firematches.requests.Match;
import firematches.requests.Request;
import firematches.profiles.exceptions.ProfileFormatException;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProfileBase {

    Map<String, Profile> profiles = new HashMap<>();

    public ProfileBase(String basePath) throws ProfileFormatException, LocationFormatException {
        List<Profile> list = loadProfiles(basePath);
        registerProfiles(list);
    }

    public List<Profile> loadProfiles(String profilesPath) throws ProfileFormatException, LocationFormatException {
        List<Profile> res = new ArrayList<>();
        Path path = Paths.get(profilesPath);

        if (!Files.exists(path)) {
            return res;
        }

        try (DirectoryStream<Path> directories = Files.newDirectoryStream(path)) {
            for (Path profilePath : directories) {
                if (!profilePath.toString().endsWith(".profile")) {
                    continue;
                }
                Profile profile = loadProfile(profilePath);
                if (profile == null) {
                    continue;
                }
                res.add(profile);
            }
        } catch (IOException ex) {
            return res;
        }
        return res;
    }

    public Profile loadProfile(Path profilePath) throws ProfileFormatException, LocationFormatException {
        FileInputStream fileInputStream;
        try {
            fileInputStream = new FileInputStream(profilePath.toString());
        } catch (FileNotFoundException ex) {
            throw new ProfileFormatException(profilePath.toString());
        }
        InputStreamReader inputStreamReader;
        try {
            inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            throw new ProfileFormatException(profilePath.toString());
        }
        BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

        List<String> lines = new ArrayList<>();
        String line;
        try {
            while ((line = bufferedReader.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException ex) {
            throw new ProfileFormatException(profilePath.toString());
        }

        return Profile.parseProfile(profilePath, lines);
    }

    public void registerProfile(Profile profile) {
        profiles.put(profile.getId(), profile);
    }

    public void registerProfiles(List<Profile> profiles) {
        for (Profile profile : profiles) {
            registerProfile(profile);
        }
    }

    public Profile findProfile(String id) {
        if (profiles.containsKey(id)) {
            return profiles.get(id);
        }
        return null;
    }

    public List<Match> matchRequest(Request request) {
        List<Match> res = new ArrayList<>();
        for (Profile profile : profiles.values()) {
            Match match = request.matchProfile(profile);
            if (match != null) {
                res.add(match);
            }
        }
        Collections.sort(res);
        return res;
    }

    public Map<String, Profile> getProfiles() {
        return profiles;
    }
}
