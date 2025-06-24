{{- define "chatconsumer.name" -}}
chatconsumer
{{- end }}

{{- define "chatconsumer.fullname" -}}
{{ .Release.Name }}
{{- end }}
