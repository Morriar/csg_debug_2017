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

namespace ShieldGen {
	partial class Shield: Facility {
		private int _health;
		public int Health {
			get {return _health;}
			protected set { _health = value;
		       	_health = _health > _capacity ? _capacity : _health;
			_health = _health < 0 ? 0 : _health;}
		}

		private int _capacity;
		public int Capacity {
			get {return _capacity;}
			protected set {_capacity = value;}
		}

		private int _upkeep;
		public int Upkeep {
			get {return _upkeep;}
			protected set {_upkeep = value;}
		}

		private int _surface;
		public int Surface {
			get {return _surface;}
			protected set {_surface = value;}
		}

		public void Fill(int energy) { Health += energy; }
	}

	partial class Generator {

		public void FillToUpkeep(Shield s) {
			var remupk = s.Upkeep - s.Health;
			var fill = Math.Min(Health, remupk);
			s.Fill(fill);
			Health -= fill;
		}

		public void Fill(Shield s) {
			if(s.Health < s.Capacity) {
				var rem = s.Capacity - s.Health;
				var fill = Math.Min(rem, Health);
				s.Fill(fill);
				Health -= fill;
			}
		}
	}
}
