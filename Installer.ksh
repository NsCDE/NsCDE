#!/bin/ksh

noninteractive=0

function check_dependencies
{
   # Python 3, ImageMagick, xdotool, yaml, PyQt, ksh (obviously) etc etc ...
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
      echo "UID $uid have a write access to the ${instpath%/*}."
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
      echo "Enabling HAS_WINDOWNAME variable in ${instpath}/config/NsCDE.conf"
      echo '# Since FVWM has been compiled with NsCDE patches, we are enabling' >> ${instpath}/config/NsCDE.conf
      echo '# HAS_WINDOWNAME for this installation to avoid workarounds.' >> ${instpath}/config/NsCDE.conf
      echo 'SetEnv HAS_WINDOWNAME 1' >> ${instpath}/config/NsCDE.conf

      # Patch NsCDE-FrontPanel.conf for "indicator 12 in"
      echo "Setting patched indicator with shadow in in NsCDE-FrontPanel.conf"
      ${instpath}/bin/ised -c 's/indicator 12,/indicator 12 in,' -f ${instpath}/config/NsCDE-FrontPanel.conf

      # Regenerate system NsCDE-Subpanels.conf with window name
      echo "Regenerating system NsCDE-Subpanels.conf"
      NSCDE_ROOT="${instpath}" HAS_WINDOWNAME=1 SYSMODE=1 ${instpath}/libexec/generate_subpanels > ${instpath}/config/NsCDE-Subpanels.conf

      echo "Done."
   fi

   if [ "$1" == "workarounds" ]; then
      echo "FVWM is marked as not patched for NsCDE. Enabling workarounds."

      # Try to compile XOverrideFontCursor.so
      echo "Trying to compile XOverrideFontCursor.so and put it in ${instpath}/lib for LD_PRELOAD"
      echo "You must have make tool, C compiler and libX11 development files (headers)"
      echo "installed for this to suceed."
      make -C ${instpath}NsCDE/src/XOverrideFontCursor
      retval=$?
      if (($retval > 0)); then
         echo "Compilation of XOverrideFontCursor.so failed. Some of the FvwmScript widgets"
         echo "will appear with XC_hand2 pointer cursor on mouse over. Fixable later ..."
      else
         echo "Done."
      fi

      # Patch NsCDE-FrontPanel.conf for Launcher Icon and PressIcon statements
      echo "Enabling alternative arrows on FrontPanel launchers in NsCDE-FrontPanel.conf"
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

