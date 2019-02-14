{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rails.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rails.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rails.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create volume mounts block.
*/}}
{{- define "rails.volumeMounts" -}}
volumeMounts:
  - name: source-volume
    mountPath: /usr/src/app
  - name: gem-volume
    mountPath: /usr/local/bundle
  - name: ssh-volume
    mountPath: /root/.ssh
{{- end -}}

{{/*
Create init command.
*/}}
{{- define "rails.initCommand" -}}
{{- $command := "bundle install" -}}
{{- if .Values.webpackDevServer.enabled -}}
{{- $command = printf "%s && yarn install" $command -}}
{{- end -}}
{{- if or .Values.mysql.enabled .Values.postgresql.enabled -}}
{{- $command = printf "%s && rake db:create && rake db:migrate" $command -}}
{{- end -}}
{{- $command -}}
{{- end -}}
