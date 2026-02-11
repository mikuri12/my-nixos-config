#!/bin/sh
cd "/home/$USER/.config/mango/"

rulefile="$(cat float.conf | grep "windowrule=isfloating:1,appid:.*")"

if [ "$rulefile" = "windowrule=isfloating:1,appid:.*" ]; then
  echo "" > float.conf
else
  echo "windowrule=isfloating:1,appid:.*" > float.conf
  echo "windowrule=width:1000,height:600,appid:.*" >> float.conf
fi
mmsg -d reload_config
