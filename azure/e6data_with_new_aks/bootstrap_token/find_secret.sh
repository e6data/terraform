#!/bin/bash

# Decode KUBECONFIG variable
KUBECONFIG_DEC=$(echo "$KUBECONFIG" | base64 -d)

# Get the name of the bootstrap token secret
TOKEN_SECRET_NAME=$(kubectl get -n kube-system secrets --field-selector=type=bootstrap.kubernetes.io/token -o jsonpath='{.items[0].metadata.name}' --kubeconfig <(echo "$KUBECONFIG_DEC"))

# Get token-id and decode it
TOKEN_ID=$(kubectl get -n kube-system secret "$TOKEN_SECRET_NAME" -o jsonpath='{.data.token-id}' --kubeconfig <(echo "$KUBECONFIG_DEC") | base64 -d)

# Get token-secret and decode it
TOKEN_SECRET=$(kubectl get -n kube-system secret "$TOKEN_SECRET_NAME" -o jsonpath='{.data.token-secret}' --kubeconfig <(echo "$KUBECONFIG_DEC") | base64 -d)

# Concatenate token-id and token-secret
BOOTSTRAP_TOKEN="$TOKEN_ID.$TOKEN_SECRET"

# Write the concatenated token to a file
echo "$BOOTSTRAP_TOKEN" > bootstrap_token/token.tpl