#!/bin/bash

ODIN_HOST=woonkang-cloud.aka.corp.amazon.com
ODIN_MATERIAL=com.amazon.access.alexa-hybrid-builder-woonkang-1

aws configure set aws_access_key_id $(ssh $ODIN_HOST "/apollo/env/envImprovement/bin/odin-get $ODIN_MATERIAL -t Principal") --profile alexa_hybrid_builder
aws configure set aws_secret_access_key $(ssh $ODIN_HOST "/apollo/env/envImprovement/bin/odin-get $ODIN_MATERIAL -t Credential") --profile alexa_hybrid_builder

