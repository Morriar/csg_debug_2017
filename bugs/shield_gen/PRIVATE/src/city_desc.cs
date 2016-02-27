/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (5 Indium 653)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Mines of Morriar
 * * Author: R4PaSs
*/

using System;
using System.Linq;

namespace ShieldGen {
	class DescriptionParser {
		private string[] content;
		private int line = 0;

		public City Parse(string str) {
			content = str.Split('\n');
			City c = ReadCity();
			if(c == null)
				return null;
			return c;
		}

		public City ReadCity() {
			while(line < content.Length && content[line] != "CITY")
				line++;
			line++;
			var ln_els = content[line].Trim().Split(' ');
			var area_kw = ln_els[0];
			var area_val = ln_els[1];
			if(area_kw != "AREA") {
				Console.WriteLine("Error: City/Area bad format");
				return null;
			}
			var c = new City(Int32.Parse(area_val));
			line++;
			while(line < content.Length) {
				var nxtel = content[line].Trim();
				if(nxtel == "GENERATOR") {
					var gen = ReadGenerator();
					if(gen == null)
						return null;
					if(!c.add_building(gen)) {
						Console.WriteLine("Error: Cannot install Generator in city, not enough space");
						return null;
					}
				} else if (nxtel == "SHIELD") {
					var shl = ReadShield();
					if(shl == null)
						return null;
					if(!c.add_building(shl)) {
						Console.WriteLine("Error: Cannot install Shield in city, not enough space");
						return null;
					}
				}
				line++;
			}
			if(!c.CoverageOk()){
				Console.WriteLine("Error: Cannot protect city with so little shields !");
				return null;
			}
			return c;
		}

		public Generator ReadGenerator() {
			line++;
			var space = -1;
			var cap = -1;
			var flr = -1;
			var health = -1;
			for(int i = 0; i < 4; i++) {
				var ln_el = content[line].Trim().Split(' ');
				var val = Int32.Parse(ln_el[1]);
				var nm = ln_el[0];
				if (nm == "SPACE") {
					space = val;
				} else if (nm == "CAPACITY") {
					cap = val;
				} else if (nm == "FILLRATE") {
					flr = val;
				} else if (nm == "HEALTH") {
					health = val;
				} else {
					return null;
				}
				line++;
			}
			return new Generator(space, cap, flr, health);
		}

		public Shield ReadShield() {
			line++;
			var space = -1;
			var energy = -1;
			var cap = -1;
			var upk = -1;
			var prot = -1;
			for(int i = 0; i < 5; i++) {
				var ln_el = content[line].Trim().Split(' ');
				var val = Int32.Parse(ln_el[1]);
				var nm = ln_el[0];
				if (nm == "SPACE") {
					space = val;
				} else if (nm == "ENERGY") {
					energy = val;
				} else if (nm == "CAPACITY") {
					cap = val;
				} else if (nm == "UPKEEP") {
					upk = val;
				} else if (nm == "SURFACE") {
					prot = val;
				} else {
					return null;
				}
				line++;
			}
			return new Shield(space, energy, cap, upk, prot);
		}
	}

	partial class Shield {
		public Shield(int space, int start_energy, int capacity, int upkeep, int protection) {
			Space = space;
			Health = start_energy;
			Capacity = capacity;
			Upkeep = upkeep;
			Surface = protection;
		}
	}

	partial class Generator {
		public Generator(int space, int capacity, int fillrate, int start_energy) {
			Space = space;
			Capacity = capacity;
			FillRate = fillrate;
			Health = start_energy;
		}
	}

	partial class City {
		public City(int area) {
			AvailableArea = area;
		}

		public bool CoverageOk() {
			return (from b in Buildings()
				where b.GetType() == typeof(Shield)
				select ((Shield)b)).Sum(((x) => x.Surface)) >= AvailableArea;
		}
	}
}
