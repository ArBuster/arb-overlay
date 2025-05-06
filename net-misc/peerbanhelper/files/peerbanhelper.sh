#!/bin/sh

/usr/bin/java -Dpbh.datadir=~/.local/share/peerbanhelper/data -Dpbh.configdir=/etc/peerbanhelper -Dpbh.logsdir=~/.local/share/peerbanhelper/log -Dpbh.log.level=WARN -Xmx512M -Xms16M -Xss512k -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ShrinkHeapInSteps -jar /opt/peerbanhelper/PeerBanHelper.jar nogui
