#!/bin/sh

salt-call --local -l debug \
    --config-dir=. \
    --file-root=. \
    --pillar-root=./pillar \
    state.highstate
