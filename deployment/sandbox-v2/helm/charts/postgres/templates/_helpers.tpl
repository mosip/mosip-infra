{{/* Temp volume for logs */}}
{{- define "logger.volume" }}
volumes:
- name: applogs
  emptyDir: {}
{{- end }}

{{/* Mount volume for logs */}}
{{- define "logger.mount" }}
volumeMounts:
- name: applogs
  mountPath: /home/logs
{{- end }}