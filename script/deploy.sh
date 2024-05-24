#!/bin/sh

fvm flutter pub global run peanut \
  --web-renderer canvaskit \
  --extra-args "--base-href=/lb_games_poc/" \
  && git push origin --set-upstream gh-pages
