#!/bin/sh

/usr/bin/java -Dpbh.datadir=${HOME}/.local/share/peerbanhelper/data -Dpbh.logsdir=${HOME}/.local/share/peerbanhelper/log -Dpbh.log.level=WARN -Xmx512M -Xms16M -Xss512k -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ShrinkHeapInSteps -jar /opt/peerbanhelper/PeerBanHelper.jar nogui
