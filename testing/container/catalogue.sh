#!/usr/bin/env bash

set -euf -o pipefail

# Clean up
trapCleanup() {
    docker rm -f catalogue
}
trap trapCleanup EXIT INT TERM

# Start the container under test (and dependencies)
docker run -d --name catalogue -h catalogue weaveworksdemos/catalogue

# Perform tests
docker run --rm --link catalogue --name catalogue-container-test alpine sh -c '
    set -euf -o pipefail ;
    apk --update add curl jq ;
    TEST_ID=$(curl -s catalogue/catalogue | jq .[0].id | tr -d "\"") ;
    if [[ $TEST_ID != "null" ]] ; then exit 0 ; else exit 1 ; fi
    '
