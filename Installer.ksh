#!/bin/ksh

noninteractive=0

function check_dependencies
{
   :
}

function install_nscde
{
   if [ -z $fvwm_patched ]; then
      echo "You must provide either -w or -f. If your installation of FVWM has been"
      echo "patched with \"FvwmButtons_sunkraise_windowname_unified.patch\" and with"
      echo "\"FvwmScript_XC_left_ptr.patch\", specify \"-f\" to the installer. If not,"
      echo "then specify \"-w\" for workarounds to be applied (see the docs)."
      exit 1
   fi

   check_dependencies

   if [ "x$instpath" == "x" ]; then
      if (($noninteractive == 1)); then
         instpath="/opt/NsCDE"
      fi
   else
      echo "Installation firectory for NsCDE [/opt/NsCDE]: \c"
      read ans
      if [ "x$ans" == "x" ]; then
         instpath="/opt/NsCDE"
      else
         instpath="$ans"
      fi
   fi

   uid=$(id -u)
   if (($uid > 0)); then
      sleep 2
      echo "Warning: running NsCDE installer as non-root user. This can only succeed if"
      echo "have a write access to the ${instpath%/*}."
   fi

   if [ -d "$instpath" ]; then
      inststate=$(ls -1 "$instpath" | wc -l)
      if (($inststate > 1)); then
         echo "Warning: $instpath already exists and appears to be populated with"
         echo "some data or previous installation."
         if (($noninteractive == 1)); then
            exit 2
         else
            echo -n "Do you want to continue with copying NsCDE installation into ${instpath}? (y|n)[n] \c"
            read ans
            if [ "$ans" != "y" ]; then
               echo "Exiting installation."
               exit 2
            fi
         fi
      else
         sleep 2
         echo "Directory $instpath already exists but appears to be empty. Continuing."
      fi
   else
      echo "Creating $instpath"
      mkdir -p "$instpath"
   fi

   if [ -d "NsCDE" ]; then
      echo "Copying NsCDE distribution files into $instpath"
      cp -rpf NsCDE/* "${instpath}/"
      retval="$?"
      if (($retval == 0)); then
         echo "Done."
      else
         echo "Error $retval occured while copying NsCDE distribution files into $instpath"
      fi
   else
      echo "Directory $instpath does not exist after attempting to create it. Exiting."
      exit 3
   fi

   if [ "x$photopath" != "x" ]; then
      echo "Copying additional photo collection from $photopath as ${instpath}/share/photos"
      if [ -d "$photopath" ]; then
         cp -f "$photopath" ${instpath}/share/photos
         retval=$?
         if (($retval != 0)); then
            echo "An error $retval occured while copying photo collection from $photopath"
         else
            echo "Done."
         fi
      else
         echo "Error: Cannot read directory with additional photo collection: $photopath"
      fi
   else
      if [ ! -d "${instpath}/share/photos" ]; then
         echo "Info: Additional photo collection not installed in ${instpath}/share/photos"
         echo "See: https://github.com/NsCDE/NsCDE-photos/releases/download/1.0/NsCDE-Photos-1.0.tar.gz"
      fi
   fi

   if [ "x$vuepath" != "x" ]; then
      echo "Copying additional VUE palettes and backdrops from $vuepath"
      if [ -d "${vuepath}" ]; then
         cp -f "$vuepath"/share/palettes/* ${instpath}/share/palettes/
         retval=$?
         if (($retval != 0)); then
            echo "An error $retval occured while copying VUE palettes collection from ${vuepath}/share/palettes"
         else
            echo "Done."
         fi
         cp -f "$vuepath"/share/backdrops/* ${instpath}/share/backdrops/
         retval=$?
         if (($retval != 0)); then
            echo "An error $retval occured while copying VUE backdrops collection from ${vuepath}/share/backdrops"
         else
            echo "Done."
         fi
      else
         echo "Error: Cannot read directory with additional VUE palettes and backdrops: $vuepath"
      fi
   else
      if [ ! -r "${instpath}/share/palettes/CoralReef.dp" ]; then
         echo "Info: Additional collection of VUE palettes and backdrops not installed in ${instpath}/share/{palettes,backdrops}"
         echo "See: https://github.com/NsCDE/NsCDE-VUE/releases/download/1.0/NsCDE-VUE-1.0.tar.gz"
      fi
   fi

   if (($fvwm_patched == 1)); then
      configure_installed patched
   else
      configure_installed workarounds
   else
   fi
}

function configure_installed
{
   if [ "$1" == "patched" ]; then
      # Uncomment HAS_WINDOWNAME in NsCDE.conf
      # Patch NsCDE-FrontPanel.conf for "indicator 12 in"
      # Regenerate system NsCDE-Subpanels.conf with window name
      :
   fi

   if [ "$1" == "workarounds" ]; then
      # Try to compile XOverrideFontCursor.so
      # Patch NsCDE-FrontPanel.conf for Launcher Icon and PressIcon statements
      :
   fi

   # Handle pclock
   :

   # Install xsession file nscde.desktop
   :
}

function upgrade_nscde
{
   # Backup photos and VUE if exists, unpack new, put photos and VUE back
   :
}

function deinstall_nscde
{
   # Question, or noninteractive, rm -rf ... careful.
   :
}

function usage
{
   echo "Usage: ${0##*/} [-i|-u|-d] [-p] [-w] [-f] [-P] [-V] [-X]"
}

while getopts iucdp:wfP:V:X:nh Option
do
   case $Option in
   i)
      install_nscde
   ;;
   u)
      upgrade_nscde
   ;;
   c)
      check_dependencies
   ;;
   d)
      deinstall_nscde
   ;;
   p)
      instpath="$OPTARG"
   ;;
   w)
      fvwm_patched=0
   ;;
   f)
      fvwm_patched=1
   ;;
   P)
      photopath="$OPTARG"
   ;;
   V)
      vuepath="$OPTARG"
   ;;
   X)
      xsessionpath="$OPTARG"
   ;;
   n)
      noninteractive=1
   ;;
   h)
      usage
   ;;
   esac
done

