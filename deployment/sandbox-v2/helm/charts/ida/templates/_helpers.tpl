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
