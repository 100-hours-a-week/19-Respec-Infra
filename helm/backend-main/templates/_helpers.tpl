{{/* Chart 이름 */}}
{{- define "backend-main.name" -}}
backend-main
{{- end }}

{{/* 전체 이름: 기본은 Release Name 사용 */}}
{{- define "backend-main.fullname" -}}
{{ .Release.Name }}
{{- end }}

{{/* 공통 라벨 정의 (선택사항) */}}
{{- define "backend-main.labels" -}}
app.kubernetes.io/name: {{ include "backend-main.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
