#!/bin/ksh

function upgrade_nscde
{
   :
}

function install_nscde
{
   :
}

function deinstall_nscde
{
   :
}

case $1 in
-upgrade)
   upgrade_nscde "$@"
;;
-install)
   install_nscde "$@"
;;
-deinstall)
   deinstall_nscde "$@"
;;
*) echo "Usage: ${0##*/} [-install|-upgrade|-deinstall]"
esac

