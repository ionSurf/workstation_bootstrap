#!/usr/bin/env zsh
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - [Place app here]
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

echo "Installing Xcode"

xcode-select --install

# Verify installation
# xcode-select -p
# Output: /Library/Developer/CommandLineTools

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Install latest node version
nvm install --lts

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
#    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
#brew tap homebrew/dupes    // Deprecates
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which
#brew install gnu-grep  Not available

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

PACKAGES=(
    ack                             autoconf                        automake
    boot2docker                     gifsicle                        graphviz
    hub                             imagemagick                     jq
    libjpeg                         libmemcached                    lynx
    markdown                        memcached                       mercurial
    postgresql                      pypy                            balena-cli
    terminal-notifier               tmux                            gh
    ansible                         jq                              node
    aom                             kubernetes-cli                  npth
    arm-linux-gnueabihf-binutils    lame                            nvm
                   leptonica                       oniguruma
    assimp                          libarchive                      open-ocd
    autoconf                        libass                          opencore-amr
    automake                        libassuan                       openexr
    awscli                          libb2                           openjdk
    bazel                           libbluray                       openjdk@11
    bdw-gc                          libconfig                       openjdk@17
    berkeley-db                     libelf                          openjpeg
    boost                           libev                           openssl@1.1
    brotli                          libevent                        openssl@3
    c-ares                          libffi                          opus
    ca-certificates                 libftdi                         p11-kit
    cairo                           libgcrypt                       p7zip
    capstone                        libgpg-error                    packer
    carthage                        libidn                          pcre
    ccache                          libidn2                         pcre2
    cjson                           libimobiledevice                perl
    cmake                           libksba                         pidof
    cmocka                          libmng                          pinentry
    cocoapods                       libnghttp2                      pipenv
    confuse                         libogg                          pixman
    coreutils                       libplist                        pkg-config
    ctop                            libpng                          planck
    dav1d                           libpthread-stubs                putty
    dbus                            librist                         pyenv
    dfu-util                        libsamplerate                   pyenv-virtualenv
    diffstat                        libslirp                        
    docker-machine                  libsndfile                      pyqt
    doctl                           libsodium                       pyqt@5
    dos2unix                        libsoxr                         python@3.10
    dotnet                          libssh                          python@3.9
    double-conversion               libssh2                         qemu
    doxygen                         libtasn1                        qt
    elixir                          libtiff                         qt@5
    emscripten                      libtool                         rabbitmq
    erlang                          libunistring                    rav1e
    expat                           libusb                          rbenv
    ffmpeg                          libusb-compat                   readline
    fish                            libusbmuxd                      redis
    flac                            libuv                           rubberband
    fontconfig                      libvidstab                      ruby
    freeglut                        libvmaf                         ruby-build
    freetype                        libvorbis                       rust
    frei0r                          libvpx                          sdl2
    fribidi                         libx11                          six
    gawk                            libxau                          snappy
    gdbm                            libxcb                          speex
    gettext                         libxdamage                      sqlite
    ghostscript                     libxdmcp                        srt
    giflib                          libxext                         ssh-copy-id
    git                             libxfixes                       swiftlint
    git-flow                        libxi                           tesseract
    git-lfs                         libxrandr                       theora
    glib                            libxrender                      tree
    gmp                             libxxf86vm                      unbound
    gnupg                           libyaml                         unzip
    gnutls                          libzip                          util-linux
    go                              little-cms2                     vde
    gobject-introspection           llvm                            vim
    graphite2                       lua                             wakeonlan
    groonga                         lz4                             watch
    groovy                          lzo                             webp
    guile                           lzop                            wget
    harfbuzz                        m4                              wxmac
    helm                            make                            wxwidgets
    hidapi                          mariadb                         x264
    highlight                       mbedtls                         x265
    hiredis                         md4c                            xorgproto
    htop                            mecab                           xvid
    hugo                            mecab-ipadic                    xz
    hunspell                        mesa                            yarn
    icarus-verilog                  minikube                        yosys
    icu4c                           mkcert                          youtube-dl
    imath                           mpdecimal                       yuicompressor
    ios-webkit-debug-proxy          mpfr                            z3
    jasper                          msgpack                         zeromq
    jbig2dec                        nano                            zimg
    jemalloc                        ncurses                         zlib
    jenkins                         nettle                          zsh
    jpeg                            nghttp2                         zsh-completions
    jpeg-turbo                      ninja                           zstd
    jpeg-xl                         nmap
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

#echo "Installing cask..."
#brew install homebrew/cask

CASKS=(
    anydesk                         android-sdk                     
    
    chromedriver
    
    daisydisk
    discord
    docker
    dropbox
    eclipse-cpp
    flutter
    firefox
    flux
    ghdl
    gtkwave
    google-chrome
    google-drive
    
    iterm2
    macvim
    messenger
    nordvpn
    openvpn-connect
    postman
    rar
    skype
    slack
    spectacle
    sublime-text
    teamviewer
    vagrant
    virtualbox
    vlc
    vuze
    visual-studio
    visual-studio-code
    whatsapp
    wireshark
    xmind
    zoom
)

echo "Installing cask apps..."
brew install ${CASKS[@]} --cask

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-inconsolata
    font-roboto
    font-clear-sans
)
brew install ${FONTS[@]} --cask

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip install ${PYTHON_PACKAGES[@]}

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g

# Install global packages
echo "Installing Yarn global packages"
YARN_PACKAGES=(
    create-next-app
    eslint-config-prettier
    prettier
    remotedebug-ios-webkit-adapter
    t2
    t2-cli
    cargo-tessel
    yarn-run-all
)
yarn global add ${YARN_PACKAGES[@]}

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Creating folder structure..."
[[ ! -d Wiki ]] && mkdir Wiki
[[ ! -d Workspace ]] && mkdir Workspace

echo "Bootstrapping complete"