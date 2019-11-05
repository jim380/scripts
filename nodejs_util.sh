#!/bin/bash
#                                                                                                         
#                                                  jim380 <admin@cyphercore.io>
#  ============================================================================
#  
#  Copyright (C) 2019 jim380
#  
#  Permission is hereby granted, free of charge, to any person obtaining
#  a copy of this software and associated documentation files (the
#  "Software"), to deal in the Software without restriction, including
#  without limitation the rights to use, copy, modify, merge, publish,
#  distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so, subject to
#  the following conditions:
#  
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#  
#  ============================================================================
NODE_VERSION="10"

function main {
    echo -e "What would you like to do:\n\n1) Remove Nodejs\n2) Install Nodejs\n3) Remove then tnstall Nodejs\n\nEnter number down below:"
    read input

    case $input in
        "1")
            remove
        ;;

        "2")
            echo -e "\nWhat major version of Nodejs would you like to install?\nExample: enter 13 if you want to install v13.x\nFind releases here: https://nodejs.org/en/download/releases/\n"
            read -p NODE_VERSION
            install
        ;;

        "3")
            echo -e "\nWhat major version of Nodejs would you like to install?\nExample: enter 13 if you want to install v13.x\nFind releases here: https://nodejs.org/en/download/releases/\n"
            read -p NODE_VERSION
            remove
            install
        ;;

        *) 
        echo -e "Invalid input - $input\n" 
        ;;
    esac
}

function remove {
    echo "-----------------------------------------"
    echo "                 Remove nvm              "
    echo "-----------------------------------------"
    sudo rm -rf ~/.nvm
    hash -r

    echo "-----------------------------------------"
    echo "                 Remove Node             "
    echo "-----------------------------------------"
    sudo npm uninstall -g n
    sudo apt-get purge -y nodejs npm
    sudo apt-get purge -y nodejs-legacy npm
    sudo apt -y autoremove

    echo "-----------------------------------------"
    echo "               File Clean-up             "
    echo "-----------------------------------------"
    sudo rm -rf /usr/local/lib/node_modules/npm
    sudo rm -rf /usr/local/lib/node_modules/n
    sudo rm -f /usr/local/bin/node
    sudo rm -f /usr/local/bin/npm
    sudo rm -f /usr/bin/node
    sudo rm -rf /usr/local/n/versions/node

    echo "Nodejs has been successfully removed."
}

function install {
    echo "-----------------------------------------"
    echo "               Install Node              "
    echo "-----------------------------------------"
    curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
    sudo apt-get install -y nodejs

    echo "-----------------------------------------"
    echo "            Path Optimization            "
    echo "-----------------------------------------"
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
    echo 'export PATH="~/.npm-global/bin:$PATH"'>>~/.profile
    source ~/.profile

    echo "Nodejs has been successfully installed."
    node -v
    npm -v
}

main
