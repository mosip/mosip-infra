{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.Docker.Registry.Url (printf "%s:%s" .Values.Docker.Registry.Username .Values.Docker.Registry.Password | b64enc) | b64enc }}
{{- end }}