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
    create_before_destroy   = {{ $.Values.lifecycle.create_before_destroy }}
    {{- end }}

    {{- if $.Values.lifecycle.ignore_changes }}
    prevent_destroy         = {{ $.Values.lifecycle.prevent_destroy }}
    {{- end }}

    {{- if $.Values.lifecycle.ignore_changes }}
    ignore_changes          = {{ $.Values.lifecycle.ignore_changes }}
    {{- end }}
  }
  {{- end }}
}

################################################################################
# AWS_VPC_DHCP_OPTIONS Resource
################################################################################
{{- if $.Values.dhcp_options }}
resource "aws_vpc_dhcp_options" "this" {

  {{- if $.Values.dhcp_options.domain_name }}
  domain_name           = var.values.dhcp_options.domain_name
  {{- end }}

  {{- if $.Values.dhcp_options.domain_name_servers }}
  domain_name_servers   = var.values.dhcp_options.domain_name_servers
  {{- end }}

  {{- if $.Values.dhcp_options.ntp_servers }}
  ntp_servers           = var.values.dhcp_options.ntp_servers
  {{- end }}

  {{- if $.Values.dhcp_options.tags }}
  tags                  = var.values.dhcp_options.tags
  {{- end }}

}

#--------------------------------------------
# Associate AWS_VPC_DHCP_OPTIONS to AWS_VPC
#--------------------------------------------
resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}

#--------------------------------------------------
# Expose AWS_DHCP_Options Attributes
#--------------------------------------------------
output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = try(aws_vpc_dhcp_options.this.id, null)
}
{{- end }}