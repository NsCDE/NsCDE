#!/bin/ksh

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

IFS=" "

function usage
{
   echo "Usage: ${0##*/} -t <title> -b <buttontitle> -i <icon> [ -s <textstr> | -f <file> ] [ -h ]"
   exit $1
}

FontSize=$($NSCDE_ROOT/bin/getfont -v -t normal -s medium -Z 16 -S)
if (($FontSize >= 16)); then
   FoldFactor=56
   verticalfactor=28
elif (($FontSize < 16)) && (($FontSize >= 14)); then
   FoldFactor=60
   verticalfactor=26
elif (($FontSize < 14)) && (($FontSize >= 12)); then
   FoldFactor=68
   verticalfactor=24
elif (($FontSize < 12)) && (($FontSize >= 11)); then
   FoldFactor=88
   verticalfactor=22
elif (($FontSize == 10)) || (($FontSize == 9)); then
   FoldFactor=90
   verticalfactor=20
else
   FoldFactor=110
   verticalfactor=18
fi

while getopts t:b:i:s:f:h Option
do
   case $Option in
      t)
         if $(whence -q gettext); then
            sh_WindowTitle=$(TEXTDOMAINDIR="$NSCDE_ROOT/share/locale" gettext -d NsCDE -s "$OPTARG")
         else
            sh_WindowTitle="$OPTARG"
         fi
      ;;
      b)
         if $(whence -q gettext); then
            sh_ButtonTitle=$(TEXTDOMAINDIR="$NSCDE_ROOT/share/locale" gettext -d NsCDE -s "$OPTARG")
         else
            sh_ButtonTitle="$OPTARG"
         fi
      ;;
      i)
         sh_IconFile="$OPTARG"
      ;;
      s)
         if $(whence -q gettext); then
            sh_TextString=$(TEXTDOMAINDIR="$NSCDE_ROOT/share/locale" gettext -d NsCDE -s "$OPTARG")
         else
            sh_TextString="$OPTARG"
         fi
         sh_WrappedText=$(echo "$sh_TextString" | fold -w $FoldFactor -s)
         sh_WrappedTextLines=$(echo "$sh_WrappedText" | wc -l)
      ;;
      f)
         sh_TextFile="$OPTARG"
         sh_TextString=$(<"$sh_TextFile")
         sh_WrappedText=$(echo "$sh_TextString" | fold -w $FoldFactor -s)
         sh_WrappedTextLines=$(echo "$sh_WrappedText" | wc -l)
      ;;
      h)
         usage 0
      ;;
   esac
done

HeightAppend=$(( $sh_WrappedTextLines * $verticalfactor ))
ScriptHeight=$(( 104 + $HeightAppend ))

if (($sh_WrappedTextLines == 1)); then
   textcharsnum=$(echo "$sh_WrappedText" | wc -c)
   if (($textcharsnum < 48)) && (($FontSize <= 12)); then
      ScriptWidth=480
      RectangleWidth=472
      ButtonPos=180
   elif (($textcharsnum < 72)) && (($FontSize <= 12)); then
      ScriptWidth=620
      RectangleWidth=612
      ButtonPos=246
   else
      ScriptWidth=754
      RectangleWidth=746
      ButtonPos=314
   fi
else
   ScriptWidth=754
   RectangleWidth=746
   ButtonPos=314
fi

cat <<EOF

WindowTitle {${sh_WindowTitle:=Notice}}
WindowSize $ScriptWidth $ScriptHeight
Colorset 22

Init
Begin
        Set \$Font = (GetOutput {\$NSCDE_ROOT/bin/getfont -v -t normal -s medium -Z 16} 1 -1)
        ChangeFont 3 \$Font
EOF

fntcnt=9
txtlinepad=$(( $sh_WrappedTextLines + $fntcnt))
while (( $fntcnt < $txtlinepad ))
do
   echo "ChangeFont $fntcnt \$Font"
   (( fntcnt = fntcnt + 1 ))
done

cat <<EOF

	Key Return A 3 1 {Dismiss}
End

EOF

WidgetNum=9
WidgetHeightStart=16
linecnt=0
echo "$sh_WrappedText" | while read line
do
   WidgetHeight=$(( $WidgetHeightStart + $linecnt ))

cat <<EOF
Widget $WidgetNum
   Property
   Size $(($ScriptWidth - 68)) $verticalfactor
   Position 68 $WidgetHeight
   Type ItemDraw
   Flags NoReliefString NoFocus Left
   Title {$line}
   Main
      Case message of
      SingleClic :
      Begin
      End
End

EOF

((WidgetNum = WidgetNum + 1 ))
((linecnt = $linecnt + $verticalfactor ))

done

cat <<EOF
Widget 1
   Property
   Size 32 32
   Position 16 $(($linecnt / 2 + 2 ))
   Type ItemDraw
   Flags NoReliefString NoFocus
   Title {}
   Icon ${sh_IconFile:=NsCDE/Info.xpm}
   Main
      Case message of
      SingleClic :
      Begin
      End
End

Widget 2
   Property
   Size $RectangleWidth 0
   Position 4 $(( $linecnt + 40 ))
   Type Rectangle
   Flags NoReliefString NoFocus
   Main
      Case message of
      SingleClic :
      Begin
      End
End

Widget 3
   Property
   Size 120 0
   Position $ButtonPos $(( $linecnt + 58 ))
   Type PushButton
   Title {${sh_ButtonTitle:=Dismiss}}
   Font "xft:::pixelsize=15"
   Flags NoReliefString Center
   Main
      Case message of
      SingleClic :
      Begin
         SendSignal 3 1
         Quit
      End
   1 :
   Begin
      If (LastString) == {Dismiss} Then
      Begin
         Quit
      End
   End
End

EOF

