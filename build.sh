#!/bin/bash
# Apply BLFS log level patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/glib-2.54.3-skip_warnings-1.patch"
# Apply BLFS meson patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/glib-2.54.3-meson_fixes-1.patch"
# Apply our aarch64 meson host compilation patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/glib2-2.54.3_aarch64_meson_host.patch"
mkdir build-glib && \
cd build-glib && \
meson --prefix=/usr \
      -Dwith-pcre=system \
      -Dwith-docs=no .. && \
NINJAJOBS=$SHED_NUM_JOBS ninja && \
DESTDIR="$SHED_FAKE_ROOT" ninja install && \
chmod -v 755 "${SHED_FAKE_ROOT}"/usr/bin/{gdbus-codegen,glib-gettextize} && \
mkdir -pv "${SHED_FAKE_ROOT}/usr/share/doc/glib-2.54.3" && \
cp -r ../docs/reference/{NEWS,README,gio,glib,gobject} "${SHED_FAKE_ROOT}/usr/share/doc/glib-2.54.3"

