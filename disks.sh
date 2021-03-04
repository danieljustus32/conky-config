#!/bin/sh

COLOR="FFFFFF"
i=1
df -hT /dev/nvme0n1p3 | grep -v '/boot' | head -4 | sed 's/vfat/FAT32/g;s/fuseblk/NTFS/g;' | grep /dev | while read DEVICE TYPE SIZE USED FREE PERCENT MOUNT && [ $i -le 6 ]
do
  label=1
  i=$((i+1))
  USED=$(printf "%4s" $USED | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  SIZE=$(printf "%4s" $SIZE | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  echo "\${color1}$label:\${color} Mount Point :   \$color1$MOUNT \$color\${alignr} Filesystem:   \${color1}$TYPE\$color
Label:                   \${color1}$DEVICE\$color 
Amount Used:
  ${USED} \${color $COLOR}\${fs_bar 6,320 ${MOUNT}} \$color\${alignr}${SIZE}"
done
df -hT /dev/sda2 | grep -v '/boot' | head -4 | sed 's/vfat/FAT32/g;s/fuseblk/NTFS/g;' | grep /dev | while read DEVICE TYPE SIZE USED FREE PERCENT MOUNT && [ $i -le 6 ]
do
  label=2
  i=$((i+1))
  USED=$(printf "%4s" $USED | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  SIZE=$(printf "%4s" $SIZE | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  echo "\${color1}$label:\${color} Mount Point :   \$color1$MOUNT \$color\${alignr} Filesystem:   \${color1}$TYPE\$color
Label:                   \${color1}$DEVICE\$color 
Amount Used:
  ${USED} \${color $COLOR}\${fs_bar 6,320 ${MOUNT}} \$color\${alignr}${SIZE}"
done
df -hT /dev/sdb1 | grep -v '/boot' | head -4 | sed 's/vfat/FAT32/g;s/fuseblk/NTFS/g;' | grep /dev | while read DEVICE TYPE SIZE USED FREE PERCENT MOUNT && [ $i -le 6 ]
do
  label=3
  i=$((i+1))
  USED=$(printf "%4s" $USED | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  SIZE=$(printf "%4s" $SIZE | sed 's/B/ B  /;s/\([KMGT]\)/ \1iB/')
  echo "\${color1}$label:\${color} Mount Point :   \$color1$MOUNT \$color\${alignr} Filesystem:   \${color1}$TYPE\$color
Label:                   \${color1}$DEVICE\$color 
Amount Used:
  ${USED} \${color $COLOR}\${fs_bar 6,320 ${MOUNT}} \$color\${alignr}${SIZE}"
done
