{{/*
Generate base name for resources
*/}}
{{- define "kube-api-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate full name for resources (e.g., with release name)
*/}}
{{- define "kube-api-proxy.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" (include "kube-api-proxy.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate chart label
*/}}
{{- define "kube-api-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate TLS Secret name
*/}}
{{- define "kube-api-proxy.tlsSecretName" -}}
{{- default (printf "%s-tls" (include "kube-api-proxy.fullname" .)) .Values.tlsSecretName }}
{{- end -}}
