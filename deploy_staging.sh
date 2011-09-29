#!/bin/sh
git checkout staging
git fetch origin
git rebase -p origin/staging
git rebase -p master
git push origin staging
git checkout master
cap staging deploy
