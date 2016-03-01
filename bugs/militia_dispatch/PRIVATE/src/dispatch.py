#!/usr/bin/python

import json
import operator
import sys

from ctypes import *

class Map(object):

    def __init__(self):
        self._city = None
        # TODO remove this
        self.sectors = []
        self.approved_city_names = ["Dome"]
        self.militia_count = 0

    def load_from_dict(self, _dict):
        self.city = _dict["city"]
        self.militia_count = _dict["militia_count"]

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

        # TODO remove return
        return out

    # Nice bug switch these two
    @property
    def city(self):
        return self._city

    @city.setter
    def city(self, city):
        if city in self.approved_city_names:
            self._city = city
        else:
            print "DomeError: THE GREAT DOME FIREWALL HAS BLOCKED YOUR QUERY."
            sys.exit(0)

    def full_occupation(self):
        occ = 0;
        # Essayer de faire un map reduce au top level
        for i in self.sectors:
            occ += i.occupation
        return occ


class Sector(object):
    def __init__(self, sector_name, occupation):
        self.name = sector_name
        self.occupation = occupation
        self.militia_count = 0


# CFUN = CFUNCTYPE(c_int, c_int, c_int)
# 
# @CFUN
# def c_int_add(a, b):
#     return a + b

# TODO bring to top level
def dispatch_miltia(city): #BEGIN C `{
    full_occ = city.full_occupation()
    militia = city.militia_count

    # Bug remove float casts
    avgs = map(lambda x: float(x.occupation) / float(full_occ), city.sectors)

    # TODO bug mask round
    _round = lambda x: int(round(militia * x))
    # rounds = map(c_int, map(_round, avgs))
    rounds = map(_round, avgs)

    total_dispatched = reduce(operator.add, rounds)
    # total_dispatched = reduce(c_int_add, rounds)

    if total_dispatched != militia:
        diff = total_dispatched - militia
        rounds[0] += diff
        # rounds[:][0] += diff

    for (sect, disp) in zip(city.sectors, rounds):
        sect.militia_count = disp
    else:
        dict = city.to_dict()
        print json.dumps(dict, indent=4)

    return rounds
    #`} END C;


try:
    json_file = sys.argv[1]

    with open(json_file, 'r') as fd:
        city_info = json.load(fd)
# TODO bug here
except (ValueError, IndexError) as e:

    print "Error reading JSON file."
    sys.exit(0)

_map = Map()
_map.load_from_dict(city_info)

dispatch_miltia(_map)

