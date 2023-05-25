dnl
dnl Autoconf for NsCDE
dnl
dnl This file is a part of the NsCDE - Not so Common Desktop Environment
dnl Author: Hegel3DReloaded
dnl Licence: GPLv3
dnl

AC_INIT([NsCDE], 2.3, [nscde@protonmail.com])

AC_CONFIG_AUX_DIR(ac-aux)

AM_INIT_AUTOMAKE([foreign subdir-objects])

AC_PROG_CC

AC_CANONICAL_HOST
AC_MSG_CHECKING(platform)
case "$host_os" in
freebsd*|dragonfly*)
        AC_CHECK_PROGS(GSED, gsed, "no")
        AS_IF([test x"$GSED" = x"no"], [AC_MSG_WARN([You must have GNU sed (gsed) installed on ${host_os} for NsCDE runtime.])])
        CPPFLAGS="$CPPFLAGS -I/usr/local/include"
        LDFLAGS="$LDFLAGS -L/usr/local/lib"
	ECHONE="echo -ne"
        ;;
netbsd*)
        AC_CHECK_PROGS(GSED, gsed, "no")
        AS_IF([test x"$GSED" = x"no"], [AC_MSG_WARN([You must have GNU sed (gsed) installed on ${host_os} for NsCDE runtime.])])
        AC_CHECK_PROGS(GTAIL, gtail, "no")
        AS_IF([test x"$GTAIL" = x"no"], [AC_MSG_WARN([You must have GNU tail (gtail) installed on ${host_os} for NsCDE runtime.])])
        CPPFLAGS="$CPPFLAGS -I/usr/X11R7/include -I/usr/pkg/include -I/usr/local/include"
        LDFLAGS="$LDFLAGS -L/usr/X11R7/lib -R/usr/X11R7/lib -L/usr/pkg/lib -R/usr/pkg/lib -L/usr/local/lib -R/usr/local/lib"
	ECHONE="echo -ne"
        ;;
openbsd*)
	AC_CHECK_PROGS(GSED, gsed, "no")
	AC_CHECK_PROGS(GMAKE, gmake, "no")
	AS_IF([test x"$GSED" = x"no"], [AC_MSG_WARN([You must have GNU sed (gsed) installed on ${host_os} for NsCDE runtime.])])
	AS_IF([test x"$GMAKE" = x"no"], [AC_MSG_ERROR([You must have GNU make (gmake) installed. Native ${host_os} make is currently broken.])])
	CPPFLAGS="$CPPFLAGS -I/usr/X11R6/include -I/usr/local/include"
	LDFLAGS="$LDFLAGS -L/usr/X11R6/lib -L/usr/local/lib"
	ECHONE="echo -ne"
	;;
sunos*|solaris*)
        AC_CHECK_PROGS(GSED, gsed, "no")
        AS_IF([test x"$GSED" = x"no"], [AC_MSG_WARN([You must have GNU sed (gsed) installed on ${host_os} for NsCDE runtime.])])
        CPPFLAGS="$CPPFLAGS -I/usr/local/include"
        LDFLAGS="$LDFLAGS -L/usr/local/lib"
	ECHONE="printf"
	;;
linux*)
	ECHONE="echo -ne"
	;;
*)
	ECHONE="printf"
        ;;
esac
AC_MSG_RESULT($host_os)

AC_MSG_CHECKING(xsessiondir)
AC_ARG_WITH([xsessiondir],
	AC_HELP_STRING([--with-xsessiondir=DIR],[Where tu put NsCDE X Display Manager file to be found by display manager.]),
	[XSESSDIR=$withval],
	[XSESSDIR=""])
AC_MSG_RESULT($XSESSDIR)

AC_SUBST(xsessiondir)

LOCALES="hr"
AC_SUBST(LOCALES)

AC_SUBST(ECHONE)
AC_SUBST(SED)

if test "$prefix" = /usr; then
   test "$sysconfdir" = '${prefix}/etc' && sysconfdir=/etc
fi

if test "$datarootdir" != "/usr/share"; then
   XDG_DATA_PATH_BOOL=1
else
   XDG_DATA_PATH_BOOL=0
fi

if test "$sysconfdir" != "/etc"; then
   XDG_CONFIG_PATH_BOOL=1
else
   XDG_CONFIG_PATH_BOOL=0
fi

AC_SUBST(XDG_DATA_PATH_BOOL)
AC_SUBST(XDG_CONFIG_PATH_BOOL)

AC_MSG_CHECKING(custom python shebang)
AC_ARG_WITH([python-shebang],
	AC_HELP_STRING([--with-python-shebang="STRING"],[How to call Python 3 in python scripts
                      (specified WITHOUT hash and exclamation mark). This disables python 3
                      autodetection and fully trusts what is provided by the user.
                      One example of this option can be: "/usr/bin/env python3". ]),
	[PYTHON_SHEBANG=$withval],
	[PYTHON_SHEBANG=""])
AC_MSG_RESULT($PYTHON_SHEBANG)

PYTHON=
REQUIRED_PYTHON_VERSION=3.0
AC_SUBST(REQUIRED_PYTHON_VERSION)
AC_PATH_PROG([PYTHON],[python3],[:])
AS_IF([test "$PYTHON" != ":"],
            [AM_PYTHON_CHECK_VERSION([$PYTHON],[$REQUIRED_PYTHON_VERSION],[:],
                                     [PYTHON=":"])])

if test "x$PYTHON_SHEBANG" != "x"; then
	PYTHON="$PYTHON_SHEBANG"
fi

# Custom check to expand full path
AC_DEFUN([RECURSIVE_EVAL],
	[_lcl_receval="$1"
	$2=`(test "x$prefix" = xNONE && prefix="$ac_default_prefix"
	test "x$exec_prefix" = xNONE && exec_prefix="${prefix}"
	_lcl_receval_old=''
	while test "[$]_lcl_receval_old" != "[$]_lcl_receval"; do
	   _lcl_receval_old="[$]_lcl_receval"
	   eval _lcl_receval="\"[$]_lcl_receval\""
	done
	echo "[$]_lcl_receval")`])

# Check python module existance
# https://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_python_module.m4
AU_ALIAS([AC_PYTHON_MODULE], [AX_PYTHON_MODULE])
AC_DEFUN([AX_PYTHON_MODULE],[
   if test "x$PYTHON_SHEBANG" = "x";
   then
      if test -z $PYTHON;
      then
         if test -z "$3";
         then
            PYTHON="python3"
         else
            PYTHON="$3"
         fi
    fi
    PYTHON_NAME=`basename $PYTHON`
   else
      PYTHON_NAME="$PYTHON_SHEBANG"
   fi
    AC_MSG_CHECKING($PYTHON_NAME module: $1)
    $PYTHON -c "import $1" 2>/dev/null
    if test $? -eq 0;
    then
        AC_MSG_RESULT(yes)
        eval AS_TR_CPP(HAVE_PYMOD_$1)=yes
    else
        AC_MSG_RESULT(no)
        eval AS_TR_CPP(HAVE_PYMOD_$1)=no
        #
        if test -n "$2"
        then
            AC_MSG_ERROR(failed to find required module $1)
            exit 1
        fi
    fi
])

RECURSIVE_EVAL("$bindir", [FULL_BINDIR])
RECURSIVE_EVAL("$bindir/nscde", [STARTNSCDE])
RECURSIVE_EVAL("$libdir/NsCDE", [NSCDE_LIBDIR])
RECURSIVE_EVAL("$libexecdir/NsCDE", [NSCDE_TOOLSDIR])
RECURSIVE_EVAL("$datarootdir/NsCDE", [NSCDE_DATADIR])
RECURSIVE_EVAL("$datarootdir/NsCDE/fvwm", [FVWM_DATADIR])
RECURSIVE_EVAL("$datarootdir", [DATA_ROOTDIR])
RECURSIVE_EVAL("$sysconfdir", [SYS_CONFDIR])
RECURSIVE_EVAL("$docdir", [DOCUMENTATION_ROOT])

# NSCDE_DATADIR=${datarootdir}/NsCDE
AC_SUBST(FVWM_DATADIR)
AC_SUBST(NSCDE_DATADIR)
AC_SUBST(NSCDE_LIBDIR)
AC_SUBST(NSCDE_TOOLSDIR)
AC_SUBST(FULL_BINDIR)
AC_SUBST(VERSION)
AC_SUBST(STARTNSCDE)
AC_SUBST(DATA_ROOTDIR)
AC_SUBST(SYS_CONFDIR)
AC_SUBST(DOCUMENTATION_ROOT)

if test "$DATA_ROOTDIR" != "/usr/share" && test "$DATA_ROOTDIR" != "/usr/local/share"; then
   NOSTDICONPATH="$DATA_ROOTDIR/icons:"
   NOSTDICONDIR="$DATA_ROOTDIR/icons"
   NOSTDICONDIRREGEX=`echo "^$DATA_ROOTDIR/icons/" | sed 's/\//\\\\\//g'`
else
   NOSTDICONPATH=""
   NOSTDICONDIR="/NONEXISTENT"
   NOSTDICONDIRREGEX=`echo "/NONEXISTENT/" | sed 's/\//\\\\\//g'`
fi

AC_SUBST(NOSTDICONPATH)
AC_SUBST(NOSTDICONDIR)
AC_SUBST(NOSTDICONDIRREGEX)

XDG_DATA_ROOTDIRS="$DATA_ROOTDIR/"
TRY_RTDT="/usr/share/"
AS_IF([test "x$TRY_RTDT" != "x$DATA_ROOTDIR/"], [ XDG_DATA_ROOTDIRS=$XDG_DATA_ROOTDIRS:$TRY_RTDT ])
TRY_RTDT="/usr/local/share/"
AS_IF([test "x$TRY_RTDT" != "x$DATA_ROOTDIR/"], [ XDG_DATA_ROOTDIRS=$XDG_DATA_ROOTDIRS:$TRY_RTDT ])

echo "$host_os" | egrep -q "netbsd"
if test $? -eq 0; then
   TRY_RTDT="/usr/pkg/share/"
   AS_IF([test "x$TRY_RTDT" != "x$DATA_ROOTDIR/"], [ XDG_DATA_ROOTDIRS=$XDG_DATA_ROOTDIRS:$TRY_RTDT ])
fi

AC_SUBST(XDG_DATA_ROOTDIRS)

XDG_CONF_DIRS="$SYS_CONFDIR/xdg"
TRY_SYSCF="/etc/xdg"
AS_IF([test "x$TRY_SYSCF" != "x$SYS_CONFDIR/xdg"], [ XDG_CONF_DIRS=$XDG_CONF_DIRS:$TRY_SYSCF ])
TRY_SYSCF="/usr/local/etc/xdg"
AS_IF([test "x$TRY_SYSCF" != "x$SYS_CONFDIR/xdg"], [ XDG_CONF_DIRS=$XDG_CONF_DIRS:$TRY_SYSCF ])

echo "$host_os" | egrep -q "netbsd"
if test $? -eq 0; then
   TRY_SYSCF="/usr/pkg/etc/xdg"
   AS_IF([test "x$TRY_SYSCF" != "x$SYS_CONFDIR/xdg"], [ XDG_CONF_DIRS=$XDG_CONF_DIRS:$TRY_SYSCF ])
fi

AC_SUBST(XDG_CONF_DIRS)

# Dependencies
AC_PATH_PROGS([KSH],[ksh93 ksh],[no])
AC_CHECK_PROGS(SED, sed gsed, "no")
AC_CHECK_PROGS(FVWM, fvwm fvwm2 fvwm3 ${FVWM_BIN}, "no")
AC_CHECK_PROGS(CPP, cpp /lib/cpp /usr/lib/cpp /usr/local/lib/cpp, "no")
AC_CHECK_PROGS(CONVERT, convert, "no")
AC_CHECK_PROGS(IMPORT, import, "no")
AC_CHECK_PROGS(XRDB, xrdb, "no")
AC_CHECK_PROGS(XSET, xset, "no")
AC_CHECK_PROGS(XPROP, xprop, "no")
AC_CHECK_PROGS(XDPYINFO, xdpyinfo, "no")
AC_CHECK_PROGS(XTERM, xterm, "no")
AC_CHECK_PROGS(GETTEXT, gettext, "no")
AC_CHECK_PROGS(MSGFMT, msgfmt, "no")
AC_CHECK_PROGS(XDOTOOL, xdotool, "no")

AC_CHECK_PROGS(XSCSVR, xscreensaver, "no")
AC_CHECK_PROGS(STALONETRAY, stalonetray, "no")
AC_CHECK_PROGS(XSETTINGSD, xsettingsd, "no")
AC_CHECK_PROGS(XRANDR, xrandr, "no")
AC_CHECK_PROGS(DUNST, dunst, "no")
AC_CHECK_PROGS(XCLIP, xclip, "no")
AC_CHECK_PROGS(ROFI, rofi, "no")

AC_CHECK_HEADERS(math.h stdlib.h string.h sys/time.h time.h unistd.h \
 X11/cursorfont.h X11/extensions/shape.h X11/Xlib.h X11/xpm.h \
 X11/Xutil.h,,AC_MSG_ERROR([Missing required header files.]))

AC_CHECK_LIB(X11, XOpenDisplay, X_LIB="-lX11", AC_MSG_ERROR([No -lX11 found.]), $X_LIBS)
AC_SUBST(X_LIB)

AC_CHECK_LIB(Xext, XShapeCombineMask, XEXT_LIB="-lXext", AC_MSG_ERROR([No -lXext found.]), $X_LIBS)
AC_SUBST(XEXT_LIB)

AC_CHECK_LIB(Xpm, XpmReadFileToXpmImage, XPM_LIB="-lXpm", AC_MSG_ERROR([No -lXpm found.]), $X_LIBS)
AC_SUBST(XPM_LIB)

AC_CHECK_LIB(m, cos, MATH_LIB="-lm", AC_MSG_ERROR([No -lm found.]), $LIBS)
AC_SUBST(MATH_LIB)

AC_SUBST(KSH)

# Dependencies failures
AS_IF([test x"$SED" = x"no"], [AC_MSG_ERROR([No sed detected.])])
AS_IF([test x"$KSH" = x"no"], [AC_MSG_ERROR([Please install AT&T ksh 93 package before continuing.])])
AS_IF([test x"$MSGFMT" = x"no"], [AC_MSG_ERROR([No msgfmt(1) detected. Please install msgfmt(1) tool.])])

# Dependencies warnings
AS_IF([test x"$FVWM" = x"no"], [AC_MSG_WARN([No FVWM detected. FVWM 2 or 3 is essential for NsCDE runtime.])])
AS_IF([test x"$CPP" = x"no"], [AC_MSG_WARN([No cpp(1) C Preprocessor detected. It is required for xrdb(1) in runtime.])])
AS_IF([test x"$XRDB" = x"no"], [AC_MSG_WARN([No xrdb(1) detected. X resource database utility (xrdb) is required for NsCDE in runtime.])])
AS_IF([test x"$XSET" = x"no"], [AC_MSG_WARN([No xset(1) detected. Xset is required for NsCDE in runtime.])])
AS_IF([test x"$XPROP" = x"no"], [AC_MSG_WARN([No xprop(1) detected. Xset is required for NsCDE in runtime.])])
AS_IF([test x"$XDPYINFO" = x"no"], [AC_MSG_WARN([No xdpyinfo(1) detected. Please install xdpyinfo(1) utility for NsCDE runtime.])])
AS_IF([test x"$XTERM" = x"no"], [AC_MSG_WARN([No xterm(1) detected. You will need xterm application at least for first NsCDE setup in runtime.])])
AS_IF([test x"$GETTEXT" = x"no"], [AC_MSG_WARN([No gettext(1) detected. Please install gettext(1) tool for NsCDE runtime.])])
AS_IF([test x"$XDOTOOL" = x"no"] && [test x"$FVWM" != x"fvwm3"], [AC_MSG_WARN([No fvwm3 detected. You need to install xdotool(1) for NsCDE runtime.])])
AS_IF([test x"$XSCSVR" = x"no"], [AC_MSG_WARN([No Xscreensaver installation found. This may be ok for virtual machine guest or for some simple setup.])])
AS_IF([test x"$STALONETRAY" = x"no"], [AC_MSG_WARN([No Stalonetray was found. This NsCDE Installation will not be able to have tray applets.])])
AS_IF([test x"$XSETTINGSD" = x"no"], [AC_MSG_WARN([No Xsettingsd daemon was found. This NsCDE Installation will not be able to dinamically change GTK themes.])])
AS_IF([test x"$XRANDR" = x"no"], [AC_MSG_WARN([No xrandr(1) command was found. It is advised to have X11 Server Utils installed.])])
AS_IF([test x"$DUNST" = x"no"], [AC_MSG_WARN([No Dunst daemon was found. NsCDE and X programs will not be able to display notifications.])])
AS_IF([test x"$XCLIP" = x"no"], [AC_MSG_WARN([No xclip(1) utility was found. NsCDE will not be able to take screenshots into the clipboard.])])
AS_IF([test x"$CONVERT" = x"no"], [AC_MSG_WARN([No ImageMagick convert(1) utility found. NsCDE will not be able to take screenshots to file.])])
AS_IF([test x"$IMPORT" = x"no"], [AC_MSG_WARN([No ImageMagick import(1) utility found. NsCDE will not be able to take screenshots to file.])])

# Python modules
AX_PYTHON_MODULE([xdg], [])
AS_IF([test "x${HAVE_PYMOD_XDG}" = x"no"], [AC_MSG_WARN([Python 3 module xdg is required for NsCDE runtime.])])

AX_PYTHON_MODULE([yaml], [])
AS_IF([test "x${HAVE_PYMOD_YAML}" = x"no"], [AC_MSG_WARN([Python 3 module yaml is required for NsCDE runtime.])])

AX_PYTHON_MODULE([os], [])
AS_IF([test "x${HAVE_PYMOD_OS}" = x"no"], [AC_MSG_WARN([Python 3 module os is required for NsCDE runtime.])])

AX_PYTHON_MODULE([re], [])
AS_IF([test "x${HAVE_PYMOD_RE}" = x"no"], [AC_MSG_WARN([Python 3 module re is required for NsCDE runtime.])])

AX_PYTHON_MODULE([shutil], [])
AS_IF([test "x${HAVE_PYMOD_SHUTIL}" = x"no"], [AC_MSG_WARN([Python 3 module shutil is required for NsCDE runtime.])])

AX_PYTHON_MODULE([subprocess], [])
AS_IF([test "x${HAVE_PYMOD_SUBPROCESS}" = x"no"], [AC_MSG_WARN([Python 3 module subprocess is required for NsCDE runtime.])])

AX_PYTHON_MODULE([sys], [])
AS_IF([test "x${HAVE_PYMOD_SYS}" = x"no"], [AC_MSG_WARN([Python 3 module sys is required for NsCDE runtime.])])

AX_PYTHON_MODULE([fnmatch], [])
AS_IF([test "x${HAVE_PYMOD_FNMATCH}" = x"no"], [AC_MSG_WARN([Python 3 module fnmatch is required for NsCDE runtime.])])

AX_PYTHON_MODULE([getopt], [])
AS_IF([test "x${HAVE_PYMOD_GETOPT}" = x"no"], [AC_MSG_WARN([Python 3 module getopt is required for NsCDE runtime.])])

AX_PYTHON_MODULE([time], [])
AS_IF([test "x${HAVE_PYMOD_TIME}" = x"no"], [AC_MSG_WARN([Python 3 module time is required for NsCDE runtime.])])

AX_PYTHON_MODULE([platform], [])
AS_IF([test "x${HAVE_PYMOD_PLATFORM}" = x"no"], [AC_MSG_WARN([Python 3 module platform is required for NsCDE runtime.])])

AX_PYTHON_MODULE([psutil], [])
AS_IF([test "x${HAVE_PYMOD_PSUTIL}" = x"no"], [AC_MSG_WARN([Python 3 module psutil is required for NsCDE runtime.])])

AX_PYTHON_MODULE([pwd], [])
AS_IF([test "x${HAVE_PYMOD_PWD}" = x"no"], [AC_MSG_WARN([Python 3 module pwd is required for NsCDE runtime.])])

AX_PYTHON_MODULE([socket], [])
AS_IF([test "x${HAVE_PYMOD_SOCKET}" = x"no"], [AC_MSG_WARN([Python 3 module socket is required for NsCDE runtime.])])

AX_PYTHON_MODULE([PyQt5], [])
AX_PYTHON_MODULE([PyQt4], [])

AS_IF([test "x${HAVE_PYMOD_PYQT5}" = "xno"], 
	AS_IF([test "x${HAVE_PYMOD_PYQT4}" = "xno"],
	[AC_MSG_WARN([Either python module PyQt5 or older PyQt4 are required for NsCDE runtime.])]))

if test -z $XSESSDIR ; then
   if test -d "/usr/share/xsessions"; then
      XSESSDIR="/usr/share/xsessions"
   elif test -d "/usr/local/share/xsessions"; then
      XSESSDIR="/usr/local/share/xsessions"
   else
      XSESSDIR="$DATA_ROOTDIR/xsessions"
   fi
fi

AC_SUBST(XSESSDIR)

if test -d "./.git"; then
   VERSIONINFO=`git describe --always --long --dirty`
   VERSION="${VERSION}-git${VERSIONINFO}"
fi

OS_PLUS_MACHINE_ARCH=`uname -sm | tr ' ' '_'`
AC_SUBST(OS_PLUS_MACHINE_ARCH)

AC_OUTPUT(
	Makefile
	src/Makefile
	src/colorpicker/Makefile
	src/XOverrideFontCursor/Makefile
	src/pclock/Makefile
	src/pclock/src/Makefile

	doc/Makefile
	doc/docbook/Makefile

	po/Makefile

	bin/Makefile
	bin/nscde
	bin/nscde_fvwmclnt

	data/Makefile
	data/fvwm/Makefile
	data/fvwm/Main.fvwmconf
	data/fvwm/Functions.fvwmconf

	data/config_templates/Makefile
	data/config_templates/fontmgr.local
	data/config_templates/colormgr.local
	data/config_templates/Dunst.conf
	data/config_templates/dot_xscreensaver

	lib/Makefile
	lib/fvwm-modules/Makefile
	lib/fvwm-modules/FvwmScript
	lib/python/Makefile
	lib/python/Globals.py
	lib/python/MiscFun.py
	lib/python/MotifColors.py
	lib/python/Opts.py
	lib/python/ThemeGtk.py
	lib/python/Theme.py

	lib/scripts/Makefile
	lib/scripts/BackdropMgr
	lib/scripts/ColorMgr
	lib/scripts/ExecDialog
	lib/scripts/FontMgr
	lib/scripts/PowerSaveMgr
	lib/scripts/KeyboardMgr
	lib/scripts/SubpanelSettings
	lib/scripts/Sysinfo

	xdg/Makefile
	xdg/xsessions/nscde.desktop

	nscde_tools/Makefile
	nscde_tools/acpimgr
	nscde_tools/appfinder
	nscde_tools/backdropmgr
	nscde_tools/bootstrap
	nscde_tools/chtheme
	nscde_tools/colormgr
	nscde_tools/colorpicker
	nscde_tools/fontmgr
	nscde_tools/fpclock
	nscde_tools/fpexec
	nscde_tools/fpdoc
	nscde_tools/fp_manage_subpanel
	nscde_tools/fpseticon
	nscde_tools/generate_app_menus
	nscde_tools/generate_subpanels
	nscde_tools/getdpi
	nscde_tools/getfont
	nscde_tools/get_logical_screens
	nscde_tools/ised
	nscde_tools/keymenu
	nscde_tools/mkpagemenu
	nscde_tools/migrate_nscde_1x_2x
	nscde_tools/strip_icon_path
	nscde_tools/subpanel_menuitem_props
	nscde_tools/style_managers.shlib
	nscde_tools/var_append
	nscde_tools/xdowrapper
	nscde_tools/xrandr_backer
	nscde_tools/colorconv
	nscde_tools/confget
	nscde_tools/confset
	nscde_tools/geticon
	nscde_tools/getla1
	nscde_tools/palette_colorgen
	nscde_tools/sysinfo
	nscde_tools/themegen
	nscde_tools/usleep

	nscde_tools/FvwmScripts/Makefile
	nscde_tools/FvwmScripts/GWM
	nscde_tools/FvwmScripts/Notifier
	nscde_tools/FvwmScripts/Splash
)

eval my_prefix="`eval echo ${prefix}`"
eval my_bindir="`eval echo ${bindir}`"
eval my_libdir="`eval echo ${libdir}`"
eval my_sysconfdir="`eval echo ${sysconfdir}`"
eval my_datadir="`eval echo ${datarootdir}`"
eval my_docdir="`eval echo ${docdir}`"
eval my_localedir="`eval echo ${localedir}`"

echo "
*********************************************************************
NsCDE Configuration Summary:

NsCDE Version:        ${VERSION}
Platform:             `uname -srm`
Detected FVWM:        $FVWM
Detected Python 3:    `$PYTHON -V`

Base Prefix:          ${my_prefix}
Main Commands:        ${my_bindir}
Library Data:         ${NSCDE_LIBDIR}
XDG Menu Definition:  ${my_sysconfdir}/xdg/menus/nscde-applications.menu
X Session Start File: ${XSESSDIR}/nscde.desktop
NsCDE Data:           ${NSCDE_DATADIR}
FVWM Data:            ${FVWM_DATADIR}
XDG App Data:         ${my_datadir}/applications
Icon Theme:           ${my_datadir}/icons/NsCDE
Tools:                ${NSCDE_TOOLSDIR}
Locale:               ${my_localedir}
Docs:                 ${my_docdir}
*********************************************************************
"

