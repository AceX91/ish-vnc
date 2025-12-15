apk add openrc \
        xorg-server xf86-video-dummy x11vnc \
        xfce4 xfce4-terminal \

rc-update add dbus

cat <<EOF > /etc/profile.d/ish.sh
export DISPLAY=:0
export NO_AT_BRIDGE=1
cat /dev/location > /dev/null &
EOF

mkdir -p /etc/X11/xorg.conf.d

cat <<EOF > /etc/X11/xorg.conf.d/10-headless.conf
Section "Device"
    Identifier  "dummy_videocard"
    Driver      "dummy"
    VideoRam    256000
EndSection

Section "Monitor"
    Identifier  "dummy_monitor"
    HorizSync   1.0 - 20000.0
    VertRefresh 1.0 - 300.0
    DisplaySize 247.6 178.5
    Modeline    "2392x1668@60"  339.00  2392 2576 2832 3272  1668 1671 1681 1729
EndSection

Section "Screen"
    Identifier  "dummy_screen"
    Device      "dummy_videocard"
    Monitor     "dummy_monitor"
    Subsection "Display"
        depth   24
        Modes   "2392x1668@60"
    EndSubsection
EndSection
EOF

mkdir -p /usr/local/bin

cat <<EOF > /usr/local/bin/startvnc
#!/bin/sh
startxfce4 &
x11vnc -rfbport 5901 -shared -noshm
EOF

chmod +x /usr/local/bin/startvnc