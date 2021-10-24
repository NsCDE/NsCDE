#!/bin/sh

die()
{
    echo "$1" >&2
    exit $2
}

autoreconf -f -i -v || die "autoreconf failed" $?

