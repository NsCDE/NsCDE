#!/usr/bin/python

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Based on (forked) CDEtheme for XFCE by Jos van Riswick
# Licence: GPLv3
#

import sys
import Globals
import os
from MotifColors import colorize_bg
from os.path import expanduser
from MiscFun import *
import ThemeGtk
import shutil

class Theme():
    def __init__(self,opts):
        # import some stuff from main window
        self.opts=opts

    def initTheme(self):
        userhome=expanduser("~")
        # checkDir(userhome)
        homedotthemes=os.path.join(userhome,'.themes')
        if not os.path.exists(homedotthemes):
            print 'NOT FOUND so CREATING '+homedotthemes
            try: os.makedirs(homedotthemes)
            except OSError as e: print >>sys.stderr, "FAILED TO CREATE ~/.themes ", e

        # if .themes/NsCDE not exist: copy
        if os.path.exists(homedotthemes):
            # srcthemepath=os.path.join(Globals.distdir,'cdetheme')
            # print srcthemepath
            print Globals.themedir
            print Globals.themesrcdir
            #sys.exit()
            if not os.path.exists(Globals.themedir):
                print 'NOT FOUND THEME DIR '+Globals.themedir
                print 'Trying to copy from default '
                shutil.copytree(Globals.themesrcdir,Globals.themedir,symlinks=True)

            if os.path.lexists(Globals.userthemedir): shutil.rmtree(Globals.userthemedir)
            if self.opts.themeGtk2 == 'True' or self.opts.themeGtk3 == 'True':
                shutil.copytree(os.path.join(Globals.themedir,'img'),os.path.join(Globals.userthemedir,'img'))
                shutil.copytree(os.path.join(Globals.themedir,'img2'),os.path.join(Globals.userthemedir,'img2'))
                shutil.copy(os.path.join(Globals.themedir,'index.theme'),os.path.join(Globals.userthemedir,'index.theme'))
            if self.opts.themeGtk2 == 'True':
                shutil.copytree(os.path.join(Globals.themedir,'gtk-2.0'),os.path.join(Globals.userthemedir,'gtk-2.0'))
            if self.opts.themeGtk3 == 'True':
                shutil.copytree(os.path.join(Globals.themedir,'gtk-3.16'),os.path.join(Globals.userthemedir,'gtk-3.16'))
                shutil.copytree(os.path.join(Globals.themedir,'gtk-3.20'),os.path.join(Globals.userthemedir,'gtk-3.20'))

    # for use in script outside of qt event loop
    def updateThemeNow(self):
        self.doUpdateTheme()

    # Zees eeze nedded unly vunce
    def doUpdateTheme(self):
        print "Generate for Gtk2:", self.opts.themeGtk2
        print "Generate for Gtk3:", self.opts.themeGtk3

        palettefilefullpath=os.path.join(Globals.palettedir,self.opts.currentpalettefile)

        if self.opts.themeGtk2 == 'True':
            filename=Globals.userthemedir+'/gtk-2.0/cdecolors.rc'
            ThemeGtk.gengtk2colors(filename,self.opts)
        if self.opts.themeGtk3 == 'True':
            filename=os.path.join(Globals.userthemedir,'gtk-3.16/cdecolors.css')
            ThemeGtk.gengtk3colors(filename,self.opts)
            filename=os.path.join(Globals.userthemedir,'gtk-3.20/cdecolors.css')
            ThemeGtk.gengtk3colors(filename,self.opts)
            ThemeGtk.updateThemeImages(self.opts)

