#!/bin/bash

set -e
PREFIX=/usr
NPROC=$(nproc)

export PATH="$PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"

mkdir -p ~/src
cd ~/src

#########################
# 1. Install wayland-server
#########################
echo "Installing wayland-server..."
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
# The wayland-server component is inside the main Wayland repo, we need to build the server as well
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 2. Install wayland-protocols
#########################
echo "Installing wayland-protocols..."
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 3. Install pixman
#########################
echo "Installing pixman..."
git clone https://gitlab.freedesktop.org/pixman/pixman.git
cd pixman
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 4. Install libliftoff
#########################
echo "Installing libliftoff..."
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 5. Install libdisplay-info
#########################
echo "Installing libdisplay-info..."
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 6. Install seatd
#########################
echo "Installing seatd..."
git clone https://git.sr.ht/~kennylevinsen/seatd
cd seatd
meson setup build --prefix=$PREFIX
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 7. Install wlroots
#########################
echo "Installing wlroots..."
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
meson setup build \
  --prefix=$PREFIX \
  -Dexamples=false \
  -Drenderers=gles2
ninja -C build -j$NPROC
ninja -C build install
cd ..

#########################
# 8. Install swayfx
#########################
echo "Installing SwayFX..."
git clone https://github.com/WillPower3309/swayfx.git
cd swayfx
meson setup build --prefix=$PREFIX -Dwarnings=false
ninja -C build -j$NPROC
ninja -C build install
cd ..

echo "✅ All components installed to $PREFIX. You can now run swayfx."
