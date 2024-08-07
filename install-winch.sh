#!/usr/bin/env bash

# This will have more and more as we progress
LINUX_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-gnu-linux-x86_64"
MACOS_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-macos-x86_64"

echo "\033[1;32mThis script will install Winch to the system continue? (Y/n)\033[0m"

read -r RESPONSE </dev/tty

if [ "$RESPONSE" = "y" ] || [ "$RESPONSE" = "Y" ] || [ "$RESPONSE" = "" ]; then
	# Green
	echo "\033[1;32mInstalling Winch...\033[0m"
	
	mkdir $HOME/.winch/ && mkdir ~/.winch/bin/
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		wget -P $HOME/.winch/bin/ $LINUX_LATEST_BINARY_URL > /dev/null 2>&1
  mv $HOME/.winch/bin/winch-gnu-linux-x86_64 $HOME/.winch/bin/winch
		chmod +x $HOME/.winch/bin/winch
	elif [[ "$OSTYPE" == "darwin"* ]]; then
 		wget -P $HOME/.winch/bin/ $MACOS_LATEST_BINARY_URL > /dev/null 2>&1
  		mv $HOME/.winch/bin/winch-macos-x86_64 $HOME/.winch/bin/winch
		chmod +x $HOME/.winch/bin/winch
  
	echo "\033[1;32mSUCCESS!\033[0m Winch is now installed on the machine. Last step add this to your shell profile:\nexport PATH=\$PATH:/\$HOME/.winch/bin/"
else
	echo "Exiting..."
	exit
fi
