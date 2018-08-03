# DO NOT EDIT THIS FILE
#
# Please edit Env.txt to set supported parameters
#

setenv loglevel "10"
setenv rootdev "/dev/mmcblk0p2"
setenv initrd_addr_r "0x41080000"
setenv load_addr "0x44000000"
setenv overlay_error "false"

if itest.b *0x10028 == 0x00 ; then
        echo "U-boot loaded from SD"
        setenv rootdev "/dev/mmcblk0p2"
fi

if itest.b *0x10028 == 0x02 ; then
        echo "U-boot loaded from eMMC"
        setenv rootdev "/dev/mmcblk2p2"
fi

if test -e mmc ${devnum} Env.txt; then
    load mmc ${devnum} ${load_addr} Env.txt
    env import -t ${load_addr} ${filesize}
fi

setenv bootargs "console=${console} console=tty1 earlyprintk root=${rootdev} rw rootwait fsck.repair=yes panic=10 loglevel=${loglevel}"

# Load DT file
load mmc ${devnum} ${fdt_addr_r} ${fdtfile}
fdt addr ${fdt_addr_r}
fdt resize 65536

for overlay in ${overlays}; do
    if load mmc ${devnum} ${load_addr} allwinner/overlay/sun50i-h5-${overlay}.dtbo; then
        echo "Applying DT overlay sun50i-h5-${overlay}.dtbo"
        fdt apply ${load_addr} || setenv overlay_error "true"
    fi
done

if test "${overlay_error}" = "true"; then
    echo "Error applying DT overlays, restoring original DT"
    load mmc ${devnum} ${fdt_addr_r} ${fdtfile}
fi

load mmc ${devnum} ${kernel_addr_r} Image

if load mmc ${devnum} ${initrd_addr_r} uInitrd; then
    booti ${kernel_addr_r} ${initrd_addr_r} ${fdt_addr_r}
else
    booti ${kernel_addr_r} - ${fdt_addr_r}
fi
