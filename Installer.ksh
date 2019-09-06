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
      if (($noninteractive == 1)); then
         echo "You must provide either -w or -f. If your installation of FVWM has been"
         echo "patched with \"FvwmButtons_sunkraise_windowname_unified.patch\" and with"
         echo "\"FvwmScript_XC_left_ptr.patch\", specify \"-f\" to the installer. If not,"
         echo "then specify \"-w\" for workarounds to be applied (see the docs)."
         exit 1
      else
         # Early detection of FVWM before check_dependencies is needed
         # for patch state detection of fvwm binary.
         whence -q fvwm
         if (($? > 0)); then
            echo "Error: cannot find fvwm binary. Install FVWM before continuing."
            exit 1
         fi
         # A nasty hack ...
         strings $(whence fvwm) | grep -q -- -NsCDE
         if (($? == 0)); then
            def_instmode="f"
            fvwm_patched=1
         else
            def_instmode="w"
            fvwm_patched=0
         fi

         echo ""
         echo "Please specify if this is installation for NsCDE patched version of the"
         echo "FVWM, or not. Depending on this answer, workarounds or some special"
         echo "configuration options will be enabled (or not) during this installation."
         echo ""
         echo "Type \"f\" for NsCDE installation with patched FVWM,"
         echo "or \"w\" for NsCDE installation with plain/non-patched FVWM."
         echo ""
         echo -ne "Simply press return for guessed default [${def_instmode}]: \c"

         read ans
         if [ "x$ans" == "x" ]; then
            true
         elif [ "x$ans" == "xf" ]; then
            fvwm_patched=1
         elif [ "x$ans" == "xw" ]; then
            fvwm_patched=0
         else
            echo "Error, answer not understood."
            exit 1
         fi
      fi
   fi

   check_dependencies

   if [ "x$instpath" == "x" ]; then
      if (($noninteractive == 1)); then
         instpath="/opt/NsCDE"
      else
         echo -ne "Installation firectory for NsCDE [/opt/NsCDE]: \c"
         read ans
         if [ "x$ans" == "x" ]; then
            instpath="/opt/NsCDE"
         else
            instpath="$ans"
         fi
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
            echo -ne "Do you want to continue with copying NsCDE installation into ${instpath}? (y|n)[n] \c"
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
      photospopulated=$(ls -1 "${instpath}/share/photos" | wc -l)
      if (($photospopulated < 1)); then
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
         if (($upgrade_mode == 0)); then
            echo "Info: Additional collection of VUE palettes and backdrops not installed in ${instpath}/share/{palettes,backdrops}"
            echo "See: https://github.com/NsCDE/NsCDE-VUE/releases/download/1.0/NsCDE-VUE-1.0.tar.gz"
         fi
      fi
   fi

   if (($fvwm_patched == 1)); then
      configure_installed patched
   else
      configure_installed workarounds
   fi
}

function configure_installed
{
   OS_PLUS_MACHINE_ARCH=$(uname -sm | tr ' ' '_')

   if [ "$1" == "patched" ]; then
      # Uncomment HAS_WINDOWNAME in NsCDE.conf
      echo "Enabling HAS_WINDOWNAME variable in ${instpath}/config/NsCDE.conf"
      echo '# Since FVWM has been compiled with NsCDE patches, we are enabling' >> ${instpath}/config/NsCDE.conf
      echo '# HAS_WINDOWNAME for this installation to avoid workarounds.' >> ${instpath}/config/NsCDE.conf
      echo 'SetEnv HAS_WINDOWNAME 1' >> ${instpath}/config/NsCDE.conf

      # Patch NsCDE-FrontPanel.conf for "indicator 12 in"
      echo "Setting patched indicator with shadow in in NsCDE-FrontPanel.conf"
      ./NsCDE/bin/ised -c 's/indicator 12,/indicator 12 in,/g' -f "${instpath}/config/NsCDE-FrontPanel.conf"

      # Regenerate system NsCDE-Subpanels.conf with window name
      echo "Regenerating system NsCDE-Subpanels.conf"
      NSCDE_ROOT="${instpath}" HAS_WINDOWNAME=1 SYSMODE=1 ${instpath}/libexec/generate_subpanels > ${instpath}/config/NsCDE-Subpanels.conf

      echo "Done."
   fi

   if [ "$1" == "workarounds" ]; then
      echo "FVWM is marked as not patched for NsCDE. Enabling workarounds."

      # Try to find suitable XOverrideFontCursor.so in our src dir.
      if [ -r "src/XOverrideFontCursor/XOverrideFontCursor.so.${OS_PLUS_MACHINE_ARCH}" ]; then
         echo "Copying XOverrideFontCursor.so.${OS_PLUS_MACHINE_ARCH} as ${instpath}/lib/XOverrideFontCursor.so"
         cp -f "src/XOverrideFontCursor/XOverrideFontCursor.so.${OS_PLUS_MACHINE_ARCH}" "${instpath}/lib/XOverrideFontCursor.so"
         chmod 0755 "${instpath}/lib/XOverrideFontCursor.so"
         echo "Done"
      else
         # Try to compile XOverrideFontCursor.so
         echo "Trying to compile XOverrideFontCursor.so and put it in ${instpath}/lib for LD_PRELOAD"
         echo "You must have make tool, C compiler and libX11 development files (headers)"
         echo "installed for this to suceed."
         make -C src/XOverrideFontCursor
         retval=$?
         if (($retval > 0)); then
            echo "Compilation of XOverrideFontCursor.so failed. Some of the FvwmScript widgets"
            echo "will appear with XC_hand2 pointer cursor on mouse over. Fixable later ..."
         else
            echo "Copying XOverrideFontCursor.so as ${instpath}/lib/XOverrideFontCursor.so"
            if [ -f "src/XOverrideFontCursor/XOverrideFontCursor.so" ]; then
               cp -f "src/XOverrideFontCursor/XOverrideFontCursor.so" "${instpath}/lib/XOverrideFontCursor.so"
               chmod 0755 "${instpath}/lib/XOverrideFontCursor.so"
               echo "Done."
            else
               echo "Error: Cannot copy or find XOverrideFontCursor.so in src/XOverrideFontCursor/"
            fi
         fi
      fi

      # Replace NsCDE-FrontPanel.conf for Launcher Icon and PressIcon statements
      echo "Enabling alternative arrows on FrontPanel launchers in NsCDE-FrontPanel.conf"
      ./NsCDE/bin/ised -c 's/ indicator 12,//g' -f "${instpath}/config/NsCDE-FrontPanel.conf"
      ./NsCDE/bin/ised -c 's/\*FrontPanel: \(.*x.*\), Id NsCDE-Subpanel\(.*\), Frame 1, PressColorset 27, \\/\*FrontPanel: \1, Id NsCDE-Subpanel\2, Frame 1, PressColorset 27, \\\n  Icon NsCDE\/FPSubArrowUp.xpm, PressIcon NsCDE\/FPSubArrowDown.xpm, \\/g' -f "${instpath}/config/NsCDE-FrontPanel.conf"
      retval=$?
      if (($retval != 0)); then
         echo "Error $retval occured."
      else
         echo "Done."
      fi
   fi

   # Handle pclock
   if [ -f "src/pclock-0.13.1/pclock-bin.${OS_PLUS_MACHINE_ARCH}" ]; then
      echo "Installing appropriate Front Panel Clock for this system and arch."
      cp -f src/pclock-0.13.1/pclock-bin.${OS_PLUS_MACHINE_ARCH} "${instpath}/bin/fpclock-${OS_PLUS_MACHINE_ARCH}"
      retval=$?
      if (($retval > 0)); then
         echo "Error $retval occured while installing src/pclock-0.13.1/pclock-bin.${OS_PLUS_MACHINE_ARCH}"
      else
         echo "Done."
      fi
   else
      echo "No suitable binary found for Front Panel Clock."
      if (($noninteractive == 0)); then
         echo "Do you want to try compiling Front Panel Clock from source?"
         echo -ne "C compiler, X11, Xext, xcb and Xpm development are needed for this. [y] \c"
         read ans
         if [ "x$ans" != "x" ] || [ "x$ans" == "xy" ]; then
            compile_pclock=1
         else
            compile_pclock=0
         fi
      else
         echo "Trying to compile one from source. C compiler, X11, Xext, xcb and Xpm development are needed for this."
         compile_pclock=1
      fi
      if (($compile_pclock == 1)); then
         make -C src/pclock-0.13.1/src
         retval=$?
         if (($retval > 0)); then
            echo "Error ocurred while trying to compile Front Panel Clock. Try to fix this manually."
         else
            echo "Installing newly compiled Front Panel Clock for this system and arch."
            cp -f src/pclock-0.13.1/src/pclock "${instpath}/bin/fpclock-${OS_PLUS_MACHINE_ARCH}"
            retval=$?
            if (($retval > 0)); then
               echo "Error $retval occured while installing src/pclock-0.13.1/pclock-bin.${OS_PLUS_MACHINE_ARCH}"
            else
               echo "Done."
            fi
         fi
      else
         echo "Front Panel Clock compilation skipped."
         echo "If there is \"pclock\" binary in PATH, an attempt to use"
         echo "it will be made (pkg install pclock on FreeBSD for example)."
      fi
   fi

   # Install xsession file nscde.desktop
   if (($noninteractive == 0)); then
      echo "Do you want to install \"nscde.desktop\" X Session Launcher for your"
      echo -ne "graphical display manager to choose it during log in time? (y/n)[y] \c"
      read ans
      if [ "x$ans" == "x" ] || [ "x$ans" == "xy" ]; then
         if [ -d "/usr/share/xsessions" ]; then
            xsess_dir="/usr/share/xsessions"
         elif [ -d "/usr/local/share/xsessions" ]; then
            xsess_dir="/usr/local/share/xsessions"
         else
            xsess_dir=""
         fi

         echo -ne "Where is your xsessions directory? [${xsess_dir}] \c"
         read xans
         if [ "x$xans" == "x" ]; then
            cp -f "${instpath}/share/doc/examples/xsession-integration/nscde.desktop" "${xsess_dir}/"
            retval=$?
            if (($retval > 0)); then
               echo "Error occured while trying to copy"
               echo "${instpath}/share/doc/examples/xsession-integration/nscde.desktop"
               echo "into ${xsess_dir}/"
            else
               echo "Done."
            fi
         else
            cp -f "${instpath}/share/doc/examples/xsession-integration/nscde.desktop" "${xans}/"
            retval=$?
            if (($retval > 0)); then
               echo "Error occured while trying to copy"
               echo "${instpath}/share/doc/examples/xsession-integration/nscde.desktop"
               echo "into ${xans}/"
            else
               echo "Done."
            fi
         fi
      else
         echo "Skipping xsession nscde.desktop file installation."
      fi
   else
      if [ -d "/usr/share/xsessions" ]; then
         xsess_dir="/usr/share/xsessions"
         xsession_inst=1
      elif [ -d "/usr/local/share/xsessions" ]; then
         xsess_dir="/usr/local/share/xsessions"
         xsession_inst=1
      else
         echo "Error: Cannot locate xsessions directory in /usr/share and /usr/local/share"
         echo "Enable NsCDE X Session startup manually in your X Display Manager configuration"
         xsession_inst=0
      fi

      if (($xsession_inst > 0)); then
         echo "Installing xsession file nscde.desktop into ${xsess_dir}."
         cp -f "${instpath}/share/doc/examples/xsession-integration/nscde.desktop" "${xsess_dir}/"
         retval=$?
         if (($retval > 0)); then
            echo "Error occured while trying to copy"
            echo "${instpath}/share/doc/examples/xsession-integration/nscde.desktop"
            echo "into ${xsess_dir}/"
         else
            echo "Done."
         fi
      fi
   fi
}

function upgrade_nscde
{
   # Prevent deinstall_nscde from running in noninteractive mode
   # before patched/non-patched state is known to us.
   if [ -z $fvwm_patched ]; then
      if (($noninteractive == 1)); then
         echo "You must provide either -w or -f. If your installation of FVWM has been"
         echo "patched with \"FvwmButtons_sunkraise_windowname_unified.patch\" and with"
         echo "\"FvwmScript_XC_left_ptr.patch\", specify \"-f\" to the installer. If not,"
         echo "then specify \"-w\" for workarounds to be applied (see the docs)."
         exit 1
      fi
   fi

   if [ "x$instpath" == "x" ]; then
      # Try default
      if [ -d "/opt/NsCDE" ]; then
         instpath="/opt/NsCDE"
      else
         echo "Default path /opt/NsCDE not found. You must specify where"
         echo "the installation of NsCDE resides (-p <nscdepath> before -u)"
         exit 10
      fi
   fi

   # Backup photos and VUE if exists, unpack new, put photos and VUE back
   old_photos=$(ls "${instpath}/share/photos")
   old_backdrops=$(ls "${instpath}/share/backdrops")
   old_palettes=$(ls "${instpath}/share/palettes")

   get_back=$(pwd)

   phcnt=0
   for ph in $old_photos
   do
      if [ ! -r "NsCDE/share/photos/$ph" ]; then
         ((phcnt = phcnt + 1))
         photo_savelist="$photo_savelist $ph"
      fi
   done
   if (($phcnt > 0)); then
      cd "${instpath}/share/photos" && tar cpf /tmp/_nscde_photo_savelist.tar $photo_savelist
      cd ${get_back}
   fi

   palcnt=0
   for pal in $old_palettes
   do
      if [ ! -r "NsCDE/share/palettes/$pal" ]; then
         ((palcnt = palcnt + 1))
         palette_savelist="$palette_savelist $pal"
      fi
   done
   if (($palcnt > 0)); then
      cd "${instpath}/share/palettes" && tar cpf /tmp/_nscde_palette_savelist.tar $palette_savelist
      cd ${get_back}
   fi

   bdrcnt=0
   for bdr in $old_backdrops
   do
      if [ ! -r "NsCDE/share/backdrops/$bdr" ]; then
         ((bdrcnt = bdrcnt + 1))
         backdrop_savelist="$backdrop_savelist $bdr"
      fi
   done
   if (($bdrcnt > 0)); then
      cd "${instpath}/share/backdrops" && tar cpf /tmp/_nscde_backdrop_savelist.tar $backdrop_savelist
      cd ${get_back}
   fi

   deinstall_nscde

   install_nscde

   if (($phcnt > 0)); then
      echo "Restoring additional photos back in ${instpath}/share/photos ..."
      cd "${instpath}/share/photos" && tar xpf /tmp/_nscde_photo_savelist.tar && rm -f /tmp/_nscde_photo_savelist.tar
      echo "Done."
   fi

   if (($palcnt > 0)); then
      echo "Restoring additional palettes back in ${instpath}/share/palettes ..."
      cd "${instpath}/share/palettes" && tar xpf /tmp/_nscde_palette_savelist.tar && rm -f /tmp/_nscde_palette_savelist.tar
      echo "Done."
   fi

   if (($bdrcnt > 0)); then
      echo "Restoring additional backdrops back in ${instpath}/share/backdrops ..."
      cd "${instpath}/share/backdrops" && tar xpf /tmp/_nscde_backdrop_savelist.tar && rm -f /tmp/_nscde_backdrop_savelist.tar
      echo "Done."
   fi
}

function deinstall_nscde
{
   # Question, or noninteractive, rm -rf ... careful.
   if [ "x$instpath" == "x" ]; then
      # Try default
      if [ -d "/opt/NsCDE" ]; then
         instpath="/opt/NsCDE"
      else
         echo "Default path /opt/NsCDE not found. You must specify where"
         echo "the installation of NsCDE resides (-p <nscdepath> before -d)"
         exit 10
      fi
   fi

   echo "Removing $instpath"

   sanity1=$(ls -1 "${instpath}/config/" | wc -l)
   sanity2=$(ls -1d ${instpath}/{bin,config,lib,libexec,share} > /dev/null 2>&1; echo $?)
   sanity3=$(${instpath}/bin/nscde -V | grep -q "NsCDE Version"; echo $?)

   if (($sanity1 > 10)) && ((sanity2 + sanity3 == 0)); then
      if (($noninteractive == 1)); then
         rm -rf "$instpath"
         retval=$?
         if (($retval == 0)); then
            echo "Done."
         else
            echo "Removal of $instpath retuned $retval exit status."
         fi
      else
         if (($upgrade_mode == 0)); then
            echo -ne "Do you want to completely remove ${instpath}? [n] \c"
            def_ans="n"
         else
            echo -ne "Do you want to completely remove ${instpath}? [y] \c"
            def_ans="y"
         fi
         read ans
         if [ "x$ans" == "x" ]; then
            ans="$def_ans"
         fi
         if [ "x$ans" == "xy" ]; then
            rm -rf "$instpath"
            retval=$?
            if (($retval == 0)); then
               echo "Done."
            else
               echo "Removal of $instpath retuned $retval exit status."
            fi
         else
            echo "Removal of $instpath skipped."
         fi
      fi

      for xdskfile in /usr/share/xsessions/nscde.desktop /usr/local/share/xsessions/nscde.desktop
      do
         if [ -r "$xdskfile" ]; then
            echo "Removing X Display Manager file"
            if (($noninteractive == 1)); then
               rm -f $xdskfile
               echo "Done."
            else
               if (($upgrade_mode == 0)); then
                  echo -ne "Do you want to completely remove ${xdskfile}? [n] \c"
                  def_ans="n"
               else
                  echo -ne "Do you want to completely remove ${xdskfile}? [y] \c"
                  def_ans="y"
               fi
               read ans
               if [ "x$ans" == "x" ]; then
                  ans="$def_ans"
               fi
               if [ "x$ans" == "xy" ]; then
                  rm -f "$xdskfile"
               else
                  echo "Removal of $xdskfile skipped."
               fi
            fi
         fi
      done
   else
      echo "One or more sanity checks before deleting $instpath and xsessions file has failed."
      echo "Check that NsCDE path given to the -p was really top directory of the NsCDE"
      echo "installation. If things are half deleted and hence non-checkable by this script"
      echo "you should manually deinstall NsCDE by deleting installation path and X session"
      echo "file nscde.desktop from /usr/share/xsessions or /usr/local/share/xsessions."
      exit 12
   fi
}

function usage
{
   echo "Usage: ${0##*/} [-i|-u|-d] [-p] [-w] [-f] [-P] [-V] [-X]"
}

while getopts iucdp:wfP:V:X:nh Option
do
   case $Option in
   i)
      upgrade_mode=0
      install_nscde
   ;;
   u)
      upgrade_mode=1
      upgrade_nscde
   ;;
   c)
      check_dependencies
   ;;
   d)
      upgrade_mode=0
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
      xsess_dir="$OPTARG"
   ;;
   n)
      noninteractive=1
   ;;
   h)
      usage
   ;;
   esac
done

