{{/* Mount volume for logs */}}
{{- define "logger.mount" }}
volumeMounts:
- name: applogs 
  mountPath: /home/logs
{{- end }}

{{/* Template for adding logging sidecar */}}
{{- define "logger.sidecar" }}
- name: logger-sidecar
  image: busybox
  args: [/bin/sh, -c, 'tail -F /home/logs/registrationProcessor.log']
  volumeMounts:
  - name: applogs
    mountPath: /home/logs
{{- end }}

{{/* Temp volume for logs */}}
{{- define "logger.volume" }}
volumes:
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
