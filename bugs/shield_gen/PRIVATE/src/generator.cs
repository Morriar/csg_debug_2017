namespace ShieldGen {
	partial class Generator: Facility {
		private int _health;
		public int Health {
			get {return _health;}
			protected set {_health = value;}
		}

		private int _capacity;
		public int Capacity {
			get {return _capacity;}
			protected set {_capacity = value;}
		}

		int _fillrate;
		public int FillRate {
			get {return _fillrate;}
			private set {_fillrate = value;}
		}
	}
}
