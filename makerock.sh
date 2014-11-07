#!/bin/sh

NAME=radarchart
TAG=`git name-rev --tags --name-only $(git rev-parse HEAD)`
TARGET=$NAME-$TAG-1.rockspec
cp $NAME-default.rockspec $TARGET
sed -i "s/%TAG%/$TAG/" $TARGET
luarocks pack $TARGET
