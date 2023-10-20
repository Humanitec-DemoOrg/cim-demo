#!/usr/bin/env bash

export HUMANITEC_TOKEN=""
export HUMANITEC_ORG=""
export HUMANITEC_APP=myapp

if [[ $1 == "httpd" ]]
then
    score-humanitec delta --token $HUMANITEC_TOKEN --org $HUMANITEC_ORG --app $HUMANITEC_APP --env development -f score-$1.yaml --extensions extension-$1.yaml --deploy
else
    score-humanitec delta --token $HUMANITEC_TOKEN --org $HUMANITEC_ORG --app $HUMANITEC_APP --env development -f score-$1.yaml --deploy
fi
