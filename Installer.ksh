#!/bin/ksh

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
      instpath="/opt/NsCDE"
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
      cp -rpf NsCDE/* ${instpath}/
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
      :
   fi

   if [ "x$vuepath" != "x" ]; then
      :
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
   :
}

function upgrade_nscde
{
   :
}

function deinstall_nscde
{
   :
}

function usage
{
   echo "Usage: ${0##*/} [-i|-u|-d] [-p] [-w] [-f] [-P] [-V] [-X]"
}

while getopts iucdp:wfP:V:X:h Option
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
   h)
      usage
   ;;
   esac
done

