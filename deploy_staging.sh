#!/bin/sh
git pull
git checkout staging
git merge master
git push origin staging
git checkout master
cap staging deploy
