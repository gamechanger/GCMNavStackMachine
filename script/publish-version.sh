#!/bin/bash

currentBranch=$(git branch | sed -n '/\* /s///p')
if [ "$currentBranch" != "master" ]
then
    echo You are not on master.  You need to be on master to run this script.
    exit 1
fi

untrackedFile=$(git status --porcelain | wc -l)
if [ $untrackedFile -ne 0 ]
then
    echo Uncommitted or untracked files are detected.  Please commit them or stash them before you run this script
    exit 1
fi

set -e
pushd `dirname "${BASH_SOURCE[0]}"`
ruby generate-podspec.rb $1 > ../GCMNavStackMachine.podspec
git add ../GCMNavStackMachine.podspec
git commit -m "Update podspec" || true
git push origin master
popd

git tag -a $1 -m "Create tag"
git push origin $1

pod push --allow-warnings gcspecs GCPartnerDBs.podspec
