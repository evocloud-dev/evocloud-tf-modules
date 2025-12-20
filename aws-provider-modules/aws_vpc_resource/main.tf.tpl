################################################################################
# AWS_VPC Resource
################################################################################
resource "aws_vpc" "this" {
  {{- if $.Values.cidr_block }}
  cidr_block            = var.values.cidr_block
  {{- end }}

  {{- if $.Values.instance_tenancy }}
  instance_tenancy      = var.values.instance_tenancy
  {{- end }}

  {{- if $.Values.enable_dns_support }}
  enable_dns_support    = var.values.enable_dns_support
  {{- end }}

  {{- if $.Values.enable_dns_hostnames }}
  enable_dns_hostnames  = var.values.enable_dns_hostnames
  {{- end }}

  {{- if $.Values.tags }}
  tags = var.values.tags
  {{- end }}

#Resource Lifecycle Management
  {{- if $.Values.lifecycle }}
  lifecycle {
    {{- if $.Values.lifecycle.create_before_destroy }}
    create_before_destroy = {{ $.Values.lifecycle.create_before_destroy }}
    {{- end }}
        
    {{- if $.Values.lifecycle.ignore_changes }}
    prevent_destroy = {{ $.Values.lifecycle.prevent_destroy }}
    {{- end }}
        
    {{- if $.Values.lifecycle.ignore_changes }}
    ignore_changes = {{ $.Values.lifecycle.ignore_changes }}
    {{- end }}
  }
  {{- end }}
}