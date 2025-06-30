{{/* Chart 이름 */}}
{{- define "backend-main.name" -}}
backend-main
{{- end }}

{{/* 전체 이름 */}}
{{- define "backend-main.fullname" -}}
{{ .Release.Name }}-{{ include "backend-main.name" . }}
{{- end }}

{{/* 공통 라벨 정의 */}}
{{- define "backend-main.labels" -}}
app.kubernetes.io/name: {{ include "backend-main.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
