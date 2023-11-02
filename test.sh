#!/bin/sh

set -e

test() {
  if [ "$2" != "" ]; then
    echo "----------------------------------------"
  fi
  echo "$1"
  echo "----------------------------------------"
}

test "help"
./npxcc -h

test "version" 1
./npxcc -V

test "ls empty" 1
./npxcc ls

echo "----------------------------------------"
echo "install http-server"
npx -y http-server -v

test "ls not empty" 1
./npxcc ls -v

echo "----------------------------------------"
echo "done"
