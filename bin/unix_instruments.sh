#!/usr/bin/env bash

set -e

run_instruments() {
  output=$(mktemp -t unix-instruments.XXX)
  instruments "$@" &> /dev/ttyvf &
  pid_instruments=$!
  cat < /dev/ptyvf | tee $output
  pid_instruments=0
  cat $output | get_error_status
}

get_error_status() {
  ruby -e 'exit 1 if STDIN.read =~ /Instruments Usage Error|Instruments Trace Error|^\d+-\d+-\d+ \d+:\d+:\d+ [-+]\d+ (Fail:|Error:|None: Script threw an uncaught JavaScript error)/'
}

trap cleanup_instruments EXIT
cleanup_instruments() {
  if [[ $pid_instruments -gt 0 ]]; then
    echo "Cleaning up instruments..."
    kill -9 $pid_instruments
  fi
}

if [[ $1 == "----test" ]]; then
  get_error_status
else
  run_instruments "$@"
fi
