#!/bin/sh
git checkout staging
git fetch origin
git rebase -p master
git rebase -p origin/staging
git push origin staging
git checkout master
cap staging deploy
