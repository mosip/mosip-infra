{{/* Mount volume for logs */}}
{{- define "logger.mount" }}
- name: applogs 
  mountPath: /logs
{{- end }}

{{/* Template for adding logging sidecar */}}
{{- define "logger.sidecar" }}
- name: logger-sidecar
  image: busybox
  args: [/bin/sh, -c, 'tail -F /logs/id-auth.log']
  volumeMounts:
  - name: applogs
    mountPath: /logs
{{- end }}

{{/* Temp volume for logs */}}
{{- define "logger.volume" }}
- name: applogs
  emptyDir: {}
{{- end }}

{{/* Template for impagepull secrets */}}
{{- define "dockerHubSecret" }}
{{ if .Values.dockerHub.private }}
imagePullSecrets:
- name: {{ .Values.dockerHub.keyname }}
{{ end }}
{{- end }}

{{/* Template for resources */}}
{{- define "resourcesDefinition" }}
{{- if .res }}
resources:
  {{- if .res.limits }}
  limits:
    {{- if .res.limits.cpu }}
    cpu: {{ .res.limits.cpu }}
    {{- end }}
    {{- if .res.limits.memory }}
    memory: {{ .res.limits.memory }}
    {{- end }}
  {{- end }}
  {{- if .res.requests }}
  requests:
    {{- if .res.requests.cpu }}
    cpu: {{ .res.requests.cpu }}
    {{- end }}
    {{- if .res.requests.memory }}
    memory: {{ .res.requests.memory }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
