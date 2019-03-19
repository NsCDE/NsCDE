#!/usr/bin/env python3

import platform
import os
import pwd
import socket

# User Name
print (pwd.getpwuid(os.getuid()).pw_name)

# Workstation Name
print (platform.node().split(".", 1)[0])

# Uname mpi
print (platform.processor(), platform.machine(), os.uname()[4])

# Internet (IP) Address
print (socket.gethostbyname(socket.gethostname()))

# Internet Domain
finddomain = socket.getfqdn(socket.gethostbyname(socket.gethostname()))
if '.' in finddomain:
    domainpart = finddomain.split(".", 1)[1]
    print (domainpart)
else:
    print ("(none)")

try:
   import psutil

   physmem_mb = int(psutil.virtual_memory()[0] / 1024 / 1024)
   swapmem_mb = int(psutil.swap_memory()[0] / 1024 / 1024)
   swapmem_avail = int(psutil.swap_memory()[2] / 1024 / 1024)
   swapmem_pct = int(psutil.swap_memory()[3] / 1024 / 1024)

   # Physical Memory (RAM)
   print (physmem_mb)

   # Virtual Memory (Swap)
   print (swapmem_mb)

   # Virtual Memory (Swap) percent
   print (swapmem_pct)

   # Virtual Memory in Use
   print (str(swapmem_pct) + "% " + "(" + str(swapmem_pct) + "/" + str(swapmem_mb) + ") " + str(swapmem_avail) + "MB Available")

except ImportError:
   physmem_mb = "(Not available)"
   swapmem_mb = "(Not available)"
   swapmem_avail = "(Not available)"
   swapmem_pct = "(Not available)"

   # Physical Memory (RAM)
   print (physmem_mb)

   # Virtual Memory (Swap)
   print (swapmem_mb)

   # Virtual Memory (Swap) percent
   print (swapmem_pct)

   # Virtual Memory in Use
   print ("(Not available)")

# System Last Booted
# print ("syslastbooted XXX") # XXX
