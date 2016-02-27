/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (1 Xenon 539)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Mines of Morriar
 * * Author: Morriar
*/

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

class ThermalConfigurator {

	public static void main(String[] args) throws IOException {
            ThermalConfigurator configurator = new ThermalConfigurator();
            String output = configurator.configure(System.in);
            System.out.print(output);
	}

        public String configure(InputStream source) throws IOException {
            ThermalConfigurationParser parser = new ThermalConfigurationParser(source);
            ThermalConfiguration configuration = parser.parseConfiguration();
            return configuration.renderReport();
        }

    class ThermalConfigurationParser {
        InputStream source;

        public ThermalConfigurationParser(InputStream source) {
            this.source = source;
        }

        public ThermalConfiguration parseConfiguration() throws IOException {
            List<ThermalProbe> probes = new ArrayList<>();
            List<String> usedNames = new ArrayList<>();
            BufferedReader reader = new BufferedReader(new InputStreamReader(source));
            // Read prob line
            int i = reader.read();
            while(i > -1) {
                Character c = (char)i;
                if(c == ' ') {
                    i = reader.read();
                    continue;
                } else if(c == '\n') {
                    break;
                }
                if(c < 'A' || c > 'Z') {
                    System.err.println("Error: maformed probe indentifier `" + c + "`");
                    System.exit(1);
                }
                String name = c.toString();
                if(usedNames.contains(name)) {
                    System.err.println("Error: probe `" + name + "` used twice in the same input");
                    System.exit(1);
                }
                ThermalProbe probe = new ThermalProbe(name);
                probes.add(probe);
                usedNames.add(name);
                i = reader.read();
            }
            // Read levels
            while(i > -1) {
                i = reader.read();
                Character c = (char)i;
                if(i < 0 || c == '\n') {
                    break;
                }
                int levelIndex = 0;
                try {
                    levelIndex = Integer.parseInt(c.toString());
                } catch(NumberFormatException e) {
                    System.err.println("Error: maformed level number `" + c + "`");
                    System.exit(1);
                }
                int probeIndex = -1;

                while(i > -1) {
                    probeIndex += 1;
                    i = reader.read(); // Read space
                    c = (char)i;
                    if(i < 0 || c == '\n') {
                        break;
                    }
                    i = reader.read(); // Read slot
                    c = (char)i;
                    if(i < 0 || c == '\n') {
                        break;
                    } else if(c == 'x') {
                        ThermalProbe probe = probes.get(probeIndex);
                        probe.level = levelIndex;
                    }
                }
            }
            ThermalConfiguration configuration = new ThermalConfiguration();
            for(ThermalProbe probe : probes) {
                if(probe.isDeployed()) {
                    configuration.addProbe(probe);
                }
            }
            if(configuration.isEmpty()) {
                System.err.println("Error: empty input");
                System.exit(1);
            }
            return configuration;
        }
    }

    class ThermalConfiguration {
        List<ThermalProbe> probes = new ArrayList<>();

        public void addProbe(ThermalProbe probe) {
            probes.add(probe);
        }

        public String renderReport() {
            Integer maxLevel = 0;
            StringBuilder res = new StringBuilder();
            res.append("Probes configuration after request:\n");
            res.append(" ");
            for(int i = 0; i < probes.size(); i++) {
                ThermalProbe probe = probes.get(i);
                res.append(" ");
                res.append(probe.name);
                if(probe.level > maxLevel) {
                    maxLevel = probe.level;
                }
            }
            res.append("\n");
            for(int i = 0; i <= maxLevel; i++) {
                res.append(i);
                for(int j = 0; j < probes.size(); j++) {
                    ThermalProbe probe = probes.get(j);
                    if(probe.level > i) {
                        res.append(" |");
                    } else if(probe.level == i) {
                        res.append(" *");
                    } else {
                        res.append("  ");
                    }
                }
                res.append("\n");
            }
            return res.toString();
        }

        public Boolean isEmpty() {
            for(ThermalProbe probe : probes) {
                if(probe.isDeployed()) {
                    return false;
                }
            }
            return true;
        }
    }

    class ThermalProbe {
        String name;

        Integer level = null;

        public ThermalProbe(String name) {
            this.name = name;
        }

        public Boolean isDeployed() {
            return level != null;
        }
    }
}
