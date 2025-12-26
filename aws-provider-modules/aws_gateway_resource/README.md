## Provider Resource: aws_internet_gateway, aws_nat_gateway, aws_route_table

Creates AWS Internet and NAT Gateways and their associated Route Tables.

## Depends On:

- `aws_vpc`

## Basic Example: Configure gateways and routes for public and private route tables

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-gateway
  namespace: flux-system
spec:
  path: aws_gateway_resource
  values:
    VPC_ID: "vpc-0bdcab4d22b8c8975" #Can reference value from aws_vpc output
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-gateway-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced below:
- [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway#argument-reference)
- [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway#argument-reference)
- [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced below:
- [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway#attribute-reference)
- [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway#attribute-reference)
- [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#attribute-reference)

## References
- [Terraform AWS_INTERNET_GATEWAY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- [Terraform AWS_NAT_GATEWAY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)
- [Terraform AWS_ROUTE_TABLE](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

