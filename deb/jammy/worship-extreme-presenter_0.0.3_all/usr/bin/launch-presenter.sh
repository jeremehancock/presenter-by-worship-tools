#!/bin/bash
# Copyright (c) 2021 Jereme Hancock <support@ubuntuce.com>

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Jammy Jellyfish Release

APP_TITLE="WorshipTools Presenter Launcher"

for filename in /usr/bin/*.AppImageUCE; do
    export INSTALLED="${filename#'/usr/bin/'}"
done

update() {
    (pkexec bash -c "
   mv /usr/bin/$INSTALLED /usr/bin/WEP_Update_bak
   echo '# \nDownloading new version\n'
   wget -q https://download.worshipextreme.com/download/latest/linux -O '/usr/bin/$LATEST.AppImageUCE'
   if test -f '/usr/bin/$LATEST.AppImageUCE'; then
      rm /usr/bin/WEP_Update_bak
      chmod 755 '/usr/bin/$LATEST.AppImageUCE'
    else
       mv /usr/bin/WEP_Update_bak /usr/bin/$INSTALLED
   fi") |
        zenity --progress \
            --title="$APP_TITLE" \
            --width=400 \
            --height=100 \
            --percentage=0 \
            --auto-close \
            --auto-kill \
            --no-cancel \
            --pulsate \
            --window-icon=/usr/share/pixmaps/worship-extreme-presenter.png

    (($? != 0)) && download_failure

}

download_failure() {
    zenity --window-icon=/usr/share/pixmaps/worship-extreme-presenter.png --error --width=300 --title "$APP_TITLE" --text="\n<span color='#CC0000'><big>Update failed!</big></span>\n\nThe current version will launch for now."
}

wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    LATEST=$(curl https://download.worshipextreme.com/latest.json | jq --raw-output '.latest')
    
    if [ "$INSTALLED" == "null.AppImageUCE" ]; then
        if
            zenity --window-icon=/usr/share/pixmaps/worship-extreme-presenter.png --question --title "$APP_TITLE" --no-wrap --text="\n<span color='#228B22'><big>Presenter by WorshipTools!</big></span>\n\nThis is the first time you have run the Presenter installer.\n\nWould you like to install the latest version from WorshipTools.com now?"
        then
            update
            /usr/bin/$LATEST.AppImageUCE
        else
             exit
        fi
       

    elif [ "$INSTALLED" == "$LATEST.AppImageUCE" ]; then
        /usr/bin/$INSTALLED
    else
        if
            zenity --window-icon=/usr/share/pixmaps/worship-extreme-presenter.png --question --title "$APP_TITLE" --no-wrap --text="\n<span color='#228B22'><big>Update available!</big></span>\n\nThe internal application updater is not able to install a new version since it does not have permission.\n\nWould you like to install the update from WorshipTools.com now?"
        then
            update
            /usr/bin/$LATEST.AppImageUCE
        else
            /usr/bin/"$INSTALLED"
        fi

    fi
else
    /usr/bin/"$INSTALLED"
fi

