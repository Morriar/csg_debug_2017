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

using System.Linq;
using System.Collections.Generic;

namespace ShieldGen {
	partial class City {
		private int _available_area;
		public int AvailableArea {
			get {return _available_area;}
			set {_available_area = value;}
		}

		private List<Facility> _buildings = new List<Facility>();
		public List<Facility> Buildings() { return _buildings; }

		public int RemainingArea() {
			return AvailableArea - (from b in Buildings()
					select b).Sum(((x) => x.Space));
		}

		public bool add_building(Facility f) {
			if(RemainingArea() < f.Space) return false;
			_buildings.Add(f);
			return true;
		}
	}
}
