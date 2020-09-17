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
  mountPath: {{ .Values.containerWorkDir }}/logs
{{- end }}
{{/* Template for adding logging sidecar */}}
{{- define "logger.sidecar" }}
- name: logger-sidecar
  image: busybox
  args: [/bin/sh, -c, 'tail -F ~/logs/id-auth.log']
  volumeMounts:
  - name: applogs
    mountPath: {{ .Values.containerWorkDir }}/logs
{{- end }}
