#!/bin/bash

if [ -z "$(git tag | grep $(git describe --tags --always))" ]; then
    if [ -z "$(git status --porcelain)" ]; then
      echo "$(git name-rev --name-only HEAD | sed "s/remotes\/origin\///g" | sed "s/\//_/g")-$(git rev-parse HEAD | cut -c1-12)-SNAPSHOT";
    else
      echo "$(git name-rev --name-only HEAD | sed "s/remotes\/origin\///g" | sed "s/\//_/g")-$(git rev-parse HEAD | cut -c1-12)-DIRTY-SNAPSHOT";
    fi
else
    echo "$(git describe --tags --dirty=-DIRTY-SNAPSHOT)";
fi
