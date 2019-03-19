#!/usr/bin/env python3

import os

la1, la2, la3 = os.getloadavg()
numcpu = os.cpu_count()
cpula100 = (la1 * 100) / numcpu
cpula10 = (la1 * 10) / numcpu
cpula1 = la1 / numcpu

print ("%.0f" % cpula100)
print ("%.0f" % cpula10)
print ("%.0f" % cpula1)
