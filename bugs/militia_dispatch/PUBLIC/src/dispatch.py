#!/usr/bin/python

# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (3 Gallium 886)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Pep/OS

import json
import operator
import sys

from ctypes import *

class Map(object):

    def __init__(self):
        self._city = None
        self.approved_city_names = ["dome"]
        self.militia_count = 0

    def load_from_dict(self, _dict):
        self.city = _dict["city"]

        sectors = []
        for sector in _dict["sectors"]:
            s_name = sector["name"]
            s_occ = sector["current_occupation"]
            s = Sector(s_name, s_occ)
            self.sectors.append(s)

    def to_dict(self):
        out = dict({})

        out["name"] = self.city
        out["sectors"] = []

        for sector in self.sectors:
            out["sectors"].append({
                "name": sector.name,
                "current_occupation": sector.occupation,
                "militia_dispatch": sector.militia_count
            })

    @city.setter
    def city(self, city):
        self._city = city

    @property
    def city(self):
        return self._city


class Sector(object):
    def __init__(self, sector_name, occupation):
        self.name = sector_name
        self.occupation = occupation


CFUN = CFUNCTYPE(c_int, c_int, c_int)

@CFUN
def c_int_add(a, b):
    return a + b


def dispatch_miltia(city): #BEGIN C_STATIC `{
    full_occ = reduce(operator.add, [sector.occupation for sector in city.sectors])
    militia = city.militia_count

    avgs = map(lambda x: x.occupation / full_occ, city.sectors)

    round = lambda x: int(round(militia * x))
    rounds = map(c_int, map(round, avgs))

    total_dispatched = reduce(c_int_add, rounds)

    if total_dispatched != militia:
        diff = total_dispatched - militia
        rounds[:][0] += diff

    for (sect, disp) in zip(city.sectors, rounds):
        sect.militia_count = disp
    else:
        dict = city.to_dict()
        print json.dumps(dict, indent=4)

    return rounds
#`} END C_STATIC;


try:
    json_file = sys.argv[1]

    with open(json_file, 'r') as fd:
        city_info = json.load(fd)

except IndexError, ValueError:
    print "Error reading JSON file."
    sys.exit(0)

map = Map()
map.load_from_dict(city_info)

dispatch_miltia(map)

