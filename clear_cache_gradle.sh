#!/bin/bash
# to run clear cashes

# chmod +x clear_cache.sh
# ./clear_cache.sh


# sudo chmod -R 777 ~/.gradle
# sudo rm -rf ~/.gradle/*

# or

# sudo rm -rf ~/.gradle/caches/transforms-3
# sudo rm -rf ~/.gradle/caches/jars-9

# ls -l ~/.gradle
# ls -l ~/.gradle
# ls -lh ~/.gradle



# Repeat for each file or directory

# Clear DNS cache
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder


# Clear system cache
sudo rm -rf /Library/Caches/*
sudo rm -rf ~/Library/Caches/*
sudo find ~/Library/Caches -type f -delete
sudo find ~/Library/Caches -type d -delete


ls -l /Users/hellobishyaka/Library/Caches/

