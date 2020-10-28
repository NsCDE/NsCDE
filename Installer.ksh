#!/bin/ksh

noninteractive=0
noexitatdepfail=0

OS=$(uname -s)

function dep_exit
{
   if (($noexitatdepfail == 0)); then
      exit $1
   fi
}

function check_dependencies
{
   # Python 3, ImageMagick, xdotool, yaml, PyQt, ksh (obviously) etc etc ...
   whence -q python3
   if (($? > 0)); then
      echo "Cannot find python3 as a named command. This is needed for NsCDE"
      echo "If you have python3 installed with some other name (for example \"python\""
      echo "or \"python34\", \"python3.6\" ... you should make symlink on it"
      echo "anywhere in your PATH."
      echo ""
      echo "For example (FreeBSD 12 example):"
      echo "ln -s /usr/local/bin/python3.6 /usr/local/bin/python3"
      echo ""
      echo "Python is referenced with \"#!/usr/bin/env python3\" in NsCDE Python"
      echo "parts since plain \"python\" command might refer to Python 2.X on"
      echo "older systems, and minor revision in Python 3 differs across systems."
      echo ""
      dep_exit 20
   fi

   for exe in convert cpp xrdb xset xrefresh xprop xdpyinfo xterm python3 gettext
   do
      whence -q $exe
      retval=$?
      if (($retval > 0)); then
         echo ""
         echo "Error: Command or program \"$exe\" as NsCDE dependency is missing"
         echo "on this system."
         echo ""
         dep_exit 20
      fi
   done

   # GNU sed on FreeBSD and Solaris."
   if [ "$OS" == "FreeBSD" ] || [ "$OS" == "SunOS" ]; then
      whence -q gsed
      retval=$?
      if (($retval > 0)); then
         echo ""
         echo "Error: Command or program \"$gexe\" as NsCDE dependency is missing"
         echo "on this system. On FreeBSD: \"pkg install gsed\"."
         echo ""
         dep_exit 20
      fi
   fi

   # Dependency only if fvwm_patched=0
   if (($fvwm_patched == 0)); then
      whence -q xdotool
      retval=$?
      if (($retval > 0)); then
         echo ""
         echo "Error: Program \"xdotool\" as NsCDE dependency (on unpatched FVWM)"
         echo "is missing on this system."
         echo ""
         dep_exit 20
      fi
   fi

   for oexe in xscreensaver stalonetray xsettingsd xrandr dunst
   do
      whence -q $oexe
      retval=$?
      if (($retval > 0)); then
         echo ""
         echo "Warning: Optional command or program \"$oexe\" as NsCDE dependency"
         echo "is missing on this system."
         echo ""
         sleep 3
      fi
   done

   if [ ! -f "/usr/share/icons/hicolor/index.theme" ]; then
      if [ ! -f "/usr/local/share/icons/hicolor/index.theme" ]; then
         echo ""
         echo "Warning: Optional dependency hicolor theme index not found in"
         echo "path /usr/share/icons and/or /usr/local/share/icons."
         echo "Expect missing icons in Workspace Menu and Subpanel Manager,"
         echo "or install hicolor icon theme package for your system."
         echo ""
         sleep 2
      fi
   fi

   for pymodule in yaml PyQt5 xdg os re shutil subprocess sys \
       fnmatch getopt time platform psutil pwd socket
   do
      python3 -c "import $pymodule"
      retval=$?
      if (($retval > 0)); then
         if [ "$pymodule" == "PyQt5" ]; then
            echo "Import of PyQt5 failed. Trying PyQt4 ..."
            python3 -c "import PyQt4"
            qtretval=$?
            if (($qtretval > 0)); then
               echo "Error: cannot find Python 3 module PyQt5 nor PyQt4. Import failed."
               dep_exit 20
            else
               echo "Import of PyQt4 suceeded. Continuing."
               continue
            fi
         fi
         echo "Error: cannot find Python 3 module ${pymodule}. Import failed."
         dep_exit 20
      fi
   done
}

function install_nscde
{
   if (($upgrade_mode == 0)); then
      echo ""
      echo "*************************************************************************"
      echo "*                                                                       *"
      echo "*  Starting Installer.ksh for Not So Common Desktop Environment (NsCDE) *"
      echo "*                                                                       *"
      echo "*  Installation procedure in progress ...                               *"
      echo "*                                                                       *"
      echo "*************************************************************************"
      echo ""
   fi

   if ((noninteractive == 0)); then
      sleep 2
   fi

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

   # Upgrade checks dependencies on it's own.
   if (($upgrade_mode != 1)); then
      check_dependencies
   fi

   if [ "x$instpath" == "x" ]; then
      if (($noninteractive == 1)); then
            if [ "x$destdir" == "x" ]; then
               instpath="/opt/NsCDE"
               realinstpath="${instpath}"
            else
               instpath="${destdir}/opt/NsCDE"
               realinstpath="/opt/NsCDE"
            fi
      else
         echo -ne "Installation directory for NsCDE [/opt/NsCDE]: \c"
         read ans
         if [ "x$ans" == "x" ]; then
            instpath="/opt/NsCDE"
            realinstpath="${instpath}"
         else
            instpath="$ans"
            realinstpath="${instpath}"
         fi
      fi
   else
      if [ "x$destdir" != "x" ]; then
         realinstpath="${instpath}"
         instpath="${destdir}/${instpath}"
      else
         realinstpath="${instpath}"
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
            echo ""
            echo "Exiting with status 2."
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
      cp -rpf NsCDE/{bin,config,lib,libexec,share} "${instpath}/"
      retval="$?"
      if (($retval == 0)); then
         echo "Done."
      else
         echo "Error $retval occured while copying NsCDE distribution files into $instpath"
      fi
      if [ "${realinstpath%*/}" != "/opt/NsCDE" ]; then
         echo "Adapting NSCDE_ROOT path for custom installation."
         ./NsCDE/bin/ised -c "s@export NSCDE_ROOT=/opt/NsCDE@export NSCDE_ROOT=${realinstpath%*/}@g" -f "${instpath}/bin/nscde"
         ./NsCDE/bin/ised -c "s@SetEnv NSCDE_ROOT /opt/NsCDE@SetEnv NSCDE_ROOT ${realinstpath%*/}@g" -f "${instpath}/config/NsCDE-Main.conf"
         echo "Adaptation done."
      fi
   else
      echo "Directory $instpath does not exist after attempting to create it. Exiting."
      exit 3
   fi

   if [ "x$photopath" != "x" ]; then
      echo "Copying additional photo collection from $photopath as ${instpath}/share/photos"
      if [ -d "$photopath" ]; then
         mkdir -p "${instpath}/share/photos"
         cp -rf "$photopath"/*.png ${instpath}/share/photos/
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
         photospopulated=0
      else
         photospopulated=$(ls -1 "${instpath}/share/photos" 2>&1 | wc -l)
      fi
      if (($photospopulated < 1)) && [ -z $phcnt ]; then
         echo "Info: Additional photo collection not installed in ${instpath}/share/photos"
         echo "See: https://github.com/NsCDE/NsCDE-photos/releases/download/1.0/NsCDE-Photos-1.0.tar.gz"
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

   # Handle colorpicker
   if [ -f "src/colorpicker/colorpicker-bin.${OS_PLUS_MACHINE_ARCH}" ]; then
      echo "Installing appropriate color picker for this system and arch."
      cp -f src/colorpicker/colorpicker-bin.${OS_PLUS_MACHINE_ARCH} "${instpath}/bin/colorpicker-${OS_PLUS_MACHINE_ARCH}"
      retval=$?
      if (($retval > 0)); then
         echo "Error $retval occured while installing src/colorpicker/colorpicker-bin.${OS_PLUS_MACHINE_ARCH}"
      else
         echo "Done."
      fi
   else
      echo "No suitable binary found for color picker."
      if (($noninteractive == 0)); then
         echo "Do you want to try compiling color picker from source?"
         echo -ne "C compiler, X11, and xcb development are needed for this. [y] \c"
         read ans
         if [ "x$ans" != "x" ] || [ "x$ans" == "xy" ]; then
            compile_colorpicker=1
         else
            compile_colorpicker=0
         fi
      else
         echo "Trying to compile one from source. C compiler, X11, and xcb development are needed for this."
         compile_colorpicker=1
      fi
      if (($compile_colorpicker == 1)); then
         make -C src/colorpicker
         retval=$?
         if (($retval > 0)); then
            echo "Error ocurred while trying to compile colorpicker. Try to fix this manually."
         else
            echo "Installing newly compiled colorpicker for this system and arch."
            cp -f src/colorpicker/colorpicker "${instpath}/bin/colorpicker-${OS_PLUS_MACHINE_ARCH}"
            retval=$?
            if (($retval > 0)); then
               echo "Error $retval occured while installing src/colorpicker/colorpicker-bin.${OS_PLUS_MACHINE_ARCH}"
            else
               echo "Done."
            fi
         fi
      else
         echo "Color picker compilation skipped."
         echo "Not essential, needed only for ColorMgr grab color function."
      fi
   fi

   # Install symlink for freedesktop standard theme (GTK, QT ...)
   if (($noninteractive == 0)); then
      # Set default icon theme link path
      if [ "$icons_dirlink" == "" ]; then
         icons_dirlink="/usr/local/share/icons/NsCDE"
      fi
      echo "Do you want to create symbolic link for freedesktop standard icons which"
      echo "will be used in GTK, QT and possibly other GUI toolkit based programs"
      echo "in the local path of system icon search path?"
      echo "It is not advisable to skip this step, because icon theme will not be"
      echo "available for use. Defaults to ${icons_dirlink}."
      echo "Type y/n, or filesystem path where you want symlink to be created."
      echo -ne "or just press enter for a default symlink creation: \c"
      read ans
      if [ "x$ans" == "x" ]; then
         ans="y"
      fi
      case $ans in
      'Y'|'y')
         mkdir -p "${icons_dirlink%/*}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: making directory ${icons_dirlink%/*} failed with exit status $retval"
            exit 15
         fi

         ln -sf "${instpath}/share/icons/freedesktop/theme/NsCDE" "${icons_dirlink}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: symlinking ${instpath}/share/icons/freedesktop/theme/NsCDE"
            echo "to ${icons_dirlink} failed with exit status $retval"
            exit 15
         fi
      ;;
      'N'|'n')
         echo "Skipping icon theme symlink creation in $icons_dirlink"
      ;;
      *)
         mkdir -p "${ans%/*}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: making directory ${ans%/*} failed with exit status $retval"
            exit 15
         fi
         ln -sf "${instpath}/share/icons/freedesktop/theme/NsCDE" "${ans}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: symlinking ${instpath}/share/icons/freedesktop/theme/NsCDE"
            echo "to ${ans} failed with exit status $retval"
            exit 15
         fi
      ;;
      esac
   else
      # Set default icon theme link path
      if [ "$icons_dirlink" == "" ]; then
         if [ "x$destdir" == "x" ]; then
            icons_dirlink="/usr/local/share/icons/NsCDE"
         else
            icons_dirlink="${destdir}/usr/local/share/icons/NsCDE"
         fi
      fi

      # Set magic no-install pseudopath and if not found, continue
      if [ "$icons_dirlink" != "nowhere" ]; then
         mkdir -p "${icons_dirlink%/*}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: making directory ${icons_dirlink%/*} failed with exit status $retval"
            exit 15
         fi

         ln -sf "${realinstpath}/share/icons/freedesktop/theme/NsCDE" "${icons_dirlink}"
         retval=$?
         if (($retval != 0)); then
            echo "Error: symlinking ${realinstpath}/share/icons/freedesktop/theme/NsCDE"
            echo "to ${icons_dirlink} failed with exit status $retval"
            exit 15
         fi
      fi
   fi

   # Install xsession file nscde.desktop
   if (($noninteractive == 0)); then
      echo "Do you want to install \"nscde.desktop\" X Session Launcher for your"
      echo -ne "graphical display manager to choose it during log in time? (y/n)[y] \c"
      read ans
      if [ "x$ans" == "x" ] || [ "x$ans" == "xy" ]; then
         # Not set with -X
         if [ -z $xsess_dir ]; then
            if [ -d "/usr/share/xsessions" ]; then
               xsess_dir="/usr/share/xsessions"
            elif [ -d "/usr/local/share/xsessions" ]; then
               xsess_dir="/usr/local/share/xsessions"
            else
               xsess_dir=""
            fi
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
               if [ "${instpath%*/}" != "/opt/NsCDE" ]; then
                  echo "Adapting Exec line in nscde.desktop ..."
                  ./NsCDE/bin/ised -c "s@Exec=/opt/NsCDE/bin/nscde@Exec=${instpath}/bin/nscde@g" -f \
                  "${xsess_dir}/nscde.desktop"
                  retval=$?
                  if (($retval > 0)); then
                     echo "Error $retval occured while adapting nscde.desktop file."
                  else
                     echo "Adapting nscde.desktop done."
                  fi
               fi
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
               if [ "${instpath%*/}" != "/opt/NsCDE" ]; then
                  echo "Adapting Exec line in nscde.desktop ..."
                  ./NsCDE/bin/ised -c "s@Exec=/opt/NsCDE/bin/nscde@Exec=${instpath}/bin/nscde@g" -f \
                  "${xans}/nscde.desktop"
                  retval=$?
                  if (($retval > 0)); then
                     echo "Error $retval occured while adapting nscde.desktop file."
                  else
                     echo "Adapting nscde.desktop done."
                  fi
               fi
               echo "Done."
            fi
         fi
      else
         echo "Skipping xsession nscde.desktop file installation."
      fi
   else
      # Not set with -X
      if [ -z $xsess_dir ]; then
         if [ -d "/usr/share/xsessions" ]; then
            if [ "x${destdir}" == "x" ]; then
               xsess_dir="/usr/share/xsessions"
            else
               xsess_dir="${destdir}//usr/share/xsessions"
               mkdir -p "${xsess_dir}"
            fi
            xsession_inst=1
         elif [ -d "/usr/local/share/xsessions" ]; then
            if [ "x${destdir}" == "x" ]; then
               xsess_dir="/usr/local/share/xsessions"
            else
               xsess_dir="${destdir}//usr/local/share/xsessions"
               mkdir -p "${xsess_dir}"
            fi
            xsession_inst=1
         else
            echo "Error: Cannot locate xsessions directory in /usr/share and /usr/local/share"
            echo "Enable NsCDE X Session startup manually in your X Display Manager configuration"
            xsession_inst=0
         fi
      else
         if [ "x${destdir}" == "x" ]; then
            if [ -d "$xsess_dir" ]; then
               xsession_inst=1
            else
               echo "Error: X Display Session directory $xsess_dir provided with -X does not exist."
               echo "Skipping nscde.desktop installation."
            fi
         else
               real_xsess_dir="${xsess_dir}"
               xsess_dir="${destdir}/${xsess_dir}"
               mkdir -p "${xsess_dir}"
               xsession_inst=1
         fi
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
            if [ "${realinstpath%*/}" != "/opt/NsCDE" ]; then
               echo "Adapting Exec line in nscde.desktop ..."
               ./NsCDE/bin/ised -c "s@Exec=/opt/NsCDE/bin/nscde@Exec=${realinstpath}/bin/nscde@g" -f \
               "${xsess_dir}/nscde.desktop"
               retval=$?
               if (($retval > 0)); then
                  echo "Error $retval occured while adapting nscde.desktop file."
               else
                  echo "Adapting nscde.desktop done."
               fi
            fi
            echo "Done."
         fi
      fi

      if (($upgrade_mode == 0)); then
         echo ""
         echo "For a reboot/poweroff, suspend and hibernate functionality of the"
         echo "System Action Dialog, you should have \"sudo\" installed and configured"
         echo "for user to launch ${realinstpath}/libexec/nscde-acpi script."
         echo ""
         echo "See ${realinstpath}/share/doc/examples/sudo/006_PowerManager for the"
         echo "example which needs to be edited for existing user(s) and put"
         echo "into /etc/sudoers.d/ on modern systems with a newer sudo package"
         echo "Option requiretty should also be set to false. See sudo(8)."
         echo ""
      fi
   fi
}

function upgrade_nscde
{
   if (($upgrade_mode == 1)); then
      echo ""
      echo "*************************************************************************"
      echo "*                                                                       *"
      echo "*  Starting Installer.ksh for Not So Common Desktop Environment (NsCDE) *"
      echo "*                                                                       *"
      echo "*  Upgrade/Reinstall procedure in progress ...                          *"
      echo "*                                                                       *"
      echo "*************************************************************************"
      echo ""
   fi

   if ((noninteractive == 0)); then
      sleep 2
   fi

   check_dependencies

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

   # Backup photos, backdrops and palettes, put it back if there was something
   # customized
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
      echo "Backing up photos not found in the new installation for later restore."
      cd "${instpath}/share/photos" && tar cpf /tmp/_nscde_photo_savelist.tar $photo_savelist
      retval=$?
      if (($retval > 0)); then
         echo "Archive (tar) process for ${instpath}/share/photos to /tmp/_nscde_photo_savelist.tar"
         echo "exited with status $retval"
         exit 14
      else
         echo "Backing up custom photos: done."
      fi
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
      retval=$?
      if (($retval > 0)); then
         echo "Archive (tar) process for ${instpath}/share/palettes to /tmp/_nscde_palette_savelist.tar"
         echo "exited with status $retval"
         exit 14
      else
         echo "Backing up custom palettes: done."
      fi
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
      if (($retval > 0)); then
         echo "Archive (tar) process for ${instpath}/share/backdrops to /tmp/_nscde_backdrop_savelist.tar"
         echo "exited with status $retval"
         exit 14
      else
         echo "Backing up custom backdrops: done."
      fi
      cd ${get_back}
   fi

   deinstall_nscde

   install_nscde

   if (($phcnt > 0)); then
      echo "Restoring additional photos back in ${instpath}/share/photos ..."
      mkdir -p "${instpath}/share/photos"
      cd "${instpath}/share/photos" && tar xpf /tmp/_nscde_photo_savelist.tar && rm -f /tmp/_nscde_photo_savelist.tar
      echo "Done."
   fi

   if (($palcnt > 0)); then
      echo "Restoring additional palettes back in ${instpath}/share/palettes ..."
      mkdir -p "${instpath}/share/palettes"
      cd "${instpath}/share/palettes" && tar xpf /tmp/_nscde_palette_savelist.tar && rm -f /tmp/_nscde_palette_savelist.tar
      echo "Done."
   fi

   if (($bdrcnt > 0)); then
      echo "Restoring additional backdrops back in ${instpath}/share/backdrops ..."
      mkdir -p "${instpath}/share/backdrops"
      cd "${instpath}/share/backdrops" && tar xpf /tmp/_nscde_backdrop_savelist.tar && rm -f /tmp/_nscde_backdrop_savelist.tar
      echo "Done."
   fi
}

function deinstall_nscde
{
   if (($upgrade_mode == 0)); then
      echo ""
      echo "*************************************************************************"
      echo "*                                                                       *"
      echo "*  Starting Installer.ksh for Not So Common Desktop Environment (NsCDE) *"
      echo "*                                                                       *"
      echo "*  Deinstallation procedure in progress ...                             *"
      echo "*                                                                       *"
      echo "*************************************************************************"
      echo ""
   fi

   if ((noninteractive == 0)); then
      sleep 2
   fi

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

   if (($upgrade_mode == 0)); then
      echo "Removing $instpath"
   else
      echo "Removing from old $instpath"
   fi

   sanity1=$(ls -1 "${instpath}/config/" 2>/dev/null | wc -l)
   sanity2=$(ls -1d ${instpath}/{bin,config,lib,libexec,share} > /dev/null 2>&1; echo $?)
   sanity3=$(${instpath}/bin/nscde -V 2>/dev/null | grep -q "NsCDE Version"; echo $?)

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
            echo -ne "Do you want to remove old ${instpath} (will preserve addons)? [y] \c"
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
                  echo -ne "Do you want to remove old ${xdskfile}? [y] \c"
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

      # Set default icon theme link path
      if [ "$icons_dirlink" == "" ]; then
         icons_dirlink="/usr/local/share/icons/NsCDE"
      fi

      # Remove icon theme symlink if found on default or given path
      if [ -L "$icons_dirlink" ]; then
         rm -f "$icons_dirlink"
      fi

   else
      echo ""
      echo "Error: One or more sanity checks for deleting NsCDE installation has failed."
      echo ""
      echo "Check that NsCDE path given to the -p was really top directory of the NsCDE"
      echo "installation. If things are half deleted and hence non-checkable by this script"
      echo "you should manually deinstall NsCDE by deleting installation path and X session"
      echo "file nscde.desktop from /usr/share/xsessions or /usr/local/share/xsessions."
      exit 12
   fi
}

function usage
{
   echo "Usage: ./Installer.ksh [ -f | -w ] [ -h ] [ -n ] [ -C ] [ -p <path> ] [ -D <destdir> ]"
   echo "       [ -P <path> ] [ -V <path> ] [ -X <path> ] [ -I <path> ] [ -i | -u | -d ]"
   echo ""
   echo ""
   echo "* Installation and Upgrade/Reinstall Mode:"
   echo ""
   echo "First option should be \"-f\" or \"-w\" (exclusive):"
   echo "   -f   if local FVWM installation is patched with NsCDE patches"
   echo "   -w   if local FVWM installation is plain, non-patched. Workarounds will apply."
   echo ""
   echo "Additional options for installation are:"
   echo "   -n   fully automatic, non-interactive mode"
   echo "   -C   dependencies check failures will be non-fatal, except for Korn Shell obviously."
   echo "   -D <dest>   destination for staged installation. Used for packaging mainly."
   echo "   -p <path>   filesystem path where NsCDE should be installed. Defaults to /opt/NsCDE."
   echo "   -P <path>   where to look for wallpapers for installing into <instpath>/share/photos."
   echo "   -X <path>   where to put nscde.desktop xsession. Defaults to /usr/share/xsessions."
   echo "   -I <path>   where to put freedesktop icons directory symlink. Defaults to"
   echo "               /usr/local/share/icons. Special path \"nowhere\" means omit symlink creation."
   echo ""
   echo "Last option:"
   echo "   -i tells installer to install NsCDE. This must be the last option."
   echo "   -u tells installer to upgrade or reinstall NsCDE. This must be the"
   echo "      last option, and it is exclusive with \"-i\" and/or \"-d\"."
   echo ""
   echo "Examples:"
   echo "   - Install non-interactively for patched FVWM into default path /opt/NsCDE"
   echo "     without looking for additional photos."
   echo "   ./Installer.ksh -f -n -i"
   echo ""
   echo "   - Install without photo addons for non-patched FVWM into default"
   echo "     path /opt/NsCDE:"
   echo "   ./Installer.ksh -w -i"
   echo ""
   echo "   - Install non-interectively with photo addons for non-patched FVWM"
   echo "     into default path /opt/NsCDE:"
   echo "   ./Installer.ksh -w -n -P /tmp/NsCDE-Photos -i"
   echo ""
   echo "   - Install NsCDE in interactive mode for non-patched FVWM into"
   echo "     path /usr/local/nscde:"
   echo "   ./Installer.ksh -w -n -p /usr/local/nscde -i"
   echo ""
   echo "   - Simply upgrade patched NsCDE (additional photos, backdrops and palettes"
   echo "     will remain preserved):"
   echo "   ./Installer.ksh -f -u"
   echo ""
   echo "   - Upgrade in default path, but non-interactive and for non-patched version:"
   echo "   ./Installer.ksh -w -n -u"
   echo ""
   echo "   - Upgrade in path /sfw/X11/NsCDE, patched, noninteractive."
   echo "   ./Installer.ksh -f -n -p /sfw/X11/NsCDE -u"
   echo ""
   echo ""
   echo "* Deinstallation mode:"
   echo ""
   echo "Additional options for deinstallation are:"
   echo "   -n   fully automatic, non-interactive mode"
   echo "   -p <path>   filesystem path where NsCDE has been installed. Defaults to /opt/NsCDE."
   echo ""
   echo "Last option:"
   echo "   -d tells installer to deinstall NsCDE. This must be the last option in this mode."
   echo ""
   echo "Examples:"
   echo "   - Deinstall NsCDE interactively:"
   echo "   ./Installer.ksh -d"
   echo ""
   echo "   - Deinstall NsCDE in non-interactive mode:"
   echo "   ./Installer.ksh -n -d"
   echo ""
   echo "   - Deinstall NsCDE which has been installed in /usr/nscde:"
   echo "   ./Installer.ksh -p /usr/nscde -d"
   echo ""
   echo "   - Deinstall in non-interactive mode NsCDE which has been installed in /usr/nscde:"
   echo "   ./Installer.ksh -n -p /usr/nscde -d"
   echo ""
   echo "NOTICE: Except nscde.desktop file in /usr/share/xsessions or /usr/local/share/xsessions"
   echo "NOTICE: this installer WILL NOT touch anything outside installation path, which is by"
   echo "NOTICE: default \"/opt/NsCDE\", or any other path specified with \"-p\" option."
   echo ""
}

while getopts iucCdD:p:wfP:V:X:I:nh Option
do
   case $Option in
   i)
      upgrade_mode=0
      install_nscde
      exit $?
   ;;
   u)
      upgrade_mode=1
      upgrade_nscde
      exit $?
   ;;
   c)
      check_dependencies
   ;;
   C)
      noexitatdepfail=1
   ;;
   d)
      upgrade_mode=0
      deinstall_nscde
      exit $?
   ;;
   D)
      destdir="$OPTARG"
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
   X)
      xsess_dir="$OPTARG"
   ;;
   I)
      icons_dirlink="$OPTARG"
   ;;
   n)
      noninteractive=1
   ;;
   h)
      usage
   ;;
   esac
done

[ -z $1 ] && usage

