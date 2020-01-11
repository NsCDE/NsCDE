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

while getopts t:b:i:s:f:h Option
do
   case $Option in
      t)
         sh_WindowTitle="$OPTARG"
      ;;
      b)
         sh_ButtonTitle="$OPTARG"
      ;;
      i)
         sh_IconFile="$OPTARG"
      ;;
      s)
         sh_TextString="$OPTARG"
         sh_WrappedText=$(echo "$sh_TextString" | fold -w 86 -s)
         sh_WrappedTextLines=$(echo "$sh_WrappedText" | wc -l)
      ;;
      f)
         sh_TextFile="$OPTARG"
         sh_TextString=$(<"$sh_TextFile")
         sh_WrappedText=$(echo "$sh_TextString" | fold -w 86 -s)
         sh_WrappedTextLines=$(echo "$sh_WrappedText" | wc -l)
      ;;
      h)
         usage 0
      ;;
   esac
done

HeightAppend=$(( $sh_WrappedTextLines * 24 ))
ScriptHeight=$(( 104 + $HeightAppend ))

if (($sh_WrappedTextLines == 1)); then
   textcharsnum=$(echo "$sh_WrappedText" | wc -c)
   if (($textcharsnum < 48)); then
      ScriptWidth=480
      RectangleWidth=472
      ButtonPos=180
   elif (($textcharsnum < 72)); then
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

	WarpPointer 3
	Key Return A 3 1 {Dismiss}
End

Widget 1
   Property
   Size 32 32
   Position 16 20
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
   Size 520 18
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
((linecnt = $linecnt + 24 ))

done

cat <<EOF
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

