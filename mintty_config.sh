#!/bin/bash

# How to install and configure font(including symbols) for mintty
# Refer to https://github.com/ryanoasis/nerd-fonts
# 1. Download fonts from https://nerdfonts.com (refer to https://github.com/ryanoasis/nerd-fonts for font compatibility and size, etc. info);
# 2. Unzip the package;
# 3. Select all the fonts -> right click -> install;
# 4. Control panel -> fonts;
# 5. Search nerd, the newly added fonts will be shown;
# 6. Remember the font name, such as "Cousine Nerd Font", "Hack Nerd Font", etc.;
# 7. Edit .minttyrc, add a field as below to enable corresponding font:
#    Font=SauceCodePro Nerd Font Mono

# Mintty color scheme can be found @https://github.com/oumu/mintty-color-schemes
echo
echo "Notice: this is for Windows git bash mintty configuration"
echo "Put below content into your .minttyrc"
echo

cat <<-EOF
#Font=SauceCodePro Nerd Font Mono
BoldAsFont=-1
Term=xterm-256color
FontHeight=12
Transparency=off
OpaqueWhenFocused=no
CursorType=block
Locale=C
Charset=UTF-8
RightClickAction=paste
MiddleClickAction=void
PgUpDnScroll=yes
ScrollMod=off
ClickTargetMod=off
BellType=0
BellTaskbar=no

ForegroundColour=147,161,161
BackgroundColour=0,43,54
CursorColour=253,157,79
Black=0,43,54
BoldBlack=101,123,131
Red=220,50,47
BoldRed=232,115,113
Green=133,153,0
BoldGreen=199,228,0
Yellow=181,137,0
BoldYellow=255,193,2
Blue=38,139,210
BoldBlue=99,173,227
Magenta=108,113,196
BoldMagenta=162,165,217
Cyan=42,161,152
BoldCyan=71,207,197
White=147,161,161
BoldWhite=253,246,227
EOF
