#!/bin/sh

# User setup
addgroup -S user -g 3000
adduser -S user user -u 3000
addgroup user tty 
addgroup user dialout

# Cleanup
rm $0