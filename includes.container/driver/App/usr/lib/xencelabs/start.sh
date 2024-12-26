#!/bin/sh
pkill xence
appname=xencelabs
dirname=/usr/lib/xencelabs
LD_LIBRARY_PATH=$dirname/lib
echo "lib path :$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
$dirname/$appname "$@"
