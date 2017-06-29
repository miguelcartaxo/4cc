#!/bin/bash

# Find the code home folder

# NOTE(allen): Copied from stack exchange, hope it's reasonable -- readlink doesn't work on mac
TARGET_FILE="$0"
cd `dirname $TARGET_FILE`
TARGET_FILE=`basename $TARGET_FILE`
while [ -L "$TARGET_FILE" ]
do
    TARGET_FILE=`readlink $TARGET_FILE`
    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`
done
PHYS_DIR=`pwd -P`
SCRIPT_FILE=$PHYS_DIR/$TARGET_FILE
CODE_HOME=$(dirname "$SCRIPT_FILE")

# Find the most reasonable candidate build file

SOURCE="$1"
if [ -z "$SOURCE" ]; then
    SOURCE="$CODE_HOME/4coder_default_bindings.cpp"
fi

# NOTE(allen): Copied from stack exchange, hope it's reasonable -- readlink doesn't work on mac
TARGET_FILE="$SOURCE"
cd `dirname $TARGET_FILE`
TARGET_FILE=`basename $TARGET_FILE`
while [ -L "$TARGET_FILE" ]
do
    TARGET_FILE=`readlink $TARGET_FILE`
    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`
done
PHYS_DIR=`pwd -P`
SOURCE=$PHYS_DIR/$TARGET_FILE

echo "Building custom_4coders.so from $SOURCE"
FLAGS="-Wno-write-strings -Wno-null-dereference -Wno-comment -Wno-switch -Wno-writable-strings"
g++ -I"$CODE_HOME" $FLAGS -std=gnu++0x "$SOURCE" -shared -o custom_4coder.so -fPIC

