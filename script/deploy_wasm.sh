#!/bin/sh

fvm flutter pub global run peanut \
  --extra-args "--base-href=/lb_games_poc/ --wasm" \
  && git push origin --set-upstream gh-pages
