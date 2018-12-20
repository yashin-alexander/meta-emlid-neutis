SUMMARY = "openalpr"
LICENSE = "GPLv3+"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=73f1eb20517c55bf9493b7dd6e480788"

SRC_URI = "https://github.com/openalpr/openalpr/archive/v${PV}.tar.gz"

S = "${WORKDIR}/${PN}-${PV}/src"

DEPENDS = "jpeg libpng opencv leptonica tesseract log4cplus curl"

EXTRA_OECMAKE = " -DWITH_BINDING_PYTHON=OFF"

SRC_URI[md5sum] = "7b864fd6378fb1c847f17953bf3e6ac0"
SRC_URI[sha256sum] = "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"

inherit cmake
