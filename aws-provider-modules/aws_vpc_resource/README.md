## Provider Resource: aws_vpc

Creates an AWS VPC resource.

## Basic Example: Create a basic VPC

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-vpc
  namespace: flux-system
spec:
  path: aws_vpc_resource
  values:
    cidr_block: "10.0.0.0/24"
    enable_dns_support: true
    enable_dns_hostnames: true
    enable_network_address_usage_metrics: false
    tags:
      Environment: Dev
      Name: main-vpc
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-vpc-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Advanced Example: Create a VPC with custom DHCP_OPTIONS

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-vpc
  namespace: flux-system
spec:
  path: aws_vpc_resource
  values:
    cidr_block: "10.0.0.0/24"
    enable_dns_support: true
    enable_dns_hostnames: true
    enable_network_address_usage_metrics: false
    tags:
      Environment: Dev
      Name: main-vpc
    dhcp_options:
      domain_name: "evocloud.gov"
      domain_name_servers:
        - "10.10.20.5"
        - "10.10.20.10"
        - "AmazonProvidedDNS"
      ntp_servers:
        - "10.10.20.5"
        - "10.10.20.10"
      tags:
        Environment: Dev
        Name: main-vpc-dhcp-option9
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-vpc-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#attribute-reference) 

## References
[Terraform AWS_VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
[AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

