#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Patch
# Apply BLFS log level patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/glib-2.58.1-skip_warnings-1.patch" &&
# Apply our xsltproc network access patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/glib-2.58.3-allow_xsltproc_net.patch" &&

# Build and Install
mkdir build &&
cd build &&
meson --prefix=/usr   \
      -Dman=true      \
      -Dselinux=false \
      ..              &&
NINJAJOBS=$SHED_NUM_JOBS ninja &&
DESTDIR="$SHED_FAKE_ROOT" ninja install || exit 1

# Install Documentation
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    mkdir -pv "${SHED_FAKE_ROOT}${SHED_PKG_DOCS_INSTALL_DIR}" &&
    cp -r ../docs/reference/{NEWS,gio,glib,gobject} "${SHED_FAKE_ROOT}${SHED_PKG_DOCS_INSTALL_DIR}"
fi
