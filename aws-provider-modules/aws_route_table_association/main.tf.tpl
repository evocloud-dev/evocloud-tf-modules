################################################################################
# AWS_ROUTE_TABLE_ASSOCIATION Resource
################################################################################
# Associate Public Subnets to Public Route Table
{{- if $.Values.PUBLIC_SUBNET_IDS }}
resource "aws_route_table_association" "public_rt_association" {
  for_each = var.values.PUBLIC_SUBNET_IDS
  {{- if $.Values.PUBLIC_ROUTE_TABLE_ID }}
  route_table_id = var.values.PUBLIC_ROUTE_TABLE_ID
  {{- end }}
  subnet_id = each.value
}
{{- end }}

# Associate Private Subnets to Private Route Table
{{- if $.Values.PRIVATE_SUBNET_IDS }}
resource "aws_route_table_association" "private_rt_association" {
  for_each = var.values.PRIVATE_SUBNET_IDS
  {{- if $.Values.PRIVATE_ROUTE_TABLE_ID }}
  route_table_id = var.values.PRIVATE_ROUTE_TABLE_ID
  {{- end }}
  subnet_id = each.value
}
{{- end }}