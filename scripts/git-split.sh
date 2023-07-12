#!/bin/sh

if [[ $# -ne 2 ]] ; then
  echo "Usage: git-split.sh original copy"
  exit 0
fi

git mv "$1" "$2"
git commit -n -m "$3 [copy dir step1]mv source to target"
REV=`git rev-parse HEAD`
git reset --hard HEAD^
git mv "$1" temp
git commit -n -m "$3 [copy dir step2]mv source to temp"
git merge $REV
git commit -a -n -m "$3 [copy dir step3]merge step1 and step2"
git mv temp "$1"
git commit -n -m "$3 [copy dir step4]mv temp to source;finished"
