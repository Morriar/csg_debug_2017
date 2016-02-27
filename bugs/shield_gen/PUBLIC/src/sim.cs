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

using System;
using System.Linq;
using System.Text;

namespace ShieldGen {
	class Simulation {
		public static void Main(string[] args) {
			if(args.Length < 2) {
				Console.WriteLine("Usage: ./sim file.desc sim_length");
				return;
			}
			var ds = new DescriptionParser();
			var city = ds.Parse(System.IO.File.ReadAllText(args[0]));
			if(city == null)
				return;
			for(int i = 0; i < 1; i++) {
				city.SimulateTurn();
				if(city.ShieldsDown()) {
					Console.WriteLine("Alert ! Shields are down after {0} turns !", 1);
					return;
				}
				Console.WriteLine(city);
			}
			Console.WriteLine("Congratulations, this configuration held for {0} turns !", 1);
		}
	}

	partial class Facility {
		public virtual void MakeTurn() {}
	}

	partial class Shield {
		public bool is_full() { return Health == Capacity; }
		public override void MakeTurn() { Health -= Upkeep; }
		public override string ToString() {
			var buf = new StringBuilder();
			buf.Append("Shield:\n");
			buf.Append("- Space: ");
			buf.Append(Space);
			buf.Append("\n");
			buf.Append("- Capacity: ");
			buf.Append(Capacity);
			buf.Append("\n");
			buf.Append("- Upkeep: ");
			buf.Append(Upkeep);
			buf.Append("\n");
			buf.Append("- Health: ");
			buf.Append(Health);
			buf.Append("\n");
			buf.Append("- Surface: ");
			buf.Append(Surface);
			buf.Append("\n");
			return buf.ToString();
		}
		public bool NeedRefill() { return Health < Capacity; }
		public bool NeedUrgentRefill() { return Health < Upkeep; }
	}

	partial class Generator {
		public override void MakeTurn() { Health += FillRate; }
		public override string ToString() {
			var buf = new StringBuilder();
			buf.Append("Generator:\n");
			buf.Append("- Space: ");
			buf.Append(Space);
			buf.Append("\n");
			buf.Append("- Capacity: ");
			buf.Append(Capacity);
			buf.Append("\n");
			buf.Append("- Fillrate: ");
			buf.Append(FillRate);
			buf.Append("\n");
			buf.Append("- Health: ");
			buf.Append(Health);
			buf.Append("\n");
			return buf.ToString();
		}
		public bool CanRefill() { return Health != 0; }
	}

	partial class City {
		public void SimulateTurn() {
			Buildings().ForEach(((x) => x.MakeTurn()));
			var gens = (from b in Buildings()
						where b.GetType() == typeof(Generator)
						select ((Generator)b));
			var shlds = (from b in Buildings()
					where b.GetType() == typeof(Shield)
					select (b);
			foreach(var g in gens) {
				foreach(var s in shlds) {
					if(g.CanRefill() && s.NeedUrgentRefill()) {
						g.FillToUpkeep(s);
					}
				}
				foreach(var s in shlds) {
					if(g.CanRefill() && s.NeedRefill()) {
						g.Fill(s);
					}
				}
			}
		}

		public bool ShieldsDown() {
			return (from b in Buildings()
				where b.GetType() == typeof(Shield)
				&& ((Shield)b).Health < ((Shield)b).Upkeep
				select b).Count() != 0;
		}

		public override string ToString() {
			var ret = new StringBuilder();
			ret.Append("City content:\n\n");
			var builds = (from b in Buildings()
					select b.ToString());
			foreach(var s in builds) { ret.Append(s); ret.Append("\n"); }
			return ret.ToString();
		}
	}
}
