#!/bin/sh
npm install
npx antora antora-playbook.yml --stacktrace --fetch --noproxy '*'
