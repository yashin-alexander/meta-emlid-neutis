SUMMARY = "openalpr"
LICENSE = "GPLv3+"
LIC_FILES_CHKSUM = "file://../../..//LICENSE;md5=73f1eb20517c55bf9493b7dd6e480788"

SRC_URI = "https://github.com/openalpr/openalpr/archive/v${PV}.tar.gz"

S = "${WORKDIR}/openalpr-${PV}/src/bindings/python"

SOLIBS = ".so"
FILES_SOLIBSDEV = ""
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT  = "1"
INSANE_SKIP_${PN} = "ldflags"

DEPENDS = "openalpr"
RDEPENDS_${PN} = "openalpr"

OPENALPR_INCLUDE_DIR="${WORKDIR}/openalpr-${PV}/src/openalpr/"
OPENALPR_LIB_DIR="${WORKDIR}/openalpr-${PV}/src/build/openalpr/"

do_compile_prepend() {
    ${CXX} openalprpy.cpp -L${OPENALPR_LIB_DIR} -I${OPENALPR_INCLUDE_DIR} -shared -fPIC -o ${WORKDIR}/libopenalprpy.so -lopenalpr
}

do_install_prepend() {
    install -d ${D}${libdir}
    install -m 0755 "${WORKDIR}/libopenalprpy.so" ${D}${libdir}
}

FILES_${PN} += "${libdir}/"

SRC_URI[md5sum] = "7b864fd6378fb1c847f17953bf3e6ac0"
SRC_URI[sha256sum] = "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"

inherit setuptools
