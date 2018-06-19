#!/bin/bash

# Generate site
swagger-codegen generate -i "$(pwd)/http-api/swagger.yaml" -l swagger -o "$(pwd)/http-api/"
# TODO: Metadata
# TODO: Clone theme

rm -dfr obj && rm -dfr _site && docfx build docfx.json --force
aws s3 cp _site s3://eventstore.org/docs --recursive
# TODO: Invalidate cache?
# TODO: To GitHub?