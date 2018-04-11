#!/bin/sh
suspend_osssound()
{
    /usr/lib/oss/scripts/killprocs.sh
    /usr/sbin/soundoff
}

resume_osssound()
{
    /usr/sbin/soundon

}

case $1 in
    pre)
        suspend_osssound
 	;;
    post)
 	resume_osssound
 	;;
    *) exit $NA
 	;;
esac
