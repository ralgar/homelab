#!/bin/bash

user="$1"
apptoken="$2"
title="$3"

curl -s \
    -F "user=$user" \
    -F "token=$apptoken" \
    -F "title=$title" \
    -F "message=$(</dev/stdin)" \
    https://api.pushover.net/1/messages.json
