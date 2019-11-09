#!/usr/bin/bash

dep_install() {
				echo "Installing dependencies"
				echo "Choose your distro: "
				echo "1 - Ubuntu/Mint/elementary"
				echo "2 - Arch/Manjaro"
				echo "3 - Fedora"
				echo "4 - Gentoo"
				echo "5 - OpenSUSE"
				read distro ">"
				case "$distro"
					"1")
						sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev libpango1.0-dev libgl1-mesa-dev libopenal-dev libsndfile-dev libmpg123-dev libgmp-dev
						sudo apt-get install ruby-dev
						sudo gem install gosu;;
					"2")
						sudo pacman -S openal pango sdl2 sdl2_ttf libsndfile pkg-config mpg123
						sudo pacman -S ruby
						sudo gem install gosu;;
					"3")
						sudo dnf groupinstall --assumeyes "Development Tools"
sudo dnf install --assumeyes mpg123-devel mesa-libGL-devel openal-devel pango-devel SDL2_ttf-devel libsndfile-devel gcc-c++ redhat-rpm-config
						sudo dnf install --assumetes ruby-devel rubygems
					  sudo gem install gosu;;
					"4")
						sudo emerge -av media-libs/mesa media-libs/openal x11-libs/pango media-libs/sdl2-ttf media-libs/libsndfile media-sound/mpg123
						sudo emerge -av dev-lang/ruby
						sudo gem install gosu;;
					"5")
						sudo zypper install --type pattern devel_basis
						sudo zypper addrepo http://download.opensuse.org/repositories/games/openSUSE_12.1/ opensuse-games
						sudo zypper install libSDL2-devel libSDL2_ttf-devel pango-devel libsndfile-devel openal-soft-devel
						sudo zypper install ruby-devel
						sudo gem install gosu;;
					*)
						echo "bad option!"
						exit
				esac
}

extract() {
				echo "Extracting game"
				echo `base64 -d < echo "
tar -xvzf colapse.tar.gz
}
dep_install
extract
echo "Done!"