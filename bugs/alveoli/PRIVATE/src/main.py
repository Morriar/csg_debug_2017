#!/usr/bin/python3

import json

from alveoli import *

if len(sys.argv) != 2:
    print("Usage: python3 main.py <jsonfile>")
    sys.exit(0)

data  = None
with open(sys.argv[1], 'r') as fd:
    data = json.load(fd)

dome_cells = []
for cell in data:
    if cell["class"] == "AntiRadiationCell":
        wave = cell["wave"]
        capacity = cell["capacity"]
        identifier = cell["identifier"]
        dome_cells.append(
            alveoli_defs.AntiRadiationCell(wave, capacity, identifier)
        )

    elif cell["class"] == "SunCell":
        luminosity = cell["luminosity"]
        capacity = cell["capacity"]
        dome_cells.append(
            alveoli_defs.SunCell(luminosity, capacity)
        )

    elif cell["class"] == "EnergyCell":
        radcell_id = cell["radcell_id"]
        capacity = cell["capacity"]
        dome_cells.append(
            alveoli_defs.EnergyCell(radcell_id, capacity)
        )

    elif cell["class"] == "AntiNonCitizenCell":
        kill_count = cell["kill_count"]
        current_health = cell["current_health"]
        dome_cells.append(
            alveoli_defs.AntiNonCitizenCell(kill_count, current_health)
        )

for cell in dome_cells:
    print(cell.__class__)

    # Order attrs for deterministic output
    items = sorted(cell.__dict__.keys())

    for k in items:
        v = cell.__dict__[k]
        print("\t%s: %s" % (k, v))

