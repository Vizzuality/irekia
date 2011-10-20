#!/bin/sh
git checkout staging
git pull origin staging
git merge master
git push origin staging
git checkout master
cap staging deploy
