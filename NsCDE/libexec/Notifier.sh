#!/usr/bin/env ksh93

#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

OLD_LC_ALL="$LC_ALL"
IFS=" "

function usage
{
   echo "Usage: ${0##*/} -t <title> -b <buttontitle> -i <icon> [ -s <textstr> | -f <file> ] [ -l <catalog name> ] [ -h ]"
   exit $1
}

case $NSCDE_FONT_DPI in
   96)
      zoomfactor=0
   ;;
   120)
      zoomfactor=18
   ;;
   144)
      zoomfactor=32
   ;;
   192)
      zoomfactor=38
   ;;
esac

FontSize=$($NSCDE_ROOT/bin/getfont -v -t normal -s medium -S -Z 16)
LC_ALL="C"
if (($FontSize >= 16)); then
   FoldFactor=$((56 - (56 * $zoomfactor / 100)))
   verticalfactor=$((28 + (28 * $zoomfactor / 100)))
elif (($FontSize < 16)) && (($FontSize >= 14)); then
   FoldFactor=$((60 - (60 * $zoomfactor / 100)))
   verticalfactor=$((26 + (26 * $zoomfactor / 100)))
elif (($FontSize < 14)) && (($FontSize >= 12)); then
   FoldFactor=$((68 - (68 * $zoomfactor / 100)))
   verticalfactor=$((24 + (24 * $zoomfactor / 100)))
elif (($FontSize < 12)) && (($FontSize >= 11)); then
   FoldFactor=$((88 - (88 * $zoomfactor / 100)))
   verticalfactor=$((22 + (22 * $zoomfactor / 100)))
elif (($FontSize == 10)) || (($FontSize == 9)); then
   FoldFactor=$((90 - (90 * $zoomfactor / 100)))
   verticalfactor=$((20 + (20 * $zoomfactor / 100)))
else
   FoldFactor=$((110 - (110 * $zoomfactor / 100)))
   verticalfactor=$((18 + (18 * $zoomfactor / 100)))
fi
LC_ALL="$OLD_LC_ALL"

while getopts t:b:i:s:f:l:h Option
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
         title_style="Title"
      ;;
      f)
         sh_TextFile="$OPTARG"
         sh_TextString=$(<"$sh_TextFile")
         sh_WrappedText=$(echo "$sh_TextString" | fold -w $FoldFactor -s)
         sh_WrappedTextLines=$(echo "$sh_WrappedText" | wc -l)
         title_style="LocaleTitle"
      ;;
      l)
         CatalogName="$OPTARG"
      ;;
      h)
         usage 0
      ;;
   esac
done

LC_ALL="C"
HeightAppend=$(( $sh_WrappedTextLines * $verticalfactor ))
ScriptHeight=$(( 104 + $HeightAppend ))

if (($sh_WrappedTextLines == 1)); then
   textcharsnum=$(echo "$sh_WrappedText" | wc -c)
   if (($textcharsnum < 48)) && (($FontSize <= 12)); then
      ScriptWidth=$((480 + (480 * $zoomfactor / 100)))
      RectangleWidth=$((472 + (472 * $zoomfactor / 100)))
      ButtonPos=$((180 + (180 * $zoomfactor / 100)))
   elif (($textcharsnum < 72)) && (($FontSize <= 12)); then
      ScriptWidth=$((620 + (620 * $zoomfactor / 100)))
      RectangleWidth=$((612 + (612 * $zoomfactor / 100)))
      ButtonPos=$((246 + (246 * $zoomfactor / 100)))
   else
      ScriptWidth=$((754 + (754 * $zoomfactor / 100)))
      RectangleWidth=$((746 + (746 * $zoomfactor / 100)))
      ButtonPos=$((314 + (314 * $zoomfactor / 100)))
   fi
else
   ScriptWidth=$((754 + (754 * $zoomfactor / 100)))
   RectangleWidth=$((746 + (746 * $zoomfactor / 100)))
   ButtonPos=$((314 + (314 * $zoomfactor / 100)))
fi
LC_ALL="$OLD_LC_ALL"

if [ "$title_style" == "LocaleTitle" ]; then
  cat <<EOF
UseGettext {$NSCDE_ROOT/share/locale;$CatalogName}
EOF
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
   if [ "x$line" == "x" ] && [ "$title_style" = "LocaleTitle" ]; then
      line=" "
   fi
   WidgetHeight=$(( $WidgetHeightStart + $linecnt ))

cat <<EOF
Widget $WidgetNum
   Property
   Size $(($ScriptWidth - 68)) $verticalfactor
   Position 68 $WidgetHeight
   Type ItemDraw
   Flags NoReliefString NoFocus Left
   $title_style {$line}
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

