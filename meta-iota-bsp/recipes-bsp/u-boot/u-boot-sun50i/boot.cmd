# DO NOT EDIT THIS FILE
#
# Please edit Env.txt to set supported parameters
#

setenv loglevel "10"
setenv rootdev "/dev/mmcblk0p2"
setenv device "0"
setenv load_addr "0x44000000"
setenv overlay_error "false"

if test -e mmc ${device} Env.txt; then
    load mmc ${device} ${load_addr} Env.txt
    env import -t ${load_addr} ${filesize}
fi

setenv bootargs "console=${console} console=tty1 root=${rootdev} panic=10 loglevel=${loglevel}"

# Load DT file
load mmc ${device} ${fdt_addr_r} ${fdtfile}
fdt addr ${fdt_addr_r}
fdt resize 65536

for overlay in ${overlays}; do
    if load mmc ${device} ${load_addr} allwinner/overlay/sun50i-h5-${overlay}.dtbo; then
        echo "Applying DT overlay sun50i-h5-${overlay}.dtbo"
        fdt apply ${load_addr} || setenv overlay_error "true"
    fi
done

if test "${overlay_error}" = "true"; then
    echo "Error applying DT overlays, restoring original DT"
    load mmc ${device} ${fdt_addr_r} ${fdtfile}
fi

load mmc ${device} ${kernel_addr_r} uImage
booti ${kernel_addr_r} - ${fdt_addr_r}