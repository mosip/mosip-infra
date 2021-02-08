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
