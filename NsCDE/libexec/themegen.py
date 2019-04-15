#!/usr/bin/python

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

import os
import sys
import shutil

nscde_root = os.environ.get('NSCDE_ROOT')
sys.path.append(nscde_root + "/lib/python")

from PyQt4 import QtCore, QtGui
import Globals
from Theme import Theme
from Opts import Opts
from MotifColors import readMotifColors2

themegen="""
For this script to work you need to install the pyqt4 modules.
    """

helptxt="""
Generate gtk2 and gtk3 theme in style of CDE/Motif

Directory 'NsCDE' will be be created as ~/.themes/NsCDE

Usage:
   themegen paletteFile nrOfColors gtk2 gtk3

Arguments:
    palette file (CDE color palettes, are located in ~/.themes/cdetheme/palettes)
    number of colors: 8 or 4 (This used to be an option in CDE. 4 Gives a reduced version)

Examples:

    ('HPUnix style')
       ./themegen ../palettes/Broica.dp 8 True True
    ('Solaris style')
       ./themegen ../palettes/Crimson.dp 4 True True
    """+themegen

if len(sys.argv)!=5:
    print helptxt
    sys.exit()

app = QtGui.QApplication(sys.argv)

opts=Opts()

currentpalettefilefullpath=sys.argv[1]
opts.ncolors=int(sys.argv[2])
opts.themeGtk2=(sys.argv[3])
opts.themeGtk3=(sys.argv[4])

opts.currentpalettefile=os.path.basename(currentpalettefilefullpath)

userhome=os.path.expanduser("~")
Globals.themedir=nscde_root + "/share/templates/integration/gtk2_gtk3_qt"
Globals.userthemedir=os.path.join(userhome,'.themes','NsCDE')
Globals.themesrcdir=Globals.themedir
Globals.palettedir=os.path.join(Globals.themedir,'palettes')

theme=Theme(opts)
Globals.colorshash=readMotifColors2(opts.ncolors,currentpalettefilefullpath)
theme.initTheme()
theme.updateThemeNow()

