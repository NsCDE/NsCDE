#!/usr/bin/env python3

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Based on (forked) CDEtheme for XFCE by Jos van Riswick
# Licence: GPLv3
#

import re
import os
import sys
import shutil
from SpritesGtk2 import spriteLWHXYgtk2
import Globals

# todo put in class

bg=[0,0,0,0,0,0,0,0,0]
fg=[0,0,0,0,0,0,0,0,0]
bs=[0,0,0,0,0,0,0,0,0]
ts=[0,0,0,0,0,0,0,0,0]
sel=[0,0,0,0,0,0,0,0,0]

#introducing the legacy Motif thingies
XmCOLOR_LITE_SEL_FACTOR=15
XmCOLOR_LITE_BS_FACTOR=40
XmCOLOR_LITE_TS_FACTOR=20
XmCOLOR_LO_SEL_FACTOR=15
XmCOLOR_LO_BS_FACTOR=60
XmCOLOR_LO_TS_FACTOR=50
XmCOLOR_HI_SEL_FACTOR=15
XmCOLOR_HI_BS_FACTOR=40
XmCOLOR_HI_TS_FACTOR=60
XmCOLOR_DARK_SEL_FACTOR=15
XmCOLOR_DARK_BS_FACTOR=30
XmCOLOR_DARK_TS_FACTOR=50
XmRED_LUMINOSITY=0.30
XmGREEN_LUMINOSITY=0.59
XmBLUE_LUMINOSITY=0.11
XmINTENSITY_FACTOR=75
XmLIGHT_FACTOR=0
XmLUMINOSITY_FACTOR=25
XmMAX_SHORT=65535
XmDEFAULT_DARK_THRESHOLD=20
XmDEFAULT_LIGHT_THRESHOLD=93
XmDEFAULT_FOREGROUND_THRESHOLD=70
XmCOLOR_PERCENTILE = (XmMAX_SHORT / 100)
XmCOLOR_LITE_THRESHOLD = XmDEFAULT_LIGHT_THRESHOLD* XmCOLOR_PERCENTILE
XmCOLOR_DARK_THRESHOLD = XmDEFAULT_DARK_THRESHOLD* XmCOLOR_PERCENTILE
XmFOREGROUND_THRESHOLD = XmDEFAULT_FOREGROUND_THRESHOLD* XmCOLOR_PERCENTILE

HEX=['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
HEXNUM=[4096,256,16,1]

def int2hex(n):
    if n==0: return '0000'
    h=''
    for a in HEXNUM:
        i=int(float(n)/a)
        h+=HEX[i]
        n-=i*a
    return h

palette=[
'#ed00a8007000',
'#9900991b99fe',
'#89559808aa00',
'#68006f008200',
'#c600b2d2a87e',
'#49009200a700',
'#b70087008d00',
'#938eab73bf00'
]

def encode16bpp(color):
    match=re.search('#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$',color)
    if match:
        a=match.group(1)
        b=match.group(2)
        c=match.group(3)
        return """#{a}{a}{b}{b}{c}{c}""".format(**locals())
    match=re.search('#[0-9a-fA-F]{12}$',color)
    if match:
        return color
    return "#888888888888";

#convert to rgb array
def bbpToRGB(hexcolor):
    rgb=[]
    match=re.search('#(....)(....)(....)',hexcolor)
    if match:
        rgb.append(int(match.group(1),16))
        rgb.append(int(match.group(2),16))
        rgb.append(int(match.group(3),16))
        return rgb
    match=re.search('#(..)(..)(..)',hexcolor)
    if match:
        rgb.append(int(match.group(1),16))
        rgb.append(int(match.group(2),16))
        rgb.append(int(match.group(3),16))
        return rgb
    return [0,0,0]

def Brightness(color):
    red = color[0]
    green = color[1]    
    blue = color[2]
    intensity = (red + green + blue) / 3.0
    luminosity = int ((XmRED_LUMINOSITY * red) + (XmGREEN_LUMINOSITY * green) + (XmBLUE_LUMINOSITY * blue))
    ma=0
    if red>green:
        if red>blue: ma=red
        else: ma=blue
    else:
        if green>blue: ma=green
        else: ma=blue
    mi=0
    if red<green:
        if red<blue:mi=red
        else: mi=blue
    else:
        if green<blue:mi=green
        else: mi=blue
    light = (mi+ ma) / 2.0
    brightness = ( (intensity * XmINTENSITY_FACTOR) + (light * XmLIGHT_FACTOR) + (luminosity * XmLUMINOSITY_FACTOR) ) / 100.0
    return brightness

def CalculateColorsForDarkBackground(bg_color):
    fg_color=[0,0,0]
    sel_color=[0,0,0]
    bs_color=[0,0,0]
    ts_color=[0,0,0]
    brightness=Brightness(bg_color)
    if brightness > XmFOREGROUND_THRESHOLD:
        fg_color[0]= 0 
        fg_color[1]= 0 
        fg_color[2]= 0
    else:
        fg_color[0]= XmMAX_SHORT 
        fg_color[1]= XmMAX_SHORT 
        fg_color[2]= XmMAX_SHORT
    color_value = bg_color[0] 
    color_value += XmCOLOR_DARK_SEL_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    sel_color[0] = color_value
    color_value = bg_color[1] 
    color_value += XmCOLOR_DARK_SEL_FACTOR * (XmMAX_SHORT - color_value) / 100.0    
    sel_color[1] = color_value
    color_value = bg_color[2] 
    color_value += XmCOLOR_DARK_SEL_FACTOR * (XmMAX_SHORT - color_value) / 100.0
    sel_color[2] = color_value
    color_value = bg_color[0] 
    color_value += XmCOLOR_DARK_BS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    bs_color[0] = color_value
    color_value = bg_color[0]
    color_value += XmCOLOR_DARK_BS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    bs_color[1] = color_value
    color_value = bg_color[2]
    color_value += XmCOLOR_DARK_BS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    bs_color[2] = color_value
    color_value = bg_color[0]
    color_value += XmCOLOR_DARK_TS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    ts_color[0] = color_value
    color_value = bg_color[1]
    color_value += XmCOLOR_DARK_TS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    ts_color[1] = color_value
    color_value = bg_color[2]
    color_value += XmCOLOR_DARK_TS_FACTOR * (XmMAX_SHORT - color_value) / 100.0 
    ts_color[2] = color_value
    return fg_color,sel_color,bs_color,ts_color

def CalculateColorsForLightBackground(bg_color):
    fg_color=[0,0,0]
    sel_color=[0,0,0]
    bs_color=[0,0,0]
    ts_color=[0,0,0]
    brightness=Brightness(bg_color)
    if (brightness > XmFOREGROUND_THRESHOLD):
        fg_color[0] = 0
        fg_color[1] = 0
        fg_color[2] = 0
    else:
        fg_color[0] = XmMAX_SHORT
        fg_color[1] = XmMAX_SHORT
        fg_color[2] = XmMAX_SHORT
    color_value = bg_color[0]
    color_value -= (color_value * XmCOLOR_LITE_SEL_FACTOR) / 100.0
    sel_color[0] = color_value
    color_value = bg_color[1]
    color_value -= (color_value * XmCOLOR_LITE_SEL_FACTOR) / 100.0
    sel_color[1] = color_value
    color_value = bg_color[2]
    color_value -= (color_value * XmCOLOR_LITE_SEL_FACTOR) / 100.0
    sel_color[2] = color_value
    color_value = bg_color[0]
    color_value -= (color_value * XmCOLOR_LITE_BS_FACTOR) / 100.0
    bs_color[0] = color_value
    color_value = bg_color[1]
    color_value -= (color_value * XmCOLOR_LITE_BS_FACTOR) / 100.0
    bs_color[1] = color_value
    color_value = bg_color[2]
    color_value -= (color_value * XmCOLOR_LITE_BS_FACTOR) / 100.0
    bs_color[2] = color_value
    color_value = bg_color[0]
    color_value -= (color_value * XmCOLOR_LITE_TS_FACTOR) / 100.0
    ts_color[0] = color_value
    color_value = bg_color[1]
    color_value -= (color_value * XmCOLOR_LITE_TS_FACTOR) / 100.0
    ts_color[1] = color_value
    color_value = bg_color[2]
    color_value -= (color_value * XmCOLOR_LITE_TS_FACTOR) / 100.0
    ts_color[2] = color_value
    return (fg_color,sel_color,bs_color,ts_color)

def CalculateColorsForMediumBackground(bg_color):
    fg_color=[0,0,0]
    sel_color=[0,0,0]
    bs_color=[0,0,0]
    ts_color=[0,0,0]
    brightness=Brightness(bg_color)
    if (brightness > XmFOREGROUND_THRESHOLD):
        fg_color[0] = 0
        fg_color[1] = 0
        fg_color[2] = 0
    else:
        fg_color[0] = XmMAX_SHORT
        fg_color[1] = XmMAX_SHORT
        fg_color[2] = XmMAX_SHORT
    f = XmCOLOR_LO_SEL_FACTOR + (brightness * ( XmCOLOR_HI_SEL_FACTOR - XmCOLOR_LO_SEL_FACTOR ) / XmMAX_SHORT)
    color_value = bg_color[0]
    color_value -= (color_value * f) / 100.0
    sel_color[0] = color_value
    color_value = bg_color[1]
    color_value -= (color_value * f) / 100.0
    sel_color[1] = color_value
    color_value = bg_color[2]
    color_value -= (color_value * f) / 100.0
    sel_color[2] = color_value
    f = XmCOLOR_LO_BS_FACTOR + (brightness * ( XmCOLOR_HI_BS_FACTOR - XmCOLOR_LO_BS_FACTOR ) / XmMAX_SHORT)
    color_value = bg_color[0]
    color_value -= (color_value * f) / 100.0
    bs_color[0] = color_value
    color_value = bg_color[1]
    color_value -= (color_value * f) / 100.0
    bs_color[1] = color_value
    color_value = bg_color[2]
    color_value -= (color_value * f) / 100.0
    bs_color[2] = color_value
    f = XmCOLOR_LO_TS_FACTOR + (brightness * ( XmCOLOR_HI_TS_FACTOR - XmCOLOR_LO_TS_FACTOR ) / XmMAX_SHORT)
    color_value = bg_color[0]
    color_value += f * ( XmMAX_SHORT - color_value ) / 100.0
    ts_color[0] = color_value
    color_value = bg_color[1]
    color_value += f * ( XmMAX_SHORT - color_value ) / 100.0
    ts_color[1] = color_value
    color_value = bg_color[2]
    color_value += f * ( XmMAX_SHORT - color_value ) / 100.0
    ts_color[2] = color_value
    return (fg_color,sel_color,bs_color,ts_color)


def rgbToHex(rgb):
    a=int2hex(rgb[0])
    b=int2hex(rgb[1])
    c=int2hex(rgb[2])
    return """#{a}{b}{c}""".format(**locals())

def equal_colors_ab(a,b):
    bg[a]=bg[b]
    fg[a]=fg[b]
    bs[a]=bs[b]
    ts[a]=ts[b]
    sel[a]=sel[b]
    

def initcolors(palette):
    for a in range(1,9):
        color16=encode16bpp(palette[a-1])
        bg_color=bbpToRGB(color16)
        backgroundbrightness=Brightness(bg_color)
        if backgroundbrightness< XmCOLOR_DARK_THRESHOLD:
            (fg_color,sel_color,bs_color,ts_color)= CalculateColorsForDarkBackground(bg_color)
        elif backgroundbrightness> XmCOLOR_LITE_THRESHOLD:
            (fg_color,sel_color,bs_color,ts_color)= CalculateColorsForLightBackground(bg_color)
        else:
            (fg_color,sel_color,bs_color,ts_color)= CalculateColorsForMediumBackground(bg_color)
        #bg[a]=encode16bpp(palette[a-1])
        bg[a]=color16
        fg[a]=rgbToHex(fg_color)
        bs[a]=rgbToHex(bs_color)
        ts[a]=rgbToHex(ts_color)
        sel[a]=rgbToHex(sel_color)
    if use_4_colors:
        equal_colors_ab(5,2)
        equal_colors_ab(6,2)
        equal_colors_ab(8,2)
        equal_colors_ab(7,2)

def round_colors_6():
    for a in range(1,9):
        bg[a]='#'+bg[a][1:3]+bg[a][5:7]+bg[a][9:11]
        fg[a]='#'+fg[a][1:3]+fg[a][5:7]+fg[a][9:11]
        bs[a]='#'+bs[a][1:3]+bs[a][5:7]+bs[a][9:11]
        ts[a]='#'+ts[a][1:3]+ts[a][5:7]+ts[a][9:11]
        sel[a]='#'+sel[a][1:3]+sel[a][5:7]+sel[a][9:11]

def readPalette(filename):
    with open(filename) as f:lines=f.read().splitlines() 
    return lines
    
use_4_colors=False

def readMotifColors2(n,filename):
    global use_4_colors
    palette=readPalette(filename)
    if n==4: 
        use_4_colors=True
    else: 
        use_4_colors=False
    initcolors(palette)
    round_colors_6()
    colors={}
    for a in range(1,9):
        colors['bg_color_'+str(a)]=bg[a]
        colors['fg_color_'+str(a)]=fg[a]
        colors['ts_color_'+str(a)]=ts[a]
        colors['bs_color_'+str(a)]=bs[a]
        colors['sel_color_'+str(a)]=sel[a]
    return colors

# LIKE IN CDE, THE SOURCE XPM MUST HAVE 4 COLORS DEFINED: 
# ts_color, bg_color, sel_color and bs_color
def colorize_bg(infile,outfile,palettefile,n,colorsetnr):
    palette=readPalette(palettefile)
    global use_4_colors
    if n==4: 
        use_4_colors=True
    else: 
        use_4_colors=False
    initcolors(palette)
    round_colors_6()
    with open(infile) as f:lines=f.read().splitlines() 
    for i in range(0,20): #color defs are somewheres in the first 20 lines or so
        lines[i]=re.sub('ts_color',ts[colorsetnr],lines[i]) 
        lines[i]=re.sub('bg_color',bg[colorsetnr],lines[i]) 
        lines[i]=re.sub('bs_color',bs[colorsetnr],lines[i]) 
        lines[i]=re.sub('sel_color',sel[colorsetnr],lines[i]) 
    with open(outfile, 'w') as f: 
        for l in lines:
            f.write(l)




######################################################################################
######################################################################################
######################################################################################

if __name__ == '__main__':

    print ('Debug me')


