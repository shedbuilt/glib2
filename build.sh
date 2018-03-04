#!/bin/bash
# Apply BLFS log level patch
patch -Np1 -i "${SHED_PATCHDIR}/glib-2.54.3-skip_warnings-1.patch"
# Apply BLFS meson patch
patch -Np1 -i "${SHED_PATCHDIR}/glib-2.54.3-meson_fixes-1.patch"
mkdir build-glib && \
cd build-glib && \
meson --prefix=/usr \
      -Dwith-pcre=system \
      -Dwith-docs=no .. && \
NINJAJOBS=$SHED_NUMJOBS ninja && \
DESTDIR="$SHED_FAKEROOT" ninja install && \
chmod -v 755 "${SHED_FAKEROOT}"/usr/bin/{gdbus-codegen,glib-gettextize} && \
mkdir -pv "${SHED_FAKEROOT}/usr/share/doc/glib-2.54.3" && \
cp -r ../docs/reference/{NEWS,README,gio,glib,gobject} "${SHED_FAKEROOT}/usr/share/doc/glib-2.54.3"

