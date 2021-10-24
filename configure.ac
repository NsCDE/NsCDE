dnl
dnl Autoconf for NsCDE
dnl
dnl This file is a part of the NsCDE - Not so Common Desktop Environment
dnl Author: Hegel3DReloaded
dnl Licence: GPLv3
dnl

AC_INIT([NsCDE], 1.3, [nscde@protonmail.com])

AC_CONFIG_AUX_DIR(ac-aux)

AM_INIT_AUTOMAKE([foreign subdir-objects])

AC_PROG_CC

ALL_LINGUAS="hr"

PYTHON=
REQUIRED_PYTHON_VERSION=3.0
AC_SUBST(REQUIRED_PYTHON_VERSION)
AC_PATH_PROG([PYTHON],[python3],[:])
AS_IF([test "$PYTHON" != ":"],
            [AM_PYTHON_CHECK_VERSION([$PYTHON],[$REQUIRED_PYTHON_VERSION],[:],
                                     [PYTHON=":"])])

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

RECURSIVE_EVAL("$bindir", [FULL_BINDIR])
RECURSIVE_EVAL("$bindir/nscde", [STARTNSCDE])
RECURSIVE_EVAL("$libdir/NsCDE", [NSCDE_LIBDIR])
RECURSIVE_EVAL("$libexecdir/NsCDE", [NSCDE_TOOLSDIR])
RECURSIVE_EVAL("$datarootdir/NsCDE", [NSCDE_DATADIR])
RECURSIVE_EVAL("$datarootdir/NsCDE/fvwm", [FVWM_DATADIR])

# NSCDE_DATADIR=${datarootdir}/NsCDE
AC_SUBST(FVWM_DATADIR)
AC_SUBST(NSCDE_DATADIR)
AC_SUBST(NSCDE_LIBDIR)
AC_SUBST(NSCDE_TOOLSDIR)
AC_SUBST(FULL_BINDIR)
AC_SUBST(KSH)
AC_SUBST(VERSION)
AC_SUBST(STARTNSCDE)

# Dependencies
AC_PATH_PROG(KSH, ksh93, ksh93)
AC_CHECK_PROGS(SED, sed gsed, sed, "")
AC_CHECK_PROGS(FVWM, fvwm fvwm2 fvwm3 ${FVWM_BIN}, "no")
AC_CHECK_PROGS(CPP, cpp /lib/cpp /usr/lib/cpp /usr/local/lib/cpp, "no")
AC_CHECK_PROGS(XRDB, xrdb, "no")
AC_CHECK_PROGS(XSET, xset, "no")
AC_CHECK_PROGS(XPROP, xprop, "no")
AC_CHECK_PROGS(XDPYINFO, xdpyinfo, "no")
AC_CHECK_PROGS(XTERM, xterm, "no")
AC_CHECK_PROGS(GETTEXT, gettext, "no")
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

# Dependencies failures
AS_IF([test x"$SED" == x"no"], [AC_MSG_ERROR([No sed detected.])])
AS_IF([test x"$KSH" == x"no"], [AC_MSG_ERROR([Please install AT&T ksh 93 package before continuing.])])
AS_IF([test x"$FVWM" == x"no"], [AC_MSG_ERROR([Please install fvwm 2 or fvwm 3 before configuring.])])
AS_IF([test x"$CPP" == x"no"], [AC_MSG_ERROR([Please install C preprocessor (cpp) before configuring.])])
AS_IF([test x"$XRDB" == x"no"], [AC_MSG_ERROR([Please install X server resource database utility (xrdb) before configuring.])])
AS_IF([test x"$XSET" == x"no"], [AC_MSG_ERROR([Please install xset(1) utility before configuring.])])
AS_IF([test x"$XPROP" == x"no"], [AC_MSG_ERROR([Please install xprop(1) utility before configuring.])])
AS_IF([test x"$XDPYINFO" == x"no"], [AC_MSG_ERROR([Please install xdpyinfo(1) utility before configuring.])])
AS_IF([test x"$XTERM" == x"no"], [AC_MSG_ERROR([Please install xterm(1) application before configuring.])])
AS_IF([test x"$GETTEXT" == x"no"], [AC_MSG_ERROR([Please install gettext(1) tool before configuring.])])
AS_IF([test x"$XDOTOOL" == x"no"] && [test x"$FVWM" != x"fvwm3"], [AC_MSG_ERROR([No fvwm3 detected. Please install xdotool(1) tool before configuring.])])

# Dependencies warnings
AS_IF([test x"$XSCSVR" == x"no"], [AC_MSG_WARN([No Xscreensaver installation found. This may be ok for virtual machine guest or for some simple setup.])])
AS_IF([test x"$STALONETRAY" == x"no"], [AC_MSG_WARN([No Stalonetray was found. This NsCDE Installation will not be able to have tray applets.])])
AS_IF([test x"$XSETTINGSD" == x"no"], [AC_MSG_WARN([No Xsettingsd daemon was found. This NsCDE Installation will not be able to dinamically change GTK themes.])])
AS_IF([test x"$XRANDR" == x"no"], [AC_MSG_WARN([No xrandr(1) command was found. It is advised to have X11 Server Utils installed.])])
AS_IF([test x"$DUNST" == x"no"], [AC_MSG_WARN([No Dunst daemon was found. NsCDE and X programs will not be able to display notifications.])])
AS_IF([test x"$XCLIP" == x"no"], [AC_MSG_WARN([No xclip(1) utility was found. NsCDE will not be able to take screenshots into the clipboard.])])

AC_CANONICAL_HOST
AC_MSG_CHECKING(platform)
case "$host_os" in
freebsd*|sunos*|openbsd*|dragonfly*)
        AC_CHECK_PROGS(GSED, gsed, "no")
        AS_IF([test x"$GSED" == x"no"], [AC_MSG_ERROR([You must have GNU sed (gsed) installed on ${host_os}.])])
        ;;
netbsd*)
        AC_CHECK_PROGS(GSED, gsed, "no")
        AS_IF([test x"$GSED" == x"no"], [AC_MSG_ERROR([You must have GNU sed (gsed) installed on ${host_os}.])])
        AC_CHECK_PROGS(GTAIL, gtail, "no")
        AS_IF([test x"$GTAIL" == x"no"], [AC_MSG_ERROR([You must have GNU tail (gtail) installed on ${host_os}.])])
        ;;
*)
        ;;
esac

AC_SUBST(SED)

AC_OUTPUT(
	Makefile
	src/Makefile
	src/colorpicker/Makefile
	src/XOverrideFontCursor/Makefile
	src/pclock/Makefile
	src/pclock/src/Makefile
	docbook/Makefile
	po/Makefile
	NsCDE/bin/Makefile
	NsCDE/bin/nscde
	NsCDE/share/NsCDE/fvwm/Main.fvwmconf
	xdg/xsessions/nscde.desktop
)

