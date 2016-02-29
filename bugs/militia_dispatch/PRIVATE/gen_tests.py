import json
import random
import string
import sys

def gen_sector_name():
    name = ''.join(random.choice(string.ascii_uppercase) for _ in range(3))
    num = ''.join(random.choice(string.digits) for _ in range(2))

    return '-'.join([name, num])


sectors = []
sector_names = []
for i in range(int(sys.argv[2])):
    sector_name = gen_sector_name()
    if sector_name in sector_names:
        continue
    else:
        sector_names.append(sector_name)
    sector_occupation = random.randrange(100000)

    sectors.append({"name": sector_name, "current_occupation": sector_occupation})

full_dict = {
        "city": sys.argv[1],
        "militia_count": random.randrange(0, 8589934592),
        # "militia_count": random.randrange(0, 1000),
        "sectors": sectors
}

print json.dumps(full_dict, indent=4)





