#!/bin/bash

swagger-codegen generate -i "$(pwd)/http-api/swagger.yaml" -l swagger -o "$(pwd)/http-api/"
# TODO: Metadata
docfx build docfx.json --force
