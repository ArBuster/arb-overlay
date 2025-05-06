#!/bin/sh

#if [ `whoami` == "root" ]; then
    /usr/bin/java -Dpbh.datadir=/var/lib/peerbanhelper -Dpbh.configdir=/etc/peerbanhelper -Dpbh.logsdir=/var/log/peerbanhelper -Dpbh.log.level=WARN -Xmx512M -Xms16M -Xss512k -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ShrinkHeapInSteps -jar PeerBanHelper.jar
#else
#    echo "Require root privilege."
#fi
